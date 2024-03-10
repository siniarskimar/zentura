const std = @import("std");
pub const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});

pub const GLFWwindow = c.GLFWwindow;

pub const Window = struct {
    allocator: std.mem.Allocator,
    glfw_window: *GLFWwindow,

    pub fn init(allocator: std.mem.Allocator) !@This() {
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 3);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 3);
        c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GLFW_TRUE);
        c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_OPENGL_API);
        c.glfwWindowHint(c.GLFW_DOUBLEBUFFER, c.GLFW_TRUE);

        const window = c.glfwCreateWindow(800, 600, "zentura", null, null);
        if (window == null) {
            return error.WindowCreationFailed;
        }

        return .{
            .allocator = allocator,
            .glfw_window = window.?,
        };
    }

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

    pub fn registerCallbacks(self: *@This()) void {
        c.glfwSetWindowUserPointer(self.glfw_window, self);
        _ = c.glfwSetKeyCallback(self.glfw_window, glfwKeyCallback);
        _ = c.glfwSetCharCallback(self.glfw_window, glfwCharCallback);
    }

    pub fn deinit(self: @This()) void {
        c.glfwDestroyWindow(self.glfw_window);
    }

    pub fn makeCurrent(self: @This()) void {
        c.glfwMakeContextCurrent(self.glfw_window);
    }
};
