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
