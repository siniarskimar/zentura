const std = @import("std");
const builtin = @import("builtin");
const c = @import("c");

pub const log = std.log.scoped(.vulkan);
pub const vk = @import("vulkan");

pub const ft = @cImport({
    @cInclude("ft2build.h");
    @cInclude("freetype/freetype.h");
});

/// Features for which to generate and load function pointers
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
    vk.features.version_1_1,
    vk.extensions.khr_surface,
    vk.extensions.khr_swapchain,
};

pub const required_instance_extensions = [_][*:0]const u8{
    vk.extensions.khr_surface.name,
};

pub const required_device_extensions = [_][*:0]const u8{
    vk.extensions.khr_swapchain.name,
};

pub const BaseDispatch = vk.BaseWrapper(apis);
pub const InstanceDispatch = vk.InstanceWrapper(apis);
pub const DeviceDispatch = vk.DeviceWrapper(apis);

pub const Instance = vk.InstanceProxy(apis);
pub const Device = vk.DeviceProxy(apis);

pub const vkGetInstanceProcAddressFn = *const fn (
    instance: vk.Instance,
    procname: [*:0]const u8,
) callconv(.C) vk.PfnVoidFunction;

pub const InstanceContext = struct {
    instance: Instance,
    base_dispatch: BaseDispatch,

    const app_info: vk.ApplicationInfo = .{
        .p_application_name = "zentura",
        .application_version = 0,
        .engine_version = 0,
        .api_version = vk.API_VERSION_1_1,
    };

    pub const CommandBuffer = vk.CommandBufferProxy(apis);

    pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window) !@This() {
        const getInstanceProcAddress = @as(
            ?vkGetInstanceProcAddressFn,
            @ptrCast(c.SDL_Vulkan_GetVkGetInstanceProcAddr()),
        ) orelse return error.vkGetInstanceProcAddress;

        const base_dispatch = try BaseDispatch.load(getInstanceProcAddress);

        var sdl_ext_count: c_uint = 0;
        if (c.SDL_Vulkan_GetInstanceExtensions(window, &sdl_ext_count, null) == c.SDL_FALSE) {
            return error.SDLGetInstanceExtensions;
        }

        const sdl_exts = try allocator.alloc([*c]const u8, sdl_ext_count);
        defer allocator.free(sdl_exts);

        if (c.SDL_Vulkan_GetInstanceExtensions(window, &sdl_ext_count, sdl_exts.ptr) == c.SDL_FALSE) {
            return error.SDLGetInstanceExtensions;
        }

        const vlayers = if (builtin.mode == .Debug)
            [_][*:0]const u8{"VK_LAYER_KHRONOS_validation"}
        else
            [_][*:0]const u8{};

        const instance = try base_dispatch.createInstance(&vk.InstanceCreateInfo{
            .p_application_info = &app_info,
            .enabled_extension_count = @intCast(sdl_exts.len),
            .pp_enabled_extension_names = @ptrCast(sdl_exts.ptr),
            .enabled_layer_count = vlayers.len,
            .pp_enabled_layer_names = &vlayers,
            .flags = .{},
        }, null);

        const instance_dispatch = try allocator.create(InstanceDispatch);
        errdefer allocator.destroy(instance_dispatch);
        instance_dispatch.* = try InstanceDispatch.load(instance, getInstanceProcAddress);

        return .{
            .instance = Instance.init(instance, instance_dispatch),
            .base_dispatch = base_dispatch,
        };
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.instance.destroyInstance(null);
        allocator.destroy(self.instance.wrapper);
    }
};

