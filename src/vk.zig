const std = @import("std");
const builtin = @import("builtin");
const c = @import("c");

pub const log = std.log.scoped(.vulkan);
const zvk = @import("zig-vulkan");

/// Features for which to generate and load function pointers
const apis: []const zvk.ApiInfo = &.{
    .{
        .base_commands = .{
            .createInstance = true,
        },
        .instance_commands = .{
            .createDevice = true,
        },
    },
    zvk.features.version_1_0,
    zvk.features.version_1_1,
    zvk.extensions.khr_surface,
    zvk.extensions.khr_swapchain,
};

pub const required_instance_extensions = [_][*:0]const u8{
    zvk.extensions.khr_surface.name,
};

pub const required_device_extensions = [_][*:0]const u8{
    zvk.extensions.khr_swapchain.name,
};

pub const BaseDispatch = zvk.BaseWrapper(apis);
pub const InstanceDispatch = zvk.InstanceWrapper(apis);
pub const DeviceDispatch = zvk.DeviceWrapper(apis);

pub const Instance = zvk.InstanceProxy(apis);
pub const Device = zvk.DeviceProxy(apis);
pub const CommandBuffer = zvk.CommandBufferProxy(apis);

pub const vkGetInstanceProcAddressFn = *const fn (
    instance: zvk.Instance,
    procname: [*:0]const u8,
) callconv(.C) zvk.PfnVoidFunction;

pub const InstanceContext = struct {
    instance: Instance,
    base_dispatch: BaseDispatch,

    const app_info: zvk.ApplicationInfo = .{
        .p_application_name = "zentura",
        .application_version = 0,
        .engine_version = 0,
        .api_version = zvk.API_VERSION_1_1,
    };

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

        const instance = try base_dispatch.createInstance(&zvk.InstanceCreateInfo{
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
    surface: zvk.SurfaceKHR,

    pdev: zvk.PhysicalDevice,
    properties: zvk.PhysicalDeviceProperties,
    memproperties: zvk.PhysicalDeviceMemoryProperties,

    dev: Device,
    graphics_queue: Queue,
    present_queue: Queue,

    pub fn init(
        allocator: std.mem.Allocator,
        instance: Instance,
        surface: zvk.SurfaceKHR,
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
        handle: zvk.Queue,
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
        pdev: zvk.PhysicalDevice,
        props: zvk.PhysicalDeviceProperties,
        queues: DeviceQueueFamilies,
    };

    fn findDeviceCandidate(allocator: std.mem.Allocator, instance: Instance, surface: zvk.SurfaceKHR) !DeviceCandidate {
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
        dev: zvk.PhysicalDevice,
        surface: zvk.SurfaceKHR,
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
            if (present == null and (try instance.getPhysicalDeviceSurfaceSupportKHR(dev, family, surface) == zvk.TRUE)) {
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
        device: zvk.PhysicalDevice,
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

    fn deviceSupportsSurface(instance: Instance, device: zvk.PhysicalDevice, surface: zvk.SurfaceKHR) !bool {
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
    ) !zvk.Device {
        const priority = [_]f32{1};

        return try instance.createDevice(candidate.pdev, &zvk.DeviceCreateInfo{
            .queue_create_info_count = if (candidate.queues.graphics_family == candidate.queues.present_family)
                1
            else
                2,
            .p_queue_create_infos = &[_]zvk.DeviceQueueCreateInfo{ .{
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
