const std = @import("std");
const builtin = @import("builtin");

pub fn Callback(Fn: type) type {
    return struct {
        ptr: FnPtr,
        ctx: ?*anyopaque = null,

        pub const FnPtr = *const Fn;
    };
}

pub const FramebufferResizeCb = Callback(fn (ctx: ?*anyopaque, width: u32, height: u32) void);
pub const KeyCallback = Callback(fn (
    ctx: ?*anyopaque,
    key: KeyCode,
    mods: KeyModifiers,
    keystate: KeyState,
    repeat: bool,
) void);
pub const TextCallback = Callback(fn (ctx: ?anyopaque, codepoint: u21) void);

pub const WindowCreationOptions = struct {
    title: []const u8 = "zentura",
    width: u32,
    height: u32,
};

pub const Extent = struct {
    width: u32,
    height: u32,
};

pub const KeyState = enum {
    released,
    pressed,
};

pub const KeyModifiers = packed struct {
    ctrl: bool,
    alt: bool,
    shift: bool,
    capslock: bool,
    numlock: bool,
    super: bool,
};

/// Platform independent representation of a keycode
pub const KeyCode = enum(u16) {
    // zig fmt: off
    grave,
    @"1", @"2", @"3",
    @"4", @"5", @"6",
    @"7", @"8", @"9",
    @"0",
    a, b, c, d, e,
    f, g, h, i, j,
    k, l, m, n, o,
    p, q, r, s, t,
    u, v, w, x, y,
    z,
    // zig fmt: on
    comma,
    period,
    slash,
    semicolon,
    apostrophe,
    lbracket,
    rbracket,
    backslash,
    equal,

    space,
    escape,
    menu,
    enter,
    tab,
    insert,
    delete,
    page_up,
    page_down,
    home,
    end,
    caps_lock,
    scroll_lock,
    up,
    left,
    right,
    down,

    // zig fmt: off
    f1, f2,   f3,  f4,
    f5, f6,   f7,  f8,
    f9, f10, f11, f12,
    // zig fmt: on

    const evdev = @import("c");
    const evdev_translation = .{
        .{ evdev.KEY_A, KeyCode.a },
        .{ evdev.KEY_B, KeyCode.b },
        .{ evdev.KEY_C, KeyCode.c },
        .{ evdev.KEY_D, KeyCode.d },
        .{ evdev.KEY_E, KeyCode.e },
        .{ evdev.KEY_F, KeyCode.f },
        .{ evdev.KEY_G, KeyCode.g },
        .{ evdev.KEY_H, KeyCode.h },
        .{ evdev.KEY_I, KeyCode.i },
        .{ evdev.KEY_J, KeyCode.j },
        .{ evdev.KEY_K, KeyCode.k },
        .{ evdev.KEY_L, KeyCode.l },
        .{ evdev.KEY_M, KeyCode.m },
        .{ evdev.KEY_N, KeyCode.n },
        .{ evdev.KEY_O, KeyCode.o },
        .{ evdev.KEY_P, KeyCode.p },
        .{ evdev.KEY_Q, KeyCode.q },
        .{ evdev.KEY_R, KeyCode.r },
        .{ evdev.KEY_S, KeyCode.s },
        .{ evdev.KEY_T, KeyCode.t },
        .{ evdev.KEY_U, KeyCode.u },
        .{ evdev.KEY_V, KeyCode.v },
        .{ evdev.KEY_W, KeyCode.w },
        .{ evdev.KEY_X, KeyCode.x },
        .{ evdev.KEY_Y, KeyCode.y },
        .{ evdev.KEY_Z, KeyCode.z },
        .{ evdev.KEY_0, KeyCode.@"0" },
        .{ evdev.KEY_1, KeyCode.@"1" },
        .{ evdev.KEY_2, KeyCode.@"2" },
        .{ evdev.KEY_3, KeyCode.@"3" },
        .{ evdev.KEY_4, KeyCode.@"4" },
        .{ evdev.KEY_5, KeyCode.@"5" },
        .{ evdev.KEY_6, KeyCode.@"6" },
        .{ evdev.KEY_7, KeyCode.@"7" },
        .{ evdev.KEY_8, KeyCode.@"8" },
        .{ evdev.KEY_9, KeyCode.@"9" },
        .{ evdev.KEY_F1, KeyCode.f1 },
        .{ evdev.KEY_F2, KeyCode.f2 },
        .{ evdev.KEY_F3, KeyCode.f3 },
        .{ evdev.KEY_F4, KeyCode.f4 },
        .{ evdev.KEY_F5, KeyCode.f5 },
        .{ evdev.KEY_F6, KeyCode.f6 },
        .{ evdev.KEY_F7, KeyCode.f7 },
        .{ evdev.KEY_F8, KeyCode.f8 },
        .{ evdev.KEY_F9, KeyCode.f9 },
        .{ evdev.KEY_F10, KeyCode.f10 },
        .{ evdev.KEY_F11, KeyCode.f11 },
        .{ evdev.KEY_F12, KeyCode.f12 },
        .{ evdev.KEY_COMMA, KeyCode.comma },
        .{ evdev.KEY_DOT, KeyCode.period },
        .{ evdev.KEY_SLASH, KeyCode.slash },
        .{ evdev.KEY_SEMICOLON, KeyCode.semicolon },
        .{ evdev.KEY_APOSTROPHE, KeyCode.apostrophe },
        .{ evdev.KEY_LEFTBRACE, KeyCode.lbracket },
        .{ evdev.KEY_RIGHTBRACE, KeyCode.rbracket },
        .{ evdev.KEY_BACKSLASH, KeyCode.backslash },
        .{ evdev.KEY_EQUAL, KeyCode.equal },
        .{ evdev.KEY_GRAVE, KeyCode.grave },
        .{ evdev.KEY_SPACE, KeyCode.space },
        .{ evdev.KEY_ESC, KeyCode.escape },
        .{ evdev.KEY_MENU, KeyCode.menu },
        .{ evdev.KEY_ENTER, KeyCode.enter },
        .{ evdev.KEY_TAB, KeyCode.tab },
        .{ evdev.KEY_INSERT, KeyCode.insert },
        .{ evdev.KEY_DELETE, KeyCode.delete },
        .{ evdev.KEY_PAGEUP, KeyCode.page_up },
        .{ evdev.KEY_PAGEDOWN, KeyCode.page_down },
        .{ evdev.KEY_HOME, KeyCode.home },
        .{ evdev.KEY_END, KeyCode.end },
        .{ evdev.KEY_CAPSLOCK, KeyCode.caps_lock },
        .{ evdev.KEY_SCROLLLOCK, KeyCode.scroll_lock },
        .{ evdev.KEY_UP, KeyCode.up },
        .{ evdev.KEY_LEFT, KeyCode.left },
        .{ evdev.KEY_RIGHT, KeyCode.right },
        .{ evdev.KEY_DOWN, KeyCode.down },
    };

    // TODO: Make comptime check if the translation is exhaustive

    pub fn fromEvdev(keycode: u32) ?@This() {
        return inline for (evdev_translation) |tuple| {
            if (tuple.@"0" == keycode) {
                return tuple.@"1";
            }
        } else null;
    }

    pub fn toEvdev(self: @This()) ?u32 {
        return inline for (evdev_translation) |tuple| {
            if (tuple.@"1" == self) {
                return tuple.@"0";
            }
        } else null;
    }
};

