const std = @import("std");
const wayland = @import("wayland").client;
const nswindow = @import("./window.zig");
const Callback = nswindow.Callback;

pub const wl = wayland.wl;
pub const xdg = wayland.xdg;

pub const log = std.log.scoped(.wayland);

pub const Platform = struct {
    wl_display: *wl.Display,
    wl_registry: *wl.Registry,
    wl_compositor: ?*wl.Compositor = null,
    wl_compositor_serial: u32 = 0,
    xdg_wm_base: ?*xdg.WmBase = null,
    xdg_wm_base_serial: u32 = 0,

    wl_seat: ?*wl.Seat = null,
    wl_seat_serial: u32 = 0,
    wl_seat_name: ?[*:0]const u8 = null,
    wl_seat_capabilities: wl.Seat.Capability = .{},

    pub fn init() !@This() {
        const display = try wl.Display.connect(null);
        errdefer display.disconnect();

        const registry = try display.getRegistry();
        errdefer registry.destroy();

        return .{
            .wl_display = display,
            .wl_registry = registry,
        };
    }

    pub fn deinit(self: *const @This()) void {
        if (self.wl_seat) |seat| seat.release();
        if (self.wl_compositor) |compositor| compositor.destroy();
        if (self.xdg_wm_base) |wm_base| wm_base.destroy();
        self.wl_registry.destroy();
        self.wl_display.disconnect();
    }

    pub fn setupListeners(self: *@This()) error{RoundtripFailed}!void {
        self.wl_registry.setListener(*@This(), globalsListener, self);
        const roundtrip = self.wl_display.roundtrip();
        if (roundtrip != .SUCCESS) return error.RoundtripFailed;
    }

    pub fn pollEvents(self: *const @This()) void {
        const result = self.wl_display.roundtrip();
        if (result != .SUCCESS) std.debug.panic("wl_display roundtrip failed: {s}", .{@tagName(result)});
    }

    pub fn globalsListener(registry: *wl.Registry, event: wl.Registry.Event, context: *Platform) void {
        switch (event) {
            .global => |glb| {
                const interface = std.mem.span(glb.interface);

                if (std.mem.eql(u8, interface, "wl_compositor") and glb.version >= wl.Compositor.generated_version) {
                    context.wl_compositor = registry.bind(glb.name, wl.Compositor, wl.Compositor.generated_version) catch |err| {
                        std.debug.panic("failed to bind wl_compositor: {}\n", .{err});
                    };
                    context.wl_compositor_serial = glb.name;
                } else if (std.mem.eql(u8, interface, "xdg_wm_base") and glb.version >= xdg.WmBase.generated_version) {
                    const wm_base = registry.bind(glb.name, xdg.WmBase, xdg.WmBase.generated_version) catch |err| {
                        std.debug.panic("failed to bind xdg_wm_base: {}\n", .{err});
                    };
                    context.xdg_wm_base = wm_base;
                    context.xdg_wm_base_serial = glb.name;

                    wm_base.setListener(?*anyopaque, xdgShellPong, null);
                } else if (std.mem.eql(u8, interface, "wl_seat") and glb.version >= wl.Seat.generated_version) {
                    if (context.wl_seat) |_| {
                        log.warn("support for multi-seat is not implemented", .{});
                    } else {
                        const wl_seat = registry.bind(glb.name, wl.Seat, wl.Seat.generated_version) catch |err| {
                            std.debug.panic("failed to bind wl_seat: {}\n", .{err});
                        };
                        context.wl_seat = wl_seat;
                        context.wl_seat_serial = glb.name;
                        wl_seat.setListener(*@This(), wlSeatListener, context);
                    }
                }
            },
            .global_remove => |glb| {
                if (glb.name == context.wl_compositor_serial) if (context.wl_compositor) |compositor| {
                    compositor.destroy();
                    context.wl_compositor = null;
                    context.wl_compositor_serial = 0;
                } else if (glb.name == context.xdg_wm_base_serial) if (context.xdg_wm_base) |wm_base| {
                    wm_base.destroy();
                    context.xdg_wm_base = null;
                    context.xdg_wm_base_serial = 0;
                } else if (glb.name == context.wl_seat_serial) if (context.wl_seat) |wl_seat| {
                    wl_seat.release();
                    context.wl_seat = null;
                    context.wl_seat_serial = 0;
                };
            },
        }
    }

    fn xdgShellPong(wm_base: *xdg.WmBase, event: xdg.WmBase.Event, _: ?*anyopaque) void {
        wm_base.pong(event.ping.serial);
    }

    fn wlSeatListener(_: *wl.Seat, event: wl.Seat.Event, context: *@This()) void {
        switch (event) {
            .capabilities => |data| context.wl_seat_capabilities = data.capabilities,
            .name => |data| context.wl_seat_name = data.name,
        }
    }
};