pub const RenderContext = struct {
    instance: Instance,
    surface: vk.SurfaceKHR,

    pdev: vk.PhysicalDevice,
    properties: vk.PhysicalDeviceProperties,
    memproperties: vk.PhysicalDeviceMemoryProperties,

    dev: Device,
    graphics_queue: Queue,
    present_queue: Queue,

    pub fn init(
        allocator: std.mem.Allocator,
        instance: Instance,
        surface: vk.SurfaceKHR,
    ) !@This() {
        const device_candidate = try findDeviceCandidate(allocator, instance, surface);
        const pdev = device_candidate.pdev;
        const props = device_candidate.props;

        const device = try initializeDeviceCandidate(&required_device_extensions, instance, device_candidate);

        const device_dispatch = try allocator.create(DeviceDispatch);
        errdefer allocator.destroy(device_dispatch);

        device_dispatch.* = try DeviceDispatch.load(device, instance.wrapper.dispatch.vkGetDeviceProcAddr);
        const dev = Device.init(device, device_dispatch);
        errdefer dev.destroyDevice(null);

        return .{
            .instance = instance,
            .surface = surface,
            .pdev = pdev,
            .properties = props,
            .memproperties = instance.getPhysicalDeviceMemoryProperties(pdev),
            .dev = dev,

            .graphics_queue = Queue.init(dev, device_candidate.queues.graphics_family, 0),
            .present_queue = Queue.init(dev, device_candidate.queues.present_family, 0),
        };
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
        device_extensions: []const [*:0]const u8,
        instance: Instance,
        candidate: DeviceCandidate,
    ) !vk.Device {
        const priority = [_]f32{1};

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
            .enabled_extension_count = @intCast(device_extensions.len),
            .pp_enabled_extension_names = device_extensions.ptr,
        }, null);
    }
};

