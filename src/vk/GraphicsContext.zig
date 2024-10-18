const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("../vk.zig");
const c = @import("c");
const InstanceContext = @import("./InstanceContext.zig");

pub const required_device_extensions = [_][*:0]const u8{
    zvk.extensions.khr_swapchain.name,
};

const log = std.log.scoped(.vk_graphics_context);

base_dispatch: vk.BaseDispatch,
instance: vk.Instance,
surface: zvk.SurfaceKHR = .null_handle,

pdev: zvk.PhysicalDevice,
properties: zvk.PhysicalDeviceProperties,
memproperties: zvk.PhysicalDeviceMemoryProperties,

dev: vk.Device,
graphics_queue: Queue,
present_queue: Queue,

pub const Queue = struct {
    handle: zvk.Queue,
    family: u32,

    fn init(device: vk.Device, family: u32, queue_index: u32) @This() {
        return .{
            .handle = device.getDeviceQueue(family, queue_index),
            .family = family,
        };
    }
};

const DeviceCandidate = struct {
    pdev: zvk.PhysicalDevice,
    props: zvk.PhysicalDeviceProperties,
    queues: DeviceQueueFamilies,
};

const DeviceQueueFamilies = struct {
    graphics_family: u32,
    present_family: u32,
};

const vkDestroyDevicePfn = *const fn (
    zvk.Device,
    ?*const zvk.AllocationCallbacks,
) callconv(.C) void;

pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window) !@This() {
    const instance_ctx = try InstanceContext.init(allocator, window);
    errdefer instance_ctx.deinit(allocator);

    const surface = try SDLCreateVulkanSurface(instance_ctx.instance, window);
    errdefer instance_ctx.instance.destroySurfaceKHR(surface, null);

    const vkGetDeviceProcAddr = instance_ctx.instance.wrapper.dispatch.vkGetDeviceProcAddr;

    const device_candidate = try findDeviceCandidate(allocator, instance_ctx.instance, surface);
    const device = try initializeDeviceCandidate(
        &required_device_extensions,
        instance_ctx.instance,
        device_candidate,
    );
    const vkDestroyDevice: vkDestroyDevicePfn = @ptrCast(vkGetDeviceProcAddr(device, "vkDestroyDevice"));
    errdefer vkDestroyDevice(device, null);

    const device_dispatch = try allocator.create(vk.DeviceDispatch);
    errdefer allocator.destroy(device_dispatch);

    device_dispatch.* = try vk.DeviceDispatch.load(
        device,
        vkGetDeviceProcAddr,
    );

    const dev = vk.Device.init(device, device_dispatch);
    errdefer dev.destroyDevice(null);

    return .{
        .base_dispatch = instance_ctx.base_dispatch,
        .instance = instance_ctx.instance,
        .surface = surface,
        .pdev = device_candidate.pdev,
        .properties = device_candidate.props,
        .memproperties = instance_ctx.instance.getPhysicalDeviceMemoryProperties(device_candidate.pdev),
        .dev = dev,
        .graphics_queue = Queue.init(dev, device_candidate.queues.graphics_family, 0),
        .present_queue = Queue.init(dev, device_candidate.queues.present_family, 0),
    };
}

pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
    self.instance.destroySurfaceKHR(self.surface, null);
    self.dev.destroyDevice(null);
    self.instance.destroyInstance(null);
    allocator.destroy(self.instance.wrapper);
    allocator.destroy(self.dev.wrapper);
}

extern fn SDL_Vulkan_CreateSurface(
    window: *c.SDL_Window,
    instance: zvk.Instance,
    surface: *zvk.SurfaceKHR,
) c.SDL_bool;

fn SDLCreateVulkanSurface(instance: vk.Instance, window: *c.SDL_Window) !zvk.SurfaceKHR {
    var surface: zvk.SurfaceKHR = .null_handle;
    if (SDL_Vulkan_CreateSurface(window, instance.handle, &surface) == c.SDL_FALSE) {
        log.err("failed to create Vulkan surface out of SDL window: {s}", .{c.SDL_GetError()});
        return error.CreateSurfaceFailed;
    }
    return surface;
}

fn findDeviceCandidate(
    allocator: std.mem.Allocator,
    instance: vk.Instance,
    surface: zvk.SurfaceKHR,
) !DeviceCandidate {
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

fn deviceSupportsRequiredExtensions(
    allocator: std.mem.Allocator,
    instance: vk.Instance,
    device: zvk.PhysicalDevice,
) !bool {
    const ext_properties = try instance.enumerateDeviceExtensionPropertiesAlloc(device, null, allocator);
    defer allocator.free(ext_properties);

    // Fine for small number of extensions
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

fn deviceSupportsSurface(instance: vk.Instance, device: zvk.PhysicalDevice, surface: zvk.SurfaceKHR) !bool {
    var format_count: u32 = undefined;
    var present_mode_count: u32 = undefined;

    _ = try instance.getPhysicalDeviceSurfaceFormatsKHR(device, surface, &format_count, null);
    _ = try instance.getPhysicalDeviceSurfacePresentModesKHR(device, surface, &present_mode_count, null);

    return format_count > 0 and present_mode_count > 0;
}

fn findRequiredQueues(
    allocator: std.mem.Allocator,
    instance: vk.Instance,
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

fn initializeDeviceCandidate(
    device_extensions: []const [*:0]const u8,
    instance: vk.Instance,
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
