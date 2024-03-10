const gl = @import("gl");
const std = @import("std");

pub const GLenum = gl.GLenum;
pub const GLboolean = gl.GLboolean;
pub const GLbitfield = gl.GLbitfield;
pub const GLbyte = gl.GLbyte;
pub const GLubyte = gl.GLubyte;
pub const GLshort = gl.GLshort;
pub const GLushort = gl.GLushort;
pub const GLint = gl.GLint;
pub const GLuint = gl.GLuint;
pub const GLclampx = gl.GLclampx;
pub const GLsizei = gl.GLsizei;
pub const GLfloat = gl.GLfloat;
pub const GLclampf = gl.GLclampf;
pub const GLdouble = gl.GLdouble;
pub const GLclampd = gl.GLclampd;
pub const GLchar = gl.GLchar;
pub const GLhalf = gl.GLhalf;
pub const GLfixed = gl.GLfixed;
pub const GLintptr = gl.GLintptr;
pub const GLsizeiptr = gl.GLsizeiptr;
pub const GLint64 = gl.GLint64;
pub const GLuint64 = gl.GLuint64;

// Wrappers around OpenGL objects

pub const VertexArray = struct {
    object: GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;

        gl.genVertexArrays(1, &object);
        if (object == 0) std.debug.panic("glGenVertexArrays failed", .{});

        return .{ .object = object };
    }

    pub fn bind(self: @This()) void {
        gl.bindVertexArray(self.object);
    }

    pub fn delete(self: @This()) void {
        gl.deleteVertexArrays(1, &self.object);
    }
};

pub const VertexBufferObject = struct {
    object: gl.GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;
        gl.genBuffers(1, &object);

        if (object == 0) std.debug.panic("glGenBuffers failed", .{});

        return .{ .object = object };
    }

    pub fn bind(self: @This()) void {
        gl.bindBuffer(gl.GL_ARRAY_BUFFER, self.object);
    }

    pub fn delete(self: @This()) void {
        gl.deleteBuffers(1, &self.object);
    }
};

pub const IndexBufferObject = struct {
    object: gl.GLuint,

    pub fn bind(self: @This()) void {
        gl.bindBuffer(gl.GL_ELEMENT_ARRAY_BUFFER, self.object);
    }
};

pub const ShaderObject = struct {
    object: gl.GLuint,

    const ShaderType = enum(gl.GLenum) {
        vertex = gl.GL_VERTEX_SHADER,
        fragment = gl.GL_FRAGMENT_SHADER,
    };

    pub fn compile(
        shader_type: ShaderType,
        source: []const u8,
        diagnostic_writer: anytype,
    ) !@This() {
        const diagnostic_disabled = @typeInfo(@TypeOf(diagnostic_writer)) == .Void;

        const object = gl.createShader(@intFromEnum(shader_type));
        errdefer gl.deleteShader(object);

        if (object == 0) std.debug.panic("glCreateShader failed", .{});

        gl.shaderSource(object, 1, &[_][*c]const gl.GLchar{source.ptr}, &[_]gl.GLint{@intCast(source.len)});
        gl.compileShader(object);

        var compile_status: gl.GLint = gl.GL_TRUE;
        gl.getShaderiv(object, gl.GL_COMPILE_STATUS, &compile_status);
        if (compile_status == gl.GL_FALSE) {
            if (!diagnostic_disabled) {
                var buffer = [_]u8{0} ** 1024;

                var info_log_len: gl.GLint = 0;
                gl.getShaderiv(object, gl.GL_INFO_LOG_LENGTH, &info_log_len);

                gl.getShaderInfoLog(object, buffer.len, null, &buffer);
                try diagnostic_writer.writeAll(buffer[0..@min(buffer.len, @as(usize, @intCast(info_log_len)))]);

                if (buffer.len < info_log_len) {
                    try diagnostic_writer.writeAll("\n// ... truncated");
                }
            }
            return error.CompilationFailed;
        }
        return .{ .object = object };
    }

    /// Flag this shader for deletion.
    /// OpenGL objects are reference counted
    pub fn delete(self: @This()) void {
        gl.deleteShader(self.object);
    }
};

pub const ProgramObject = struct {
    object: gl.GLuint,

    pub fn compile(
        vertex_source: []const u8,
        fragment_source: []const u8,
        diagnostic_writer: anytype,
    ) !@This() {
        const program = gl.createProgram();

        if (program == 0) std.debug.panic("glCreateProgram failed", .{});
        errdefer gl.deleteProgram(program);

        const vs = try ShaderObject.compile(.vertex, vertex_source, diagnostic_writer);
        defer vs.delete();

        const fs = try ShaderObject.compile(.fragment, fragment_source, diagnostic_writer);
        defer fs.delete();

        gl.attachShader(program, vs.object);
        gl.attachShader(program, fs.object);

        return .{ .object = program };
    }

    pub fn link(self: @This()) !void {
        var link_status: gl.GLint = gl.GL_TRUE;
        gl.linkProgram(self.object);
        gl.getProgramiv(self.object, gl.GL_LINK_STATUS, &link_status);

        if (link_status == gl.GL_FALSE) {
            return error.LinkingFailed;
        }

        var attached_count: gl.GLsizei = 0;
        var attached_shaders = [_]gl.GLuint{0} ** std.meta.fieldNames(ShaderObject.ShaderType).len;

        gl.getAttachedShaders(self.object, attached_shaders.len, &attached_count, &attached_shaders);
        for (0..@as(usize, @intCast(attached_count))) |idx| {
            gl.detachShader(self.object, attached_shaders[idx]);
        }
    }

    pub fn delete(self: @This()) void {
        gl.deleteProgram(self.object);
    }
};