pub const WlWindow = struct {
    context: *const Platform,
    wl_surface: *wl.Surface,
    xdg_surface: *xdg.Surface,
    xdg_toplevel: *xdg.Toplevel,

    // Properties
    width: u32,
    height: u32,
    state_closed: bool = false,
    state_maximized: bool = false,
    state_fullscreen: bool = false,
    state_activated: bool = false,

    // Synchronization state
    got_resized: bool = false,
    cb_framebuffer_resize: ?Callback(nswindow.FramebufferResizeCb) = null,

    pub fn init(context: *const Platform, width: u32, height: u32) !@This() {
        const wm_base = context.xdg_wm_base orelse return error.XdgWmBaseNull;
        const wl_compositor = context.wl_compositor orelse return error.WlCompositorNull;

        const surface = try wl_compositor.createSurface();
        errdefer surface.destroy();

        const xdg_surface = try wm_base.getXdgSurface(surface);
        errdefer xdg_surface.destroy();

        const toplevel = try xdg_surface.getToplevel();
        errdefer toplevel.destroy();

        return .{
            .context = context,
            .wl_surface = surface,
            .xdg_surface = xdg_surface,
            .xdg_toplevel = toplevel,
            .width = width,
            .height = height,
        };
    }

    pub fn initListeners(self: *@This()) void {
        self.xdg_surface.setListener(*@This(), xdgSurfaceHandler, self);
        self.xdg_toplevel.setListener(*@This(), xdgToplevelHandler, self);
    }

    pub fn deinit(self: *@This()) void {
        self.xdg_toplevel.destroy();
        self.xdg_surface.destroy();
        self.wl_surface.destroy();
    }

    pub fn setFramebufferResizeCallback(
        self: *@This(),
        callback: ?Callback(nswindow.FramebufferResizeCb),
    ) ?Callback(nswindow.FramebufferResizeCb) {
        const old = self.cb_framebuffer_resize;
        self.cb_framebuffer_resize = callback;
        return old;
    }

    fn xdgSurfaceHandler(surface: *xdg.Surface, event: xdg.Surface.Event, data: *@This()) void {
        switch (event) {
            .configure => {
                if (data.cb_framebuffer_resize) |cb| {
                    cb.ptr(cb.ctx, data.width, data.height);
                }
                surface.ackConfigure(event.configure.serial);
            },
        }
    }

    fn xdgToplevelHandler(toplevel: *xdg.Toplevel, event: xdg.Toplevel.Event, data: *@This()) void {
        _ = toplevel;
        switch (event) {
            .configure => |ev| {
                data.state_maximized = false;
                data.state_fullscreen = false;
                data.state_activated = false;

                data.got_resized = false;
                if (ev.width != 0 and ev.height != 0) {
                    data.got_resized = true;
                    data.width = @intCast(ev.width);
                    data.height = @intCast(ev.height);
                }
                const State = xdg.Toplevel.State;
                const states = ev.states.slice(State);
                for (states) |state| switch (state) {
                    State.maximized => data.state_maximized = true,
                    State.fullscreen => data.state_fullscreen = true,
                    State.activated => data.state_activated = true,
                    else => {},
                };
            },
            .close => {
                data.state_closed = true;
            },
        }
    }
};
