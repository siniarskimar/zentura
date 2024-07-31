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

pub const Platform = struct {
    ptr: *anyopaque,
    vtable: VTable,

    pub const Tag = enum {
        wayland,
        x11,
    };

    pub const VTable = struct {
        deinit: *const fn (ptr: *anyopaque, allocator: std.mem.Allocator) void,
        tag: *const fn () Tag,
        pollEvents: *const fn (ptr: *anyopaque) PollEventsError!void,
        createWindow: *const fn (
            ptr: *anyopaque,
            allocator: std.mem.Allocator,
            options: WindowCreationOptions,
        ) WindowCreationError!Window,
    };

    pub const PlatformInitError = error{
        OutOfMemory,
        NoSuitablePlatform,
        ConnectionFailed,
    };

    const log = std.log.scoped(.platform);

    pub fn init(allocator: std.mem.Allocator) PlatformInitError!@This() {
        switch (builtin.target.os.tag) {
            .linux,
            .netbsd,
            .freebsd,
            => {
                const wayland = @import("./wayland.zig");
                const x11 = @import("./x11.zig");

                // TODO(future): detect if wayland or x11 are supported first
                // by dynamically loading their libraries
                if (wayland.Platform.init()) |plat| {
                    const heap = try allocator.create(wayland.Platform);
                    heap.* = plat;
                    heap.setupListeners();

                    return .{ .ptr = heap, .vtable = wayland.Platform.vtable() };
                } else |err| {
                    log.debug("Wayland platform creation failed: {}", .{err});
                }

                if (x11.Platform.init()) |plat| {
                    const heap = try allocator.create(x11.Platform);
                    heap.* = plat;

                    return .{ .ptr = heap, .vtable = x11.Platform.vtable() };
                } else |err| {
                    log.err("X11 platform creation failed: {}", .{err});
                }

                return error.NoSuitablePlatform;
            },
            else => |os| @compileError(std.fmt.comptimePrint("{} is unsupported", .{os})),
        }
    }
    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.vtable.deinit(self.ptr, allocator);
    }

    pub fn tag(self: @This()) Tag {
        return self.vtable.tag();
    }

    pub const PollEventsError = error{
        ConnectionLost,
        RoundtripFailed,
    };

    pub fn pollEvents(self: @This()) PollEventsError!void {
        try self.vtable.pollEvents(self.ptr);
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
        return try self.vtable.createWindow(self.ptr, allocator, options);
    }
};

pub const Window = struct {
    ptr: *anyopaque,
    vtable: VTable,

    pub const VTable = struct {
        deinit: *const fn (ptr: *anyopaque, allocator: std.mem.Allocator) void,
        dimensions: *const fn (ptr: *anyopaque) Dimensions,
        closed: *const fn (ptr: *anyopaque) bool,

        // This doesn't have to be a virtual function call
        tag: *const fn () Platform.Tag,

        setFramebufferResizeCallback: *const fn (
            ptr: *anyopaque,
            cb: ?Callback(FramebufferResizeCb),
        ) ?Callback(FramebufferResizeCb),
    };

    pub const Dimensions = struct {
        width: u32,
        height: u32,
    };

    pub fn deinit(self: @This(), allocator: std.mem.Allocator) void {
        self.vtable.deinit(self.ptr, allocator);
    }

    pub fn closed(self: @This()) bool {
        return self.vtable.closed(self.ptr);
    }

    pub fn dimensions(self: @This()) Dimensions {
        return self.vtable.dimensions(self.ptr);
    }

    pub fn tag(self: @This()) Platform.Tag {
        return self.vtable.tag();
    }

    pub fn setFramebufferResizeCallback(
        self: @This(),
        cb: ?Callback(FramebufferResizeCb),
    ) ?Callback(FramebufferResizeCb) {
        return self.vtable.setFramebufferResizeCallback(self.ptr, cb);
    }
};
