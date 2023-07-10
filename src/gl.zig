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

pub const GLboolean = enum(u8) {
    FALSE = 0,
    TRUE = 1,
};

pub const FALSE = GLboolean.FALSE;
pub const TRUE = GLboolean.TRUE;

pub const GLbitfield = enum(u32) {
    CURRENT_BIT = 0x00000001,
    POINT_BIT = 0x00000002,
    LINE_BIT = 0x00000004,
    POLYGON_BIT = 0x00000008,
    POLYGON_STIPPLE_BIT = 0x00000010,
    PIXEL_MODE_BIT = 0x00000020,
    LIGHTING_BIT = 0x00000040,
    FOG_BIT = 0x00000080,
    DEPTH_BUFFER_BIT = 0x00000100,
    ACCUM_BUFFER_BIT = 0x00000200,
    STENCIL_BUFFER_BIT = 0x00000400,
    VIEWPORT_BIT = 0x00000800,
    TRANSFORM_BIT = 0x00001000,
    ENABLE_BIT = 0x00002000,
    COLOR_BUFFER_BIT = 0x00004000,
    HINT_BIT = 0x00008000,
    EVAL_BIT = 0x00010000,
    LIST_BIT = 0x00020000,
    TEXTURE_BIT = 0x00040000,
    SCISSOR_BIT = 0x00080000,
    MULTISAMPLE_BIT = 0x20000000,
    ALL_ATTRIB_BITS = 0xFFFFFFFF,
};

pub const CURRENT_BIT = GLbitfield.CURRENT_BIT;
pub const POINT_BIT = GLbitfield.POINT_BIT;
pub const LINE_BIT = GLbitfield.LINE_BIT;
pub const POLYGON_BIT = GLbitfield.POLYGON_BIT;
pub const POLYGON_STIPPLE_BIT = GLbitfield.POLYGON_STIPPLE_BIT;
pub const PIXEL_MODE_BIT = GLbitfield.PIXEL_MODE_BIT;
pub const LIGHTING_BIT = GLbitfield.LIGHTING_BIT;
pub const FOG_BIT = GLbitfield.FOG_BIT;
pub const DEPTH_BUFFER_BIT = GLbitfield.DEPTH_BUFFER_BIT;
pub const ACCUM_BUFFER_BIT = GLbitfield.ACCUM_BUFFER_BIT;
pub const STENCIL_BUFFER_BIT = GLbitfield.STENCIL_BUFFER_BIT;
pub const VIEWPORT_BIT = GLbitfield.VIEWPORT_BIT;
pub const TRANSFORM_BIT = GLbitfield.TRANSFORM_BIT;
pub const ENABLE_BIT = GLbitfield.ENABLE_BIT;
pub const COLOR_BUFFER_BIT = GLbitfield.COLOR_BUFFER_BIT;
pub const HINT_BIT = GLbitfield.HINT_BIT;
pub const EVAL_BIT = GLbitfield.EVAL_BIT;
pub const LIST_BIT = GLbitfield.LIST_BIT;
pub const TEXTURE_BIT = GLbitfield.TEXTURE_BIT;
pub const SCISSOR_BIT = GLbitfield.SCISSOR_BIT;
pub const MULTISAMPLE_BIT = GLbitfield.MULTISAMPLE_BIT;
pub const MULTISAMPLE_BIT_ARB = GLbitfield.MULTISAMPLE_BIT;
pub const MULTISAMPLE_BIT_EXT = GLbitfield.MULTISAMPLE_BIT;
pub const MULTISAMPLE_BIT_3DFX = GLbitfield.MULTISAMPLE_BIT;
pub const ALL_ATTRIB_BITS = GLbitfield.ALL_ATTRIB_BITS;

pub const GLenum = c_int;

// There are too many values of GLenum for it to
// make sense to put in dedicated enum

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

