const glb = @import("glb");
const std = @import("std");

pub const GLenum = glb.GLenum;
pub const GLboolean = glb.GLboolean;
pub const GLbitfield = glb.GLbitfield;
pub const GLbyte = glb.GLbyte;
pub const GLubyte = glb.GLubyte;
pub const GLint = glb.GLint;
pub const GLuint = glb.GLuint;
pub const GLsizei = glb.GLsizei;
pub const GLfloat = glb.GLfloat;
pub const GLclampf = glb.GLclampf;
pub const GLdouble = glb.GLdouble;
pub const GLclampd = glb.GLclampd;
pub const GLchar = glb.GLchar;
pub const GLsizeiptr = glb.GLsizeiptr;
pub const GLint64 = glb.GLint64;
pub const GLuint64 = glb.GLuint64;

// Wrappers around OpenGL objects

pub const VertexArray = struct {
    object: GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;

        glb.genVertexArrays(1, &object);
        if (object == 0) std.debug.panic("glGenVertexArrays failed", .{});

        return .{ .object = object };
    }

    pub fn bind(self: @This()) void {
        glb.bindVertexArray(self.object);
    }

    pub fn delete(self: @This()) void {
        glb.deleteVertexArrays(1, &self.object);
    }
};

pub const VertexBufferObject = struct {
    object: glb.GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;
        glb.genBuffers(1, &object);

        if (object == 0) std.debug.panic("glGenBuffers failed", .{});

        return .{ .object = object };
    }

    pub fn bind(self: @This()) void {
        glb.bindBuffer(glb.GL_ARRAY_BUFFER, self.object);
    }

    pub fn delete(self: @This()) void {
        glb.deleteBuffers(1, &self.object);
    }
};

pub const IndexBufferObject = struct {
    object: glb.GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;
        glb.genBuffers(1, &object);

        if (object == 0) std.debug.panic("glGenBuffers failed", .{});

        return .{ .object = object };
    }

    pub fn bind(self: @This()) void {
        glb.bindBuffer(glb.GL_ELEMENT_ARRAY_BUFFER, self.object);
    }
};

pub const ShaderObject = struct {
    object: glb.GLuint,

    const ShaderType = enum(glb.GLenum) {
        vertex = glb.GL_VERTEX_SHADER,
        fragment = glb.GL_FRAGMENT_SHADER,
    };

    pub fn compile(
        shader_type: ShaderType,
        source: []const u8,
        diagnostic_writer: anytype,
    ) !@This() {
        const diagnostic_disabled = @typeInfo(@TypeOf(diagnostic_writer)) == .Void;

        const object = glb.createShader(@intFromEnum(shader_type));
        errdefer glb.deleteShader(object);

        if (object == 0) std.debug.panic("glCreateShader failed", .{});

        glb.shaderSource(object, 1, &[_][*c]const GLchar{source.ptr}, &[_]GLint{@intCast(source.len)});
        glb.compileShader(object);

        var compile_status: GLint = glb.GL_TRUE;
        glb.getShaderiv(object, glb.GL_COMPILE_STATUS, &compile_status);
        if (compile_status == glb.GL_FALSE) {
            if (!diagnostic_disabled) {
                var buffer = [_]u8{0} ** 1024;

                var info_log_len: glb.GLint = 0;
                glb.getShaderiv(object, glb.GL_INFO_LOG_LENGTH, &info_log_len);

                glb.getShaderInfoLog(object, buffer.len, null, &buffer);
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
        glb.deleteShader(self.object);
    }
};

pub const ProgramObject = struct {
    object: GLuint,

    pub fn compile(
        vertex_source: []const u8,
        fragment_source: []const u8,
        diagnostic_writer: anytype,
    ) !@This() {
        const program = glb.createProgram();

        if (program == 0) std.debug.panic("glCreateProgram failed", .{});
        errdefer glb.deleteProgram(program);

        const vs = try ShaderObject.compile(.vertex, vertex_source, diagnostic_writer);
        defer vs.delete();

        const fs = try ShaderObject.compile(.fragment, fragment_source, diagnostic_writer);
        defer fs.delete();

        glb.attachShader(program, vs.object);
        glb.attachShader(program, fs.object);

        return .{ .object = program };
    }

    pub fn link(self: @This()) !void {
        var link_status: glb.GLint = glb.GL_TRUE;
        glb.linkProgram(self.object);
        glb.getProgramiv(self.object, glb.GL_LINK_STATUS, &link_status);

        if (link_status == glb.GL_FALSE) {
            return error.LinkingFailed;
        }

        var attached_count: GLsizei = 0;
        var attached_shaders = [_]GLuint{0} ** std.meta.fieldNames(ShaderObject.ShaderType).len;

        glb.getAttachedShaders(self.object, attached_shaders.len, &attached_count, &attached_shaders);
        for (0..@as(usize, @intCast(attached_count))) |idx| {
            glb.detachShader(self.object, attached_shaders[idx]);
        }
    }

    pub fn delete(self: @This()) void {
        glb.deleteProgram(self.object);
    }

    pub fn use(self: @This()) void {
        glb.useProgram(self.object);
    }
};

pub const TextureObject = struct {
    object: GLuint,

    pub fn generateOne() @This() {
        var object: GLuint = 0;
        glb.genTextures(1, &object);

        if (object == 0) std.debug.panic("glGenTextures failed", .{});

        return .{ .object = object };
    }

    pub fn delete(self: @This()) void {
        glb.deleteTextures(1, &self.object);
    }
};
