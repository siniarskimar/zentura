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

    var window_platform = try nswindow.Platform.init(gpa.allocator());
    defer window_platform.deinit(gpa.allocator());

    try window_platform.pollEvents();

    var window = try window_platform.createWindow(gpa.allocator(), .{
        .width = 800,
        .height = 600,
    });
    defer window.deinit(gpa.allocator());

    try window_platform.pollEvents();

    _ = window.setKeyCallback(.{
        .ptr = &(struct {
            pub fn keyCallback(
                _: ?*anyopaque,
                key: nswindow.KeyCode,
                mods: nswindow.KeyModifiers,
                keystate: nswindow.KeyState,
                _: bool,
            ) void {
                const stdout = std.io.getStdOut();
                stdout.writeAll(@tagName(keystate)) catch return;
                stdout.writeAll(" ") catch return;
                if (mods.ctrl) stdout.writeAll("ctrl+") catch return;
                if (mods.alt) stdout.writeAll("alt+") catch return;
                if (mods.shift) stdout.writeAll("shift+") catch return;
                stdout.writeAll(@tagName(key)) catch return;
                stdout.writeAll("\n") catch return;
            }
        }).keyCallback,
    });

    _ = try vulkan.loadLibrary();
    defer vulkan.unloadLibrary();

    var vkrenderer = try vulkan.Renderer.init(gpa.allocator(), &window);
    defer vkrenderer.deinit();

    vkrenderer.initCallbacks();

    while (!window.closed()) {
        try window_platform.pollEvents();

        try vkrenderer.present();
        std.time.sleep(std.time.ns_per_ms);
    }
}
