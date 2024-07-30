const std = @import("std");
const wayland = @import("wayland").client;
const nswindow = @import("./window.zig");
const Callback = nswindow.Callback;

pub const wl = wayland.wl;
pub const xdg = wayland.xdg;

pub const log = std.log.scoped(.wayland);

const WL_SURFACE_TAG: [*:0]const u8 = "ZENTURA";

pub const SeatCapabilityCb = *const fn (
    ctx: ?*anyopaque,
    wl_seat: *wl.Seat,
    cap: wl.Seat.Capability,
) void;

pub const Platform = struct {
    wl_display: *wl.Display,
    wl_registry: *wl.Registry,
    wl_compositor: ?*wl.Compositor = null,
    wl_compositor_serial: u32 = 0,
    xdg_wm_base: ?*xdg.WmBase = null,
    xdg_wm_base_serial: u32 = 0,

    // Input
    wl_seat: ?*wl.Seat = null,
    wl_seat_serial: u32 = 0,
    wl_seat_capabilities: wl.Seat.Capability = .{},
    wl_pointer: ?*wl.Pointer = null,
    wl_keyboard: ?*wl.Keyboard = null,

    pointer_focused: ?*wl.Surface = null,
    pointer_x: u32 = 0,
    pointer_y: u32 = 0,
    keyboard_focused: ?*wl.Surface = null,
    keyboard_repeat_delay: u32 = 0,
    keyboard_repeat_rate: u32 = 0,
    keymap_fd: std.posix.fd_t = -1,

    pub fn vtable() nswindow.Platform.VTable {
        const S = struct {
            pub fn tag() nswindow.Platform.Tag {
                return .wayland;
            }
            pub fn deinit(ptr: *anyopaque, allocator: std.mem.Allocator) void {
                const self: *const Platform = @alignCast(@ptrCast(ptr));
                self.deinit();
                allocator.destroy(self);
            }
            pub fn pollEvents(ptr: *anyopaque) nswindow.Platform.PollEventsError!void {
                const self: *const Platform = @alignCast(@ptrCast(ptr));
                try self.pollEvents();
            }
        };

        return .{
            .deinit = S.deinit,
            .tag = S.tag,
            .pollEvents = S.pollEvents,
            .createWindow = createWindow,
        };
    }

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

    pub fn setupListeners(self: *@This()) void {
        self.wl_registry.setListener(*@This(), globalsListener, self);
    }

    pub fn pollEvents(self: *const @This()) error{RoundtripFailed}!void {
        const result = self.wl_display.roundtrip();
        if (result != .SUCCESS) {
            return error.RoundtripFailed;
        }
    }

    pub fn createWindow(
        ptr: *anyopaque,
        allocator: std.mem.Allocator,
        options: nswindow.WindowCreationOptions,
    ) nswindow.Platform.WindowCreationError!nswindow.Window {
        const self: *@This() = @alignCast(@ptrCast(ptr));

        const window = WlWindow.init(self, options.width, options.height) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            error.XdgWmBaseNull,
            error.WlCompositorNull,
            => return error.FeaturesNotSupported,
        };
        errdefer window.deinit();

        const heap = try allocator.create(WlWindow);
        heap.* = window;

        heap.initListeners();

        return .{ .ptr = heap, .vtable = WlWindow.vtable() };
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

    fn wlSeatListener(seat: *wl.Seat, event: wl.Seat.Event, self: *@This()) void {
        switch (event) {
            .capabilities => |data| {
                const cap = data.capabilities;
                self.wl_seat_capabilities = cap;

                if (cap.pointer and self.wl_pointer == null) {
                    self.wl_pointer = seat.getPointer() catch |err| blk: {
                        log.warn("(window) Failed to get pointer seat: {s}", .{@errorName(err)});
                        break :blk null;
                    };
                    self.wl_pointer.?.setListener(*@This(), wlPointerHandler, self);
                } else if (!cap.pointer and self.wl_pointer != null) {
                    self.wl_pointer.?.release();
                    self.wl_pointer = null;
                }

                if (cap.keyboard and self.wl_keyboard == null) {
                    self.wl_keyboard = seat.getKeyboard() catch |err| blk: {
                        log.warn("(window) Failed to get keyboard seat: {s}", .{@errorName(err)});
                        break :blk null;
                    };
                    self.wl_keyboard.?.setListener(*@This(), wlKeyboardHandler, self);
                } else if (!cap.keyboard and self.wl_keyboard != null) {
                    self.wl_keyboard.?.release();
                    self.wl_keyboard = null;
                }
            },
            .name => {},
        }
    }

    extern fn wl_proxy_get_tag(proxy: *wl.Proxy) [*:0]const u8;

    fn wlPointerHandler(_: *wl.Pointer, event: wl.Pointer.Event, self: *@This()) void {
        switch (event) {
            .enter => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.pointer_focused = surface;
                self.pointer_x = @intCast(data.surface_x.toInt());
                self.pointer_y = @intCast(data.surface_y.toInt());
            },
            .leave => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.pointer_focused = null;
            },
            .button => |data| if (self.pointer_focused) |_| {
                std.debug.print("pointer button {x}\n", .{data.button});
            },
            .motion => |data| if (self.pointer_focused) |_| {
                self.pointer_x = @intCast(data.surface_x.toInt());
                self.pointer_y = @intCast(data.surface_y.toInt());
            },
            else => {},
        }
    }

    fn wlKeyboardHandler(_: *wl.Keyboard, event: wl.Keyboard.Event, self: *@This()) void {
        switch (event) {
            .enter => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.keyboard_focused = surface;
            },
            .leave => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.keyboard_focused = surface;
            },
            .key => |data| {
                std.debug.print("keyboard key {x} {s}\n", .{ data.key, @tagName(data.state) });
            },
            .keymap => |data| {
                if (data.fd > 0) {
                    std.posix.close(data.fd);
                }
                std.debug.print("keyboard format: {s}\n", .{@tagName(data.format)});
            },
            .repeat_info => |data| {
                self.keyboard_repeat_delay = @intCast(data.delay);
                self.keyboard_repeat_rate = @intCast(data.rate);
            },
            .modifiers => |data| {
                std.debug.print(
                    "mods_depressed={b}, mods_latched={b}, mods_locked={b}",
                    .{ data.mods_depressed, data.mods_latched, data.mods_locked },
                );
            },
        }
    }
};

