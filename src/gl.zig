const std = @import("std");

pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLsizei = isize;
pub const GLsizeu = usize;
pub const GLfloat = f32;
pub const GLdouble = f64;
pub const GLclampf = GLfloat;
pub const GLclampd = GLdouble;
pub const GLchar = u8;

pub const GLenum = c_int;
pub const GLbitfield = u32;

pub const GLboolean = enum(u8) {
    FALSE = 0,
    TRUE = 1,
};

pub const FALSE = GLboolean.FALSE;
pub const TRUE = GLboolean.TRUE;

pub const CURRENT_BIT: GLbitfield = 0x00000001;
pub const POINT_BIT: GLbitfield = 0x00000002;
pub const LINE_BIT: GLbitfield = 0x00000004;
pub const POLYGON_BIT: GLbitfield = 0x00000008;
pub const POLYGON_STIPPLE_BIT: GLbitfield = 0x00000010;
pub const PIXEL_MODE_BIT: GLbitfield = 0x00000020;
pub const LIGHTING_BIT: GLbitfield = 0x00000040;
pub const FOG_BIT: GLbitfield = 0x00000080;
pub const DEPTH_BUFFER_BIT: GLbitfield = 0x00000100;
pub const ACCUM_BUFFER_BIT: GLbitfield = 0x00000200;
pub const STENCIL_BUFFER_BIT: GLbitfield = 0x00000400;
pub const VIEWPORT_BIT: GLbitfield = 0x00000800;
pub const TRANSFORM_BIT: GLbitfield = 0x00001000;
pub const ENABLE_BIT: GLbitfield = 0x00002000;
pub const COLOR_BUFFER_BIT: GLbitfield = 0x00004000;
pub const HINT_BIT: GLbitfield = 0x00008000;
pub const EVAL_BIT: GLbitfield = 0x00010000;
pub const LIST_BIT: GLbitfield = 0x00020000;
pub const TEXTURE_BIT: GLbitfield = 0x00040000;
pub const SCISSOR_BIT: GLbitfield = 0x00080000;
pub const MULTISAMPLE_BIT: GLbitfield = 0x20000000;
pub const ALL_ATTRIB_BITS: GLbitfield = 0xFFFFFFFF;

pub const POINTS: GLenum = 0x0000;
pub const LINES: GLenum = 0x0001;
pub const LINE_LOOP: GLenum = 0x0002;
pub const LINE_STRIP: GLenum = 0x0003;
pub const TRIANGLES: GLenum = 0x0004;
pub const TRIANGLE_STRIP: GLenum = 0x0005;
pub const TRIANGLE_FAN: GLenum = 0x0006;
pub const QUADS: GLenum = 0x0007;
pub const QUAD_STRIP: GLenum = 0x0008;
pub const POLYGON: GLenum = 0x0009;
pub const LINES_ADJACENCY: GLenum = 0x000A;
pub const LINE_STRIP_ADJACENCY: GLenum = 0x000B;
pub const TRIANGLES_ADJACENCY: GLenum = 0x000C;
pub const TRIANGLE_STRIP_ADJACENCY: GLenum = 0x000D;

// mark: Enum strings
pub const VERSION: GLenum = 0x1F02;
pub const EXTENSIONS: GLenum = 0x1F03;

// mark: Enum errors
pub const GLenumerror = enum(GLenum) {
    NO_ERROR = 0,
    INVALID_ENUM = 0x500,
    INVALID_VALUE = 0x501,
    INVALID_OPERATION = 0x502,
    STACK_OVERFLOW = 0x0503,
    STACK_UNDERFLOW = 0x0504,
    OUT_OF_MEMORY = 0x0505,
    INVALID_FRAMEBUFFER_OPERATION = 0x0506,
    CONTEXT_LOST = 0x507,
};

pub const GLenumshadertype = enum(GLenum) {
    FRAGMENT_SHADER = 0x8B30,
    VERTEX_SHADER = 0x8B31,
};

pub const FRAGMENT_SHADER = GLenumshadertype.FRAGMENT_SHADER;
pub const VERTEX_SHADER = GLenumshadertype.VERTEX_SHADER;

pub const MAX_FRAGMENT_UNIFORM_COMPONENTS: GLenum = 0x8B49;
pub const MAX_VERTEX_UNIFORM_COMPONENTS: GLenum = 0x8B4A;
pub const MAX_VARYING_FLOATS: GLenum = 0x8B4B;
pub const MAX_VARYING_COMPONENTS: GLenum = MAX_VARYING_FLOATS;
pub const MAX_VERTEX_TEXTURE_IMAGE_UNITS: GLenum = 0x8B4C;
pub const MAX_COMBINED_TEXTURE_IMAGE_UNITS: GLenum = 0x8B4D;
pub const SHADER_TYPE: GLenum = 0x8B4F;

