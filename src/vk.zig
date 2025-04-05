//! Common vulkan declarations

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

pub const ValidationLayers = struct {
    VK_LAYER_KHRONOS_validation: bool = false,

    const hashset = blk: {
        const field_names = std.meta.fieldNames(@This());
        var entries: [field_names.len]struct { []const u8 } = undefined;
        for (&entries, field_names) |*entry, name| {
            entry.@"0" = name[0..];
        }

        break :blk std.StaticStringMap(void).initComptime(entries);
    };

    pub fn enumerate(tmp_alocator: std.mem.Allocator, base_dispatch: *const BaseDispatch) !@This() {
        const layer_properties = try base_dispatch.enumerateInstanceLayerPropertiesAlloc(tmp_alocator);
        defer tmp_alocator.free(layer_properties);

        var layers: @This() = .{};
        for (layer_properties) |layer_props| {
            const layer_name_c: [*:0]const u8 = @ptrCast(&layer_props.layer_name);
            layers.set(layer_name_c);
        }
        return layers;
    }

    pub fn asSlice(self: @This(), allocator: std.mem.Allocator) ![][*:0]const u8 {
        var layers = std.ArrayList([*:0]const u8).init(allocator);
        defer layers.deinit();

        inline for (std.meta.fields(@This())) |field| {
            if (@field(self, field.name)) {
                try layers.append(field.name);
            }
        }

        return try layers.toOwnedSlice();
    }

    pub fn set(self: *@This(), name_c: [*:0]const u8) void {
        const name = std.mem.span(name_c);
        if (hashset.get(name) == null) return;

        inline for (comptime std.meta.fieldNames(@This())) |field_name| {
            if (std.mem.eql(u8, name, field_name[0..])) {
                @field(self, field_name[0..]) = true;
            }
        }
    }
};

pub const InstanceExtensions = struct {
    VK_KHR_wayland_surface: bool = false,
    VK_KHR_xlib_surface: bool = false,
    VK_KHR_xcb_surface: bool = false,
    VK_KHR_surface: bool = false,
    VK_KHR_win32_surface: bool = false,

    const hashset = blk: {
        const field_names = std.meta.fieldNames(@This());
        var entries: [field_names.len]struct { []const u8 } = undefined;
        for (&entries, field_names) |*entry, name| {
            entry.@"0" = name[0..];
        }

        break :blk std.StaticStringMap(void).initComptime(entries);
    };

    pub fn enumerate(tmp_alocator: std.mem.Allocator, base_dispatch: *const BaseDispatch) !@This() {
        const extension_properties = try base_dispatch.enumerateInstanceExtensionPropertiesAlloc(null, tmp_alocator);
        defer tmp_alocator.free(extension_properties);

        var layers: @This() = .{};
        for (extension_properties) |ext_props| {
            const ext_name_c: [*:0]const u8 = @ptrCast(&ext_props.extension_name);
            layers.set(ext_name_c);
        }
        return layers;
    }

    pub fn asSlice(self: @This(), allocator: std.mem.Allocator) ![][*:0]const u8 {
        var extensions = std.ArrayList([*:0]const u8).init(allocator);
        defer extensions.deinit();

        inline for (std.meta.fields(@This())) |field| {
            if (@field(self, field.name)) {
                try extensions.append(field.name);
            }
        }

        return try extensions.toOwnedSlice();
    }

    pub fn set(self: *@This(), ext_c: [*:0]const u8) void {
        const ext = std.mem.span(ext_c);
        if (hashset.get(ext) == null) return;

        inline for (comptime std.meta.fieldNames(@This())) |field_name| {
            if (std.mem.eql(u8, ext, field_name[0..])) {
                @field(self, field_name[0..]) = true;
            }
        }
    }

    pub fn disableSurfaceRelated(self: *@This()) void {
        self.VK_KHR_wayland_surface = false;
        self.VK_KHR_xlib_surface = false;
        self.VK_KHR_xcb_surface = false;
        self.VK_KHR_surface = false;
        self.VK_KHR_win32_surface = false;
    }
};

pub const DeviceExtensions = struct {
    VK_KHR_swapchain: bool = false,

    const hashset = blk: {
        const field_names = std.meta.fieldNames(@This());
        var entries: [field_names.len]struct { []const u8 } = undefined;
        for (&entries, field_names) |*entry, name| {
            entry.@"0" = name[0..];
        }

        break :blk std.StaticStringMap(void).initComptime(entries);
    };

    pub fn enumerate(
        tmp_alocator: std.mem.Allocator,
        instance_dispatch: *const InstanceDispatch,
        device: zvk.PhysicalDevice,
    ) !@This() {
        const ext_properties = try instance_dispatch.enumerateDeviceExtensionPropertiesAlloc(device, null, tmp_alocator);
        defer tmp_alocator.free(ext_properties);

        var exts: @This() = .{};
        for (ext_properties) |ext_props| {
            const ext_name_c: [*:0]const u8 = @ptrCast(&ext_props.extension_name);
            exts.set(ext_name_c);
        }
        return exts;
    }

    pub fn asSlice(self: @This(), allocator: std.mem.Allocator) ![][*:0]const u8 {
        var layers = std.ArrayList([*:0]const u8).init(allocator);
        defer layers.deinit();

        inline for (std.meta.fields(@This())) |field| {
            if (@field(self, field.name)) {
                try layers.append(field.name);
            }
        }

        return try layers.toOwnedSlice();
    }

    pub fn set(self: *@This(), name_c: [*:0]const u8) void {
        const name = std.mem.span(name_c);
        if (hashset.get(name) == null) return;

        inline for (comptime std.meta.fieldNames(@This())) |field_name| {
            if (std.mem.eql(u8, name, field_name[0..])) {
                @field(self, field_name[0..]) = true;
            }
        }
    }

    pub fn supportsRequired(self: @This(), required: @This()) bool {
        inline for (std.meta.fields(@This())) |field| {
            if (@field(required, field.name)) {
                if (@field(required, field.name) != @field(self, field.name)) return false;
            }
        }
        return true;
    }
};
