const std = @import("std");
const wayland = @import("./wayland.zig");
const vulkan = @import("./vulkan.zig");
const builtin = @import("builtin");

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

    var wlcontext = try WlContext.init();
    defer wlcontext.deinit();

    wlcontext.wl_registry.setListener(*WlContext, WlContext.globalsListener, &wlcontext);
    if (wlcontext.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    var wlwindow = try WlWindow.init(&wlcontext);
    defer wlwindow.deinit();

    wlwindow.initListeners();
    wlwindow.xdg_toplevel.setTitle("zentura");
    wlwindow.xdg_toplevel.setAppId("siniarskimar.zentura");

    wlwindow.wl_surface.commit();
    if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;
    wlwindow.wl_surface.commit();

    var vkcontext = try vulkan.Context.initWayland(gpa.allocator(), wlcontext.wl_display, wlwindow.wl_surface);
    defer vkcontext.deinit(gpa.allocator());

    wlwindow.wl_surface.commit();
    if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    std.debug.print("{s}\n", .{std.mem.sliceTo(&vkcontext.pdevprops.device_name, 0)});

    while (!wlwindow.is_closed) {
        std.time.sleep(std.time.ns_per_ms);
        if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;
    }
}
