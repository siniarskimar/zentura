const std = @import("std");
const wayland = @import("wayland").client;
const wl = wayland.wl;

pub fn main() !void {
    const display = try wl.Display.connect(null);
    const registry = try display.getRegistry();
    registry.setListener(?*u8, listener, null);
    if (display.roundtrip() != .SUCCESS) return error.RoundtripFailed;
}

fn listener(_: *wl.Registry, event: wl.Registry.Event, data: ?*u8) void {
    _ = data;
    std.debug.print("{s}\n", .{event.global.interface});
}
