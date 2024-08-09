const std = @import("std");
const wayland = @import("wayland").client;
const nswindow = @import("./window.zig");
const Callback = nswindow.Callback;
const Extent = nswindow.Extent;

const c = @import("c");

pub const wl = wayland.wl;
pub const xdg = wayland.xdg;

pub const log = std.log.scoped(.wayland);

extern fn wl_proxy_get_tag(proxy: *wl.Proxy) [*:0]const u8;

const WL_SURFACE_TAG: [*:0]const u8 = "ZENTURA";

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

    xkb_context: ?*c.xkb_context,
    kbd: ?Keyboard = null,

    pub fn init() !@This() {
        const display = try wl.Display.connect(null);
        errdefer display.disconnect();

        const registry = try display.getRegistry();
        errdefer registry.destroy();

        const xkb_context = c.xkb_context_new(c.XKB_CONTEXT_NO_FLAGS) orelse
            return error.XKBContextCreate;

        return .{
            .wl_display = display,
            .wl_registry = registry,
            .xkb_context = xkb_context,
        };
    }

    pub fn deinit(self: *const @This()) void {
        if (self.kbd) |kbd| kbd.deinit();
        c.xkb_context_unref(self.xkb_context);

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

    const WindowCreationError = nswindow.Platform.WindowCreationError;
    pub fn createWindow(
        self: *const @This(),
        allocator: std.mem.Allocator,
        options: nswindow.WindowCreationOptions,
    ) WindowCreationError!nswindow.Window {
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

        return .{ .inner = .{ .wayland = heap } };
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

                if (cap.keyboard and self.kbd == null) {
                    const wl_keyboard = seat.getKeyboard() catch |err| {
                        log.warn("failed to get keyboard seat: {s}", .{@errorName(err)});
                        return;
                    };
                    self.kbd = .{
                        .wl_keyboard = wl_keyboard,
                        .platform = self,
                    };
                    wl_keyboard.setListener(*Keyboard, Keyboard.wlKeyboardHandler, &self.kbd.?);
                } else if (!cap.keyboard and self.kbd != null) {
                    self.kbd.?.deinit();
                    self.kbd = null;
                }
            },
            .name => {},
        }
    }
};

pub const Keyboard = struct {
    platform: *Platform,
    wl_keyboard: *wl.Keyboard,
    keymap: ?*c.xkb_keymap = null,
    state: ?*c.xkb_state = null,

    mod_shift_idx: c.xkb_mod_index_t = c.XKB_MOD_INVALID,
    mod_ctrl_idx: c.xkb_mod_index_t = c.XKB_MOD_INVALID,
    mod_alt_idx: c.xkb_mod_index_t = c.XKB_MOD_INVALID,
    mod_capslock_idx: c.xkb_mod_index_t = c.XKB_MOD_INVALID,

    repeat_delay: u32 = 0,
    repeat_rate: u32 = 0,

    focused: ?*wl.Surface = null,

    pub fn deinit(self: @This()) void {
        c.xkb_state_unref(self.state);
        c.xkb_keymap_unref(self.keymap);
        self.wl_keyboard.release();
    }

    fn wlKeyboardHandler(_: *wl.Keyboard, event: wl.Keyboard.Event, self: *@This()) void {
        switch (event) {
            .enter => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.focused = surface;

                if (self.state) |state| for (data.keys.slice(u32)) |evdev_key| {
                    const key = evdev_key + 8;
                    const userdata = proxy.getUserData() orelse
                        std.debug.panic("wl_surface userdata is null", .{});

                    const window: *WlWindow = @ptrCast(@alignCast(userdata));
                    window.keyCodeHandler(self, state, key, .pressed, false);
                };
            },
            .leave => |data| if (data.surface) |surface| {
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                self.focused = null;
            },
            .key => |data| if (self.state) |state| if (self.focused) |surface| {
                const key: u32 = data.key + 8;
                const proxy: *wl.Proxy = @ptrCast(surface);
                const tag = wl_proxy_get_tag(proxy);
                if (tag != WL_SURFACE_TAG) return;

                const userdata = proxy.getUserData() orelse
                    std.debug.panic("wl_surface userdata is null: {p}", .{surface});

                const window: *WlWindow = @ptrCast(@alignCast(userdata));
                window.keyCodeHandler(self, state, key, data.state, false);
            },
            .keymap => |data| {
                defer std.posix.close(data.fd);
                if (data.format == .no_keymap) {
                    log.err("raw keyboard keymap is unsupported", .{});
                    return;
                }
                const keymap_string = std.posix.mmap(
                    null,
                    data.size,
                    std.posix.PROT.READ,
                    std.posix.MAP{ .TYPE = .PRIVATE },
                    data.fd,
                    0,
                ) catch |err| std.debug.panic("keymap mmap failed: {}", .{err});
                defer std.posix.munmap(keymap_string);

                if (self.state) |old_state| c.xkb_state_unref(old_state);
                if (self.keymap) |old_keymap| c.xkb_keymap_unref(old_keymap);

                const keymap = c.xkb_keymap_new_from_string(
                    self.platform.xkb_context,
                    keymap_string.ptr,
                    c.XKB_KEYMAP_FORMAT_TEXT_V1,
                    c.XKB_KEYMAP_COMPILE_NO_FLAGS,
                ) orelse {
                    log.err("failed to create xkb_keymap", .{});
                    return;
                };
                const state = c.xkb_state_new(keymap) orelse {
                    log.err("failed to create xkb_state", .{});
                    c.xkb_keymap_unref(keymap);
                    return;
                };
                self.mod_shift_idx = c.xkb_keymap_mod_get_index(keymap, c.XKB_MOD_NAME_SHIFT);
                self.mod_ctrl_idx = c.xkb_keymap_mod_get_index(keymap, c.XKB_MOD_NAME_CTRL);
                self.mod_alt_idx = c.xkb_keymap_mod_get_index(keymap, c.XKB_MOD_NAME_ALT);
                self.mod_capslock_idx = c.xkb_keymap_mod_get_index(keymap, c.XKB_MOD_NAME_CAPS);

                self.keymap = keymap;
                self.state = state;
            },
            .repeat_info => |data| {
                self.repeat_delay = @intCast(data.delay);
                self.repeat_rate = @intCast(data.rate);
            },
            .modifiers => |data| if (self.state) |state| {
                // zig fmt: off
                _ = c.xkb_state_update_mask(state,
                    data.mods_depressed, data.mods_latched, data.mods_locked,
                    0, 0, data.group,
                );
                // zig fmt: on
            },
        }
    }
};

