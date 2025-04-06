const std = @import("std");
const vk = @import("../vk.zig");
const zvk = @import("zig-vulkan");
const glfw = @import("../bindings/glfw.zig");
const builtin = @import("builtin");

instance: vk.Instance,
base_dispatch: vk.BaseDispatch,

const app_info: zvk.ApplicationInfo = .{
    .application_version = 0,
    .engine_version = 0,
    .api_version = zvk.API_VERSION_1_1,
};

pub fn init(allocator: std.mem.Allocator) !@This() {
    if (!glfw.vulkanSupported()) return error.VulkanUnsupported;

    const getInstanceProcAddress = @as(
        ?vk.vkGetInstanceProcAddressFn,
        @ptrCast(&glfw.getInstanceProcAddress),
    ) orelse return error.vkGetInstanceProcAddress;

    var tmp_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer tmp_arena.deinit();

    const base_dispatch = try vk.BaseDispatch.load(getInstanceProcAddress);

    const validation_layers = try vk.ValidationLayers.enumerate(tmp_arena.allocator(), &base_dispatch);
    if (builtin.mode == .Debug and !validation_layers.VK_LAYER_KHRONOS_validation) {
        vk.log.warn("VK_LAYER_KHRONOS_validation layer is not present, no vulkan messages will be emited", .{});
    }

    var instance_extensions = try vk.InstanceExtensions.enumerate(tmp_arena.allocator(), &base_dispatch);

    // Let GLFW decide surface extensions
    instance_extensions.disableSurfaceRelated();
    const req_exts = glfw.getInstanceExtensions();
    for (req_exts) |ext| {
        instance_extensions.set(ext);
    }

    const exts = try instance_extensions.asSlice(tmp_arena.allocator());
    const vlayers = try validation_layers.asSlice(tmp_arena.allocator());

    const instance = try base_dispatch.createInstance(&zvk.InstanceCreateInfo{
        .p_application_info = &app_info,
        .enabled_extension_count = @intCast(exts.len),
        .pp_enabled_extension_names = @ptrCast(exts.ptr),
        .enabled_layer_count = @intCast(vlayers.len),
        .pp_enabled_layer_names = @ptrCast(vlayers.ptr),
        .flags = .{},
    }, null);

    const vkDestroyInstance: zvk.PfnDestroyInstance = @ptrCast(getInstanceProcAddress(instance, "vkDestroyInstance"));
    errdefer vkDestroyInstance(instance, null);

    const instance_dispatch = try allocator.create(vk.InstanceDispatch);
    errdefer allocator.destroy(instance_dispatch);
    instance_dispatch.* = try vk.InstanceDispatch.load(instance, getInstanceProcAddress);

    return .{
        .instance = vk.Instance.init(instance, instance_dispatch),
        .base_dispatch = base_dispatch,
    };
}

pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
    self.instance.destroyInstance(null);
    allocator.destroy(self.instance.wrapper);
}