pub const DELETE_STATUS: GLenum = 0x8B80;
pub const COMPILE_STATUS: GLenum = 0x8B81;
pub const LINK_STATUS: GLenum = 0x8B82;
pub const VALIDATE_STATUS: GLenum = 0x8B83;
pub const INFO_LOG_LENGTH: GLenum = 0x8B84;
pub const ATTACHED_SHADERS: GLenum = 0x8B85;
pub const ACTIVE_UNIFORMS: GLenum = 0x8B86;
pub const ACTIVE_UNIFORM_MAX_LENGTH: GLenum = 0x8B87;
pub const SHADER_SOURCE_LENGTH: GLenum = 0x8B88;
pub const ACTIVE_ATTRIBUTES: GLenum = 0x8B89;
pub const ACTIVE_ATTRIBUTE_MAX_LENGTH: GLenum = 0x8B8A;
pub const FRAGMENT_SHADER_DERIVATIVE_HINT: GLenum = 0x8B8B;
pub const SHADING_LANGUAGE_VERSION: GLenum = 0x8B8C;
pub const CURRENT_PROGRAM: GLenum = 0x8B8D;

pub const DEBUG_TYPE_ERROR: GLenum = 0x824C;
pub const DEBUG_TYPE_DEPRECATED_BEHAVIOR: GLenum = 0x824D;
pub const DEBUG_TYPE_UNDEFINED_BEHAVIOR: GLenum = 0x824E;
pub const DEBUG_TYPE_PORTABILITY: GLenum = 0x824F;
pub const DEBUG_TYPE_PERFORMANCE: GLenum = 0x8250;
pub const DEBUG_TYPE_OTHER: GLenum = 0x8251;

// mark: Capabilities
pub const DEBUG_OUTPUT: GLenum = 0x92E0;

/// Function Prototypes
const FNPROCGENERIC = *const fn () callconv(.C) void;

const FNDEBUGPROC = *const fn (
    source: GLenum,
    target: GLenum,
    id: GLuint,
    severity: GLenum,
    length: GLsizei,
    message: [*c]const GLchar,
    userparam: ?*anyopaque,
) callconv(.C) void;

// glxGetProcAddress/wglGetProcAddress etc.
const PGETPROCADDRESS = *const fn (funcname: [*c]const u8) callconv(.C) ?*const fn () callconv(.C) void;

const PGLCLEARCOLOR = *const fn (red: GLclampf, green: GLclampf, blue: GLclampf, alpha: GLclampf) callconv(.C) void;
var p_glClearColor: ?PGLCLEARCOLOR = null;

pub fn clearColor(red: GLclampf, green: GLclampf, blue: GLclampf, alpha: GLclampf) void {
    p_glClearColor.?(red, green, blue, alpha);
}

const PGLCLEAR = *const fn (bitfield: GLbitfield) callconv(.C) void;
var p_glClear: ?PGLCLEAR = null;

pub fn clear(bitmask: GLbitfield) void {
    p_glClear.?(bitmask);
}

const PGLBEGIN = *const fn (primitive: GLenum) callconv(.C) void;
var p_glBegin: ?PGLBEGIN = null;

pub fn begin(primitive: GLenum) void {
    p_glBegin.?(primitive);
}

const PGLEND = *const fn () callconv(.C) void;
var p_glEnd: ?PGLEND = null;

pub fn end() void {
    p_glEnd.?();
}

const PGLGETSTRING = *const fn (name: GLenum) callconv(.C) [*c]const GLubyte;
var p_glGetString: ?PGLGETSTRING = null;

pub fn getString(name: GLenum) [*c]const GLubyte {
    return p_glGetString.?(name);
}

const PGLVERTEX2F = *const fn (x: GLfloat, y: GLfloat) callconv(.C) void;
var p_glVertex2f: ?PGLVERTEX2F = null;

pub fn vertex2f(x: GLfloat, y: GLfloat) void {
    p_glVertex2f.?(x, y);
}

const PGLVERTEX3F = *const fn (x: GLfloat, y: GLfloat, z: GLfloat) callconv(.C) void;
var p_glVertex3f: ?PGLVERTEX3F = null;

pub fn vertex3f(x: GLfloat, y: GLfloat, z: GLfloat) void {
    p_glVertex3f.?(x, y, z);
}

const PGLCOLOR3F = *const fn (r: GLfloat, g: GLfloat, b: GLfloat) callconv(.C) void;
var p_glColor3f: ?PGLCOLOR3F = null;

pub fn color3f(r: GLfloat, g: GLfloat, b: GLfloat) void {
    p_glColor3f.?(r, g, b);
}

const PGLGETERROR = *const fn () callconv(.C) GLenumerror;
var p_glGetError: ?PGLGETERROR = null;

pub fn getError() GLenumerror {
    return p_glGetError.?();
}

const PGLENABLE = *const fn (cap: GLenum) callconv(.C) void;
var p_glEnable: ?PGLENABLE = null;

pub fn enable(cap: GLenum) void {
    p_glEnable.?(cap);
}

const PGLDISABLE = *const fn (cap: GLenum) callconv(.C) void;
var p_glDisable: ?PGLDISABLE = null;

pub fn disable(cap: GLenum) void {
    p_glDisable.?(cap);
}

const PGLDEBUGMESSAGECALLBACK = *const fn (callback: ?FNDEBUGPROC, userparam: ?*const anyopaque) callconv(.C) void;
var p_glDebugMessageCallback: ?PGLDEBUGMESSAGECALLBACK = null;

