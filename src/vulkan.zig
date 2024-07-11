const std = @import("std");
const builtin = @import("builtin");

pub const vk = @import("vulkan");

/// Features for which to generate and load function pointers
/// Comments with `SEPERATE:` indicate that given feature is loaded
/// utside of vulkan-zig
const apis: []const vk.ApiInfo = &.{
    .{
        .base_commands = .{
            .createInstance = true,
        },
        .instance_commands = .{
            .createDevice = true,
        },
    },
    vk.features.version_1_0,
    vk.extensions.khr_surface,
    // SEPERATE: vk.extensions.khr_wayland_surface,
    vk.extensions.khr_swapchain,
};

const required_instance_extensions = [_][*:0]const u8{
    vk.extensions.khr_surface.name,
};

const required_device_extensions = [_][*:0]const u8{
    vk.extensions.khr_swapchain.name,
};

pub const BaseDispatch = vk.BaseWrapper(apis);
pub const InstanceDispatch = vk.InstanceWrapper(apis);
pub const DeviceDispatch = vk.DeviceWrapper(apis);

pub const Instance = vk.InstanceProxy(apis);
pub const Device = vk.DeviceProxy(apis);

const vkGetInstanceProcAddressFn = *const fn (instance: vk.Instance, procname: [*:0]const u8) vk.PfnVoidFunction;

var vkGetInstanceProcAddress: ?vkGetInstanceProcAddressFn = null;

pub fn loadSharedLibrary() !std.DynLib {
    const filename = switch (builtin.os.tag) {
        .linux => "libvulkan.so",
        .netbsd, .freebsd => "libvulkan.so",
        .windows => "vulkan-1.dll",
        else => @compileError("Unsupported OS"),
    };
    var lib = try std.DynLib.open(filename);

    vkGetInstanceProcAddress = lib.lookup(vkGetInstanceProcAddressFn, "vkGetInstanceProcAddr") orelse
        return error.LookupFailed;
    return lib;
}

pub const Context = struct {
    instance: Instance,
    base_dispatch: BaseDispatch,

    getInstanceProcAddress: vkGetInstanceProcAddressFn,

    const app_info: vk.ApplicationInfo = .{
        .p_application_name = "zentura",
        .application_version = 0,
        .engine_version = 0,
        .api_version = vk.API_VERSION_1_0,
    };

    pub const CommandBuffer = vk.CommandBufferProxy(apis);

    pub fn init(comptime extensions: []const [*:0]const u8, allocator: std.mem.Allocator) !@This() {
        var self: Context = undefined;
        self.getInstanceProcAddress = vkGetInstanceProcAddress orelse return error.VkGetInstanceProcAddressNull;

        const req_exts = required_instance_extensions ++ extensions;

        self.base_dispatch = try BaseDispatch.load(self.getInstanceProcAddress);
        const instance = try self.base_dispatch.createInstance(&vk.InstanceCreateInfo{
            .p_application_info = &app_info,
            .enabled_extension_count = @intCast(req_exts.len),
            .pp_enabled_extension_names = req_exts,
            .enabled_layer_count = 1,
            .pp_enabled_layer_names = @ptrCast(&[_][*:0]const u8{"VK_LAYER_KHRONOS_validation"}),
            .flags = .{},
        }, null);

        const instance_dispatch = try allocator.create(InstanceDispatch);
        errdefer allocator.destroy(instance_dispatch);
        instance_dispatch.* = try InstanceDispatch.load(instance, self.getInstanceProcAddress);
        self.instance = Instance.init(instance, instance_dispatch);

        return self;
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.instance.destroyInstance(null);
        allocator.destroy(self.instance.wrapper);
    }
};

