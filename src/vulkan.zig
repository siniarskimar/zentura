const std = @import("std");
const builtin = @import("builtin");

const wayland = if (builtin.os.tag == .linux) @import("wayland").client else {};
const wl = wayland.wl;
const vk = @import("vulkan");

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
    vk.extensions.khr_wayland_surface,
    vk.extensions.khr_swapchain,
};

const required_instance_extensions = [_][*:0]const u8{
    vk.extensions.khr_surface.name,
    vk.extensions.khr_wayland_surface.name,
};

const required_device_extensions = [_][*:0]const u8{
    vk.extensions.khr_swapchain.name,
};

const BaseDispatch = vk.BaseWrapper(apis);
const InstanceDispatch = vk.InstanceWrapper(apis);
const DeviceDispatch = vk.DeviceWrapper(apis);

const Instance = vk.InstanceProxy(apis);
const Device = vk.DeviceProxy(apis);

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

    surface: vk.SurfaceKHR,

    pdev: vk.PhysicalDevice,
    pdevprops: vk.PhysicalDeviceProperties,
    pdevmemprops: vk.PhysicalDeviceMemoryProperties,

    dev: Device,
    graphics_queue: Queue,
    present_queue: Queue,

    getInstanceProcAddress: vkGetInstanceProcAddressFn,

    const app_info: vk.ApplicationInfo = .{
        .p_application_name = "zentura",
        .application_version = 0,
        .engine_version = 0,
        .api_version = vk.API_VERSION_1_0,
    };

    pub const CommandBuffer = vk.CommandBufferProxy(apis);

    fn init(allocator: std.mem.Allocator) !@This() {
        var self: Context = undefined;
        self.getInstanceProcAddress = vkGetInstanceProcAddress orelse return error.VkGetInstanceProcAddressNull;

        self.base_dispatch = try BaseDispatch.load(self.getInstanceProcAddress);
        const instance = try self.base_dispatch.createInstance(&vk.InstanceCreateInfo{
            .p_application_info = &app_info,
            .enabled_extension_count = @intCast(required_instance_extensions.len),
            .pp_enabled_extension_names = @ptrCast(&required_instance_extensions),
            .flags = .{},
        }, null);

        const instance_dispatch = try allocator.create(InstanceDispatch);
        errdefer allocator.destroy(instance_dispatch);
        instance_dispatch.* = try InstanceDispatch.load(instance, self.getInstanceProcAddress);
        self.instance = Instance.init(instance, instance_dispatch);

        return self;
    }

    pub fn initWayland(allocator: std.mem.Allocator, wl_display: *wl.Display, wl_surface: *wl.Surface) !@This() {
        var self = try init(allocator);
        errdefer allocator.destroy(self.instance.wrapper);
        errdefer self.instance.destroyInstance(null);

        self.surface = try self.instance.createWaylandSurfaceKHR(&vk.WaylandSurfaceCreateInfoKHR{
            .display = @ptrCast(wl_display),
            .surface = @ptrCast(wl_surface),
            .flags = .{},
        }, null);
        errdefer self.instance.destroySurfaceKHR(self.surface, null);

        const device_candidate = try findDeviceCandidate(allocator, self.instance, self.surface);
        self.pdev = device_candidate.pdev;
        self.pdevprops = device_candidate.props;

        const device = try initializeDeviceCandidate(self.instance, device_candidate);

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

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.dev.destroyDevice(null);
        allocator.destroy(self.dev.wrapper);

        self.instance.destroySurfaceKHR(self.surface, null);

        self.instance.destroyInstance(null);
        allocator.destroy(self.instance.wrapper);
    }

    fn initializeDeviceCandidate(instance: Instance, candidate: DeviceCandidate) !vk.Device {
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
            .enabled_extension_count = @intCast(required_device_extensions.len),
            .pp_enabled_extension_names = &required_device_extensions,
        }, null);
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
            const queues = allocateQueues(allocator, instance, device, surface) catch |err| switch (err) {
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

    fn allocateQueues(allocator: std.mem.Allocator, instance: Instance, dev: vk.PhysicalDevice, surface: vk.SurfaceKHR) !DeviceQueueFamilies {
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

    fn deviceSupportsRequiredExtensions(allocator: std.mem.Allocator, instance: Instance, device: vk.PhysicalDevice) !bool {
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
};
