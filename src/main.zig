const std = @import("std");
const c = @cImport({
    @cInclude("GLFW/glfw3.h");
});

const gl = @import("gl");

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

const Window = struct {
    allocator: std.mem.Allocator,
    glfw_window: *c.GLFWwindow,

    pub fn init(allocator: std.mem.Allocator) !@This() {
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 2);
        c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 1);
        c.glfwWindowHint(c.GLFW_OPENGL_DEBUG_CONTEXT, c.GLFW_TRUE);

        const window = c.glfwCreateWindow(800, 600, "zentura", null, null);
        if (window == null) {
            return error.WindowCreationFailed;
        }

        return .{
            .allocator = allocator,
            .glfw_window = window.?,
        };
    }

    fn glfwKeyCallback(window: *c.GLFWWindow, key: c_int, scancode: c_int, action: c_int, mods: c_int) callconv(.C) void {
        _ = scancode;
        _ = action;
        _ = mods;
        _ = window;
        if (key == c.GLFW_KEY_SPACE) {
            std.debug.print("SPAAAACCEEEE!!!\n", .{});
        }
        // var self: *Window = @ptrCast(c.glfwGetWindowUserPointer(window));
    }

    pub fn registerCallbacks(self: *@This()) !void {
        c.glfwSetWindowUserPointer(self.glfw_window, self);
        c.glfwSetKeyCallback(self.glfw_window, glfwKeyCallback);
    }

    pub fn deinit(self: *@This()) void {
        c.glfwDestroyWindow(self.glfw_window);
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpaalloc = gpa.allocator();

    _ = c.glfwSetErrorCallback(glfwErrorCallback);

    if (c.glfwInit() == 0) {
        return error.GLFWInitFailed;
    }
    defer c.glfwTerminate();

    var window = try Window.init(gpaalloc);
    defer window.deinit();

    c.glfwMakeContextCurrent(window.glfw_window);

    gl.makeProcTableCurrent(try gl.loadGL(c.glfwGetProcAddress));

    const gl_version_str: [*:0]const u8 = gl.getString(gl.GL_VERSION) orelse "<n/a>";

    std.log.info("Loaded OpenGL {s}\n", .{
        std.mem.span(gl_version_str),
    });

    // if (gl.ARB_debug_output()) {
    //     gl.enable(gl.DEBUG_OUTPUT);
    //     gl.debugMessageCallback(gl_debugCallback, null);
    // }

    gl.clearColor(0.0, 0.0, 0.0, 1.0);

    while (c.glfwWindowShouldClose(window.glfw_window) == 0) {
        c.glfwPollEvents();

        gl.clear(gl.GL_COLOR_BUFFER_BIT);

        gl.begin(gl.GL_TRIANGLES);
        gl.color3f(1.0, 0.0, 0.0);
        gl.vertex2f(0.0, 0.5);
        gl.vertex2f(0.5, -0.5);
        gl.vertex2f(-0.5, -0.5);
        gl.end();

        c.glfwSwapBuffers(window.glfw_window);
    }
}