pub const WlWindow = struct {
    context: *const Platform,
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
    content_scale: i32 = 1,

    // Synchronization state
    got_resized: bool = false,
    cb_framebuffer_resize: ?nswindow.FramebufferResizeCb = null,
    cb_key_callback: ?nswindow.KeyCallback = null,

    extern fn wl_proxy_set_tag(proxy: *wl.Proxy, tag: [*:0]const u8) void;

    pub fn init(
        context: *const Platform,
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
        self.wl_surface.setListener(*@This(), wlSurfaceHandler, self);
        self.xdg_surface.setListener(*@This(), xdgSurfaceHandler, self);
        self.xdg_toplevel.setListener(*@This(), xdgToplevelHandler, self);
    }

    pub fn deinit(self: *const @This()) void {
        if (self.wl_pointer) |pointer| pointer.release();
        if (self.wl_keyboard) |kbd| kbd.release();
        self.xdg_toplevel.destroy();
        self.xdg_surface.destroy();
        self.wl_surface.destroy();
    }

    pub fn setFramebufferResizeCallback(
        self: *@This(),
        callback: ?nswindow.FramebufferResizeCb,
    ) ?nswindow.FramebufferResizeCb {
        const old = self.cb_framebuffer_resize;
        self.cb_framebuffer_resize = callback;
        return old;
    }

    pub fn setKeyCallback(self: *@This(), cb: ?nswindow.KeyCallback) ?nswindow.KeyCallback {
        const old = self.cb_key_callback;
        self.cb_key_callback = cb;
        return old;
    }

    pub fn closed(self: @This()) bool {
        return self.state_closed;
    }

    pub fn extent(self: @This()) Extent {
        return .{ .width = self.width, .height = self.height };
    }

    pub fn vulkanExtensions() []const [*:0]const u8 {
        const vk = @import("vulkan");
        return &[_][*:0]const u8{
            vk.extensions.khr_wayland_surface.name,
        };
    }

    fn wlSurfaceHandler(surface: *wl.Surface, event: wl.Surface.Event, self: *@This()) void {
        switch (event) {
            .enter => {},
            .leave => {},
            .preferred_buffer_scale => |data| {
                self.content_scale = data.factor;
                surface.setBufferScale(self.content_scale);
                surface.commit();
            },
            .preferred_buffer_transform => {},
        }
    }

    fn keyCodeHandler(
        self: *@This(),
        kbd: *Keyboard,
        state: *c.xkb_state,
        keycode: c.xkb_keycode_t,
        keystate: wl.Keyboard.KeyState,
        repeat: bool,
    ) void {
        const evdev_keycode = keycode - 8;
        const translated = nswindow.KeyCode.fromEvdev(evdev_keycode) orelse return;

        const mods = nswindow.KeyModifiers{
            .ctrl = c.xkb_state_mod_index_is_active(
                state,
                kbd.mod_ctrl_idx,
                c.XKB_STATE_MODS_DEPRESSED | c.XKB_STATE_MODS_EFFECTIVE,
            ) > 0,
            .alt = c.xkb_state_mod_index_is_active(
                state,
                kbd.mod_alt_idx,
                c.XKB_STATE_MODS_DEPRESSED | c.XKB_STATE_MODS_EFFECTIVE,
            ) > 0,
            .shift = c.xkb_state_mod_index_is_active(
                state,
                kbd.mod_shift_idx,
                c.XKB_STATE_MODS_DEPRESSED | c.XKB_STATE_MODS_EFFECTIVE,
            ) > 0,
            .capslock = c.xkb_state_mod_index_is_active(
                state,
                kbd.mod_capslock_idx,
                c.XKB_STATE_MODS_DEPRESSED | c.XKB_STATE_MODS_EFFECTIVE,
            ) > 0,
            .numlock = false,
            .super = false,
        };

        if (self.cb_key_callback) |cb| {
            cb.ptr(cb.ctx, translated, mods, switch (keystate) {
                .pressed => .pressed,
                .released => .released,
                else => std.debug.panic("invalid wayland keystate", .{}),
            }, repeat);
        }
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