pub const WlWindow = struct {
    context: *Platform,
    wl_surface: *wl.Surface,
    xdg_surface: *xdg.Surface,
    xdg_toplevel: *xdg.Toplevel,
    wl_pointer: ?*wl.Pointer = null,
    wl_keyboard: ?*wl.Keyboard = null,

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

    extern fn wl_proxy_set_tag(proxy: *wl.Proxy, tag: [*:0]const u8) void;

    pub fn vtable() nswindow.Window.VTable {
        const S = struct {
            pub fn closed(ptr: *anyopaque) bool {
                const self: *const WlWindow = @alignCast(@ptrCast(ptr));
                return self.state_closed;
            }
            pub fn deinit(ptr: *anyopaque, allocator: std.mem.Allocator) void {
                const self: *WlWindow = @alignCast(@ptrCast(ptr));
                self.deinit();
                allocator.destroy(self);
            }
            pub fn dimensions(ptr: *anyopaque) nswindow.Window.Dimensions {
                const self: *const WlWindow = @alignCast(@ptrCast(ptr));
                return .{
                    .width = self.width,
                    .height = self.height,
                };
            }
            pub fn tag() nswindow.Platform.Tag {
                return .wayland;
            }

            pub fn setFramebufferResizeCallback(
                ptr: *anyopaque,
                cb: ?Callback(nswindow.FramebufferResizeCb),
            ) ?Callback(nswindow.FramebufferResizeCb) {
                const self: *WlWindow = @alignCast(@ptrCast(ptr));
                return self.setFramebufferResizeCallback(cb);
            }
        };

        return .{
            .deinit = S.deinit,
            .dimensions = S.dimensions,
            .closed = S.closed,
            .tag = S.tag,
            .setFramebufferResizeCallback = S.setFramebufferResizeCallback,
        };
    }

    pub fn init(
        context: *Platform,
        width: u32,
        height: u32,
    ) error{ XdgWmBaseNull, WlCompositorNull, OutOfMemory }!@This() {
        const wm_base = context.xdg_wm_base orelse return error.XdgWmBaseNull;
        const wl_compositor = context.wl_compositor orelse return error.WlCompositorNull;

        const surface = try wl_compositor.createSurface();
        errdefer surface.destroy();

        const surface_proxy: *wl.Proxy = @ptrCast(surface);
        wl_proxy_set_tag(surface_proxy, WL_SURFACE_TAG);

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

    pub fn deinit(self: @This()) void {
        if (self.wl_pointer) |pointer| pointer.release();
        if (self.wl_keyboard) |kbd| kbd.release();
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