pub const Swapchain = struct {
    instance: Instance,
    context: *const RenderContext,

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
        context: *const RenderContext,
        extent: vk.Extent2D,
    ) !@This() {
        return try recycle(allocator, instance, context, extent, .null_handle);
    }

    pub fn recreate(self: *@This(), allocator: std.mem.Allocator, extent: vk.Extent2D) !void {
        const instance = self.instance;
        const context = self.context;

        try self.context.dev.deviceWaitIdle();
        self.destroyWithoutHandle(allocator);
        self.* = try recycle(allocator, instance, context, extent, self.handle);
    }

    fn recycle(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const RenderContext,
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

    /// Enqueue cmdbuf for the current frame and acquire the next swap-image
    /// Asserts that the current frame has finished rendering
    pub fn present(self: *@This(), cmdbuf: vk.CommandBuffer) !enum { optimal, suboptimal } {
        const current_img = self.currentSwapImage();
        if (try self.context.dev.getFenceStatus(current_img.render_fence) != .not_ready) {
            std.debug.panic("assertion failed: current frame has not finished rendering", .{});
        }

        // Sumbit the command buffer
        // This queues up the work for the next frame, but doesn't start it yet
        const wait_stage = [_]vk.PipelineStageFlags{.{ .top_of_pipe_bit = true }};
        try self.context.dev.queueSubmit(
            self.context.graphics_queue.handle,
            1,
            &[_]vk.SubmitInfo{.{
                .wait_semaphore_count = 1,
                // Wait till the next image is acquired
                .p_wait_semaphores = @ptrCast(&current_img.image_acquired),
                .p_wait_dst_stage_mask = &wait_stage,
                .command_buffer_count = 1,
                .p_command_buffers = @ptrCast(&cmdbuf),
                .signal_semaphore_count = 1,
                // Signal that rendering finished on GPU
                .p_signal_semaphores = @ptrCast(&current_img.render_semaphore),
            }},
            // Trip render_fence once work has completed
            current_img.render_fence,
        );

        // Present current_img when rendering has finished
        _ = try self.context.dev.queuePresentKHR(self.context.present_queue.handle, &.{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = @ptrCast(&current_img.render_semaphore),
            .swapchain_count = 1,
            .p_swapchains = @ptrCast(&self.handle),
            .p_image_indices = @ptrCast(&self.image_index),
        });

        // Acquire next image
        // This will start the rendering of the next image
        const result = try self.context.dev.acquireNextImageKHR(
            self.handle,
            std.math.maxInt(u64),
            // Since we don't know the index of the next image to be acquired
            // We have to reference a semaphore outside of self.swap_images
            self.next_image_acquired,
            // Optional fence to signal
            .null_handle,
        );

        // Make the next image as the present image
        std.mem.swap(
            vk.Semaphore,
            &self.swap_images[result.image_index].image_acquired,
            &self.next_image_acquired,
        );
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
        // If we fail to wait, just wait on the CPU and cross fingers the GPU
        // completed all jobs
        self.context.dev.deviceWaitIdle() catch |err| {
            log.warn("deviceWaitIdle failed: {s}", .{@errorName(err)});
            std.time.sleep(std.time.ns_per_ms * 20);
        };
        self.destroyWithoutHandle(allocator);
        self.context.dev.destroySwapchainKHR(self.handle, null);
    }

    fn initSwapchainImages(
        allocator: std.mem.Allocator,
        context: *const RenderContext,
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

    /// Tries to find V-sync enabled mode `mailbox_khr`, else fallback to `fifo_khr`.
    ///
    /// `mailbox_khr` maintains a single-entry queue. Whenever a new image is pushed
    /// it gets replaced with new one.
    ///
    /// [p] - [1]
    ///
    /// `fifo_khr` maintains a mutiple-entry queue. Each entry is appened to the end of the queue
    ///
    /// [p] - [1] - [2] - ...
    // TODO: When using mailbox_khr, manually limit frame rate to display's refresh rate
    fn findPresentationMode(
        _: std.mem.Allocator,
        _: Instance,
        _: *const RenderContext,
    ) !vk.PresentModeKHR {
        // const modes = try instance.getPhysicalDeviceSurfacePresentModesAllocKHR(context.pdev, context.surface, allocator);
        // defer allocator.free(modes);

        // for (modes) |mode| {
        //     if (mode == .mailbox_khr) return mode;
        // }

        return .fifo_khr;
    }

    /// Tries to find RGB8 srgb surface format.
    /// If the search fails, returns whatever the first format was reported
    fn findSurfaceFormat(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const RenderContext,
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
        context: *const RenderContext,
        handle: vk.Image,
        view: vk.ImageView,

        /// Signaled whenever this SwapImage has been released by the OS
        /// and is ready to be rendered to
        image_acquired: vk.Semaphore,

        /// Signaled whenever a framebuffer has finished rendering
        /// GPU-side only, CPU doesn't know the state of the semaphore
        render_semaphore: vk.Semaphore,

        /// Same as render_semaphore but this fence the CPU is signaled
        render_fence: vk.Fence,

        pub fn init(context: *const RenderContext, handle: vk.Image, format: vk.Format) !@This() {
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

            const render_semaphore = try context.dev.createSemaphore(&.{}, null);
            errdefer context.dev.destroySemaphore(render_semaphore, null);

            const render_fence = try context.dev.createFence(&.{
                // create it in signaled state so present() doesn't deadlock
                .flags = .{ .signaled_bit = true },
            }, null);
            errdefer context.dev.destroyFence(render_fence, null);

            return .{
                .context = context,
                .handle = handle,
                .view = view,
                .image_acquired = image_acquired,
                .render_semaphore = render_semaphore,
                .render_fence = render_fence,
            };
        }

        pub fn deinit(self: *@This()) void {
            _ = self.context.dev.waitForFences(
                1,
                &.{self.render_fence},
                vk.TRUE,
                std.time.ns_per_ms * 500,
            ) catch {};
            self.context.dev.destroyImageView(self.view, null);
            self.context.dev.destroySemaphore(self.image_acquired, null);
            self.context.dev.destroySemaphore(self.render_semaphore, null);
            self.context.dev.destroyFence(self.render_fence, null);
        }
    };
};

pub const Renderer = struct {
    window: *c.SDL_Window,
    allocator: std.mem.Allocator,

    ctx: InstanceContext,
    rctx: *RenderContext,
    swapchain: Swapchain,

    render_pass: vk.RenderPass,
    pipeline_layout: vk.PipelineLayout,
    pipeline: vk.Pipeline,
    cmdpool: vk.CommandPool,
    framebuffers: []vk.Framebuffer,
    cmdbufs: []vk.CommandBuffer,

    should_resize: bool = false,
    frame_count: u64 = 0,
    ft_library: ft.FT_Library,
    ft_face: ft.FT_Face = null,

    const shaders = @import("shaders");

    extern fn SDL_Vulkan_CreateSurface(
        window: *c.SDL_Window,
        instance: vk.Instance,
        surface: *vk.SurfaceKHR,
    ) c.SDL_bool;

    pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window, ft_library: ft.FT_Library) !@This() {
        var ctx = try InstanceContext.init(allocator, window);
        errdefer ctx.deinit(allocator);

        var surface: vk.SurfaceKHR = .null_handle;
        if (SDL_Vulkan_CreateSurface(window, ctx.instance.handle, &surface) == c.SDL_FALSE) {
            log.err("failed to create Vulkan surface: {s}", .{c.SDL_GetError()});
            return error.CreateSurfaceFailed;
        }
        errdefer ctx.instance.destroySurfaceKHR(surface, null);

        const rctx = try allocator.create(RenderContext);
        errdefer allocator.destroy(rctx);

        rctx.* = try RenderContext.init(allocator, ctx.instance, surface);
        errdefer rctx.deinit(allocator);

        var window_width: c_int = undefined;
        var window_height: c_int = undefined;
        c.SDL_Vulkan_GetDrawableSize(window, &window_width, &window_height);

        var swapchain = try Swapchain.create(
            allocator,
            ctx.instance,
            rctx,
            .{ .width = @intCast(window_width), .height = @intCast(window_height) },
        );
        errdefer swapchain.destroy(allocator);

        const render_pass = try createRenderPass(rctx.dev, swapchain);
        errdefer rctx.dev.destroyRenderPass(render_pass, null);

        const layout = try rctx.dev.createPipelineLayout(&vk.PipelineLayoutCreateInfo{}, null);
        errdefer rctx.dev.destroyPipelineLayout(layout, null);

        const pipeline = try createVulkanPipeline(rctx.dev, layout, render_pass);
        errdefer rctx.dev.destroyPipeline(pipeline, null);

        const cmdpool = try rctx.dev.createCommandPool(
            &vk.CommandPoolCreateInfo{
                .queue_family_index = rctx.graphics_queue.family,
                .flags = .{ .reset_command_buffer_bit = true },
            },
            null,
        );
        errdefer rctx.dev.destroyCommandPool(cmdpool, null);

        const framebuffers = try createFramebuffers(allocator, rctx.dev, render_pass, swapchain);
        errdefer destroyFramebuffers(allocator, rctx.dev, framebuffers);

        const cmdbufs = try allocateCommandBuffers(
            allocator,
            rctx.dev,
            cmdpool,
            framebuffers,
        );
        errdefer destroyCommandBuffers(allocator, rctx.dev, cmdpool, cmdbufs);

        return .{
            .window = window,
            .allocator = allocator,
            .ctx = ctx,
            .rctx = rctx,
            .ft_library = ft_library,
            .swapchain = swapchain,

            .render_pass = render_pass,
            .pipeline_layout = layout,
            .pipeline = pipeline,
            .cmdpool = cmdpool,
            .cmdbufs = cmdbufs,
            .framebuffers = framebuffers,
        };
    }

    pub fn deinit(self: *@This()) void {
        const allocator = self.allocator;
        self.rctx.dev.deviceWaitIdle() catch std.time.sleep(std.time.ns_per_ms * 20);

        destroyFramebuffers(allocator, self.rctx.dev, self.framebuffers);
        destroyCommandBuffers(allocator, self.rctx.dev, self.cmdpool, self.cmdbufs);
        self.rctx.dev.destroyCommandPool(self.cmdpool, null);

        self.rctx.dev.destroyPipeline(self.pipeline, null);
        self.rctx.dev.destroyPipelineLayout(self.pipeline_layout, null);
        self.rctx.dev.destroyRenderPass(self.render_pass, null);

        self.swapchain.destroy(allocator);
        self.rctx.deinit(allocator);
        allocator.destroy(self.rctx);
        self.ctx.deinit(allocator);
    }

    pub fn present(self: *@This()) !void {
        const dev = self.rctx.dev;
        const extent = self.swapchain.extent;
        const cmdbuf = self.cmdbufs[self.swapchain.image_index];
        const framebuffer = self.framebuffers[self.swapchain.image_index];
        switch (try dev.waitForFences(
            1,
            &.{self.swapchain.currentSwapImage().render_fence},
            vk.TRUE,
            std.time.ns_per_s,
        )) {
            vk.Result.success => {},
            vk.Result.timeout => return error.Timeout,
            else => return error.Unknown,
        }
        try dev.resetFences(1, &.{self.swapchain.currentSwapImage().render_fence});
        try dev.resetCommandBuffer(cmdbuf, .{});

        const clear = vk.ClearValue{ .color = .{
            .float_32 = .{
                0,
                @abs(std.math.sin(@as(f32, @floatFromInt(self.frame_count)) / 120.0)),
                0,
                1,
            },
        } };
        const viewport = vk.Viewport{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(self.swapchain.extent.width),
            .height = @floatFromInt(self.swapchain.extent.height),
            .min_depth = 0,
            .max_depth = 1,
        };
        const scissor = vk.Rect2D{
            .offset = .{ .x = 0, .y = 0 },
            .extent = self.swapchain.extent,
        };
        try dev.beginCommandBuffer(cmdbuf, &vk.CommandBufferBeginInfo{
            .flags = .{ .one_time_submit_bit = true },
        });
        dev.cmdPipelineBarrier(
            cmdbuf,
            .{ .all_graphics_bit = true },
            .{ .all_graphics_bit = true },
            .{ .by_region_bit = true },
            0,
            null,
            0,
            null,
            1,
            &[_]vk.ImageMemoryBarrier{
                vk.ImageMemoryBarrier{
                    .image = self.swapchain.swap_images[self.swapchain.image_index].handle,
                    .src_access_mask = .{ .memory_write_bit = true },
                    .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
                    .old_layout = .undefined,
                    .new_layout = .color_attachment_optimal,
                    .src_queue_family_index = self.rctx.graphics_queue.family,
                    .dst_queue_family_index = self.rctx.graphics_queue.family,
                    .subresource_range = vk.ImageSubresourceRange{
                        .aspect_mask = .{ .color_bit = true },
                        .base_mip_level = 0,
                        .level_count = vk.REMAINING_MIP_LEVELS,
                        .base_array_layer = 0,
                        .layer_count = vk.REMAINING_ARRAY_LAYERS,
                    },
                },
            },
        );

        dev.cmdSetViewport(cmdbuf, 0, 1, @ptrCast(&viewport));
        dev.cmdSetScissor(cmdbuf, 0, 1, @ptrCast(&scissor));

        const render_area = vk.Rect2D{
            .offset = .{ .x = 0, .y = 0 },
            .extent = extent,
        };

        dev.cmdBeginRenderPass(cmdbuf, &.{
            .render_pass = self.render_pass,
            .framebuffer = framebuffer,
            .render_area = render_area,
            .clear_value_count = 1,
            .p_clear_values = @ptrCast(&clear),
        }, .@"inline");

        dev.cmdBindPipeline(cmdbuf, .graphics, self.pipeline);
        dev.cmdDraw(cmdbuf, 3, 1, 0, 0);
        dev.cmdEndRenderPass(cmdbuf);

        dev.cmdPipelineBarrier(
            cmdbuf,
            .{ .all_graphics_bit = true },
            .{ .all_graphics_bit = true },
            .{ .by_region_bit = true },
            0,
            null,
            0,
            null,
            1,
            &[_]vk.ImageMemoryBarrier{
                vk.ImageMemoryBarrier{
                    .image = self.swapchain.swap_images[self.swapchain.image_index].handle,
                    .src_access_mask = .{ .memory_write_bit = true },
                    .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
                    .old_layout = .color_attachment_optimal,
                    .new_layout = .present_src_khr,
                    .src_queue_family_index = self.rctx.graphics_queue.family,
                    .dst_queue_family_index = self.rctx.graphics_queue.family,
                    .subresource_range = vk.ImageSubresourceRange{
                        .aspect_mask = .{ .color_bit = true },
                        .base_mip_level = 0,
                        .level_count = vk.REMAINING_MIP_LEVELS,
                        .base_array_layer = 0,
                        .layer_count = vk.REMAINING_ARRAY_LAYERS,
                    },
                },
            },
        );
        try dev.endCommandBuffer(cmdbuf);

        const result = self.swapchain.present(cmdbuf) catch |err| switch (err) {
            error.OutOfDateKHR => .suboptimal,
            else => return err,
        };
        self.frame_count += 1;

        if (result == .suboptimal or self.should_resize) {
            self.should_resize = false;
            var window_width: c_int = undefined;
            var window_height: c_int = undefined;
            c.SDL_Vulkan_GetDrawableSize(self.window, &window_width, &window_height);

            try self.swapchain.recreate(
                self.allocator,
                .{ .width = @intCast(window_width), .height = @intCast(window_height) },
            );

            destroyFramebuffers(self.allocator, self.rctx.dev, self.framebuffers);
            self.framebuffers = try createFramebuffers(
                self.allocator,
                self.rctx.dev,
                self.render_pass,
                self.swapchain,
            );

            destroyCommandBuffers(self.allocator, self.rctx.dev, self.cmdpool, self.cmdbufs);
            self.cmdbufs = try allocateCommandBuffers(
                self.allocator,
                self.rctx.dev,
                self.cmdpool,
                self.framebuffers,
            );
        }
    }

    fn destroyCommandBuffers(
        allocator: std.mem.Allocator,
        dev: Device,
        cmdpool: vk.CommandPool,
        cmdbufs: []vk.CommandBuffer,
    ) void {
        dev.freeCommandBuffers(cmdpool, @intCast(cmdbufs.len), cmdbufs.ptr);
        allocator.free(cmdbufs);
    }

    fn destroyFramebuffers(allocator: std.mem.Allocator, dev: Device, framebuffers: []vk.Framebuffer) void {
        for (framebuffers) |fb| dev.destroyFramebuffer(fb, null);
        allocator.free(framebuffers);
    }

    fn allocateCommandBuffers(
        allocator: std.mem.Allocator,
        dev: Device,
        cmdpool: vk.CommandPool,
        framebuffers: []vk.Framebuffer,
    ) ![]vk.CommandBuffer {
        const cmdbufs = try allocator.alloc(vk.CommandBuffer, framebuffers.len);
        errdefer allocator.free(cmdbufs);

        try dev.allocateCommandBuffers(&.{
            .command_pool = cmdpool,
            .level = .primary,
            .command_buffer_count = @intCast(cmdbufs.len),
        }, cmdbufs.ptr);

        return cmdbufs;
    }

    fn createFramebuffers(
        allocator: std.mem.Allocator,
        dev: Device,
        render_pass: vk.RenderPass,
        swapchain: Swapchain,
    ) ![]vk.Framebuffer {
        var framebuffers = try allocator.alloc(vk.Framebuffer, swapchain.swap_images.len);
        errdefer allocator.free(framebuffers);

        var idx: usize = 0;
        errdefer for (framebuffers[0..idx]) |fb| dev.destroyFramebuffer(fb, null);

        while (idx < framebuffers.len) {
            framebuffers[idx] = try dev.createFramebuffer(&vk.FramebufferCreateInfo{
                .render_pass = render_pass,
                .attachment_count = 1,
                .p_attachments = @ptrCast(&swapchain.swap_images[idx].view),
                .width = swapchain.extent.width,
                .height = swapchain.extent.height,
                .layers = 1,
            }, null);
            idx += 1;
        }

        return framebuffers;
    }

    fn createRenderPass(dev: Device, swapchain: Swapchain) !vk.RenderPass {
        const color_attachment = vk.AttachmentDescription{
            .format = swapchain.surface_format.format,
            .samples = .{ .@"1_bit" = true },
            .load_op = .clear,
            .store_op = .store,
            .stencil_load_op = .dont_care,
            .stencil_store_op = .dont_care,
            .initial_layout = .color_attachment_optimal,
            .final_layout = .color_attachment_optimal,
        };

        const color_attachment_ref = vk.AttachmentReference{
            .attachment = 0,
            .layout = .color_attachment_optimal,
        };

        const subpass = vk.SubpassDescription{
            .pipeline_bind_point = .graphics,
            .color_attachment_count = 1,
            .p_color_attachments = @ptrCast(&color_attachment_ref),
        };

        return try dev.createRenderPass(&vk.RenderPassCreateInfo{
            .attachment_count = 1,
            .p_attachments = @ptrCast(&color_attachment),
            .subpass_count = 1,
            .p_subpasses = @ptrCast(&subpass),
        }, null);
    }

    fn createVulkanPipeline(
        dev: Device,
        layout: vk.PipelineLayout,
        render_pass: vk.RenderPass,
    ) !vk.Pipeline {
        const vert_module = try dev.createShaderModule(&vk.ShaderModuleCreateInfo{
            .code_size = shaders.triangle_vert.len,
            .p_code = @ptrCast(&shaders.triangle_vert),
        }, null);
        defer dev.destroyShaderModule(vert_module, null);

        const frag_module = try dev.createShaderModule(&vk.ShaderModuleCreateInfo{
            .code_size = shaders.triangle_frag.len,
            .p_code = @ptrCast(&shaders.triangle_frag),
        }, null);
        defer dev.destroyShaderModule(frag_module, null);

        const shader_stages = [_]vk.PipelineShaderStageCreateInfo{
            .{
                .module = vert_module,
                .p_name = "main",
                .stage = .{ .vertex_bit = true },
            },
            .{
                .module = frag_module,
                .p_name = "main",
                .stage = .{ .fragment_bit = true },
            },
        };

        const vertex_input_info = vk.PipelineVertexInputStateCreateInfo{
            .vertex_binding_description_count = 0,
            .vertex_attribute_description_count = 0,
        };

        const input_assembly_info = vk.PipelineInputAssemblyStateCreateInfo{
            .topology = .triangle_list,
            .primitive_restart_enable = vk.FALSE,
        };

        const dynamic_state = [_]vk.DynamicState{ .viewport, .scissor };
        const dynamic_state_info = vk.PipelineDynamicStateCreateInfo{
            .dynamic_state_count = dynamic_state.len,
            .p_dynamic_states = &dynamic_state,
        };

        const viewport_state = vk.PipelineViewportStateCreateInfo{
            .viewport_count = 1,
            .p_viewports = undefined,
            .scissor_count = 1,
            .p_scissors = undefined,
        };

        const rasterizer_info = vk.PipelineRasterizationStateCreateInfo{
            .flags = .{},
            .depth_clamp_enable = vk.FALSE,
            .rasterizer_discard_enable = vk.FALSE,
            .polygon_mode = .fill,
            .cull_mode = .{ .back_bit = true },
            .front_face = .clockwise,
            .depth_bias_enable = vk.FALSE,
            .depth_bias_constant_factor = 0,
            .depth_bias_clamp = 0,
            .depth_bias_slope_factor = 0,
            .line_width = 1,
        };
        const multisampling_info = vk.PipelineMultisampleStateCreateInfo{
            .rasterization_samples = .{ .@"1_bit" = true },
            .min_sample_shading = 1,
            .alpha_to_coverage_enable = vk.FALSE,
            .alpha_to_one_enable = vk.FALSE,
            .sample_shading_enable = vk.FALSE,
        };

        const colorblending_attach_info = vk.PipelineColorBlendAttachmentState{
            .blend_enable = vk.FALSE,
            .src_color_blend_factor = .one,
            .dst_color_blend_factor = .zero,
            .color_blend_op = .add,
            .src_alpha_blend_factor = .one,
            .dst_alpha_blend_factor = .zero,
            .alpha_blend_op = .add,
            .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = false },
        };

        const colorblending_info = vk.PipelineColorBlendStateCreateInfo{
            .logic_op_enable = vk.FALSE,
            .logic_op = .copy,
            .attachment_count = 1,
            .p_attachments = @ptrCast(&colorblending_attach_info),
            .blend_constants = .{ 0, 0, 0, 0 },
        };

        const pipeline_info = vk.GraphicsPipelineCreateInfo{
            .stage_count = 2,
            .p_stages = &shader_stages,
            .p_vertex_input_state = &vertex_input_info,
            .p_input_assembly_state = &input_assembly_info,
            .p_tessellation_state = null,
            .p_viewport_state = &viewport_state,
            .p_rasterization_state = &rasterizer_info,
            .p_multisample_state = &multisampling_info,
            .p_depth_stencil_state = null,
            .p_color_blend_state = &colorblending_info,
            .p_dynamic_state = &dynamic_state_info,
            .layout = layout,
            .render_pass = render_pass,
            .subpass = 0,
            .base_pipeline_handle = .null_handle,
            .base_pipeline_index = -1,
        };

        var pipeline: vk.Pipeline = .null_handle;
        _ = try dev.createGraphicsPipelines(
            .null_handle,
            1,
            @ptrCast(&pipeline_info),
            null,
            @ptrCast(&pipeline),
        );
        return pipeline;
    }
};