pub fn debugMessageCallback(callback: ?FNDEBUGPROC, userparam: ?*anyopaque) void {
    p_glDebugMessageCallback.?(callback, userparam);
}

const PGLCREATEPROGRAM = *const fn () callconv(.C) GLuint;
var p_glCreateProgram: ?PGLCREATEPROGRAM = null;

pub fn createProgram() GLuint {
    return p_glCreateProgram.?();
}

const PGLCREATESHADER = *const fn (type: GLenum) callconv(.C) GLuint;
var p_glCreateShader: ?PGLCREATESHADER = null;

pub fn createShader(typ: GLenumshadertype) GLuint {
    return p_glCreateShader.?(typ);
}

const PGLGETUNIFORMLOCATION = *const fn (program: GLuint, name: [*c]const GLchar) callconv(.C) GLint;
var p_glGetUniformLocation: ?PGLGETUNIFORMLOCATION = null;

pub fn getUniformLocation(program: GLuint, name: [*c]const GLchar) GLint {
    return p_glGetUniformLocation.?(program, name);
}

const PGLGETATTRIBLOCATION = *const fn (program: GLuint, name: [*c]const GLchar) callconv(.C) GLint;
var p_glGetAttribLocation: ?PGLGETATTRIBLOCATION = null;

pub fn getAttribLocation(program: GLuint, name: [*c]const GLchar) GLint {
    return p_glGetAttribLocation.?(program, name);
}

const PGLSHADERSOURCE = *const fn (shader: GLuint, count: GLsizei, sources: [][*c]const GLchar, length: [*c]const GLint) callconv(.C) void;
var p_glShaderSource: ?PGLSHADERSOURCE = null;

pub fn shaderSource(shader: GLuint, count: GLsizei, sources: [][*c]const GLchar, length: [*c]const GLint) void {
    p_glShaderSource.?(shader, count, sources, length);
}

const PGLATTACHSHADER = *const fn (program: GLuint, shader: GLuint) callconv(.C) void;
var p_glAttachShader: ?PGLATTACHSHADER = null;

pub fn attachShader(program: GLuint, shader: GLuint) void {
    p_glAttachShader.?(program, shader);
}

const PGLLINKPROGRAM = *const fn (program: GLuint) callconv(.C) void;
var p_glLinkProgram: ?PGLLINKPROGRAM = null;

pub fn linkProgram(program: GLuint) void {
    p_glLinkProgram.?(program);
}

const PGLGETSHADERIV = *const fn (shader: GLuint, pname: GLenum, param: *GLint) callconv(.C) void;
var p_glGetShaderiv: ?PGLGETSHADERIV = null;

pub fn getShaderiv(shader: GLuint, pname: GLenum, param: *GLint) void {
    p_glGetShaderiv.?(shader, pname, param);
}

const PGLCOMPILESHADER = *const fn (shader: GLuint) callconv(.C) void;
var p_glCompileShader: ?PGLCOMPILESHADER = null;

pub fn compileShader(shader: GLuint) void {
    p_glCompileShader.?(shader);
}

pub fn isExtensionSupported(name: []const u8) bool {
    const gl_ext_str = std.mem.span(getString(EXTENSIONS));
    var it = std.mem.tokenizeAny(GLchar, gl_ext_str, " ");

    while (it.next()) |ext| {
        if (std.mem.eql(u8, name, ext)) {
            return true;
        }
    }
    return false;
}

pub fn ARB_debug_output() bool {
    return isExtensionSupported("GL_ARB_debug_output") or isExtensionSupported("GL_KHR_debug");
}

fn loadGLFunction(name: [*]const u8, getproc: PGETPROCADDRESS) !FNPROCGENERIC {
    const ptr = getproc(name);
    if (ptr == null) {
        return error.CouldNotLoadGLFunc;
    }
    return ptr.?;
}

pub fn loadGL(getproc: PGETPROCADDRESS) !void {
    p_glClearColor = @ptrCast(try loadGLFunction("glClearColor", getproc));
    p_glClear = @ptrCast(try loadGLFunction("glClear", getproc));
    p_glBegin = @ptrCast(try loadGLFunction("glBegin", getproc));
    p_glEnd = @ptrCast(try loadGLFunction("glEnd", getproc));
    p_glEnable = @ptrCast(try loadGLFunction("glEnable", getproc));
    p_glDisable = @ptrCast(try loadGLFunction("glDisable", getproc));
    p_glGetString = @ptrCast(try loadGLFunction("glGetString", getproc));
    p_glVertex2f = @ptrCast(try loadGLFunction("glVertex2f", getproc));
    p_glVertex3f = @ptrCast(try loadGLFunction("glVertex3f", getproc));
    p_glColor3f = @ptrCast(try loadGLFunction("glColor3f", getproc));
    p_glGetError = @ptrCast(try loadGLFunction("glGetError", getproc));
    if (isExtensionSupported("GL_ARB_debug_output")) {
        p_glDebugMessageCallback = @ptrCast(try loadGLFunction("glDebugMessageCallback", getproc));
    }
}
