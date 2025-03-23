const std = @import("std");
const vk = @import("../vk.zig");
const zvk = @import("zig-vulkan");
const c = @import("c");
const builtin = @import("builtin");

instance: vk.Instance,
base_dispatch: vk.BaseDispatch,

const app_info: zvk.ApplicationInfo = .{
    .application_version = 0,
    .engine_version = 0,
    .api_version = zvk.API_VERSION_1_1,
};

pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window) !@This() {
    const getInstanceProcAddress = @as(
        ?vk.vkGetInstanceProcAddressFn,
        @ptrCast(c.SDL_Vulkan_GetVkGetInstanceProcAddr()),
    ) orelse return error.vkGetInstanceProcAddress;

    var tmp_arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer tmp_arena.deinit();

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

    const validation_layers = try ValidationLayers.enumerate(tmp_arena.allocator(), &base_dispatch);
    if (builtin.mode == .Debug and !validation_layers.VK_LAYER_KHRONOS_validation) {
        vk.log.warn("VK_LAYER_KHRONOS_validation layer is not present, no vulkan messages will be emited", .{});
    }

    const vlayers = try validation_layers.asSlice(tmp_arena.allocator());

    const instance = try base_dispatch.createInstance(&zvk.InstanceCreateInfo{
        .p_application_info = &app_info,
        .enabled_extension_count = @intCast(sdl_exts.len),
        .pp_enabled_extension_names = @ptrCast(sdl_exts.ptr),
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

const ValidationLayers = struct {
    VK_LAYER_KHRONOS_validation: bool = false,

    fn enumerate(tmp_alocator: std.mem.Allocator, base_dispatch: *const vk.BaseDispatch) !@This() {
        const layer_properties = try base_dispatch.enumerateInstanceLayerPropertiesAlloc(tmp_alocator);
        defer tmp_alocator.free(layer_properties);

        var layers: @This() = .{};
        for (layer_properties) |layer_props| {
            const layer_name_c: [*:0]const u8 = @ptrCast(&layer_props.layer_name);
            const layer_name = std.mem.span(layer_name_c);

            // n^2, but n should be small enough that it shouldn't be a big problem
            inline for (comptime std.meta.fieldNames(@This())) |field_name| {
                if (std.mem.eql(u8, layer_name, field_name[0..])) {
                    @field(layers, field_name[0..]) = true;
                }
            }
        }
        return layers;
    }

    fn asSlice(self: @This(), allocator: std.mem.Allocator) ![][*:0]const u8 {
        var layers = std.ArrayList([*:0]const u8).init(allocator);
        defer layers.deinit();

        inline for (std.meta.fields(@This())) |field| {
            if (@field(self, field.name)) {
                try layers.append(field.name);
            }
        }

        return try layers.toOwnedSlice();
    }
};
