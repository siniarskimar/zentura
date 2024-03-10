const std = @import("std");
const windowing = @import("./window.zig");
const cglfw = windowing.c;

const glb = @import("gl");
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

fn loadGL() !void {
    glb.makeProcTableCurrent(try glb.loadGL(cglfw.glfwGetProcAddress));

    if (glb.loadGL_KHR_DEBUG(glb.getProcTablePtr().?, cglfw.glfwGetProcAddress)) {
        glb.enable(glb.GL_DEBUG_OUTPUT);
        glb.debugMessageCallback(gl_debugCallback, null);
    } else |_| {
        std.log.debug("GL_KHR_DEBUG unavailable", .{});
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const gpaalloc = gpa.allocator();

    _ = cglfw.glfwSetErrorCallback(glfwErrorCallback);

    if (cglfw.glfwInit() == 0) {
        return error.GLFWInitFailed;
    }
    defer cglfw.glfwTerminate();

    var window = try windowing.Window.init(gpaalloc);
    defer window.deinit();

    window.registerCallbacks();
    window.makeCurrent();

    try loadGL();

    const program = try gl.ProgramObject.compile(
        \\#version 330
        \\
        \\in vec3 in_pos;
        \\void main(){
        \\   gl_Position = vec4(in_pos, 1.0);
        \\}
    ,
        \\#version 330
        \\
        \\out vec4 out_color;
        \\void main() {
        \\   out_color = vec4(1.0,0.0,0.0,1.0);
        \\}
    , std.io.getStdErr());
    defer program.delete();

    glb.bindAttribLocation(program.object, 0, "in_pos");
    try program.link();

    var vao = gl.VertexArray.generateOne();
    defer vao.delete();

    var vbo = gl.VertexBufferObject.generateOne();
    defer vbo.delete();

    const vertices = [_]gl.GLfloat{
        0.0,  0.5,  0.0,
        0.5,  -0.5, 0.0,
        -0.5, -0.5, 0.0,
    };
    const indeces = [_]gl.GLuint{ 0, 1, 2 };

    vao.bind();

    vbo.bind();
    glb.bufferData(glb.GL_ARRAY_BUFFER, @sizeOf([vertices.len]glb.GLfloat), &vertices, glb.GL_STATIC_DRAW);

    glb.enableVertexAttribArray(0);
    glb.vertexAttribPointer(0, 3, glb.GL_FLOAT, glb.GL_FALSE, @sizeOf(glb.GLfloat) * 3, @ptrFromInt(0));

    glb.useProgram(program.object);
    glb.clearColor(0.0, 0.0, 0.0, 1.0);

    while (cglfw.glfwWindowShouldClose(window.glfw_window) == 0) {
        while (true) {
            const err = glb.getError();
            if (err == glb.GL_NO_ERROR) {
                break;
            }
            std.log.err("GLERROR {}", .{err});
        }
        cglfw.glfwPollEvents();

        glb.clear(glb.GL_COLOR_BUFFER_BIT);
        // glb.drawArrays(glb.GL_TRIANGLES, 0, 3);
        glb.drawElements(glb.GL_TRIANGLES, 3, glb.GL_UNSIGNED_INT, &indeces);

        cglfw.glfwSwapBuffers(window.glfw_window);
    }
}