pub const DeviceContext = struct {
    instance: Instance,
    surface: vk.SurfaceKHR,

    pdev: vk.PhysicalDevice,
    pdevprops: vk.PhysicalDeviceProperties,
    pdevmemprops: vk.PhysicalDeviceMemoryProperties,

    dev: Device,
    graphics_queue: Queue,
    present_queue: Queue,

    pub fn init(
        comptime extensions: []const [*:0]const u8,
        allocator: std.mem.Allocator,
        instance: Instance,
        surface: vk.SurfaceKHR,
    ) !@This() {
        var self: @This() = undefined;
        self.instance = instance;

        self.surface = surface;
        errdefer self.instance.destroySurfaceKHR(self.surface, null);

        const device_candidate = try findDeviceCandidate(allocator, self.instance, self.surface);
        self.pdev = device_candidate.pdev;
        self.pdevprops = device_candidate.props;

        const device = try initializeDeviceCandidate(extensions, self.instance, device_candidate);

        const device_dispatch = try allocator.create(DeviceDispatch);
        errdefer allocator.destroy(device_dispatch);

        device_dispatch.* = try DeviceDispatch.load(device, self.instance.wrapper.dispatch.vkGetDeviceProcAddr);
        self.dev = Device.init(device, device_dispatch);
        errdefer self.dev.destroyDevice(null);

        self.graphics_queue = Queue.init(self.dev, device_candidate.queues.graphics_family, 0);
        self.present_queue = Queue.init(self.dev, device_candidate.queues.present_family, 0);

        self.pdevmemprops = self.instance.getPhysicalDeviceMemoryProperties(self.pdev);

        return self;
    }

    pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
        self.instance.destroySurfaceKHR(self.surface, null);

        self.dev.destroyDevice(null);
        allocator.destroy(self.dev.wrapper);
    }

    const Queue = struct {
        handle: vk.Queue,
        family: u32,

        fn init(device: Device, family: u32, queue_index: u32) @This() {
            return .{
                .handle = device.getDeviceQueue(family, queue_index),
                .family = family,
            };
        }
    };

    const DeviceQueueFamilies = struct {
        graphics_family: u32,
        present_family: u32,
    };

    const DeviceCandidate = struct {
        pdev: vk.PhysicalDevice,
        props: vk.PhysicalDeviceProperties,
        queues: DeviceQueueFamilies,
    };

    fn findDeviceCandidate(allocator: std.mem.Allocator, instance: Instance, surface: vk.SurfaceKHR) !DeviceCandidate {
        const physical_devices = try instance.enumeratePhysicalDevicesAlloc(allocator);
        defer allocator.free(physical_devices);

        if (physical_devices.len == 0) return error.NoPhysicalDevices;

        return for (physical_devices) |device| {
            if (!(try deviceSupportsRequiredExtensions(allocator, instance, device))) {
                continue;
            }
            if (!(try deviceSupportsSurface(instance, device, surface))) {
                continue;
            }
            const queues = findRequiredQueues(allocator, instance, device, surface) catch |err| switch (err) {
                error.NoSuitableQueues => continue,
                else => return err,
            };
            break DeviceCandidate{
                .pdev = device,
                .props = instance.getPhysicalDeviceProperties(device),
                .queues = queues,
            };
        } else error.NoSuitableDevice;
    }

    fn findRequiredQueues(
        allocator: std.mem.Allocator,
        instance: Instance,
        dev: vk.PhysicalDevice,
        surface: vk.SurfaceKHR,
    ) !DeviceQueueFamilies {
        const families = try instance.getPhysicalDeviceQueueFamilyPropertiesAlloc(dev, allocator);
        defer allocator.free(families);

        var graphics: ?u32 = null;
        var present: ?u32 = null;

        return for (families, 0..) |fprops, idx| {
            const family: u32 = @intCast(idx);

            if (graphics == null and fprops.queue_flags.graphics_bit) {
                graphics = family;
            }
            if (present == null and (try instance.getPhysicalDeviceSurfaceSupportKHR(dev, family, surface) == vk.TRUE)) {
                present = family;
            }
            if (graphics != null and present != null) {
                break DeviceQueueFamilies{
                    .graphics_family = graphics.?,
                    .present_family = present.?,
                };
            }
        } else error.NoSuitableQueues;
    }

    fn deviceSupportsRequiredExtensions(
        allocator: std.mem.Allocator,
        instance: Instance,
        device: vk.PhysicalDevice,
    ) !bool {
        const ext_properties = try instance.enumerateDeviceExtensionPropertiesAlloc(device, null, allocator);
        defer allocator.free(ext_properties);

        // TODO: Explore if this is the most optimal way of doing this
        for (required_device_extensions) |ext| {
            for (ext_properties) |props| {
                if (std.mem.eql(u8, std.mem.span(ext), std.mem.sliceTo(&props.extension_name, 0))) {
                    break;
                }
            } else {
                return false;
            }
        }

        return true;
    }

    fn deviceSupportsSurface(instance: Instance, device: vk.PhysicalDevice, surface: vk.SurfaceKHR) !bool {
        var format_count: u32 = undefined;
        var present_mode_count: u32 = undefined;

        _ = try instance.getPhysicalDeviceSurfaceFormatsKHR(device, surface, &format_count, null);
        _ = try instance.getPhysicalDeviceSurfacePresentModesKHR(device, surface, &present_mode_count, null);

        return format_count > 0 and present_mode_count > 0;
    }

    fn initializeDeviceCandidate(
        comptime extensions: []const [*:0]const u8,
        instance: Instance,
        candidate: DeviceCandidate,
    ) !vk.Device {
        const priority = [_]f32{1};

        const exts = required_device_extensions ++ extensions;

        return try instance.createDevice(candidate.pdev, &vk.DeviceCreateInfo{
            .queue_create_info_count = if (candidate.queues.graphics_family == candidate.queues.present_family)
                1
            else
                2,
            .p_queue_create_infos = &[_]vk.DeviceQueueCreateInfo{ .{
                .queue_family_index = candidate.queues.graphics_family,
                .queue_count = 1,
                .p_queue_priorities = &priority,
            }, .{
                .queue_family_index = candidate.queues.present_family,
                .queue_count = 1,
                .p_queue_priorities = &priority,
            } },
            .enabled_extension_count = @intCast(exts.len),
            .pp_enabled_extension_names = exts,
        }, null);
    }
};