pub const DEBUG_TYPE_ERROR: GLenum = 0x824C;
pub const DEBUG_TYPE_ERROR_ARB: GLenum = 0x824C;
pub const DEBUG_TYPE_ERROR_KHR: GLenum = 0x824C;
pub const DEBUG_TYPE_DEPRECATED_BEHAVIOR: GLenum = 0x824D;
pub const DEBUG_TYPE_DEPRECATED_BEHAVIOR_ARB: GLenum = 0x824D;
pub const DEBUG_TYPE_DEPRECATED_BEHAVIOR_KHR: GLenum = 0x824D;
pub const DEBUG_TYPE_UNDEFINED_BEHAVIOR: GLenum = 0x824E;
pub const DEBUG_TYPE_UNDEFINED_BEHAVIOR_ARB: GLenum = 0x824E;
pub const DEBUG_TYPE_UNDEFINED_BEHAVIOR_KHR: GLenum = 0x824E;
pub const DEBUG_TYPE_PORTABILITY: GLenum = 0x824F;
pub const DEBUG_TYPE_PORTABILITY_ARB: GLenum = 0x824F;
pub const DEBUG_TYPE_PORTABILITY_KHR: GLenum = 0x824F;
pub const DEBUG_TYPE_PERFORMANCE: GLenum = 0x8250;
pub const DEBUG_TYPE_PERFORMANCE_ARB: GLenum = 0x8250;
pub const DEBUG_TYPE_PERFORMANCE_KHR: GLenum = 0x8250;
pub const DEBUG_TYPE_OTHER: GLenum = 0x8251;
pub const DEBUG_TYPE_OTHER_ARB: GLenum = 0x8251;
pub const DEBUG_TYPE_OTHER_KHR: GLenum = 0x8251;

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
const PGLCLEAR = *const fn (bitfield: GLbitfield) callconv(.C) void;
const PGLBEGIN = *const fn (primitive: GLenum) callconv(.C) void;
const PGLEND = *const fn () callconv(.C) void;
const PGLGETSTRING = *const fn (name: GLenum) callconv(.C) [*c]const GLubyte;
const PGLVERTEX2F = *const fn (x: GLfloat, y: GLfloat) callconv(.C) void;
const PGLVERTEX3F = *const fn (x: GLfloat, y: GLfloat, z: GLfloat) callconv(.C) void;
const PGLCOLOR3F = *const fn (r: GLfloat, g: GLfloat, b: GLfloat) callconv(.C) void;
const PGLGETERROR = *const fn () callconv(.C) GLenumerror;
const PGLENABLE = *const fn (cap: GLenum) callconv(.C) void;
const PGLDISABLE = *const fn (cap: GLenum) callconv(.C) void;
const PGLDEBUGMESSAGECALLBACK = *const fn (callback: ?FNDEBUGPROC, userparam: ?*const anyopaque) callconv(.C) void;

var p_glClearColor: ?PGLCLEARCOLOR = null;
var p_glClear: ?PGLCLEAR = null;
var p_glBegin: ?PGLBEGIN = null;
var p_glEnd: ?PGLEND = null;
var p_glGetString: ?PGLGETSTRING = null;
var p_glVertex2f: ?PGLVERTEX2F = null;
var p_glVertex3f: ?PGLVERTEX3F = null;
var p_glColor3f: ?PGLCOLOR3F = null;
var p_glGetError: ?PGLGETERROR = null;
var p_glEnable: ?PGLENABLE = null;
var p_glDisable: ?PGLDISABLE = null;
var p_glDebugMessageCallback: ?PGLDEBUGMESSAGECALLBACK = null;

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

pub fn clearColor(red: GLclampf, green: GLclampf, blue: GLclampf, alpha: GLclampf) void {
    p_glClearColor.?(red, green, blue, alpha);
}

pub fn clear(bitmask: GLbitfield) void {
    p_glClear.?(bitmask);
}

pub fn begin(primitive: GLenum) void {
    p_glBegin.?(primitive);
}

pub fn end() void {
    p_glEnd.?();
}

pub fn getString(name: GLenum) [*c]const GLubyte {
    return p_glGetString.?(name);
}

pub fn vertex2f(x: GLfloat, y: GLfloat) void {
    p_glVertex2f.?(x, y);
}

pub fn vertex3f(x: GLfloat, y: GLfloat, z: GLfloat) void {
    p_glVertex3f.?(x, y, z);
}

pub fn color3f(r: GLfloat, g: GLfloat, b: GLfloat) void {
    p_glColor3f.?(r, g, b);
}

pub fn getError() GLenumerror {
    return p_glGetError.?();
}

pub fn enable(cap: GLenum) void {
    p_glEnable.?(cap);
}

pub fn disable(cap: GLenum) void {
    p_glDisable.?(cap);
}

pub fn debugMessageCallback(callback: ?FNDEBUGPROC, userparam: ?*anyopaque) void {
    p_glDebugMessageCallback.?(callback, userparam);
}
