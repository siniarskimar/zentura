const std = @import("std");
const builtin = @import("builtin");
const vulkan = @import("./vulkan.zig");

const target_os = builtin.target.os;
pub const host_is_posix: bool =
    target_os.tag == .linux or target_os.tag == .netbsd or target_os.tag == .freebsd;

const wayland = if (host_is_posix) @import("./wayland.zig") else {};
const x11 = if (host_is_posix) @import("./x11.zig") else {};

pub const log = std.log.scoped(.window);

pub const Platform = if (host_is_posix) union(enum) {
    wayland: *wayland.Platform,
    x11: x11.Platform,

    pub fn init(allocator: std.mem.Allocator) !@This() {
        if (wayland.Platform.init()) |plat| {
            const result = try allocator.create(wayland.Platform);
            result.* = plat;

            try result.setupListeners();

            return .{ .wayland = result };
        } else |err| switch (err) {
            error.OutOfMemory => {
                log.err("Got error.OutOfMemory while initializing Wayland", .{});
                return err;
            },
            else => {
                log.warn("Failed to initialize Wayland: {s}", .{@errorName(err)});
                if (@errorReturnTrace()) |return_trace| {
                    std.debug.dumpStackTrace(return_trace.*);
                }
            },
        }

        if (@import("./x11.zig").Platform.init()) |plat| {
            return .{ .x11 = plat };
        } else |err| {
            log.warn("Failed to initialize X11: {s}", .{@errorName(err)});
            if (@errorReturnTrace()) |return_trace| {
                std.debug.dumpStackTrace(return_trace.*);
            }
        }

        std.log.err("Could not initialize a window platform", .{});
        return error.InitWindowPlatfromFailed;
    }

    pub fn deinit(self: *const @This(), allocator: std.mem.Allocator) void {
        switch (self.*) {
            .wayland => |plat| {
                plat.deinit();
                allocator.destroy(plat);
            },
            .x11 => |plat| {
                plat.deinit();
            },
        }
    }

    pub fn pollEvents(self: *const @This()) void {
        switch (self.*) {
            .wayland => |plat| plat.pollEvents(),
            .x11 => |plat| plat.pollEvents(),
        }
    }
} else @compileError("Unsupported OS");

pub const FnFramebufferResizeCb = fn (ctx: ?*anyopaque, width: u32, height: u32) void;

pub const WindowDimensions = struct {
    width: u32,
    height: u32,
};

pub const Window = if (host_is_posix) union(enum) {
    wayland: *wayland.WlWindow,
    x11: *x11.Window,

    pub fn init(allocator: std.mem.Allocator, platform: *const Platform, width: u32, height: u32) !@This() {
        switch (platform.*) {
            .wayland => |plat| {
                const wlwindow = try allocator.create(wayland.WlWindow);
                errdefer allocator.destroy(wlwindow);

                wlwindow.* = try wayland.WlWindow.init(plat, width, height);
                wlwindow.initListeners();

                return .{ .wayland = wlwindow };
            },
            .x11 => |plat| {
                const X11Window = @import("./x11.zig").Window;
                const window = try allocator.create(X11Window);
                errdefer allocator.destroy(window);

                window.* = try X11Window.init(plat, width, height);
                _ = x11.c.XMapWindow(plat.display, window.window_handle);

                switch (x11.c.XSaveContext(plat.display, window.window_handle, plat.xcontext, @ptrCast(window))) {
                    0 => {},
                    x11.c.XCNOMEM => return error.OutOfMemory,
                    else => return error.UnknownX11,
                }

                return .{ .x11 = window };
            },
        }
    }

    pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
        switch (self.*) {
            .wayland => |window| {
                window.deinit();
                allocator.destroy(window);
            },
            .x11 => |window| {
                x11.c.XDeleteContext(window.context.display, window.window_handle, window.context.xcontext);
                window.deinit();
                allocator.destroy(window);
            },
        }
    }

    pub fn setFramebufferResizeCallback(
        self: @This(),
        ctx: ?*anyopaque,
        callback: ?*const FnFramebufferResizeCb,
    ) void {
        switch (self) {
            .wayland => |window| {
                window.setFramebufferResizeCallback(ctx, callback);
            },
            .x11 => |window| {
                window.setFramebufferResizeCallback(ctx, callback);
            },
        }
    }

    pub fn setTitle(self: @This(), title: [:0]const u8) void {
        switch (self) {
            .wayland => |window| {
                window.xdg_toplevel.setTitle(title);
            },
            .x11 => |window| {
                _ = x11.c.XStoreName(window.context.display, window.window_handle, title);
            },
        }
    }

    pub fn commit(self: @This()) void {
        switch (self) {
            .wayland => |window| {
                window.wl_surface.commit();
            },
            .x11 => |window| {
                _ = window;
                // Changes are synchronous
            },
        }
    }

    pub fn closed(self: @This()) bool {
        return switch (self) {
            .wayland => |window| window.state_closed,
            .x11 => |window| window.state_closed,
        };
    }

    pub fn dimensions(self: @This()) WindowDimensions {
        return switch (self) {
            .wayland => |window| .{ .width = window.width, .height = window.height },
            .x11 => |window| .{ .width = window.width, .height = window.height },
        };
    }
} else @compileError("Unsupported OS");
