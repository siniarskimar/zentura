const std = @import("std");
const c = @cImport({
    @cInclude("stdbool.h");
    @cInclude("GLFW/glfw3.h");
});

const gl = @import("./gl.zig");

fn glfwErrorCallback(error_code: c_int, error_msg: [*c]const u8) callconv(.C) void {
    _ = error_code;
    std.log.err("[GLFW] {s}\n", .{error_msg});
}

fn gl_debugCallback(
    source: gl.GLenum,
    target: gl.GLenum,
    id: gl.GLuint,
    severity: gl.GLenum,
    length: gl.GLsizei,
    message: [*c]const gl.GLchar,
    userparam: ?*anyopaque,
) callconv(.C) void {
    _ = userparam;
    _ = length;
    _ = severity;
    _ = id;
    _ = source;

    std.log.debug("GLDEBUG [{}] {s}", .{ target, message });
}

pub fn main() !void {
    _ = c.glfwSetErrorCallback(glfwErrorCallback);

    if (c.glfwInit() == c.false) {
        return error.GLFWInitFailed;
    }
    defer c.glfwTerminate();

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 2);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);
    c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GLFW_TRUE);

    const window = c.glfwCreateWindow(800, 600, "zen", null, null);
    if (window == null) {
        return error.WindowCreationFailed;
    }
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    try gl.loadGL(c.glfwGetProcAddress);

    std.log.info("Loaded OpenGL {s}\n", .{gl.getString(gl.VERSION)});

    if (gl.ARB_debug_output()) {
        gl.enable(gl.DEBUG_OUTPUT);
        gl.debugMessageCallback(gl_debugCallback, null);
    }

    gl.clearColor(0.0, 0.0, 0.0, 1.0);

    while (c.glfwWindowShouldClose(window) == c.false) {
        c.glfwPollEvents();

        gl.clear(gl.COLOR_BUFFER_BIT);

        gl.begin(gl.TRIANGLES);
        gl.color3f(1.0, 0.0, 0.0);
        gl.vertex2f(0.0, 0.5);
        gl.vertex2f(0.5, -0.5);
        gl.vertex2f(-0.5, -0.5);
        gl.end();

        c.glfwSwapBuffers(window);
    }
}
