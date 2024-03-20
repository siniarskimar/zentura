//! Wrapper around GLFW windowing capabilities

const std = @import("std");
pub const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub const GLFWwindow = c.GLFWwindow;

pub const WindowInfo = struct {
    width: u32,
    height: u32,
};

pub const Window = struct {
    allocator: std.mem.Allocator,
    glfw_window: *GLFWwindow,
    window_info: *WindowInfo,

    pub fn init(allocator: std.mem.Allocator, initial_width: u32, initial_height: u32) !@This() {
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GLFW_TRUE);
        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_OPENGL_API);
        c.glfwWindowHint(c.GLFW_DOUBLEBUFFER, c.GLFW_TRUE);

        const window = c.glfwCreateWindow(@intCast(initial_width), @intCast(initial_height), "zentura", null, null);
        if (window == null) {
            return error.WindowCreationFailed;
        }
        const window_info = try allocator.create(WindowInfo);
        window_info.* = .{
            .width = initial_width,
            .height = initial_height,
        };

        c.glfwSetWindowUserPointer(window, window_info);
        _ = c.glfwSetKeyCallback(window, glfwKeyCallback);
        _ = c.glfwSetCharCallback(window, glfwCharCallback);
        _ = c.glfwSetWindowSizeCallback(window, glfwSizeCallback);

        return .{
            .allocator = allocator,
            .glfw_window = window.?,
            .window_info = window_info,
        };
    }

    pub fn deinit(self: @This()) void {
        c.glfwDestroyWindow(self.glfw_window);
        self.allocator.destroy(self.window_info);
    }

    pub fn makeCurrent(self: @This()) void {
        c.glfwMakeContextCurrent(self.glfw_window);
    }

    pub fn width(self: @This()) u32 {
        return self.window_info.width;
    }

    pub fn height(self: @This()) u32 {
        return self.window_info.height;
    }

    pub fn swapBuffers(self: @This()) void {
        c.glfwSwapBuffers(self.glfw_window);
    }
};

fn glfwKeyCallback(window: ?*c.GLFWwindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
    _ = scancode;
    _ = action;
    _ = mods;
    _ = window;
    _ = key;
}

fn glfwCharCallback(window: ?*c.GLFWwindow, codepoint: c_uint) callconv(.C) void {
    _ = window;
    const zcodepoint: u21 = @truncate(codepoint);
    std.debug.print("{u}\n", .{zcodepoint});
}

fn glfwSizeCallback(window: ?*GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    // the pointer is allocated from Zig, so this is fine
    const user_pointer = c.glfwGetWindowUserPointer(window) orelse @panic("window_info is null");
    var window_info: *WindowInfo = @alignCast(@ptrCast(user_pointer));

    window_info.width = @intCast(width);
    window_info.height = @intCast(height);
}
