const std = @import("std");
const builtin = @import("builtin");

const wayland = @import("./wayland.zig");
const vulkan = @import("./vulkan.zig");
const x11 = @import("./x11.zig");
const vk = vulkan.vk;
const shaders = @import("shaders");

const WlContext = wayland.WlContext;
const WlWindow = wayland.WlWindow;

const std_options = std.Options{
    .log_level = if (builtin.mode == .Debug) .debug else .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var vksolib = try vulkan.loadSharedLibrary();
    defer vksolib.close();

    var x11context = try x11.Context.init();
    defer x11context.deinit();

    var x11window = try x11.Window.init(x11context, 800, 600);
    defer x11window.deinit();

    _ = x11.c.XMapWindow(x11context.display, x11window.window_handle);

    _ = x11.c.XSync(x11context.display, x11.c.False);

    // var wlcontext = try WlContext.init();
    // defer wlcontext.deinit();

    // wlcontext.wl_registry.setListener(*WlContext, WlContext.globalsListener, &wlcontext);
    // if (wlcontext.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    // var wlwindow = try WlWindow.init(&wlcontext);
    // defer wlwindow.deinit();

    // wlwindow.initListeners();
    // wlwindow.width = 800;
    // wlwindow.height = 600;
    // wlwindow.xdg_toplevel.setTitle("zentura");
    // wlwindow.xdg_toplevel.setAppId("siniarskimar.zentura");
    // wlwindow.xdg_toplevel.setMinSize(100, 100);

    var vkcontext = try x11.VulkanContext.init(gpa.allocator(), x11window);
    defer vkcontext.deinit(gpa.allocator());
}
