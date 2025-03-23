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
