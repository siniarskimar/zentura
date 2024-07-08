const std = @import("std");
const wayland = @import("./wayland.zig");
const WlContext = wayland.WlContext;
const WlWindow = wayland.WlWindow;

pub fn main() !void {
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

    while (!wlwindow.is_closed) {
        std.time.sleep(std.time.ns_per_ms);
        if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;
    }
}