pub const PosixPlatfrom = union(enum) {
    wayland: *wayland.Platform,
    x11: x11.Platform,

    const wayland = @import("./wayland.zig");
    const x11 = @import("./x11.zig");

    const log = std.log.scoped(.platform);

    pub fn init(allocator: std.mem.Allocator) !@This() {

        // TODO(future): detect if wayland or x11 are supported first
        // by dynamically loading their libraries
        if (wayland.Platform.init()) |plat| {
            const heap = try allocator.create(wayland.Platform);
            heap.* = plat;
            heap.setupListeners();

            return .{ .wayland = heap };
        } else |err| {
            log.debug("Wayland platform creation failed: {}", .{err});
        }

        if (x11.Platform.init()) |plat| {
            return .{ .x11 = plat };
        } else |err| {
            log.err("X11 platform creation failed: {}", .{err});
        }

        return error.NoSuitablePlatform;
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        switch (self) {
            .wayland => |impl| {
                impl.deinit();
                allocator.destroy(impl);
            },
            inline else => |impl| impl.deinit(),
        }
    }

    pub fn pollEvents(self: @This()) Platform.PollEventsError!void {
        switch (self) {
            inline else => |impl| try impl.pollEvents(),
        }
    }

    pub fn createWindow(
        self: @This(),
        allocator: std.mem.Allocator,
        options: WindowCreationOptions,
    ) Platform.WindowCreationError!Window {
        switch (self) {
            inline else => |impl| return try impl.createWindow(allocator, options),
        }
    }
};

