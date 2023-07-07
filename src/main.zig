const std = @import("std");
const c = @cImport({
    @cInclude("stdbool.h");
    @cInclude("GLFW/glfw3.h");
});

const GLbitfield = u32;
const GLfloat = f32;
const GLdouble = f64;
const GLclampf = GLfloat;
const GLclampd = GLdouble;
const PGLCLEARCOLOR = *const fn (red: GLclampf, green: GLclampf, blue: GLclampf, alpha: GLclampf) callconv(.C) void;
const PGLCLEAR = *const fn (bitfield: GLbitfield) callconv(.C) void;

const GL_CURRENT_BIT = 0x00000001;
const GL_POINT_BIT = 0x00000002;
const GL_LINE_BIT = 0x00000004;
const GL_POLYGON_BIT = 0x00000008;
const GL_POLYGON_STIPPLE_BIT = 0x00000010;
const GL_PIXEL_MODE_BIT = 0x00000020;
const GL_LIGHTING_BIT = 0x00000040;
const GL_FOG_BIT = 0x00000080;
const GL_DEPTH_BUFFER_BIT = 0x00000100;
const GL_ACCUM_BUFFER_BIT = 0x00000200;
const GL_STENCIL_BUFFER_BIT = 0x00000400;
const GL_VIEWPORT_BIT = 0x00000800;
const GL_TRANSFORM_BIT = 0x00001000;
const GL_ENABLE_BIT = 0x00002000;
const GL_COLOR_BUFFER_BIT = 0x00004000;
const GL_HINT_BIT = 0x00008000;
const GL_EVAL_BIT = 0x00010000;
const GL_LIST_BIT = 0x00020000;
const GL_TEXTURE_BIT = 0x00040000;
const GL_SCISSOR_BIT = 0x00080000;
const GL_MULTISAMPLE_BIT = 0x20000000;
const GL_MULTISAMPLE_BIT_ARB = 0x20000000;
const GL_MULTISAMPLE_BIT_EXT = 0x20000000;
const GL_MULTISAMPLE_BIT_3DFX = 0x20000000;
const GL_ALL_ATTRIB_BITS = 0xFFFFFFFF;

fn glfwErrorCallback(error_code: c_int, error_msg: [*c]const u8) callconv(.C) void {
    _ = error_code;
    std.log.err("[GLFW] {s}\n", .{error_msg});
}

pub fn main() !void {
    _ = c.glfwSetErrorCallback(glfwErrorCallback);

    if (c.glfwInit() == c.false) {
        return error.GLFWInitFailed;
    }
    defer c.glfwTerminate();

    const window = c.glfwCreateWindow(800, 600, "zen", null, null);
    if (window == null) {
        return error.WindowCreationFailed;
    }
    defer c.glfwDestroyWindow(window);

    c.glfwMakeContextCurrent(window);
    const glClearColor: ?PGLCLEARCOLOR = @ptrCast(c.glfwGetProcAddress("glClearColor"));
    const glClear: ?PGLCLEAR = @ptrCast(c.glfwGetProcAddress("glClear"));

    if (glClearColor == null) {
        return error.FailedLoadingGLFunction;
    }

    if (glClear == null) {
        return error.FailedLoadingGLFunction;
    }
    var prev_time = try std.time.Instant.now();

    while (c.glfwWindowShouldClose(window) == c.false) {
        c.glfwPollEvents();

        const curr_time = try std.time.Instant.now();
        const diff = @as(u64, @divFloor(curr_time.since(prev_time), std.time.ns_per_s));
        if (diff == 0) {
            glClearColor.?(1.0, 0.0, 0.0, 1.0);
        } else if (diff == 1) {
            glClearColor.?(0.0, 1.0, 0.0, 1.0);
        } else if (diff == 2) {
            glClearColor.?(0.0, 0.0, 1.0, 1.0);
        } else {
            prev_time = curr_time;
        }
        glClear.?(GL_COLOR_BUFFER_BIT);
        c.glfwSwapBuffers(window);
    }
}
