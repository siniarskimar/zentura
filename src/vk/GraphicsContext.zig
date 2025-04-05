const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("../vk.zig");
const c = @import("c");
const InstanceContext = @import("./InstanceContext.zig");

pub const required_device_extensions: vk.DeviceExtensions = .{ .VK_KHR_swapchain = true };

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
    extensions: vk.DeviceExtensions,
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

    var tmp_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer tmp_arena.deinit();

    const vkGetDeviceProcAddr = instance_ctx.instance.wrapper.dispatch.vkGetDeviceProcAddr;

    const device_candidate = try findDeviceCandidate(
        allocator,
        instance_ctx.instance,
        surface,
        tmp_arena.allocator(),
    );

    const device = try initializeDeviceCandidate(
        instance_ctx.instance,
        device_candidate,
        tmp_arena.allocator(),
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
    tmp_allocator: std.mem.Allocator,
) !DeviceCandidate {
    const physical_devices = try instance.enumeratePhysicalDevicesAlloc(tmp_allocator);

    if (physical_devices.len == 0) return error.NoPhysicalDevices;

    return for (physical_devices) |device| {
        const device_extensions = try vk.DeviceExtensions.enumerate(
            tmp_allocator,
            instance.wrapper,
            device,
        );

        if (!device_extensions.supportsRequired(required_device_extensions)) {
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
            .extensions = device_extensions,
        };
    } else error.NoSuitableDevice;
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
    instance: vk.Instance,
    candidate: DeviceCandidate,
    tmp_allocator: std.mem.Allocator,
) !zvk.Device {
    const exts = try candidate.extensions.asSlice(tmp_allocator);
    defer tmp_allocator.free(exts);

    return try instance.createDevice(candidate.pdev, &zvk.DeviceCreateInfo{
        .queue_create_info_count = if (candidate.queues.graphics_family == candidate.queues.present_family)
            1
        else
            2,
        .p_queue_create_infos = &[_]zvk.DeviceQueueCreateInfo{ .{
            .queue_family_index = candidate.queues.graphics_family,
            .queue_count = 1,
            .p_queue_priorities = &.{1},
        }, .{
            .queue_family_index = candidate.queues.present_family,
            .queue_count = 1,
            .p_queue_priorities = &.{1},
        } },
        .enabled_extension_count = @intCast(exts.len),
        .pp_enabled_extension_names = exts.ptr,
    }, null);
}
