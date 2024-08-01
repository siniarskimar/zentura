const std = @import("std");
const builtin = @import("builtin");

pub const FramebufferResizeCb = *const fn (ctx: ?*anyopaque, width: u32, height: u32) void;

pub fn Callback(FnPtr: type) type {
    return struct {
        ptr: FnPtr,
        ctx: ?*anyopaque = null,
    };
}

pub const WindowCreationOptions = struct {
    title: []const u8 = "zentura",
    width: u32,
    height: u32,
};

pub const Extent = struct {
    width: u32,
    height: u32,
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
        cb: ?Callback(FramebufferResizeCb),
    ) ?Callback(FramebufferResizeCb) {
        return self.inner.setFramebufferResizeCallback(cb);
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
        cb: ?Callback(FramebufferResizeCb),
    ) ?Callback(FramebufferResizeCb) {
        switch (self.*) {
            .wayland => |impl| return impl.setFramebufferResizeCallback(cb),
            .x11 => |*impl| return impl.setFramebufferResizeCallback(cb),
        }
    }

    pub fn vulkanExtensions(self: @This()) []const [*:0]const u8 {
        switch (self) {
            .wayland => return wayland.WlWindow.vulkanExtensions(),
            .x11 => return x11.Window.vulkanExtentions(),
        }
    }
};
