const std = @import("std");
const builtin = @import("builtin");

const vulkan = @import("./vulkan.zig");
const nswindow = @import("./window.zig");
const vk = vulkan.vk;
const shaders = @import("shaders");

const std_options = std.Options{
    .log_level = if (builtin.mode == .Debug) .debug else .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const window_platform = try nswindow.Platform.init(gpa.allocator());
    defer window_platform.deinit(gpa.allocator());

    window_platform.pollEvents();

    var window = try nswindow.Window.init(gpa.allocator(), &window_platform, 800, 600);
    defer window.deinit(gpa.allocator());

    window.setTitle("zentura");
    window.commit();
    window_platform.pollEvents();

    _ = try vulkan.loadLibrary();
    defer vulkan.unloadLibrary();

    var vkcontext = try vulkan.InstanceContext.init(gpa.allocator(), &window);
    defer vkcontext.deinit(gpa.allocator());
}