pub const Swapchain = struct {
    instance: Instance,
    context: *const DeviceContext,

    handle: vk.SwapchainKHR,
    extent: vk.Extent2D,
    surface_format: vk.SurfaceFormatKHR,
    present_mode: vk.PresentModeKHR,

    swap_images: []SwapImage,
    image_index: u32,
    next_image_acquired: vk.Semaphore,

    pub fn create(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const DeviceContext,
        extent: vk.Extent2D,
    ) !@This() {
        return try recycle(allocator, instance, context, extent, .null_handle);
    }

    pub fn recreate(self: *@This(), allocator: std.mem.Allocator, extent: vk.Extent2D) !void {
        const instance = self.instance;
        const context = self.context;

        self.destroyWithoutHandle(allocator);
        self.* = try recycle(allocator, instance, context, extent, self.handle);
    }

    fn recycle(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const DeviceContext,
        extent: vk.Extent2D,
        old_swapchain: vk.SwapchainKHR,
    ) !@This() {
        const caps = try instance.getPhysicalDeviceSurfaceCapabilitiesKHR(context.pdev, context.surface);
        const actual_extent = findActualExtent(caps, extent);

        if (actual_extent.width == 0 or actual_extent.height == 0) return error.InvalidSurfaceDimentions;

        const surface_format = try findSurfaceFormat(allocator, instance, context);
        const presentation_mode = try findPresentationMode(allocator, instance, context);

        var image_count = caps.min_image_count + 1;
        if (caps.max_image_count > 0 and image_count > caps.max_image_count) {
            image_count = caps.max_image_count;
        }

        var create_info = vk.SwapchainCreateInfoKHR{
            .surface = context.surface,
            .min_image_count = image_count,
            .image_format = surface_format.format,
            .image_color_space = surface_format.color_space,
            .image_extent = actual_extent,
            .image_array_layers = 1,
            .image_usage = .{ .color_attachment_bit = true },
            .image_sharing_mode = .exclusive,

            .present_mode = presentation_mode,
            .clipped = vk.TRUE,
            .pre_transform = caps.current_transform,
            .composite_alpha = .{ .opaque_bit_khr = true },

            .old_swapchain = old_swapchain,
        };
        if (context.graphics_queue.family != context.present_queue.family) {
            create_info.image_sharing_mode = .concurrent;
            create_info.queue_family_index_count = 2;
            create_info.p_queue_family_indices = &[_]u32{ context.graphics_queue.family, context.present_queue.family };
        }

        const swapchain = try context.dev.createSwapchainKHR(&create_info, null);
        errdefer context.dev.destroySwapchainKHR(swapchain, null);

        if (old_swapchain != .null_handle) {
            context.dev.destroySwapchainKHR(old_swapchain, null);
        }

        const swap_images = try initSwapchainImages(allocator, context, swapchain, surface_format.format);
        errdefer {
            for (swap_images) |*image| {
                image.deinit();
            }
            allocator.free(swap_images);
        }

        var next_image_acquired = try context.dev.createSemaphore(&.{}, null);
        errdefer context.dev.destroySemaphore(next_image_acquired, null);

        const result = try context.dev.acquireNextImageKHR(swapchain, std.math.maxInt(u64), next_image_acquired, .null_handle);
        if (result.result != .success) return error.ImageAcquireFailed;

        std.mem.swap(vk.Semaphore, &swap_images[result.image_index].image_acquired, &next_image_acquired);

        return .{
            .instance = instance,
            .context = context,
            .handle = swapchain,
            .extent = actual_extent,
            .surface_format = surface_format,
            .present_mode = presentation_mode,
            .swap_images = swap_images,
            .next_image_acquired = next_image_acquired,
            .image_index = result.image_index,
        };
    }

    pub fn present(self: *@This(), cmdbuf: vk.CommandBuffer) !enum { optimal, suboptimal } {

        // Wait till current frame finished rendering
        const current = self.currentSwapImage();
        try current.waitForPresent();
        try self.context.dev.resetFences(1, @ptrCast(&current.present_fence));

        // Sumbit the command buffer
        const wait_stage = [_]vk.PipelineStageFlags{.{ .top_of_pipe_bit = true }};
        try self.context.dev.queueSubmit(
            self.context.graphics_queue.handle,
            1,
            &[_]vk.SubmitInfo{.{
                .wait_semaphore_count = 1,
                // Wait till the next image is acquired
                .p_wait_semaphores = @ptrCast(&current.image_acquired),
                .p_wait_dst_stage_mask = &wait_stage,
                .command_buffer_count = 1,
                .p_command_buffers = @ptrCast(&cmdbuf),
                .signal_semaphore_count = 1,
                // Signal that rendering finished on GPU
                .p_signal_semaphores = @ptrCast(&current.render_finished),
            }},
            // Trip present_fence once work has completed
            current.present_fence,
        );

        // Present current frame
        _ = try self.context.dev.queuePresentKHR(self.context.present_queue.handle, &.{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = @ptrCast(&current.render_finished),
            .swapchain_count = 1,
            .p_swapchains = @ptrCast(&self.handle),
            .p_image_indices = @ptrCast(&self.image_index),
        });

        // Acquire next image
        // This will start the rendering of the next image
        const result = try self.context.dev.acquireNextImageKHR(
            self.handle,
            std.math.maxInt(u64),
            self.next_image_acquired,
            .null_handle,
        );

        std.mem.swap(vk.Semaphore, &self.swap_images[result.image_index].image_acquired, &self.next_image_acquired);
        self.image_index = result.image_index;
        return switch (result.result) {
            .success => .optimal,
            .suboptimal_khr => .suboptimal,
            else => unreachable,
        };
    }

    pub fn currentSwapImage(self: *const @This()) *const SwapImage {
        return &self.swap_images[self.image_index];
    }

    pub fn destroyWithoutHandle(self: *@This(), allocator: std.mem.Allocator) void {
        for (self.swap_images) |*swapimage| {
            swapimage.deinit();
        }
        allocator.free(self.swap_images);
        self.context.dev.destroySemaphore(self.next_image_acquired, null);
    }

    pub fn destroy(self: *@This(), allocator: std.mem.Allocator) void {
        self.destroyWithoutHandle(allocator);
        self.context.dev.destroySwapchainKHR(self.handle, null);
    }

    fn initSwapchainImages(
        allocator: std.mem.Allocator,
        context: *const DeviceContext,
        swapchain: vk.SwapchainKHR,
        format: vk.Format,
    ) ![]SwapImage {
        const images = try context.dev.getSwapchainImagesAllocKHR(swapchain, allocator);
        defer allocator.free(images);

        const swap_images = try allocator.alloc(SwapImage, images.len);
        errdefer allocator.free(swap_images);

        var last_idx: usize = 0;
        errdefer for (0..last_idx) |i| swap_images[i].deinit();

        while (last_idx < images.len) {
            swap_images[last_idx] = try SwapImage.init(context, images[last_idx], format);
            last_idx += 1;
        }
        return swap_images;
    }

    fn findActualExtent(caps: vk.SurfaceCapabilitiesKHR, extent: vk.Extent2D) vk.Extent2D {
        if (caps.current_extent.width != std.math.maxInt(u32)) {
            return caps.current_extent;
        } else {
            return .{
                .width = std.math.clamp(extent.width, caps.min_image_extent.width, caps.max_image_extent.width),
                .height = std.math.clamp(extent.height, caps.min_image_extent.height, caps.max_image_extent.height),
            };
        }
    }

    fn findPresentationMode(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const DeviceContext,
    ) !vk.PresentModeKHR {
        const modes = try instance.getPhysicalDeviceSurfacePresentModesAllocKHR(context.pdev, context.surface, allocator);
        defer allocator.free(modes);

        for (modes) |mode| {
            if (mode == .mailbox_khr) return mode;
        }

        return .fifo_khr;
    }

    fn findSurfaceFormat(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const DeviceContext,
    ) !vk.SurfaceFormatKHR {
        const surface_formats = try instance.getPhysicalDeviceSurfaceFormatsAllocKHR(context.pdev, context.surface, allocator);
        defer allocator.free(surface_formats);

        const preffered = vk.SurfaceFormatKHR{
            .format = .r8g8b8_srgb,
            .color_space = .srgb_nonlinear_khr,
        };

        for (surface_formats) |format| {
            if (std.meta.eql(format, preffered)) return format;
        }

        return surface_formats[0];
    }
    const SwapImage = struct {
        context: *const DeviceContext,
        handle: vk.Image,
        view: vk.ImageView,

        image_acquired: vk.Semaphore,
        render_finished: vk.Semaphore,
        present_fence: vk.Fence,

        pub fn init(context: *const DeviceContext, handle: vk.Image, format: vk.Format) !@This() {
            const view = try context.dev.createImageView(&vk.ImageViewCreateInfo{
                .image = handle,
                .view_type = .@"2d",
                .format = format,
                .components = .{
                    .r = .identity,
                    .g = .identity,
                    .b = .identity,
                    .a = .identity,
                },
                .subresource_range = .{
                    .aspect_mask = .{ .color_bit = true },
                    .base_mip_level = 0,
                    .level_count = 1,
                    .base_array_layer = 0,
                    .layer_count = 1,
                },
            }, null);
            errdefer context.dev.destroyImageView(view, null);

            const image_acquired = try context.dev.createSemaphore(&.{}, null);
            errdefer context.dev.destroySemaphore(image_acquired, null);

            const render_finished = try context.dev.createSemaphore(&.{}, null);
            errdefer context.dev.destroySemaphore(render_finished, null);

            const present_fence = try context.dev.createFence(&.{ .flags = .{ .signaled_bit = true } }, null);
            errdefer context.dev.destroyFence(present_fence, null);

            return .{
                .context = context,
                .handle = handle,
                .view = view,
                .image_acquired = image_acquired,
                .render_finished = render_finished,
                .present_fence = present_fence,
            };
        }

        pub fn deinit(self: *@This()) void {
            self.waitForPresent() catch return;
            self.context.dev.destroyImageView(self.view, null);
            self.context.dev.destroySemaphore(self.image_acquired, null);
            self.context.dev.destroySemaphore(self.render_finished, null);
            self.context.dev.destroyFence(self.present_fence, null);
        }

        pub fn waitForPresent(self: *const @This()) !void {
            _ = try self.context.dev.waitForFences(1, @ptrCast(&self.present_fence), vk.TRUE, std.math.maxInt(u64));
        }
    };
};
