const std = @import("std");
const vk = @import("../vk.zig");
const zvk = @import("zig-vulkan");
const c = @import("c");
const builtin = @import("builtin");

instance: vk.Instance,
base_dispatch: vk.BaseDispatch,

const app_info: zvk.ApplicationInfo = .{
    .p_application_name = "zentura",
    .application_version = 0,
    .engine_version = 0,
    .api_version = zvk.API_VERSION_1_1,
};

const vkGetInstanceProcAddressFn = vk.vkGetInstanceProcAddressFn;

pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window) !@This() {
    const getInstanceProcAddress = @as(
        ?vkGetInstanceProcAddressFn,
        @ptrCast(c.SDL_Vulkan_GetVkGetInstanceProcAddr()),
    ) orelse return error.vkGetInstanceProcAddress;

    const base_dispatch = try vk.BaseDispatch.load(getInstanceProcAddress);

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