pub const Platform = struct {
    inner: InnerType,

    pub const InnerType = switch (builtin.os.tag) {
        .linux, .netbsd, .freebsd => PosixPlatfrom,
        else => @compileError("Unsupported OS"),
    };

    pub const InitError = error{
        OutOfMemory,
        NoSuitablePlatform,
        ConnectionFailed,
    };

    const log = std.log.scoped(.platform);

    pub fn init(allocator: std.mem.Allocator) InitError!@This() {
        return .{ .inner = try InnerType.init(allocator) };
    }

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.inner.deinit(allocator);
    }

    pub const PollEventsError = error{
        ConnectionLost,
        RoundtripFailed,
    };

    pub fn pollEvents(self: @This()) PollEventsError!void {
        try self.inner.pollEvents();
    }

    pub const WindowCreationError = error{
        OutOfMemory,
        FeaturesNotSupported,
    };

    pub fn createWindow(
        self: @This(),
        allocator: std.mem.Allocator,
        options: WindowCreationOptions,
    ) WindowCreationError!Window {
        return try self.inner.createWindow(allocator, options);
    }
};

/// Generic window interface
/// Defines the shape of a window
pub const Window = struct {
    inner: InnerType,

    pub const InnerType = switch (builtin.os.tag) {
        .linux, .openbsd, .freebsd => PosixWindow,
        else => @compileError("Unsopported OS"),
    };

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.inner.deinit(allocator);
    }

    pub fn closed(self: @This()) bool {
        return self.inner.closed();
    }

    pub fn extent(self: @This()) Extent {
        return self.inner.extent();
    }

    pub fn setFramebufferResizeCallback(
        self: *@This(),
        cb: ?FramebufferResizeCb,
    ) ?FramebufferResizeCb {
        return self.inner.setFramebufferResizeCallback(cb);
    }

    pub fn setKeyCallback(self: *@This(), cb: ?KeyCallback) ?KeyCallback {
        return self.inner.setKeyCallback(cb);
    }

    pub fn vulkanExtensions(self: @This()) []const [*:0]const u8 {
        return self.inner.vulkanExtensions();
    }
};

/// Dispatches method calls to correct posix backend
pub const PosixWindow = union(enum) {
    wayland: *wayland.WlWindow,
    x11: x11.Window,

    const wayland = @import("./wayland.zig");
    const x11 = @import("./x11.zig");

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        switch (self) {
            .wayland => |impl| {
                impl.deinit();
                allocator.destroy(impl);
            },
            inline else => |impl| impl.deinit(),
        }
    }

    pub fn closed(self: @This()) bool {
        switch (self) {
            inline else => |impl| return impl.closed(),
        }
    }

    pub fn extent(self: @This()) Extent {
        switch (self) {
            inline else => |impl| return impl.extent(),
        }
    }

    pub fn setFramebufferResizeCallback(
        self: *@This(),
        cb: ?FramebufferResizeCb,
    ) ?FramebufferResizeCb {
        switch (self.*) {
            .wayland => |impl| return impl.setFramebufferResizeCallback(cb),
            .x11 => |*impl| return impl.setFramebufferResizeCallback(cb),
        }
    }

    pub fn setKeyCallback(self: *@This(), cb: ?KeyCallback) ?KeyCallback {
        switch (self.*) {
            .wayland => |impl| return impl.setKeyCallback(cb),
            .x11 => |*impl| return impl.setKeyCallback(cb),
        }
    }

    pub fn vulkanExtensions(self: @This()) []const [*:0]const u8 {
        switch (self) {
            .wayland => return wayland.WlWindow.vulkanExtensions(),
            .x11 => return x11.Window.vulkanExtentions(),
        }
    }
};
