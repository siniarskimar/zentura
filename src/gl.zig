const std = @import("std");
const builtin = std.builtin;

pub const FunctionPointer: type = *align(@alignOf(fn (u32) callconv(.C) u32)) const anyopaque;

pub const GLenum = c_uint;
pub const GLboolean = u8;
pub const GLbitfield = c_uint;
pub const GLbyte = i8;
pub const GLubyte = u8;
pub const GLshort = i16;
pub const GLushort = u16;
pub const GLint = c_int;
pub const GLuint = c_uint;
pub const GLclampx = i32;
pub const GLsizei = c_int;
pub const GLfloat = f32;
pub const GLclampf = f32;
pub const GLdouble = f64;
pub const GLclampd = f64;
pub const GLeglClientBufferEXT = void;
pub const GLeglImageOES = void;
pub const GLchar = u8;
pub const GLcharARB = u8;

pub const GLhandleARB = if (builtin.os.tag == .macos) *anyopaque else c_uint;

pub const GLhalf = u16;
pub const GLhalfARB = u16;
pub const GLfixed = i32;
pub const GLintptr = usize;
pub const GLintptrARB = usize;
pub const GLsizeiptr = isize;
pub const GLsizeiptrARB = isize;
pub const GLint64 = i64;
pub const GLint64EXT = i64;
pub const GLuint64 = u64;
pub const GLuint64EXT = u64;

pub const GLsync = *opaque {};

pub const _cl_context = opaque {};
pub const _cl_event = opaque {};

pub const GLDEBUGPROC = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCARB = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;
pub const GLDEBUGPROCKHR = *const fn (source: GLenum, _type: GLenum, id: GLuint, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLDEBUGPROCAMD = *const fn (id: GLuint, category: GLenum, severity: GLenum, length: GLsizei, message: [*:0]const u8, userParam: ?*anyopaque) callconv(.C) void;

pub const GLhalfNV = u16;
pub const GLvdpauSurfaceNV = GLintptr;
pub const GLVULKANPROCNV = *const fn () callconv(.C) void;

pub const GETPROCADDRESSPROC = *const fn(procname: [*:0]const u8) callconv(.C) ?*const fn() callconv(.C) void;pub const UseProgramStageMask = packed struct(GLenum) {GL_VERTEX_SHADER_BIT: bool = false, // 0x1
GL_FRAGMENT_SHADER_BIT: bool = false, // 0x2
GL_GEOMETRY_SHADER_BIT: bool = false, // 0x4
GL_TESS_CONTROL_SHADER_BIT: bool = false, // 0x8
GL_TESS_EVALUATION_SHADER_BIT: bool = false, // 0x10
GL_COMPUTE_SHADER_BIT: bool = false, // 0x20
_: u26 = 0,
pub const GL_ALL_SHADER_BITS = @as(@This(), @bitCast(0xFFFFFFFF));
};
pub const MapBufferAccessMask = packed struct(GLenum) {GL_MAP_READ_BIT: bool = false, // 0x1
GL_MAP_WRITE_BIT: bool = false, // 0x2
GL_MAP_INVALIDATE_RANGE_BIT: bool = false, // 0x4
GL_MAP_INVALIDATE_BUFFER_BIT: bool = false, // 0x8
GL_MAP_FLUSH_EXPLICIT_BIT: bool = false, // 0x10
GL_MAP_UNSYNCHRONIZED_BIT: bool = false, // 0x20
GL_MAP_PERSISTENT_BIT: bool = false, // 0x40
GL_MAP_COHERENT_BIT: bool = false, // 0x80
_: u24 = 0,
};
pub const FragmentShaderDestModMaskATI = packed struct(GLenum) {_: u32 = 0,
pub const GL_NONE = @as(@This(), @bitCast(0x0));
};
pub const ContextFlagMask = packed struct(GLenum) {GL_CONTEXT_FLAG_FORWARD_COMPATIBLE_BIT: bool = false, // 0x1
GL_CONTEXT_FLAG_DEBUG_BIT: bool = false, // 0x2
GL_CONTEXT_FLAG_ROBUST_ACCESS_BIT: bool = false, // 0x4
GL_CONTEXT_FLAG_NO_ERROR_BIT: bool = false, // 0x8
_: u28 = 0,
};
pub const ContextProfileMask = packed struct(GLenum) {GL_CONTEXT_CORE_PROFILE_BIT: bool = false, // 0x1
GL_CONTEXT_COMPATIBILITY_PROFILE_BIT: bool = false, // 0x2
_: u30 = 0,
};
pub const SyncObjectMask = packed struct(GLenum) {GL_SYNC_FLUSH_COMMANDS_BIT: bool = false, // 0x1
_: u31 = 0,
};
pub const ClearBufferMask = packed struct(GLenum) {_: u8 = 0,
GL_DEPTH_BUFFER_BIT: bool = false, // 0x100
GL_ACCUM_BUFFER_BIT: bool = false, // 0x200
GL_STENCIL_BUFFER_BIT: bool = false, // 0x400
__: u3 = 0,
GL_COLOR_BUFFER_BIT: bool = false, // 0x4000
___: u17 = 0,
};
pub const MemoryBarrierMask = packed struct(GLenum) {GL_VERTEX_ATTRIB_ARRAY_BARRIER_BIT: bool = false, // 0x1
GL_ELEMENT_ARRAY_BARRIER_BIT: bool = false, // 0x2
GL_UNIFORM_BARRIER_BIT: bool = false, // 0x4
GL_TEXTURE_FETCH_BARRIER_BIT: bool = false, // 0x8
_: u1 = 0,
GL_SHADER_IMAGE_ACCESS_BARRIER_BIT: bool = false, // 0x20
GL_COMMAND_BARRIER_BIT: bool = false, // 0x40
GL_PIXEL_BUFFER_BARRIER_BIT: bool = false, // 0x80
GL_TEXTURE_UPDATE_BARRIER_BIT: bool = false, // 0x100
GL_BUFFER_UPDATE_BARRIER_BIT: bool = false, // 0x200
GL_FRAMEBUFFER_BARRIER_BIT: bool = false, // 0x400
GL_TRANSFORM_FEEDBACK_BARRIER_BIT: bool = false, // 0x800
GL_ATOMIC_COUNTER_BARRIER_BIT: bool = false, // 0x1000
GL_SHADER_STORAGE_BARRIER_BIT: bool = false, // 0x2000
GL_CLIENT_MAPPED_BUFFER_BARRIER_BIT: bool = false, // 0x4000
GL_QUERY_BUFFER_BARRIER_BIT: bool = false, // 0x8000
__: u16 = 0,
pub const GL_ALL_BARRIER_BITS = @as(@This(), @bitCast(0xFFFFFFFF));
};
pub const ClientAttribMask = packed struct(GLenum) {GL_CLIENT_PIXEL_STORE_BIT: bool = false, // 0x1
GL_CLIENT_VERTEX_ARRAY_BIT: bool = false, // 0x2
_: u30 = 0,
pub const GL_CLIENT_ALL_ATTRIB_BITS = @as(@This(), @bitCast(0xFFFFFFFF));
};
pub const BufferStorageMask = packed struct(GLenum) {_: u8 = 0,
GL_DYNAMIC_STORAGE_BIT: bool = false, // 0x100
GL_CLIENT_STORAGE_BIT: bool = false, // 0x200
__: u22 = 0,
};
pub const AttribMask = packed struct(GLenum) {GL_CURRENT_BIT: bool = false, // 0x1
GL_POINT_BIT: bool = false, // 0x2
GL_LINE_BIT: bool = false, // 0x4
GL_POLYGON_BIT: bool = false, // 0x8
GL_POLYGON_STIPPLE_BIT: bool = false, // 0x10
GL_PIXEL_MODE_BIT: bool = false, // 0x20
GL_LIGHTING_BIT: bool = false, // 0x40
GL_FOG_BIT: bool = false, // 0x80
_: u3 = 0,
GL_VIEWPORT_BIT: bool = false, // 0x800
GL_TRANSFORM_BIT: bool = false, // 0x1000
GL_ENABLE_BIT: bool = false, // 0x2000
__: u1 = 0,
GL_HINT_BIT: bool = false, // 0x8000
GL_EVAL_BIT: bool = false, // 0x10000
GL_LIST_BIT: bool = false, // 0x20000
GL_TEXTURE_BIT: bool = false, // 0x40000
GL_SCISSOR_BIT: bool = false, // 0x80000
___: u9 = 0,
GL_MULTISAMPLE_BIT: bool = false, // 0x20000000
____: u2 = 0,
pub const GL_ALL_ATTRIB_BITS = @as(@This(), @bitCast(0xFFFFFFFF));
};
pub const TexCoordPointerType = GLenum;
pub const PixelType = GLenum;
pub const BufferPointerNameARB = GLenum;
pub const VertexAttribPointerPropertyARB = GLenum;
pub const BufferStorageTarget = GLenum;
pub const ClipControlOrigin = GLenum;
pub const FramebufferAttachmentParameterName = GLenum;
pub const ConvolutionTargetEXT = GLenum;
pub const HistogramTarget = GLenum;
pub const FogPName = GLenum;
pub const FragmentShaderGenericSourceATI = GLenum;
pub const TransformFeedbackPName = GLenum;
pub const AlphaFunction = GLenum;
pub const TextureTarget = GLenum;
pub const SamplerParameterF = GLenum;
pub const SecondaryColorPointerTypeIBM = GLenum;
pub const FramebufferTarget = GLenum;
pub const ListNameType = GLenum;
pub const SyncParameterName = GLenum;
pub const NormalPointerType = GLenum;
pub const TextureUnit = GLenum;
pub const VertexAttribIType = GLenum;
pub const PatchParameterName = GLenum;
pub const CombinerComponentUsageNV = GLenum;
pub const TangentPointerTypeEXT = GLenum;
pub const QueryParameterName = GLenum;
pub const ColorBuffer = GLenum;
pub const ReplacementCodeTypeSUN = GLenum;
pub const ObjectIdentifier = GLenum;
pub const MatrixMode = GLenum;
pub const ScalarType = GLenum;
pub const PixelTransferParameter = GLenum;
pub const FogCoordSrc = GLenum;
pub const RenderbufferTarget = GLenum;
pub const SeparableTarget = GLenum;
pub const ProgramStagePName = GLenum;
pub const ErrorCode = GLenum;
pub const HistogramTargetEXT = GLenum;
pub const MinmaxTargetEXT = GLenum;
pub const FogPointerTypeIBM = GLenum;
pub const StencilFunction = GLenum;
pub const BufferTargetARB = GLenum;
pub const ListMode = GLenum;
pub const Buffer = GLenum;
pub const SeparableTargetEXT = GLenum;
pub const LogicOp = GLenum;
pub const ShaderBinaryFormat = GLenum;
pub const ClampColorModeARB = GLenum;
pub const TextureEnvMode = GLenum;
pub const VertexWeightPointerTypeEXT = GLenum;
pub const GetMapQuery = GLenum;
pub const DrawBufferMode = GLenum;
pub const GetFramebufferParameter = GLenum;
pub const HintTarget = GLenum;
pub const DebugSeverity = GLenum;
pub const HintMode = GLenum;
pub const ElementPointerTypeATI = GLenum;
pub const VertexShaderTextureUnitParameter = GLenum;
pub const LightModelColorControl = GLenum;
pub const VertexBufferObjectUsage = GLenum;
pub const UniformType = GLenum;
pub const RenderbufferParameterName = GLenum;
pub const SubroutineParameterName = GLenum;
pub const InvalidateFramebufferAttachment = GLenum;
pub const ColorPointerType = GLenum;
pub const DepthStencilTextureMode = GLenum;
pub const DebugSource = GLenum;
pub const QueryCounterTarget = GLenum;
pub const FragmentShaderTextureSourceATI = GLenum;
pub const BufferAccessARB = GLenum;
pub const FramebufferAttachment = GLenum;
pub const FramebufferParameterName = GLenum;
pub const PixelMap = GLenum;
pub const UniformBlockPName = GLenum;
pub const ProgramResourceProperty = GLenum;
pub const LightTextureModeEXT = GLenum;
pub const VertexAttribType = GLenum;
pub const FogPointerTypeEXT = GLenum;
pub const GraphicsResetStatus = GLenum;
pub const FeedbackType = GLenum;
pub const SyncStatus = GLenum;
pub const TextureCoordName = GLenum;
pub const ColorTableTarget = GLenum;
pub const BufferPNameARB = GLenum;
pub const PrecisionType = GLenum;
pub const GetPointervPName = GLenum;
pub const PathColorFormat = GLenum;
pub const TextureCompareMode = GLenum;
pub const InternalFormat = GLenum;
pub const VertexAttribEnum = GLenum;
pub const VertexProvokingMode = GLenum;
pub const GetMultisamplePNameNV = GLenum;
pub const VertexArrayPName = GLenum;
pub const MatrixIndexPointerTypeARB = GLenum;
pub const SamplerParameterI = GLenum;
pub const IndexMaterialParameterEXT = GLenum;
pub const VertexAttribLType = GLenum;
pub const LightParameter = GLenum;
pub const GetTextureParameter = GLenum;
pub const SyncCondition = GLenum;
pub const WeightPointerTypeARB = GLenum;
pub const PathFillMode = GLenum;
pub const BindTransformFeedbackTarget = GLenum;
pub const VertexShaderWriteMaskEXT = GLenum;
pub const ConvolutionTarget = GLenum;
pub const MeshMode1 = GLenum;
pub const TextureWrapMode = GLenum;
pub const TriangleFace = GLenum;
pub const PrimitiveType = GLenum;
pub const FeedBackToken = GLenum;
pub const BlitFramebufferFilter = GLenum;
pub const TextureParameterName = GLenum;
pub const MapTypeNV = GLenum;
pub const StringName = GLenum;
pub const ClampColorTargetARB = GLenum;
pub const FogCoordinatePointerType = GLenum;
pub const FramebufferStatus = GLenum;
pub const ShaderType = GLenum;
pub const FragmentShaderValueRepATI = GLenum;
pub const ShaderParameterName = GLenum;
pub const IndexPointerType = GLenum;
pub const PixelCopyType = GLenum;
pub const PixelTexGenModeSGIX = GLenum;
pub const LightName = GLenum;
pub const FragmentLightParameterSGIX = GLenum;
pub const BufferUsageARB = GLenum;
pub const MeshMode2 = GLenum;
pub const UniformPName = GLenum;
pub const AccumOp = GLenum;
pub const ClipPlaneName = GLenum;
pub const ProgramParameterPName = GLenum;
pub const MapTarget = GLenum;
pub const TextureEnvTarget = GLenum;
pub const TextureGenParameter = GLenum;
pub const ConditionalRenderMode = GLenum;
pub const PipelineParameterName = GLenum;
pub const TextureSwizzle = GLenum;
pub const BlendingFactor = GLenum;
pub const AttributeType = GLenum;
pub const DebugType = GLenum;
pub const CombinerPortionNV = GLenum;
pub const MaterialParameter = GLenum;
pub const InterleavedArrayFormat = GLenum;
pub const BlendEquationModeEXT = GLenum;
pub const QueryTarget = GLenum;
pub const IndexFunctionEXT = GLenum;
pub const PolygonMode = GLenum;
pub const TextureEnvParameter = GLenum;
pub const TextureMinFilter = GLenum;
pub const PathColor = GLenum;
pub const DrawElementsType = GLenum;
pub const ColorMaterialParameter = GLenum;
pub const Boolean = GLenum;
pub const TextureGenMode = GLenum;
pub const AtomicCounterBufferPName = GLenum;
pub const GetPName = GLenum;
pub const CopyImageSubDataTarget = GLenum;
pub const TransformFeedbackBufferMode = GLenum;
pub const ColorTableTargetSGI = GLenum;
pub const SpecialNumbers = GLenum;
pub const RenderingMode = GLenum;
pub const ShadingModel = GLenum;
pub const PointParameterNameARB = GLenum;
pub const LightEnvModeSGIX = GLenum;
pub const QueryObjectParameterName = GLenum;
pub const PixelStoreParameter = GLenum;
pub const SizedInternalFormat = GLenum;
pub const InternalFormatPName = GLenum;
pub const VertexAttribPropertyARB = GLenum;
pub const ProgramInterface = GLenum;
pub const ClipControlDepth = GLenum;
pub const VertexAttribPointerType = GLenum;
pub const ReadBufferMode = GLenum;
pub const EnableCap = GLenum;
pub const PathGenMode = GLenum;
pub const PixelFormat = GLenum;
pub const VertexPointerType = GLenum;
pub const FogMode = GLenum;
pub const DepthFunction = GLenum;
pub const FrontFaceDirection = GLenum;
pub const MinmaxTarget = GLenum;
pub const CopyBufferSubDataTarget = GLenum;
pub const StencilOp = GLenum;
pub const TextureMagFilter = GLenum;
pub const ProgramInterfacePName = GLenum;
pub const ProgramPropertyARB = GLenum;
pub const MapQuery = GLenum;
pub const LightModelParameter = GLenum;
pub const FogParameter = GLenum;
pub const BinormalPointerTypeEXT = GLenum;
pub const GL_FALSE: GLenum = 0x0;// groups: SpecialNumbers Boolean VertexShaderWriteMaskEXT ClampColorModeARB
pub const GL_TRUE: GLenum = 0x1;// groups: SpecialNumbers Boolean VertexShaderWriteMaskEXT ClampColorModeARB
pub const GL_POINTS: PrimitiveType = 0x0;
pub const GL_LINES: PrimitiveType = 0x1;
pub const GL_LINE_LOOP: PrimitiveType = 0x2;
pub const GL_LINE_STRIP: PrimitiveType = 0x3;
pub const GL_TRIANGLES: PrimitiveType = 0x4;
pub const GL_TRIANGLE_STRIP: PrimitiveType = 0x5;
pub const GL_TRIANGLE_FAN: PrimitiveType = 0x6;
pub const GL_QUADS: PrimitiveType = 0x7;
pub const GL_NEVER: GLenum = 0x200;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_LESS: GLenum = 0x201;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_EQUAL: GLenum = 0x202;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_LEQUAL: GLenum = 0x203;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_GREATER: GLenum = 0x204;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_NOTEQUAL: GLenum = 0x205;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_GEQUAL: GLenum = 0x206;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_ALWAYS: GLenum = 0x207;// groups: StencilFunction IndexFunctionEXT AlphaFunction DepthFunction
pub const GL_ZERO: GLenum = 0x0;// groups: SpecialNumbers TextureSwizzle StencilOp BlendingFactor FragmentShaderGenericSourceATI
pub const GL_ONE: GLenum = 0x1;// groups: SpecialNumbers TextureSwizzle BlendingFactor FragmentShaderGenericSourceATI
pub const GL_SRC_COLOR: BlendingFactor = 0x300;
pub const GL_ONE_MINUS_SRC_COLOR: BlendingFactor = 0x301;
pub const GL_SRC_ALPHA: BlendingFactor = 0x302;
pub const GL_ONE_MINUS_SRC_ALPHA: BlendingFactor = 0x303;
pub const GL_DST_ALPHA: BlendingFactor = 0x304;
pub const GL_ONE_MINUS_DST_ALPHA: BlendingFactor = 0x305;
pub const GL_DST_COLOR: BlendingFactor = 0x306;
pub const GL_ONE_MINUS_DST_COLOR: BlendingFactor = 0x307;
pub const GL_SRC_ALPHA_SATURATE: BlendingFactor = 0x308;
pub const GL_FRONT_LEFT: GLenum = 0x400;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_FRONT_RIGHT: GLenum = 0x401;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_BACK_LEFT: GLenum = 0x402;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_BACK_RIGHT: GLenum = 0x403;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_FRONT: GLenum = 0x404;// groups: ColorBuffer DrawBufferMode ReadBufferMode TriangleFace
pub const GL_BACK: GLenum = 0x405;// groups: ColorBuffer DrawBufferMode ReadBufferMode TriangleFace
pub const GL_LEFT: GLenum = 0x406;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_RIGHT: GLenum = 0x407;// groups: ColorBuffer DrawBufferMode ReadBufferMode
pub const GL_FRONT_AND_BACK: GLenum = 0x408;// groups: ColorBuffer DrawBufferMode TriangleFace
pub const GL_NO_ERROR: GLenum = 0x0;// groups: SpecialNumbers GraphicsResetStatus ErrorCode
pub const GL_INVALID_ENUM: ErrorCode = 0x500;
pub const GL_INVALID_VALUE: ErrorCode = 0x501;
pub const GL_INVALID_OPERATION: ErrorCode = 0x502;
pub const GL_OUT_OF_MEMORY: ErrorCode = 0x505;
pub const GL_CW: FrontFaceDirection = 0x900;
pub const GL_CCW: FrontFaceDirection = 0x901;
pub const GL_POINT_SIZE: GetPName = 0xB11;
pub const GL_POINT_SIZE_RANGE: GetPName = 0xB12;
pub const GL_POINT_SIZE_GRANULARITY: GetPName = 0xB13;
pub const GL_LINE_SMOOTH: GLenum = 0xB20;// groups: GetPName EnableCap
pub const GL_LINE_WIDTH: GetPName = 0xB21;
pub const GL_LINE_WIDTH_RANGE: GetPName = 0xB22;
pub const GL_LINE_WIDTH_GRANULARITY: GetPName = 0xB23;
pub const GL_POLYGON_MODE: GetPName = 0xB40;
pub const GL_POLYGON_SMOOTH: GLenum = 0xB41;// groups: GetPName EnableCap
pub const GL_CULL_FACE: GLenum = 0xB44;// groups: GetPName EnableCap
pub const GL_CULL_FACE_MODE: GetPName = 0xB45;
pub const GL_FRONT_FACE: GetPName = 0xB46;
pub const GL_DEPTH_RANGE: GetPName = 0xB70;
pub const GL_DEPTH_TEST: GLenum = 0xB71;// groups: GetPName EnableCap
pub const GL_DEPTH_WRITEMASK: GetPName = 0xB72;
pub const GL_DEPTH_CLEAR_VALUE: GetPName = 0xB73;
pub const GL_DEPTH_FUNC: GetPName = 0xB74;
pub const GL_STENCIL_TEST: GLenum = 0xB90;// groups: GetPName EnableCap
pub const GL_STENCIL_CLEAR_VALUE: GetPName = 0xB91;
pub const GL_STENCIL_FUNC: GetPName = 0xB92;
pub const GL_STENCIL_VALUE_MASK: GetPName = 0xB93;
pub const GL_STENCIL_FAIL: GetPName = 0xB94;
pub const GL_STENCIL_PASS_DEPTH_FAIL: GetPName = 0xB95;
pub const GL_STENCIL_PASS_DEPTH_PASS: GetPName = 0xB96;
pub const GL_STENCIL_REF: GetPName = 0xB97;
pub const GL_STENCIL_WRITEMASK: GetPName = 0xB98;
pub const GL_VIEWPORT: GetPName = 0xBA2;
pub const GL_DITHER: GLenum = 0xBD0;// groups: GetPName EnableCap
pub const GL_BLEND_DST: GetPName = 0xBE0;
pub const GL_BLEND_SRC: GetPName = 0xBE1;
pub const GL_BLEND: GLenum = 0xBE2;// groups: TextureEnvMode EnableCap GetPName
pub const GL_LOGIC_OP_MODE: GetPName = 0xBF0;
pub const GL_DRAW_BUFFER: GetPName = 0xC01;
pub const GL_READ_BUFFER: GetPName = 0xC02;
pub const GL_SCISSOR_BOX: GetPName = 0xC10;
pub const GL_SCISSOR_TEST: GLenum = 0xC11;// groups: GetPName EnableCap
pub const GL_COLOR_CLEAR_VALUE: GetPName = 0xC22;
pub const GL_COLOR_WRITEMASK: GetPName = 0xC23;
pub const GL_DOUBLEBUFFER: GLenum = 0xC32;// groups: GetFramebufferParameter GetPName
pub const GL_STEREO: GLenum = 0xC33;// groups: GetFramebufferParameter GetPName
pub const GL_LINE_SMOOTH_HINT: GLenum = 0xC52;// groups: HintTarget GetPName
pub const GL_POLYGON_SMOOTH_HINT: GLenum = 0xC53;// groups: HintTarget GetPName
pub const GL_UNPACK_SWAP_BYTES: GLenum = 0xCF0;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_LSB_FIRST: GLenum = 0xCF1;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_ROW_LENGTH: GLenum = 0xCF2;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_SKIP_ROWS: GLenum = 0xCF3;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_SKIP_PIXELS: GLenum = 0xCF4;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_ALIGNMENT: GLenum = 0xCF5;// groups: PixelStoreParameter GetPName
pub const GL_PACK_SWAP_BYTES: GLenum = 0xD00;// groups: PixelStoreParameter GetPName
pub const GL_PACK_LSB_FIRST: GLenum = 0xD01;// groups: PixelStoreParameter GetPName
pub const GL_PACK_ROW_LENGTH: GLenum = 0xD02;// groups: PixelStoreParameter GetPName
pub const GL_PACK_SKIP_ROWS: GLenum = 0xD03;// groups: PixelStoreParameter GetPName
pub const GL_PACK_SKIP_PIXELS: GLenum = 0xD04;// groups: PixelStoreParameter GetPName
pub const GL_PACK_ALIGNMENT: GLenum = 0xD05;// groups: PixelStoreParameter GetPName
pub const GL_MAX_TEXTURE_SIZE: GetPName = 0xD33;
pub const GL_MAX_VIEWPORT_DIMS: GetPName = 0xD3A;
pub const GL_SUBPIXEL_BITS: GetPName = 0xD50;
pub const GL_TEXTURE_1D: GLenum = 0xDE0;// groups: CopyImageSubDataTarget EnableCap GetPName TextureTarget
pub const GL_TEXTURE_2D: GLenum = 0xDE1;// groups: CopyImageSubDataTarget EnableCap GetPName TextureTarget
pub const GL_TEXTURE_WIDTH: GLenum = 0x1000;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_HEIGHT: GLenum = 0x1001;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_BORDER_COLOR: GLenum = 0x1004;// groups: SamplerParameterF GetTextureParameter TextureParameterName
pub const GL_DONT_CARE: GLenum = 0x1100;// groups: DebugSeverity HintMode DebugSource DebugType
pub const GL_FASTEST: HintMode = 0x1101;
pub const GL_NICEST: HintMode = 0x1102;
pub const GL_BYTE: GLenum = 0x1400;// groups: VertexAttribIType WeightPointerTypeARB TangentPointerTypeEXT BinormalPointerTypeEXT ColorPointerType ListNameType NormalPointerType PixelType VertexAttribType VertexAttribPointerType
pub const GL_UNSIGNED_BYTE: GLenum = 0x1401;// groups: VertexAttribIType ScalarType ReplacementCodeTypeSUN ElementPointerTypeATI MatrixIndexPointerTypeARB WeightPointerTypeARB ColorPointerType DrawElementsType ListNameType PixelType VertexAttribType VertexAttribPointerType
pub const GL_SHORT: GLenum = 0x1402;// groups: VertexAttribIType SecondaryColorPointerTypeIBM WeightPointerTypeARB TangentPointerTypeEXT BinormalPointerTypeEXT ColorPointerType IndexPointerType ListNameType NormalPointerType PixelType TexCoordPointerType VertexPointerType VertexAttribType VertexAttribPointerType
pub const GL_UNSIGNED_SHORT: GLenum = 0x1403;// groups: VertexAttribIType ScalarType ReplacementCodeTypeSUN ElementPointerTypeATI MatrixIndexPointerTypeARB WeightPointerTypeARB ColorPointerType DrawElementsType ListNameType PixelFormat PixelType VertexAttribType VertexAttribPointerType
pub const GL_INT: GLenum = 0x1404;// groups: VertexAttribIType SecondaryColorPointerTypeIBM WeightPointerTypeARB TangentPointerTypeEXT BinormalPointerTypeEXT ColorPointerType IndexPointerType ListNameType NormalPointerType PixelType TexCoordPointerType VertexPointerType VertexAttribType AttributeType UniformType VertexAttribPointerType
pub const GL_UNSIGNED_INT: GLenum = 0x1405;// groups: VertexAttribIType ScalarType ReplacementCodeTypeSUN ElementPointerTypeATI MatrixIndexPointerTypeARB WeightPointerTypeARB ColorPointerType DrawElementsType ListNameType PixelFormat PixelType VertexAttribType AttributeType UniformType VertexAttribPointerType
pub const GL_FLOAT: GLenum = 0x1406;// groups: MapTypeNV SecondaryColorPointerTypeIBM WeightPointerTypeARB VertexWeightPointerTypeEXT TangentPointerTypeEXT BinormalPointerTypeEXT ColorPointerType FogCoordinatePointerType FogPointerTypeEXT FogPointerTypeIBM IndexPointerType ListNameType NormalPointerType PixelType TexCoordPointerType VertexPointerType VertexAttribType AttributeType UniformType VertexAttribPointerType
pub const GL_STACK_OVERFLOW: ErrorCode = 0x503;
pub const GL_STACK_UNDERFLOW: ErrorCode = 0x504;
pub const GL_CLEAR: LogicOp = 0x1500;
pub const GL_AND: LogicOp = 0x1501;
pub const GL_AND_REVERSE: LogicOp = 0x1502;
pub const GL_COPY: LogicOp = 0x1503;
pub const GL_AND_INVERTED: LogicOp = 0x1504;
pub const GL_NOOP: LogicOp = 0x1505;
pub const GL_XOR: LogicOp = 0x1506;
pub const GL_OR: LogicOp = 0x1507;
pub const GL_NOR: LogicOp = 0x1508;
pub const GL_EQUIV: LogicOp = 0x1509;
pub const GL_INVERT: GLenum = 0x150A;// groups: PathFillMode LogicOp StencilOp
pub const GL_OR_REVERSE: LogicOp = 0x150B;
pub const GL_COPY_INVERTED: LogicOp = 0x150C;
pub const GL_OR_INVERTED: LogicOp = 0x150D;
pub const GL_NAND: LogicOp = 0x150E;
pub const GL_SET: LogicOp = 0x150F;
pub const GL_TEXTURE: GLenum = 0x1702;// groups: ObjectIdentifier MatrixMode
pub const GL_COLOR: GLenum = 0x1800;// groups: Buffer PixelCopyType InvalidateFramebufferAttachment
pub const GL_DEPTH: GLenum = 0x1801;// groups: Buffer PixelCopyType InvalidateFramebufferAttachment
pub const GL_STENCIL: GLenum = 0x1802;// groups: Buffer PixelCopyType InvalidateFramebufferAttachment
pub const GL_STENCIL_INDEX: GLenum = 0x1901;// groups: InternalFormat PixelFormat DepthStencilTextureMode
pub const GL_DEPTH_COMPONENT: GLenum = 0x1902;// groups: InternalFormat PixelFormat DepthStencilTextureMode
pub const GL_RED: GLenum = 0x1903;// groups: FragmentShaderValueRepATI TextureSwizzle PixelFormat InternalFormat
pub const GL_GREEN: GLenum = 0x1904;// groups: FragmentShaderValueRepATI TextureSwizzle PixelFormat
pub const GL_BLUE: GLenum = 0x1905;// groups: FragmentShaderValueRepATI TextureSwizzle CombinerComponentUsageNV PixelFormat
pub const GL_ALPHA: GLenum = 0x1906;// groups: PixelTexGenModeSGIX FragmentShaderValueRepATI TextureSwizzle CombinerPortionNV PathColorFormat CombinerComponentUsageNV PixelFormat
pub const GL_RGB: GLenum = 0x1907;// groups: PixelTexGenModeSGIX CombinerPortionNV PathColorFormat CombinerComponentUsageNV PixelFormat InternalFormat
pub const GL_RGBA: GLenum = 0x1908;// groups: PixelTexGenModeSGIX PathColorFormat PixelFormat InternalFormat
pub const GL_POINT: GLenum = 0x1B00;// groups: PolygonMode MeshMode1 MeshMode2
pub const GL_LINE: GLenum = 0x1B01;// groups: PolygonMode MeshMode1 MeshMode2
pub const GL_FILL: GLenum = 0x1B02;// groups: PolygonMode MeshMode2
pub const GL_KEEP: StencilOp = 0x1E00;
pub const GL_REPLACE: GLenum = 0x1E01;// groups: StencilOp LightEnvModeSGIX TextureEnvMode
pub const GL_INCR: StencilOp = 0x1E02;
pub const GL_DECR: StencilOp = 0x1E03;
pub const GL_VENDOR: StringName = 0x1F00;
pub const GL_RENDERER: StringName = 0x1F01;
pub const GL_VERSION: StringName = 0x1F02;
pub const GL_EXTENSIONS: StringName = 0x1F03;
pub const GL_NEAREST: GLenum = 0x2600;// groups: BlitFramebufferFilter TextureMagFilter TextureMinFilter
pub const GL_LINEAR: GLenum = 0x2601;// groups: BlitFramebufferFilter FogMode TextureMagFilter TextureMinFilter
pub const GL_NEAREST_MIPMAP_NEAREST: TextureMinFilter = 0x2700;
pub const GL_LINEAR_MIPMAP_NEAREST: TextureMinFilter = 0x2701;
pub const GL_NEAREST_MIPMAP_LINEAR: TextureMinFilter = 0x2702;
pub const GL_LINEAR_MIPMAP_LINEAR: GLenum = 0x2703;// groups: TextureWrapMode TextureMinFilter
pub const GL_TEXTURE_MAG_FILTER: GLenum = 0x2800;// groups: SamplerParameterI GetTextureParameter TextureParameterName
pub const GL_TEXTURE_MIN_FILTER: GLenum = 0x2801;// groups: SamplerParameterI GetTextureParameter TextureParameterName
pub const GL_TEXTURE_WRAP_S: GLenum = 0x2802;// groups: SamplerParameterI GetTextureParameter TextureParameterName
pub const GL_TEXTURE_WRAP_T: GLenum = 0x2803;// groups: SamplerParameterI GetTextureParameter TextureParameterName
pub const GL_REPEAT: TextureWrapMode = 0x2901;
pub const GL_QUAD_STRIP: PrimitiveType = 0x8;
pub const GL_POLYGON: PrimitiveType = 0x9;
pub const GL_ACCUM: AccumOp = 0x100;
pub const GL_LOAD: AccumOp = 0x101;
pub const GL_RETURN: AccumOp = 0x102;
pub const GL_MULT: AccumOp = 0x103;
pub const GL_ADD: GLenum = 0x104;// groups: TextureEnvMode AccumOp LightEnvModeSGIX
pub const GL_AUX0: GLenum = 0x409;// groups: ReadBufferMode DrawBufferMode
pub const GL_AUX1: GLenum = 0x40A;// groups: ReadBufferMode DrawBufferMode
pub const GL_AUX2: GLenum = 0x40B;// groups: ReadBufferMode DrawBufferMode
pub const GL_AUX3: GLenum = 0x40C;// groups: ReadBufferMode DrawBufferMode
pub const GL_2D: FeedbackType = 0x600;
pub const GL_3D: FeedbackType = 0x601;
pub const GL_3D_COLOR: FeedbackType = 0x602;
pub const GL_3D_COLOR_TEXTURE: FeedbackType = 0x603;
pub const GL_4D_COLOR_TEXTURE: FeedbackType = 0x604;
pub const GL_PASS_THROUGH_TOKEN: FeedBackToken = 0x700;
pub const GL_POINT_TOKEN: FeedBackToken = 0x701;
pub const GL_LINE_TOKEN: FeedBackToken = 0x702;
pub const GL_POLYGON_TOKEN: FeedBackToken = 0x703;
pub const GL_BITMAP_TOKEN: FeedBackToken = 0x704;
pub const GL_DRAW_PIXEL_TOKEN: FeedBackToken = 0x705;
pub const GL_COPY_PIXEL_TOKEN: FeedBackToken = 0x706;
pub const GL_LINE_RESET_TOKEN: FeedBackToken = 0x707;
pub const GL_EXP: FogMode = 0x800;
pub const GL_EXP2: FogMode = 0x801;
pub const GL_COEFF: GLenum = 0xA00;// groups: MapQuery GetMapQuery
pub const GL_ORDER: GLenum = 0xA01;// groups: MapQuery GetMapQuery
pub const GL_DOMAIN: GLenum = 0xA02;// groups: MapQuery GetMapQuery
pub const GL_PIXEL_MAP_I_TO_I: PixelMap = 0xC70;
pub const GL_PIXEL_MAP_S_TO_S: PixelMap = 0xC71;
pub const GL_PIXEL_MAP_I_TO_R: PixelMap = 0xC72;
pub const GL_PIXEL_MAP_I_TO_G: PixelMap = 0xC73;
pub const GL_PIXEL_MAP_I_TO_B: PixelMap = 0xC74;
pub const GL_PIXEL_MAP_I_TO_A: PixelMap = 0xC75;
pub const GL_PIXEL_MAP_R_TO_R: PixelMap = 0xC76;
pub const GL_PIXEL_MAP_G_TO_G: PixelMap = 0xC77;
pub const GL_PIXEL_MAP_B_TO_B: PixelMap = 0xC78;
pub const GL_PIXEL_MAP_A_TO_A: PixelMap = 0xC79;
pub const GL_CURRENT_COLOR: GetPName = 0xB00;
pub const GL_CURRENT_INDEX: GetPName = 0xB01;
pub const GL_CURRENT_NORMAL: GetPName = 0xB02;
pub const GL_CURRENT_TEXTURE_COORDS: GLenum = 0xB03;// groups: GetPName VertexShaderTextureUnitParameter
pub const GL_CURRENT_RASTER_COLOR: GetPName = 0xB04;
pub const GL_CURRENT_RASTER_INDEX: GetPName = 0xB05;
pub const GL_CURRENT_RASTER_TEXTURE_COORDS: GetPName = 0xB06;
pub const GL_CURRENT_RASTER_POSITION: GetPName = 0xB07;
pub const GL_CURRENT_RASTER_POSITION_VALID: GetPName = 0xB08;
pub const GL_CURRENT_RASTER_DISTANCE: GetPName = 0xB09;
pub const GL_POINT_SMOOTH: GLenum = 0xB10;// groups: GetPName EnableCap
pub const GL_LINE_STIPPLE: GLenum = 0xB24;// groups: GetPName EnableCap
pub const GL_LINE_STIPPLE_PATTERN: GetPName = 0xB25;
pub const GL_LINE_STIPPLE_REPEAT: GetPName = 0xB26;
pub const GL_LIST_MODE: GetPName = 0xB30;
pub const GL_MAX_LIST_NESTING: GetPName = 0xB31;
pub const GL_LIST_BASE: GetPName = 0xB32;
pub const GL_LIST_INDEX: GetPName = 0xB33;
pub const GL_POLYGON_STIPPLE: GLenum = 0xB42;// groups: GetPName EnableCap
pub const GL_EDGE_FLAG: GetPName = 0xB43;
pub const GL_LIGHTING: GLenum = 0xB50;// groups: GetPName EnableCap
pub const GL_LIGHT_MODEL_LOCAL_VIEWER: GLenum = 0xB51;// groups: LightModelParameter GetPName
pub const GL_LIGHT_MODEL_TWO_SIDE: GLenum = 0xB52;// groups: LightModelParameter GetPName
pub const GL_LIGHT_MODEL_AMBIENT: GLenum = 0xB53;// groups: LightModelParameter GetPName
pub const GL_SHADE_MODEL: GetPName = 0xB54;
pub const GL_COLOR_MATERIAL_FACE: GetPName = 0xB55;
pub const GL_COLOR_MATERIAL_PARAMETER: GetPName = 0xB56;
pub const GL_COLOR_MATERIAL: GLenum = 0xB57;// groups: GetPName EnableCap
pub const GL_FOG: GLenum = 0xB60;// groups: GetPName EnableCap
pub const GL_FOG_INDEX: GLenum = 0xB61;// groups: FogPName FogParameter GetPName
pub const GL_FOG_DENSITY: GLenum = 0xB62;// groups: FogPName FogParameter GetPName
pub const GL_FOG_START: GLenum = 0xB63;// groups: FogPName FogParameter GetPName
pub const GL_FOG_END: GLenum = 0xB64;// groups: FogPName FogParameter GetPName
pub const GL_FOG_MODE: GLenum = 0xB65;// groups: FogPName FogParameter GetPName
pub const GL_FOG_COLOR: GLenum = 0xB66;// groups: GetPName FogParameter
pub const GL_ACCUM_CLEAR_VALUE: GetPName = 0xB80;
pub const GL_MATRIX_MODE: GetPName = 0xBA0;
pub const GL_NORMALIZE: GLenum = 0xBA1;// groups: GetPName EnableCap
pub const GL_MODELVIEW_STACK_DEPTH: GetPName = 0xBA3;
pub const GL_PROJECTION_STACK_DEPTH: GetPName = 0xBA4;
pub const GL_TEXTURE_STACK_DEPTH: GetPName = 0xBA5;
pub const GL_MODELVIEW_MATRIX: GetPName = 0xBA6;
pub const GL_PROJECTION_MATRIX: GetPName = 0xBA7;
pub const GL_TEXTURE_MATRIX: GLenum = 0xBA8;// groups: GetPName VertexShaderTextureUnitParameter
pub const GL_ATTRIB_STACK_DEPTH: GetPName = 0xBB0;
pub const GL_ALPHA_TEST: GLenum = 0xBC0;// groups: GetPName EnableCap
pub const GL_ALPHA_TEST_FUNC: GetPName = 0xBC1;
pub const GL_ALPHA_TEST_REF: GetPName = 0xBC2;
pub const GL_LOGIC_OP: GetPName = 0xBF1;
pub const GL_AUX_BUFFERS: GetPName = 0xC00;
pub const GL_INDEX_CLEAR_VALUE: GetPName = 0xC20;
pub const GL_INDEX_WRITEMASK: GetPName = 0xC21;
pub const GL_INDEX_MODE: GetPName = 0xC30;
pub const GL_RGBA_MODE: GetPName = 0xC31;
pub const GL_RENDER_MODE: GetPName = 0xC40;
pub const GL_PERSPECTIVE_CORRECTION_HINT: GLenum = 0xC50;// groups: HintTarget GetPName
pub const GL_POINT_SMOOTH_HINT: GLenum = 0xC51;// groups: HintTarget GetPName
pub const GL_FOG_HINT: GLenum = 0xC54;// groups: HintTarget GetPName
pub const GL_TEXTURE_GEN_S: GLenum = 0xC60;// groups: GetPName EnableCap
pub const GL_TEXTURE_GEN_T: GLenum = 0xC61;// groups: GetPName EnableCap
pub const GL_TEXTURE_GEN_R: GLenum = 0xC62;// groups: GetPName EnableCap
pub const GL_TEXTURE_GEN_Q: GLenum = 0xC63;// groups: GetPName EnableCap
pub const GL_PIXEL_MAP_I_TO_I_SIZE: GetPName = 0xCB0;
pub const GL_PIXEL_MAP_S_TO_S_SIZE: GetPName = 0xCB1;
pub const GL_PIXEL_MAP_I_TO_R_SIZE: GetPName = 0xCB2;
pub const GL_PIXEL_MAP_I_TO_G_SIZE: GetPName = 0xCB3;
pub const GL_PIXEL_MAP_I_TO_B_SIZE: GetPName = 0xCB4;
pub const GL_PIXEL_MAP_I_TO_A_SIZE: GetPName = 0xCB5;
pub const GL_PIXEL_MAP_R_TO_R_SIZE: GetPName = 0xCB6;
pub const GL_PIXEL_MAP_G_TO_G_SIZE: GetPName = 0xCB7;
pub const GL_PIXEL_MAP_B_TO_B_SIZE: GetPName = 0xCB8;
pub const GL_PIXEL_MAP_A_TO_A_SIZE: GetPName = 0xCB9;
pub const GL_MAP_COLOR: GLenum = 0xD10;// groups: PixelTransferParameter GetPName
pub const GL_MAP_STENCIL: GLenum = 0xD11;// groups: PixelTransferParameter GetPName
pub const GL_INDEX_SHIFT: GLenum = 0xD12;// groups: PixelTransferParameter GetPName
pub const GL_INDEX_OFFSET: GLenum = 0xD13;// groups: PixelTransferParameter IndexMaterialParameterEXT GetPName
pub const GL_RED_SCALE: GLenum = 0xD14;// groups: PixelTransferParameter GetPName
pub const GL_RED_BIAS: GLenum = 0xD15;// groups: PixelTransferParameter GetPName
pub const GL_ZOOM_X: GetPName = 0xD16;
pub const GL_ZOOM_Y: GetPName = 0xD17;
pub const GL_GREEN_SCALE: GLenum = 0xD18;// groups: PixelTransferParameter GetPName
pub const GL_GREEN_BIAS: GLenum = 0xD19;// groups: PixelTransferParameter GetPName
pub const GL_BLUE_SCALE: GLenum = 0xD1A;// groups: PixelTransferParameter GetPName
pub const GL_BLUE_BIAS: GLenum = 0xD1B;// groups: PixelTransferParameter GetPName
pub const GL_ALPHA_SCALE: GLenum = 0xD1C;// groups: PixelTransferParameter GetPName TextureEnvParameter
pub const GL_ALPHA_BIAS: GLenum = 0xD1D;// groups: PixelTransferParameter GetPName
pub const GL_DEPTH_SCALE: GLenum = 0xD1E;// groups: PixelTransferParameter GetPName
pub const GL_DEPTH_BIAS: GLenum = 0xD1F;// groups: PixelTransferParameter GetPName
pub const GL_MAX_EVAL_ORDER: GetPName = 0xD30;
pub const GL_MAX_LIGHTS: GetPName = 0xD31;
pub const GL_MAX_CLIP_PLANES: GetPName = 0xD32;
pub const GL_MAX_PIXEL_MAP_TABLE: GetPName = 0xD34;
pub const GL_MAX_ATTRIB_STACK_DEPTH: GetPName = 0xD35;
pub const GL_MAX_MODELVIEW_STACK_DEPTH: GetPName = 0xD36;
pub const GL_MAX_NAME_STACK_DEPTH: GetPName = 0xD37;
pub const GL_MAX_PROJECTION_STACK_DEPTH: GetPName = 0xD38;
pub const GL_MAX_TEXTURE_STACK_DEPTH: GetPName = 0xD39;
pub const GL_INDEX_BITS: GetPName = 0xD51;
pub const GL_RED_BITS: GetPName = 0xD52;
pub const GL_GREEN_BITS: GetPName = 0xD53;
pub const GL_BLUE_BITS: GetPName = 0xD54;
pub const GL_ALPHA_BITS: GetPName = 0xD55;
pub const GL_DEPTH_BITS: GetPName = 0xD56;
pub const GL_STENCIL_BITS: GetPName = 0xD57;
pub const GL_ACCUM_RED_BITS: GetPName = 0xD58;
pub const GL_ACCUM_GREEN_BITS: GetPName = 0xD59;
pub const GL_ACCUM_BLUE_BITS: GetPName = 0xD5A;
pub const GL_ACCUM_ALPHA_BITS: GetPName = 0xD5B;
pub const GL_NAME_STACK_DEPTH: GetPName = 0xD70;
pub const GL_AUTO_NORMAL: GLenum = 0xD80;// groups: GetPName EnableCap
pub const GL_MAP1_COLOR_4: GLenum = 0xD90;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_INDEX: GLenum = 0xD91;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_NORMAL: GLenum = 0xD92;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_TEXTURE_COORD_1: GLenum = 0xD93;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_TEXTURE_COORD_2: GLenum = 0xD94;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_TEXTURE_COORD_3: GLenum = 0xD95;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_TEXTURE_COORD_4: GLenum = 0xD96;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_VERTEX_3: GLenum = 0xD97;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_VERTEX_4: GLenum = 0xD98;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_COLOR_4: GLenum = 0xDB0;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_INDEX: GLenum = 0xDB1;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_NORMAL: GLenum = 0xDB2;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_TEXTURE_COORD_1: GLenum = 0xDB3;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_TEXTURE_COORD_2: GLenum = 0xDB4;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_TEXTURE_COORD_3: GLenum = 0xDB5;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_TEXTURE_COORD_4: GLenum = 0xDB6;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_VERTEX_3: GLenum = 0xDB7;// groups: MapTarget EnableCap GetPName
pub const GL_MAP2_VERTEX_4: GLenum = 0xDB8;// groups: MapTarget EnableCap GetPName
pub const GL_MAP1_GRID_DOMAIN: GetPName = 0xDD0;
pub const GL_MAP1_GRID_SEGMENTS: GetPName = 0xDD1;
pub const GL_MAP2_GRID_DOMAIN: GetPName = 0xDD2;
pub const GL_MAP2_GRID_SEGMENTS: GetPName = 0xDD3;
pub const GL_TEXTURE_COMPONENTS: GLenum = 0x1003;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_BORDER: GLenum = 0x1005;// groups: TextureParameterName GetTextureParameter
pub const GL_AMBIENT: GLenum = 0x1200;// groups: LightParameter MaterialParameter FragmentLightParameterSGIX ColorMaterialParameter
pub const GL_DIFFUSE: GLenum = 0x1201;// groups: LightParameter MaterialParameter FragmentLightParameterSGIX ColorMaterialParameter
pub const GL_SPECULAR: GLenum = 0x1202;// groups: LightParameter MaterialParameter FragmentLightParameterSGIX ColorMaterialParameter
pub const GL_POSITION: GLenum = 0x1203;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_SPOT_DIRECTION: GLenum = 0x1204;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_SPOT_EXPONENT: GLenum = 0x1205;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_SPOT_CUTOFF: GLenum = 0x1206;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_CONSTANT_ATTENUATION: GLenum = 0x1207;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_LINEAR_ATTENUATION: GLenum = 0x1208;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_QUADRATIC_ATTENUATION: GLenum = 0x1209;// groups: LightParameter FragmentLightParameterSGIX
pub const GL_COMPILE: ListMode = 0x1300;
pub const GL_COMPILE_AND_EXECUTE: ListMode = 0x1301;
pub const GL_2_BYTES: ListNameType = 0x1407;
pub const GL_3_BYTES: ListNameType = 0x1408;
pub const GL_4_BYTES: ListNameType = 0x1409;
pub const GL_EMISSION: GLenum = 0x1600;// groups: MaterialParameter ColorMaterialParameter
pub const GL_SHININESS: MaterialParameter = 0x1601;
pub const GL_AMBIENT_AND_DIFFUSE: GLenum = 0x1602;// groups: MaterialParameter ColorMaterialParameter
pub const GL_COLOR_INDEXES: MaterialParameter = 0x1603;
pub const GL_MODELVIEW: MatrixMode = 0x1700;
pub const GL_PROJECTION: MatrixMode = 0x1701;
pub const GL_COLOR_INDEX: PixelFormat = 0x1900;
pub const GL_LUMINANCE: GLenum = 0x1909;// groups: PathColorFormat PixelFormat
pub const GL_LUMINANCE_ALPHA: GLenum = 0x190A;// groups: PathColorFormat PixelFormat
pub const GL_BITMAP: PixelType = 0x1A00;
pub const GL_RENDER: RenderingMode = 0x1C00;
pub const GL_FEEDBACK: RenderingMode = 0x1C01;
pub const GL_SELECT: RenderingMode = 0x1C02;
pub const GL_FLAT: ShadingModel = 0x1D00;
pub const GL_SMOOTH: ShadingModel = 0x1D01;
pub const GL_S: TextureCoordName = 0x2000;
pub const GL_T: TextureCoordName = 0x2001;
pub const GL_R: TextureCoordName = 0x2002;
pub const GL_Q: TextureCoordName = 0x2003;
pub const GL_MODULATE: GLenum = 0x2100;// groups: TextureEnvMode LightEnvModeSGIX
pub const GL_DECAL: TextureEnvMode = 0x2101;
pub const GL_TEXTURE_ENV_MODE: TextureEnvParameter = 0x2200;
pub const GL_TEXTURE_ENV_COLOR: TextureEnvParameter = 0x2201;
pub const GL_TEXTURE_ENV: TextureEnvTarget = 0x2300;
pub const GL_EYE_LINEAR: GLenum = 0x2400;// groups: PathGenMode TextureGenMode
pub const GL_OBJECT_LINEAR: GLenum = 0x2401;// groups: PathGenMode TextureGenMode
pub const GL_SPHERE_MAP: TextureGenMode = 0x2402;
pub const GL_TEXTURE_GEN_MODE: TextureGenParameter = 0x2500;
pub const GL_OBJECT_PLANE: TextureGenParameter = 0x2501;
pub const GL_EYE_PLANE: TextureGenParameter = 0x2502;
pub const GL_CLAMP: TextureWrapMode = 0x2900;
pub const GL_CLIP_PLANE0: GLenum = 0x3000;// groups: GetPName ClipPlaneName EnableCap
pub const GL_CLIP_PLANE1: GLenum = 0x3001;// groups: GetPName ClipPlaneName EnableCap
pub const GL_CLIP_PLANE2: GLenum = 0x3002;// groups: GetPName ClipPlaneName EnableCap
pub const GL_CLIP_PLANE3: GLenum = 0x3003;// groups: GetPName ClipPlaneName EnableCap
pub const GL_CLIP_PLANE4: GLenum = 0x3004;// groups: GetPName ClipPlaneName EnableCap
pub const GL_CLIP_PLANE5: GLenum = 0x3005;// groups: GetPName ClipPlaneName EnableCap
pub const GL_LIGHT0: GLenum = 0x4000;// groups: LightName EnableCap GetPName
pub const GL_LIGHT1: GLenum = 0x4001;// groups: LightName EnableCap GetPName
pub const GL_LIGHT2: GLenum = 0x4002;// groups: LightName EnableCap GetPName
pub const GL_LIGHT3: GLenum = 0x4003;// groups: LightName EnableCap GetPName
pub const GL_LIGHT4: GLenum = 0x4004;// groups: LightName EnableCap GetPName
pub const GL_LIGHT5: GLenum = 0x4005;// groups: LightName EnableCap GetPName
pub const GL_LIGHT6: GLenum = 0x4006;// groups: LightName EnableCap GetPName
pub const GL_LIGHT7: GLenum = 0x4007;// groups: LightName EnableCap GetPName
pub const GL_COLOR_LOGIC_OP: GLenum = 0xBF2;// groups: GetPName EnableCap
pub const GL_POLYGON_OFFSET_UNITS: GetPName = 0x2A00;
pub const GL_POLYGON_OFFSET_POINT: GLenum = 0x2A01;// groups: GetPName EnableCap
pub const GL_POLYGON_OFFSET_LINE: GLenum = 0x2A02;// groups: GetPName EnableCap
pub const GL_POLYGON_OFFSET_FILL: GLenum = 0x8037;// groups: GetPName EnableCap
pub const GL_POLYGON_OFFSET_FACTOR: GetPName = 0x8038;
pub const GL_TEXTURE_BINDING_1D: GetPName = 0x8068;
pub const GL_TEXTURE_BINDING_2D: GetPName = 0x8069;
pub const GL_TEXTURE_INTERNAL_FORMAT: GLenum = 0x1003;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_RED_SIZE: GLenum = 0x805C;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_GREEN_SIZE: GLenum = 0x805D;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_BLUE_SIZE: GLenum = 0x805E;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_ALPHA_SIZE: GLenum = 0x805F;// groups: TextureParameterName GetTextureParameter
pub const GL_DOUBLE: GLenum = 0x140A;// groups: VertexAttribLType MapTypeNV SecondaryColorPointerTypeIBM WeightPointerTypeARB TangentPointerTypeEXT BinormalPointerTypeEXT ColorPointerType FogCoordinatePointerType FogPointerTypeEXT FogPointerTypeIBM IndexPointerType NormalPointerType TexCoordPointerType VertexPointerType VertexAttribType AttributeType UniformType VertexAttribPointerType
pub const GL_PROXY_TEXTURE_1D: TextureTarget = 0x8063;
pub const GL_PROXY_TEXTURE_2D: TextureTarget = 0x8064;
pub const GL_R3_G3_B2: GLenum = 0x2A10;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB4: GLenum = 0x804F;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB5: GLenum = 0x8050;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB8: GLenum = 0x8051;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB10: GLenum = 0x8052;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB12: GLenum = 0x8053;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB16: GLenum = 0x8054;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA2: GLenum = 0x8055;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA4: GLenum = 0x8056;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB5_A1: GLenum = 0x8057;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA8: GLenum = 0x8058;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB10_A2: GLenum = 0x8059;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA12: GLenum = 0x805A;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA16: GLenum = 0x805B;// groups: InternalFormat SizedInternalFormat
pub const GL_VERTEX_ARRAY_POINTER: GetPointervPName = 0x808E;
pub const GL_NORMAL_ARRAY_POINTER: GetPointervPName = 0x808F;
pub const GL_COLOR_ARRAY_POINTER: GetPointervPName = 0x8090;
pub const GL_INDEX_ARRAY_POINTER: GetPointervPName = 0x8091;
pub const GL_TEXTURE_COORD_ARRAY_POINTER: GetPointervPName = 0x8092;
pub const GL_EDGE_FLAG_ARRAY_POINTER: GetPointervPName = 0x8093;
pub const GL_FEEDBACK_BUFFER_POINTER: GetPointervPName = 0xDF0;
pub const GL_SELECTION_BUFFER_POINTER: GetPointervPName = 0xDF3;
pub const GL_CLIENT_ATTRIB_STACK_DEPTH: GetPName = 0xBB1;
pub const GL_INDEX_LOGIC_OP: GLenum = 0xBF1;// groups: GetPName EnableCap
pub const GL_MAX_CLIENT_ATTRIB_STACK_DEPTH: GetPName = 0xD3B;
pub const GL_FEEDBACK_BUFFER_SIZE: GetPName = 0xDF1;
pub const GL_FEEDBACK_BUFFER_TYPE: GetPName = 0xDF2;
pub const GL_SELECTION_BUFFER_SIZE: GetPName = 0xDF4;
pub const GL_VERTEX_ARRAY: GLenum = 0x8074;// groups: ObjectIdentifier EnableCap GetPName
pub const GL_NORMAL_ARRAY: GLenum = 0x8075;// groups: GetPName EnableCap
pub const GL_COLOR_ARRAY: GLenum = 0x8076;// groups: GetPName EnableCap
pub const GL_INDEX_ARRAY: GLenum = 0x8077;// groups: GetPName EnableCap
pub const GL_TEXTURE_COORD_ARRAY: GLenum = 0x8078;// groups: GetPName EnableCap
pub const GL_EDGE_FLAG_ARRAY: GLenum = 0x8079;// groups: GetPName EnableCap
pub const GL_VERTEX_ARRAY_SIZE: GetPName = 0x807A;
pub const GL_VERTEX_ARRAY_TYPE: GetPName = 0x807B;
pub const GL_VERTEX_ARRAY_STRIDE: GetPName = 0x807C;
pub const GL_NORMAL_ARRAY_TYPE: GetPName = 0x807E;
pub const GL_NORMAL_ARRAY_STRIDE: GetPName = 0x807F;
pub const GL_COLOR_ARRAY_SIZE: GetPName = 0x8081;
pub const GL_COLOR_ARRAY_TYPE: GetPName = 0x8082;
pub const GL_COLOR_ARRAY_STRIDE: GetPName = 0x8083;
pub const GL_INDEX_ARRAY_TYPE: GetPName = 0x8085;
pub const GL_INDEX_ARRAY_STRIDE: GetPName = 0x8086;
pub const GL_TEXTURE_COORD_ARRAY_SIZE: GetPName = 0x8088;
pub const GL_TEXTURE_COORD_ARRAY_TYPE: GetPName = 0x8089;
pub const GL_TEXTURE_COORD_ARRAY_STRIDE: GetPName = 0x808A;
pub const GL_EDGE_FLAG_ARRAY_STRIDE: GetPName = 0x808C;
pub const GL_TEXTURE_LUMINANCE_SIZE: GLenum = 0x8060;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_INTENSITY_SIZE: GLenum = 0x8061;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_PRIORITY: GLenum = 0x8066;// groups: TextureParameterName GetTextureParameter
pub const GL_TEXTURE_RESIDENT: GLenum = 0x8067;// groups: TextureParameterName GetTextureParameter
pub const GL_ALPHA4: GLenum = 0x803B;// groups: InternalFormat SizedInternalFormat
pub const GL_ALPHA8: GLenum = 0x803C;// groups: InternalFormat SizedInternalFormat
pub const GL_ALPHA12: GLenum = 0x803D;// groups: InternalFormat SizedInternalFormat
pub const GL_ALPHA16: GLenum = 0x803E;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE4: GLenum = 0x803F;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE8: GLenum = 0x8040;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE12: GLenum = 0x8041;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE16: GLenum = 0x8042;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE4_ALPHA4: GLenum = 0x8043;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE6_ALPHA2: GLenum = 0x8044;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE8_ALPHA8: GLenum = 0x8045;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE12_ALPHA4: GLenum = 0x8046;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE12_ALPHA12: GLenum = 0x8047;// groups: InternalFormat SizedInternalFormat
pub const GL_LUMINANCE16_ALPHA16: GLenum = 0x8048;// groups: InternalFormat SizedInternalFormat
pub const GL_INTENSITY: GLenum = 0x8049;// groups: InternalFormat PathColorFormat
pub const GL_INTENSITY4: GLenum = 0x804A;// groups: InternalFormat SizedInternalFormat
pub const GL_INTENSITY8: GLenum = 0x804B;// groups: InternalFormat SizedInternalFormat
pub const GL_INTENSITY12: GLenum = 0x804C;// groups: InternalFormat SizedInternalFormat
pub const GL_INTENSITY16: GLenum = 0x804D;// groups: InternalFormat SizedInternalFormat
pub const GL_V2F: InterleavedArrayFormat = 0x2A20;
pub const GL_V3F: InterleavedArrayFormat = 0x2A21;
pub const GL_C4UB_V2F: InterleavedArrayFormat = 0x2A22;
pub const GL_C4UB_V3F: InterleavedArrayFormat = 0x2A23;
pub const GL_C3F_V3F: InterleavedArrayFormat = 0x2A24;
pub const GL_N3F_V3F: InterleavedArrayFormat = 0x2A25;
pub const GL_C4F_N3F_V3F: InterleavedArrayFormat = 0x2A26;
pub const GL_T2F_V3F: InterleavedArrayFormat = 0x2A27;
pub const GL_T4F_V4F: InterleavedArrayFormat = 0x2A28;
pub const GL_T2F_C4UB_V3F: InterleavedArrayFormat = 0x2A29;
pub const GL_T2F_C3F_V3F: InterleavedArrayFormat = 0x2A2A;
pub const GL_T2F_N3F_V3F: InterleavedArrayFormat = 0x2A2B;
pub const GL_T2F_C4F_N3F_V3F: InterleavedArrayFormat = 0x2A2C;
pub const GL_T4F_C4F_N3F_V4F: InterleavedArrayFormat = 0x2A2D;
pub const GL_UNSIGNED_BYTE_3_3_2: PixelType = 0x8032;
pub const GL_UNSIGNED_SHORT_4_4_4_4: PixelType = 0x8033;
pub const GL_UNSIGNED_SHORT_5_5_5_1: PixelType = 0x8034;
pub const GL_UNSIGNED_INT_8_8_8_8: PixelType = 0x8035;
pub const GL_UNSIGNED_INT_10_10_10_2: PixelType = 0x8036;
pub const GL_TEXTURE_BINDING_3D: GetPName = 0x806A;
pub const GL_PACK_SKIP_IMAGES: GLenum = 0x806B;// groups: PixelStoreParameter GetPName
pub const GL_PACK_IMAGE_HEIGHT: GLenum = 0x806C;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_SKIP_IMAGES: GLenum = 0x806D;// groups: PixelStoreParameter GetPName
pub const GL_UNPACK_IMAGE_HEIGHT: GLenum = 0x806E;// groups: PixelStoreParameter GetPName
pub const GL_TEXTURE_3D: GLenum = 0x806F;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_PROXY_TEXTURE_3D: TextureTarget = 0x8070;
pub const GL_TEXTURE_DEPTH: GLenum = 0x8071;
pub const GL_TEXTURE_WRAP_R: GLenum = 0x8072;// groups: SamplerParameterI TextureParameterName
pub const GL_MAX_3D_TEXTURE_SIZE: GetPName = 0x8073;
pub const GL_UNSIGNED_BYTE_2_3_3_REV: PixelType = 0x8362;
pub const GL_UNSIGNED_SHORT_5_6_5: PixelType = 0x8363;
pub const GL_UNSIGNED_SHORT_5_6_5_REV: PixelType = 0x8364;
pub const GL_UNSIGNED_SHORT_4_4_4_4_REV: PixelType = 0x8365;
pub const GL_UNSIGNED_SHORT_1_5_5_5_REV: PixelType = 0x8366;
pub const GL_UNSIGNED_INT_8_8_8_8_REV: PixelType = 0x8367;
pub const GL_UNSIGNED_INT_2_10_10_10_REV: GLenum = 0x8368;// groups: PixelType VertexAttribPointerType VertexAttribType
pub const GL_BGR: PixelFormat = 0x80E0;
pub const GL_BGRA: PixelFormat = 0x80E1;
pub const GL_MAX_ELEMENTS_VERTICES: GetPName = 0x80E8;
pub const GL_MAX_ELEMENTS_INDICES: GetPName = 0x80E9;
pub const GL_CLAMP_TO_EDGE: TextureWrapMode = 0x812F;
pub const GL_TEXTURE_MIN_LOD: GLenum = 0x813A;// groups: SamplerParameterF TextureParameterName
pub const GL_TEXTURE_MAX_LOD: GLenum = 0x813B;// groups: SamplerParameterF TextureParameterName
pub const GL_TEXTURE_BASE_LEVEL: TextureParameterName = 0x813C;
pub const GL_TEXTURE_MAX_LEVEL: TextureParameterName = 0x813D;
pub const GL_SMOOTH_POINT_SIZE_RANGE: GetPName = 0xB12;
pub const GL_SMOOTH_POINT_SIZE_GRANULARITY: GetPName = 0xB13;
pub const GL_SMOOTH_LINE_WIDTH_RANGE: GetPName = 0xB22;
pub const GL_SMOOTH_LINE_WIDTH_GRANULARITY: GetPName = 0xB23;
pub const GL_ALIASED_LINE_WIDTH_RANGE: GetPName = 0x846E;
pub const GL_RESCALE_NORMAL: GLenum = 0x803A;
pub const GL_LIGHT_MODEL_COLOR_CONTROL: GLenum = 0x81F8;// groups: LightModelParameter GetPName
pub const GL_SINGLE_COLOR: LightModelColorControl = 0x81F9;
pub const GL_SEPARATE_SPECULAR_COLOR: LightModelColorControl = 0x81FA;
pub const GL_ALIASED_POINT_SIZE_RANGE: GetPName = 0x846D;
pub const GL_TEXTURE0: GLenum = 0x84C0;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE1: GLenum = 0x84C1;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE2: GLenum = 0x84C2;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE3: GLenum = 0x84C3;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE4: GLenum = 0x84C4;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE5: GLenum = 0x84C5;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE6: GLenum = 0x84C6;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE7: GLenum = 0x84C7;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE8: GLenum = 0x84C8;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE9: GLenum = 0x84C9;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE10: GLenum = 0x84CA;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE11: GLenum = 0x84CB;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE12: GLenum = 0x84CC;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE13: GLenum = 0x84CD;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE14: GLenum = 0x84CE;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE15: GLenum = 0x84CF;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE16: GLenum = 0x84D0;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE17: GLenum = 0x84D1;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE18: GLenum = 0x84D2;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE19: GLenum = 0x84D3;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE20: GLenum = 0x84D4;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE21: GLenum = 0x84D5;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE22: GLenum = 0x84D6;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE23: GLenum = 0x84D7;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE24: GLenum = 0x84D8;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE25: GLenum = 0x84D9;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE26: GLenum = 0x84DA;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE27: GLenum = 0x84DB;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE28: GLenum = 0x84DC;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE29: GLenum = 0x84DD;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE30: GLenum = 0x84DE;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_TEXTURE31: GLenum = 0x84DF;// groups: TextureUnit FragmentShaderTextureSourceATI
pub const GL_ACTIVE_TEXTURE: GetPName = 0x84E0;
pub const GL_MULTISAMPLE: EnableCap = 0x809D;
pub const GL_SAMPLE_ALPHA_TO_COVERAGE: EnableCap = 0x809E;
pub const GL_SAMPLE_ALPHA_TO_ONE: EnableCap = 0x809F;
pub const GL_SAMPLE_COVERAGE: EnableCap = 0x80A0;
pub const GL_SAMPLE_BUFFERS: GLenum = 0x80A8;// groups: GetFramebufferParameter GetPName
pub const GL_SAMPLES: GLenum = 0x80A9;// groups: GetFramebufferParameter GetPName InternalFormatPName
pub const GL_SAMPLE_COVERAGE_VALUE: GetPName = 0x80AA;
pub const GL_SAMPLE_COVERAGE_INVERT: GetPName = 0x80AB;
pub const GL_TEXTURE_CUBE_MAP: GLenum = 0x8513;// groups: CopyImageSubDataTarget TextureTarget EnableCap
pub const GL_TEXTURE_BINDING_CUBE_MAP: GetPName = 0x8514;
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_X: TextureTarget = 0x8515;
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_X: TextureTarget = 0x8516;
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_Y: TextureTarget = 0x8517;
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_Y: TextureTarget = 0x8518;
pub const GL_TEXTURE_CUBE_MAP_POSITIVE_Z: TextureTarget = 0x8519;
pub const GL_TEXTURE_CUBE_MAP_NEGATIVE_Z: TextureTarget = 0x851A;
pub const GL_PROXY_TEXTURE_CUBE_MAP: TextureTarget = 0x851B;
pub const GL_MAX_CUBE_MAP_TEXTURE_SIZE: GetPName = 0x851C;
pub const GL_COMPRESSED_RGB: InternalFormat = 0x84ED;
pub const GL_COMPRESSED_RGBA: InternalFormat = 0x84EE;
pub const GL_TEXTURE_COMPRESSION_HINT: GLenum = 0x84EF;// groups: HintTarget GetPName
pub const GL_TEXTURE_COMPRESSED_IMAGE_SIZE: GLenum = 0x86A0;
pub const GL_TEXTURE_COMPRESSED: InternalFormatPName = 0x86A1;
pub const GL_NUM_COMPRESSED_TEXTURE_FORMATS: GetPName = 0x86A2;
pub const GL_COMPRESSED_TEXTURE_FORMATS: GetPName = 0x86A3;
pub const GL_CLAMP_TO_BORDER: TextureWrapMode = 0x812D;
pub const GL_CLIENT_ACTIVE_TEXTURE: GLenum = 0x84E1;
pub const GL_MAX_TEXTURE_UNITS: GLenum = 0x84E2;
pub const GL_TRANSPOSE_MODELVIEW_MATRIX: GLenum = 0x84E3;
pub const GL_TRANSPOSE_PROJECTION_MATRIX: GLenum = 0x84E4;
pub const GL_TRANSPOSE_TEXTURE_MATRIX: GLenum = 0x84E5;
pub const GL_TRANSPOSE_COLOR_MATRIX: GLenum = 0x84E6;
pub const GL_NORMAL_MAP: GetTextureParameter = 0x8511;
pub const GL_REFLECTION_MAP: GetTextureParameter = 0x8512;
pub const GL_COMPRESSED_ALPHA: GLenum = 0x84E9;
pub const GL_COMPRESSED_LUMINANCE: GLenum = 0x84EA;
pub const GL_COMPRESSED_LUMINANCE_ALPHA: GLenum = 0x84EB;
pub const GL_COMPRESSED_INTENSITY: GLenum = 0x84EC;
pub const GL_COMBINE: GLenum = 0x8570;// groups: TextureEnvParameter TextureEnvMode
pub const GL_COMBINE_RGB: TextureEnvParameter = 0x8571;
pub const GL_COMBINE_ALPHA: TextureEnvParameter = 0x8572;
pub const GL_SOURCE0_RGB: TextureEnvParameter = 0x8580;
pub const GL_SOURCE1_RGB: TextureEnvParameter = 0x8581;
pub const GL_SOURCE2_RGB: TextureEnvParameter = 0x8582;
pub const GL_SOURCE0_ALPHA: TextureEnvParameter = 0x8588;
pub const GL_SOURCE1_ALPHA: TextureEnvParameter = 0x8589;
pub const GL_SOURCE2_ALPHA: TextureEnvParameter = 0x858A;
pub const GL_OPERAND0_RGB: TextureEnvParameter = 0x8590;
pub const GL_OPERAND1_RGB: TextureEnvParameter = 0x8591;
pub const GL_OPERAND2_RGB: TextureEnvParameter = 0x8592;
pub const GL_OPERAND0_ALPHA: TextureEnvParameter = 0x8598;
pub const GL_OPERAND1_ALPHA: TextureEnvParameter = 0x8599;
pub const GL_OPERAND2_ALPHA: TextureEnvParameter = 0x859A;
pub const GL_RGB_SCALE: TextureEnvParameter = 0x8573;
pub const GL_ADD_SIGNED: TextureEnvParameter = 0x8574;
pub const GL_INTERPOLATE: TextureEnvParameter = 0x8575;
pub const GL_SUBTRACT: GLenum = 0x84E7;
pub const GL_CONSTANT: GLenum = 0x8576;// groups: TextureEnvParameter PathGenMode
pub const GL_PRIMARY_COLOR: GLenum = 0x8577;// groups: TextureEnvParameter PathColor FragmentShaderGenericSourceATI
pub const GL_PREVIOUS: TextureEnvParameter = 0x8578;
pub const GL_DOT3_RGB: GLenum = 0x86AE;
pub const GL_DOT3_RGBA: GLenum = 0x86AF;
pub const GL_BLEND_DST_RGB: GetPName = 0x80C8;
pub const GL_BLEND_SRC_RGB: GetPName = 0x80C9;
pub const GL_BLEND_DST_ALPHA: GetPName = 0x80CA;
pub const GL_BLEND_SRC_ALPHA: GetPName = 0x80CB;
pub const GL_POINT_FADE_THRESHOLD_SIZE: GLenum = 0x8128;// groups: PointParameterNameARB GetPName
pub const GL_DEPTH_COMPONENT16: GLenum = 0x81A5;// groups: InternalFormat SizedInternalFormat
pub const GL_DEPTH_COMPONENT24: GLenum = 0x81A6;// groups: InternalFormat SizedInternalFormat
pub const GL_DEPTH_COMPONENT32: GLenum = 0x81A7;// groups: InternalFormat SizedInternalFormat
pub const GL_MIRRORED_REPEAT: TextureWrapMode = 0x8370;
pub const GL_MAX_TEXTURE_LOD_BIAS: GetPName = 0x84FD;
pub const GL_TEXTURE_LOD_BIAS: GLenum = 0x8501;// groups: TextureParameterName SamplerParameterF TextureEnvParameter
pub const GL_INCR_WRAP: StencilOp = 0x8507;
pub const GL_DECR_WRAP: StencilOp = 0x8508;
pub const GL_TEXTURE_DEPTH_SIZE: GLenum = 0x884A;
pub const GL_TEXTURE_COMPARE_MODE: GLenum = 0x884C;// groups: SamplerParameterI TextureParameterName
pub const GL_TEXTURE_COMPARE_FUNC: GLenum = 0x884D;// groups: SamplerParameterI TextureParameterName
pub const GL_POINT_SIZE_MIN: GLenum = 0x8126;// groups: PointParameterNameARB GetPName
pub const GL_POINT_SIZE_MAX: GLenum = 0x8127;// groups: PointParameterNameARB GetPName
pub const GL_POINT_DISTANCE_ATTENUATION: GLenum = 0x8129;// groups: PointParameterNameARB GetPName
pub const GL_GENERATE_MIPMAP: GLenum = 0x8191;// groups: InternalFormatPName TextureParameterName
pub const GL_GENERATE_MIPMAP_HINT: HintTarget = 0x8192;
pub const GL_FOG_COORDINATE_SOURCE: GLenum = 0x8450;
pub const GL_FOG_COORDINATE: FogCoordSrc = 0x8451;
pub const GL_FRAGMENT_DEPTH: GLenum = 0x8452;// groups: FogCoordSrc LightTextureModeEXT
pub const GL_CURRENT_FOG_COORDINATE: GLenum = 0x8453;
pub const GL_FOG_COORDINATE_ARRAY_TYPE: GLenum = 0x8454;
pub const GL_FOG_COORDINATE_ARRAY_STRIDE: GLenum = 0x8455;
pub const GL_FOG_COORDINATE_ARRAY_POINTER: GLenum = 0x8456;
pub const GL_FOG_COORDINATE_ARRAY: GLenum = 0x8457;
pub const GL_COLOR_SUM: GLenum = 0x8458;
pub const GL_CURRENT_SECONDARY_COLOR: GLenum = 0x8459;
pub const GL_SECONDARY_COLOR_ARRAY_SIZE: GLenum = 0x845A;
pub const GL_SECONDARY_COLOR_ARRAY_TYPE: GLenum = 0x845B;
pub const GL_SECONDARY_COLOR_ARRAY_STRIDE: GLenum = 0x845C;
pub const GL_SECONDARY_COLOR_ARRAY_POINTER: GLenum = 0x845D;
pub const GL_SECONDARY_COLOR_ARRAY: GLenum = 0x845E;
pub const GL_TEXTURE_FILTER_CONTROL: TextureEnvTarget = 0x8500;
pub const GL_DEPTH_TEXTURE_MODE: GLenum = 0x884B;
pub const GL_COMPARE_R_TO_TEXTURE: TextureCompareMode = 0x884E;
pub const GL_BLEND_COLOR: GetPName = 0x8005;
pub const GL_BLEND_EQUATION: GetPName = 0x8009;
pub const GL_CONSTANT_COLOR: BlendingFactor = 0x8001;
pub const GL_ONE_MINUS_CONSTANT_COLOR: BlendingFactor = 0x8002;
pub const GL_CONSTANT_ALPHA: BlendingFactor = 0x8003;
pub const GL_ONE_MINUS_CONSTANT_ALPHA: BlendingFactor = 0x8004;
pub const GL_FUNC_ADD: BlendEquationModeEXT = 0x8006;
pub const GL_FUNC_REVERSE_SUBTRACT: BlendEquationModeEXT = 0x800B;
pub const GL_FUNC_SUBTRACT: BlendEquationModeEXT = 0x800A;
pub const GL_MIN: BlendEquationModeEXT = 0x8007;
pub const GL_MAX: BlendEquationModeEXT = 0x8008;
pub const GL_BUFFER_SIZE: BufferPNameARB = 0x8764;
pub const GL_BUFFER_USAGE: BufferPNameARB = 0x8765;
pub const GL_QUERY_COUNTER_BITS: QueryParameterName = 0x8864;
pub const GL_CURRENT_QUERY: QueryParameterName = 0x8865;
pub const GL_QUERY_RESULT: QueryObjectParameterName = 0x8866;
pub const GL_QUERY_RESULT_AVAILABLE: QueryObjectParameterName = 0x8867;
pub const GL_ARRAY_BUFFER: GLenum = 0x8892;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_ELEMENT_ARRAY_BUFFER: GLenum = 0x8893;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_ARRAY_BUFFER_BINDING: GetPName = 0x8894;
pub const GL_ELEMENT_ARRAY_BUFFER_BINDING: GetPName = 0x8895;
pub const GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING: GLenum = 0x889F;// groups: VertexAttribEnum VertexAttribPropertyARB
pub const GL_READ_ONLY: BufferAccessARB = 0x88B8;
pub const GL_WRITE_ONLY: BufferAccessARB = 0x88B9;
pub const GL_READ_WRITE: BufferAccessARB = 0x88BA;
pub const GL_BUFFER_ACCESS: BufferPNameARB = 0x88BB;
pub const GL_BUFFER_MAPPED: BufferPNameARB = 0x88BC;
pub const GL_BUFFER_MAP_POINTER: BufferPointerNameARB = 0x88BD;
pub const GL_STREAM_DRAW: GLenum = 0x88E0;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_STREAM_READ: GLenum = 0x88E1;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_STREAM_COPY: GLenum = 0x88E2;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_STATIC_DRAW: GLenum = 0x88E4;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_STATIC_READ: GLenum = 0x88E5;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_STATIC_COPY: GLenum = 0x88E6;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_DYNAMIC_DRAW: GLenum = 0x88E8;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_DYNAMIC_READ: GLenum = 0x88E9;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_DYNAMIC_COPY: GLenum = 0x88EA;// groups: VertexBufferObjectUsage BufferUsageARB
pub const GL_SAMPLES_PASSED: QueryTarget = 0x8914;
pub const GL_SRC1_ALPHA: GLenum = 0x8589;// groups: TextureEnvParameter BlendingFactor
pub const GL_VERTEX_ARRAY_BUFFER_BINDING: GLenum = 0x8896;
pub const GL_NORMAL_ARRAY_BUFFER_BINDING: GLenum = 0x8897;
pub const GL_COLOR_ARRAY_BUFFER_BINDING: GLenum = 0x8898;
pub const GL_INDEX_ARRAY_BUFFER_BINDING: GLenum = 0x8899;
pub const GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING: GLenum = 0x889A;
pub const GL_EDGE_FLAG_ARRAY_BUFFER_BINDING: GLenum = 0x889B;
pub const GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING: GLenum = 0x889C;
pub const GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING: GLenum = 0x889D;
pub const GL_WEIGHT_ARRAY_BUFFER_BINDING: GLenum = 0x889E;
pub const GL_FOG_COORD_SRC: FogPName = 0x8450;
pub const GL_FOG_COORD: FogCoordSrc = 0x8451;
pub const GL_CURRENT_FOG_COORD: GLenum = 0x8453;
pub const GL_FOG_COORD_ARRAY_TYPE: GLenum = 0x8454;
pub const GL_FOG_COORD_ARRAY_STRIDE: GLenum = 0x8455;
pub const GL_FOG_COORD_ARRAY_POINTER: GLenum = 0x8456;
pub const GL_FOG_COORD_ARRAY: GLenum = 0x8457;
pub const GL_FOG_COORD_ARRAY_BUFFER_BINDING: GLenum = 0x889D;
pub const GL_SRC0_RGB: TextureEnvParameter = 0x8580;
pub const GL_SRC1_RGB: TextureEnvParameter = 0x8581;
pub const GL_SRC2_RGB: TextureEnvParameter = 0x8582;
pub const GL_SRC0_ALPHA: TextureEnvParameter = 0x8588;
pub const GL_SRC2_ALPHA: TextureEnvParameter = 0x858A;
pub const GL_BLEND_EQUATION_RGB: GetPName = 0x8009;
pub const GL_VERTEX_ATTRIB_ARRAY_ENABLED: GLenum = 0x8622;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_VERTEX_ATTRIB_ARRAY_SIZE: GLenum = 0x8623;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_VERTEX_ATTRIB_ARRAY_STRIDE: GLenum = 0x8624;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_VERTEX_ATTRIB_ARRAY_TYPE: GLenum = 0x8625;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_CURRENT_VERTEX_ATTRIB: GLenum = 0x8626;// groups: VertexAttribEnum VertexAttribPropertyARB
pub const GL_VERTEX_PROGRAM_POINT_SIZE: GLenum = 0x8642;
pub const GL_VERTEX_ATTRIB_ARRAY_POINTER: VertexAttribPointerPropertyARB = 0x8645;
pub const GL_STENCIL_BACK_FUNC: GetPName = 0x8800;
pub const GL_STENCIL_BACK_FAIL: GetPName = 0x8801;
pub const GL_STENCIL_BACK_PASS_DEPTH_FAIL: GetPName = 0x8802;
pub const GL_STENCIL_BACK_PASS_DEPTH_PASS: GetPName = 0x8803;
pub const GL_MAX_DRAW_BUFFERS: GetPName = 0x8824;
pub const GL_DRAW_BUFFER0: GLenum = 0x8825;
pub const GL_DRAW_BUFFER1: GLenum = 0x8826;
pub const GL_DRAW_BUFFER2: GLenum = 0x8827;
pub const GL_DRAW_BUFFER3: GLenum = 0x8828;
pub const GL_DRAW_BUFFER4: GLenum = 0x8829;
pub const GL_DRAW_BUFFER5: GLenum = 0x882A;
pub const GL_DRAW_BUFFER6: GLenum = 0x882B;
pub const GL_DRAW_BUFFER7: GLenum = 0x882C;
pub const GL_DRAW_BUFFER8: GLenum = 0x882D;
pub const GL_DRAW_BUFFER9: GLenum = 0x882E;
pub const GL_DRAW_BUFFER10: GLenum = 0x882F;
pub const GL_DRAW_BUFFER11: GLenum = 0x8830;
pub const GL_DRAW_BUFFER12: GLenum = 0x8831;
pub const GL_DRAW_BUFFER13: GLenum = 0x8832;
pub const GL_DRAW_BUFFER14: GLenum = 0x8833;
pub const GL_DRAW_BUFFER15: GLenum = 0x8834;
pub const GL_BLEND_EQUATION_ALPHA: GetPName = 0x883D;
pub const GL_MAX_VERTEX_ATTRIBS: GetPName = 0x8869;
pub const GL_VERTEX_ATTRIB_ARRAY_NORMALIZED: GLenum = 0x886A;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_MAX_TEXTURE_IMAGE_UNITS: GetPName = 0x8872;
pub const GL_FRAGMENT_SHADER: GLenum = 0x8B30;// groups: PipelineParameterName ShaderType
pub const GL_VERTEX_SHADER: GLenum = 0x8B31;// groups: PipelineParameterName ShaderType
pub const GL_MAX_FRAGMENT_UNIFORM_COMPONENTS: GetPName = 0x8B49;
pub const GL_MAX_VERTEX_UNIFORM_COMPONENTS: GetPName = 0x8B4A;
pub const GL_MAX_VARYING_FLOATS: GetPName = 0x8B4B;
pub const GL_MAX_VERTEX_TEXTURE_IMAGE_UNITS: GetPName = 0x8B4C;
pub const GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS: GetPName = 0x8B4D;
pub const GL_SHADER_TYPE: ShaderParameterName = 0x8B4F;
pub const GL_FLOAT_VEC2: GLenum = 0x8B50;// groups: AttributeType UniformType
pub const GL_FLOAT_VEC3: GLenum = 0x8B51;// groups: AttributeType UniformType
pub const GL_FLOAT_VEC4: GLenum = 0x8B52;// groups: AttributeType UniformType
pub const GL_INT_VEC2: GLenum = 0x8B53;// groups: AttributeType UniformType
pub const GL_INT_VEC3: GLenum = 0x8B54;// groups: AttributeType UniformType
pub const GL_INT_VEC4: GLenum = 0x8B55;// groups: AttributeType UniformType
pub const GL_BOOL: GLenum = 0x8B56;// groups: AttributeType UniformType
pub const GL_BOOL_VEC2: GLenum = 0x8B57;// groups: AttributeType UniformType
pub const GL_BOOL_VEC3: GLenum = 0x8B58;// groups: AttributeType UniformType
pub const GL_BOOL_VEC4: GLenum = 0x8B59;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT2: GLenum = 0x8B5A;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT3: GLenum = 0x8B5B;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT4: GLenum = 0x8B5C;// groups: AttributeType UniformType
pub const GL_SAMPLER_1D: GLenum = 0x8B5D;// groups: AttributeType UniformType
pub const GL_SAMPLER_2D: GLenum = 0x8B5E;// groups: AttributeType UniformType
pub const GL_SAMPLER_3D: GLenum = 0x8B5F;// groups: AttributeType UniformType
pub const GL_SAMPLER_CUBE: GLenum = 0x8B60;// groups: AttributeType UniformType
pub const GL_SAMPLER_1D_SHADOW: GLenum = 0x8B61;// groups: AttributeType UniformType
pub const GL_SAMPLER_2D_SHADOW: GLenum = 0x8B62;// groups: AttributeType UniformType
pub const GL_DELETE_STATUS: GLenum = 0x8B80;// groups: ProgramPropertyARB ShaderParameterName
pub const GL_COMPILE_STATUS: ShaderParameterName = 0x8B81;
pub const GL_LINK_STATUS: ProgramPropertyARB = 0x8B82;
pub const GL_VALIDATE_STATUS: ProgramPropertyARB = 0x8B83;
pub const GL_INFO_LOG_LENGTH: GLenum = 0x8B84;// groups: ProgramPropertyARB ShaderParameterName PipelineParameterName
pub const GL_ATTACHED_SHADERS: ProgramPropertyARB = 0x8B85;
pub const GL_ACTIVE_UNIFORMS: ProgramPropertyARB = 0x8B86;
pub const GL_ACTIVE_UNIFORM_MAX_LENGTH: ProgramPropertyARB = 0x8B87;
pub const GL_SHADER_SOURCE_LENGTH: ShaderParameterName = 0x8B88;
pub const GL_ACTIVE_ATTRIBUTES: ProgramPropertyARB = 0x8B89;
pub const GL_ACTIVE_ATTRIBUTE_MAX_LENGTH: ProgramPropertyARB = 0x8B8A;
pub const GL_FRAGMENT_SHADER_DERIVATIVE_HINT: GLenum = 0x8B8B;// groups: HintTarget GetPName
pub const GL_SHADING_LANGUAGE_VERSION: StringName = 0x8B8C;
pub const GL_CURRENT_PROGRAM: GetPName = 0x8B8D;
pub const GL_POINT_SPRITE_COORD_ORIGIN: GLenum = 0x8CA0;
pub const GL_LOWER_LEFT: ClipControlOrigin = 0x8CA1;
pub const GL_UPPER_LEFT: ClipControlOrigin = 0x8CA2;
pub const GL_STENCIL_BACK_REF: GetPName = 0x8CA3;
pub const GL_STENCIL_BACK_VALUE_MASK: GetPName = 0x8CA4;
pub const GL_STENCIL_BACK_WRITEMASK: GetPName = 0x8CA5;
pub const GL_VERTEX_PROGRAM_TWO_SIDE: GLenum = 0x8643;
pub const GL_POINT_SPRITE: TextureEnvTarget = 0x8861;
pub const GL_COORD_REPLACE: TextureEnvParameter = 0x8862;
pub const GL_MAX_TEXTURE_COORDS: GLenum = 0x8871;
pub const GL_PIXEL_PACK_BUFFER: GLenum = 0x88EB;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_PIXEL_UNPACK_BUFFER: GLenum = 0x88EC;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_PIXEL_PACK_BUFFER_BINDING: GetPName = 0x88ED;
pub const GL_PIXEL_UNPACK_BUFFER_BINDING: GetPName = 0x88EF;
pub const GL_FLOAT_MAT2x3: GLenum = 0x8B65;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT2x4: GLenum = 0x8B66;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT3x2: GLenum = 0x8B67;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT3x4: GLenum = 0x8B68;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT4x2: GLenum = 0x8B69;// groups: AttributeType UniformType
pub const GL_FLOAT_MAT4x3: GLenum = 0x8B6A;// groups: AttributeType UniformType
pub const GL_SRGB: InternalFormat = 0x8C40;
pub const GL_SRGB8: GLenum = 0x8C41;// groups: InternalFormat SizedInternalFormat
pub const GL_SRGB_ALPHA: InternalFormat = 0x8C42;
pub const GL_SRGB8_ALPHA8: GLenum = 0x8C43;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SRGB: InternalFormat = 0x8C48;
pub const GL_COMPRESSED_SRGB_ALPHA: InternalFormat = 0x8C49;
pub const GL_CURRENT_RASTER_SECONDARY_COLOR: GLenum = 0x845F;
pub const GL_SLUMINANCE_ALPHA: GLenum = 0x8C44;
pub const GL_SLUMINANCE8_ALPHA8: GLenum = 0x8C45;
pub const GL_SLUMINANCE: GLenum = 0x8C46;
pub const GL_SLUMINANCE8: GLenum = 0x8C47;
pub const GL_COMPRESSED_SLUMINANCE: GLenum = 0x8C4A;
pub const GL_COMPRESSED_SLUMINANCE_ALPHA: GLenum = 0x8C4B;
pub const GL_COMPARE_REF_TO_TEXTURE: TextureCompareMode = 0x884E;
pub const GL_CLIP_DISTANCE0: GLenum = 0x3000;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE1: GLenum = 0x3001;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE2: GLenum = 0x3002;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE3: GLenum = 0x3003;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE4: GLenum = 0x3004;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE5: GLenum = 0x3005;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE6: GLenum = 0x3006;// groups: EnableCap ClipPlaneName
pub const GL_CLIP_DISTANCE7: GLenum = 0x3007;// groups: EnableCap ClipPlaneName
pub const GL_MAX_CLIP_DISTANCES: GetPName = 0xD32;
pub const GL_MAJOR_VERSION: GetPName = 0x821B;
pub const GL_MINOR_VERSION: GetPName = 0x821C;
pub const GL_NUM_EXTENSIONS: GetPName = 0x821D;
pub const GL_CONTEXT_FLAGS: GetPName = 0x821E;
pub const GL_COMPRESSED_RED: InternalFormat = 0x8225;
pub const GL_COMPRESSED_RG: InternalFormat = 0x8226;
pub const GL_RGBA32F: GLenum = 0x8814;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB32F: GLenum = 0x8815;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA16F: GLenum = 0x881A;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB16F: GLenum = 0x881B;// groups: InternalFormat SizedInternalFormat
pub const GL_VERTEX_ATTRIB_ARRAY_INTEGER: GLenum = 0x88FD;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_MAX_ARRAY_TEXTURE_LAYERS: GetPName = 0x88FF;
pub const GL_MIN_PROGRAM_TEXEL_OFFSET: GetPName = 0x8904;
pub const GL_MAX_PROGRAM_TEXEL_OFFSET: GetPName = 0x8905;
pub const GL_CLAMP_READ_COLOR: ClampColorTargetARB = 0x891C;
pub const GL_FIXED_ONLY: ClampColorModeARB = 0x891D;
pub const GL_MAX_VARYING_COMPONENTS: GetPName = 0x8B4B;
pub const GL_TEXTURE_1D_ARRAY: GLenum = 0x8C18;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_PROXY_TEXTURE_1D_ARRAY: TextureTarget = 0x8C19;
pub const GL_TEXTURE_2D_ARRAY: GLenum = 0x8C1A;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_PROXY_TEXTURE_2D_ARRAY: TextureTarget = 0x8C1B;
pub const GL_TEXTURE_BINDING_1D_ARRAY: GetPName = 0x8C1C;
pub const GL_TEXTURE_BINDING_2D_ARRAY: GetPName = 0x8C1D;
pub const GL_R11F_G11F_B10F: GLenum = 0x8C3A;// groups: InternalFormat SizedInternalFormat
pub const GL_UNSIGNED_INT_10F_11F_11F_REV: GLenum = 0x8C3B;// groups: PixelType VertexAttribPointerType VertexAttribType
pub const GL_RGB9_E5: GLenum = 0x8C3D;// groups: InternalFormat SizedInternalFormat
pub const GL_UNSIGNED_INT_5_9_9_9_REV: PixelType = 0x8C3E;
pub const GL_TEXTURE_SHARED_SIZE: GLenum = 0x8C3F;
pub const GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH: ProgramPropertyARB = 0x8C76;
pub const GL_TRANSFORM_FEEDBACK_BUFFER_MODE: ProgramPropertyARB = 0x8C7F;
pub const GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS: GLenum = 0x8C80;
pub const GL_TRANSFORM_FEEDBACK_VARYINGS: ProgramPropertyARB = 0x8C83;
pub const GL_TRANSFORM_FEEDBACK_BUFFER_START: GLenum = 0x8C84;// groups: TransformFeedbackPName GetPName
pub const GL_TRANSFORM_FEEDBACK_BUFFER_SIZE: GLenum = 0x8C85;// groups: TransformFeedbackPName GetPName
pub const GL_PRIMITIVES_GENERATED: QueryTarget = 0x8C87;
pub const GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN: QueryTarget = 0x8C88;
pub const GL_RASTERIZER_DISCARD: EnableCap = 0x8C89;
pub const GL_MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS: GLenum = 0x8C8A;
pub const GL_MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS: GLenum = 0x8C8B;
pub const GL_INTERLEAVED_ATTRIBS: TransformFeedbackBufferMode = 0x8C8C;
pub const GL_SEPARATE_ATTRIBS: TransformFeedbackBufferMode = 0x8C8D;
pub const GL_TRANSFORM_FEEDBACK_BUFFER: GLenum = 0x8C8E;// groups: ProgramInterface BufferTargetARB BufferStorageTarget CopyBufferSubDataTarget
pub const GL_TRANSFORM_FEEDBACK_BUFFER_BINDING: GLenum = 0x8C8F;// groups: TransformFeedbackPName GetPName
pub const GL_RGBA32UI: GLenum = 0x8D70;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB32UI: GLenum = 0x8D71;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA16UI: GLenum = 0x8D76;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB16UI: GLenum = 0x8D77;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA8UI: GLenum = 0x8D7C;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB8UI: GLenum = 0x8D7D;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA32I: GLenum = 0x8D82;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB32I: GLenum = 0x8D83;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA16I: GLenum = 0x8D88;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB16I: GLenum = 0x8D89;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA8I: GLenum = 0x8D8E;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB8I: GLenum = 0x8D8F;// groups: InternalFormat SizedInternalFormat
pub const GL_RED_INTEGER: PixelFormat = 0x8D94;
pub const GL_GREEN_INTEGER: PixelFormat = 0x8D95;
pub const GL_BLUE_INTEGER: PixelFormat = 0x8D96;
pub const GL_RGB_INTEGER: PixelFormat = 0x8D98;
pub const GL_RGBA_INTEGER: PixelFormat = 0x8D99;
pub const GL_BGR_INTEGER: PixelFormat = 0x8D9A;
pub const GL_BGRA_INTEGER: PixelFormat = 0x8D9B;
pub const GL_SAMPLER_1D_ARRAY: UniformType = 0x8DC0;
pub const GL_SAMPLER_2D_ARRAY: UniformType = 0x8DC1;
pub const GL_SAMPLER_1D_ARRAY_SHADOW: GLenum = 0x8DC3;// groups: AttributeType UniformType
pub const GL_SAMPLER_2D_ARRAY_SHADOW: GLenum = 0x8DC4;// groups: AttributeType UniformType
pub const GL_SAMPLER_CUBE_SHADOW: GLenum = 0x8DC5;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_VEC2: GLenum = 0x8DC6;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_VEC3: GLenum = 0x8DC7;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_VEC4: GLenum = 0x8DC8;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_1D: GLenum = 0x8DC9;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_2D: GLenum = 0x8DCA;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_3D: GLenum = 0x8DCB;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_CUBE: GLenum = 0x8DCC;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_1D_ARRAY: GLenum = 0x8DCE;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_2D_ARRAY: GLenum = 0x8DCF;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_1D: GLenum = 0x8DD1;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_2D: GLenum = 0x8DD2;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_3D: GLenum = 0x8DD3;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_CUBE: GLenum = 0x8DD4;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_1D_ARRAY: GLenum = 0x8DD6;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_2D_ARRAY: GLenum = 0x8DD7;// groups: AttributeType UniformType
pub const GL_QUERY_WAIT: ConditionalRenderMode = 0x8E13;
pub const GL_QUERY_NO_WAIT: ConditionalRenderMode = 0x8E14;
pub const GL_QUERY_BY_REGION_WAIT: ConditionalRenderMode = 0x8E15;
pub const GL_QUERY_BY_REGION_NO_WAIT: ConditionalRenderMode = 0x8E16;
pub const GL_BUFFER_ACCESS_FLAGS: BufferPNameARB = 0x911F;
pub const GL_BUFFER_MAP_LENGTH: BufferPNameARB = 0x9120;
pub const GL_BUFFER_MAP_OFFSET: BufferPNameARB = 0x9121;
pub const GL_DEPTH_COMPONENT32F: GLenum = 0x8CAC;// groups: InternalFormat SizedInternalFormat
pub const GL_DEPTH32F_STENCIL8: GLenum = 0x8CAD;// groups: InternalFormat SizedInternalFormat
pub const GL_FLOAT_32_UNSIGNED_INT_24_8_REV: PixelType = 0x8DAD;
pub const GL_INVALID_FRAMEBUFFER_OPERATION: ErrorCode = 0x506;
pub const GL_FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING: FramebufferAttachmentParameterName = 0x8210;
pub const GL_FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE: FramebufferAttachmentParameterName = 0x8211;
pub const GL_FRAMEBUFFER_ATTACHMENT_RED_SIZE: FramebufferAttachmentParameterName = 0x8212;
pub const GL_FRAMEBUFFER_ATTACHMENT_GREEN_SIZE: FramebufferAttachmentParameterName = 0x8213;
pub const GL_FRAMEBUFFER_ATTACHMENT_BLUE_SIZE: FramebufferAttachmentParameterName = 0x8214;
pub const GL_FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE: FramebufferAttachmentParameterName = 0x8215;
pub const GL_FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE: FramebufferAttachmentParameterName = 0x8216;
pub const GL_FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE: FramebufferAttachmentParameterName = 0x8217;
pub const GL_FRAMEBUFFER_DEFAULT: GLenum = 0x8218;
pub const GL_FRAMEBUFFER_UNDEFINED: FramebufferStatus = 0x8219;
pub const GL_DEPTH_STENCIL_ATTACHMENT: GLenum = 0x821A;// groups: FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_MAX_RENDERBUFFER_SIZE: GetPName = 0x84E8;
pub const GL_DEPTH_STENCIL: GLenum = 0x84F9;// groups: InternalFormat PixelFormat
pub const GL_UNSIGNED_INT_24_8: PixelType = 0x84FA;
pub const GL_DEPTH24_STENCIL8: GLenum = 0x88F0;// groups: InternalFormat SizedInternalFormat
pub const GL_TEXTURE_STENCIL_SIZE: GLenum = 0x88F1;
pub const GL_TEXTURE_RED_TYPE: GLenum = 0x8C10;
pub const GL_TEXTURE_GREEN_TYPE: GLenum = 0x8C11;
pub const GL_TEXTURE_BLUE_TYPE: GLenum = 0x8C12;
pub const GL_TEXTURE_ALPHA_TYPE: GLenum = 0x8C13;
pub const GL_TEXTURE_DEPTH_TYPE: GLenum = 0x8C16;
pub const GL_UNSIGNED_NORMALIZED: GLenum = 0x8C17;
pub const GL_FRAMEBUFFER_BINDING: GLenum = 0x8CA6;
pub const GL_DRAW_FRAMEBUFFER_BINDING: GetPName = 0x8CA6;
pub const GL_RENDERBUFFER_BINDING: GetPName = 0x8CA7;
pub const GL_READ_FRAMEBUFFER: FramebufferTarget = 0x8CA8;
pub const GL_DRAW_FRAMEBUFFER: FramebufferTarget = 0x8CA9;
pub const GL_READ_FRAMEBUFFER_BINDING: GetPName = 0x8CAA;
pub const GL_RENDERBUFFER_SAMPLES: RenderbufferParameterName = 0x8CAB;
pub const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE: FramebufferAttachmentParameterName = 0x8CD0;
pub const GL_FRAMEBUFFER_ATTACHMENT_OBJECT_NAME: FramebufferAttachmentParameterName = 0x8CD1;
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL: FramebufferAttachmentParameterName = 0x8CD2;
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE: FramebufferAttachmentParameterName = 0x8CD3;
pub const GL_FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER: FramebufferAttachmentParameterName = 0x8CD4;
pub const GL_FRAMEBUFFER_COMPLETE: FramebufferStatus = 0x8CD5;
pub const GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT: FramebufferStatus = 0x8CD6;
pub const GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: FramebufferStatus = 0x8CD7;
pub const GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER: FramebufferStatus = 0x8CDB;
pub const GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER: FramebufferStatus = 0x8CDC;
pub const GL_FRAMEBUFFER_UNSUPPORTED: FramebufferStatus = 0x8CDD;
pub const GL_MAX_COLOR_ATTACHMENTS: GetPName = 0x8CDF;
pub const GL_COLOR_ATTACHMENT0: GLenum = 0x8CE0;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT1: GLenum = 0x8CE1;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT2: GLenum = 0x8CE2;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT3: GLenum = 0x8CE3;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT4: GLenum = 0x8CE4;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT5: GLenum = 0x8CE5;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT6: GLenum = 0x8CE6;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT7: GLenum = 0x8CE7;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT8: GLenum = 0x8CE8;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT9: GLenum = 0x8CE9;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT10: GLenum = 0x8CEA;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT11: GLenum = 0x8CEB;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT12: GLenum = 0x8CEC;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT13: GLenum = 0x8CED;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT14: GLenum = 0x8CEE;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT15: GLenum = 0x8CEF;// groups: ColorBuffer DrawBufferMode ReadBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT16: GLenum = 0x8CF0;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT17: GLenum = 0x8CF1;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT18: GLenum = 0x8CF2;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT19: GLenum = 0x8CF3;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT20: GLenum = 0x8CF4;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT21: GLenum = 0x8CF5;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT22: GLenum = 0x8CF6;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT23: GLenum = 0x8CF7;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT24: GLenum = 0x8CF8;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT25: GLenum = 0x8CF9;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT26: GLenum = 0x8CFA;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT27: GLenum = 0x8CFB;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT28: GLenum = 0x8CFC;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT29: GLenum = 0x8CFD;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT30: GLenum = 0x8CFE;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_COLOR_ATTACHMENT31: GLenum = 0x8CFF;// groups: ColorBuffer DrawBufferMode FramebufferAttachment InvalidateFramebufferAttachment
pub const GL_DEPTH_ATTACHMENT: GLenum = 0x8D00;// groups: InvalidateFramebufferAttachment FramebufferAttachment
pub const GL_STENCIL_ATTACHMENT: FramebufferAttachment = 0x8D20;
pub const GL_FRAMEBUFFER: GLenum = 0x8D40;// groups: ObjectIdentifier FramebufferTarget
pub const GL_RENDERBUFFER: GLenum = 0x8D41;// groups: ObjectIdentifier RenderbufferTarget CopyImageSubDataTarget TextureTarget
pub const GL_RENDERBUFFER_WIDTH: RenderbufferParameterName = 0x8D42;
pub const GL_RENDERBUFFER_HEIGHT: RenderbufferParameterName = 0x8D43;
pub const GL_RENDERBUFFER_INTERNAL_FORMAT: RenderbufferParameterName = 0x8D44;
pub const GL_STENCIL_INDEX1: GLenum = 0x8D46;// groups: InternalFormat SizedInternalFormat
pub const GL_STENCIL_INDEX4: GLenum = 0x8D47;// groups: InternalFormat SizedInternalFormat
pub const GL_STENCIL_INDEX8: GLenum = 0x8D48;// groups: InternalFormat SizedInternalFormat
pub const GL_STENCIL_INDEX16: GLenum = 0x8D49;// groups: InternalFormat SizedInternalFormat
pub const GL_RENDERBUFFER_RED_SIZE: RenderbufferParameterName = 0x8D50;
pub const GL_RENDERBUFFER_GREEN_SIZE: RenderbufferParameterName = 0x8D51;
pub const GL_RENDERBUFFER_BLUE_SIZE: RenderbufferParameterName = 0x8D52;
pub const GL_RENDERBUFFER_ALPHA_SIZE: RenderbufferParameterName = 0x8D53;
pub const GL_RENDERBUFFER_DEPTH_SIZE: RenderbufferParameterName = 0x8D54;
pub const GL_RENDERBUFFER_STENCIL_SIZE: RenderbufferParameterName = 0x8D55;
pub const GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE: FramebufferStatus = 0x8D56;
pub const GL_MAX_SAMPLES: GLenum = 0x8D57;
pub const GL_INDEX: GLenum = 0x8222;
pub const GL_TEXTURE_LUMINANCE_TYPE: GLenum = 0x8C14;
pub const GL_TEXTURE_INTENSITY_TYPE: GLenum = 0x8C15;
pub const GL_FRAMEBUFFER_SRGB: EnableCap = 0x8DB9;
pub const GL_HALF_FLOAT: GLenum = 0x140B;// groups: PixelType VertexAttribPointerType VertexAttribType
pub const GL_COMPRESSED_RED_RGTC1: GLenum = 0x8DBB;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SIGNED_RED_RGTC1: GLenum = 0x8DBC;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RG_RGTC2: GLenum = 0x8DBD;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SIGNED_RG_RGTC2: GLenum = 0x8DBE;// groups: InternalFormat SizedInternalFormat
pub const GL_RG: GLenum = 0x8227;// groups: InternalFormat PixelFormat
pub const GL_RG_INTEGER: PixelFormat = 0x8228;
pub const GL_R8: GLenum = 0x8229;// groups: InternalFormat SizedInternalFormat
pub const GL_R16: GLenum = 0x822A;// groups: InternalFormat SizedInternalFormat
pub const GL_RG8: GLenum = 0x822B;// groups: InternalFormat SizedInternalFormat
pub const GL_RG16: GLenum = 0x822C;// groups: InternalFormat SizedInternalFormat
pub const GL_R16F: GLenum = 0x822D;// groups: InternalFormat SizedInternalFormat
pub const GL_R32F: GLenum = 0x822E;// groups: InternalFormat SizedInternalFormat
pub const GL_RG16F: GLenum = 0x822F;// groups: InternalFormat SizedInternalFormat
pub const GL_RG32F: GLenum = 0x8230;// groups: InternalFormat SizedInternalFormat
pub const GL_R8I: GLenum = 0x8231;// groups: InternalFormat SizedInternalFormat
pub const GL_R8UI: GLenum = 0x8232;// groups: InternalFormat SizedInternalFormat
pub const GL_R16I: GLenum = 0x8233;// groups: InternalFormat SizedInternalFormat
pub const GL_R16UI: GLenum = 0x8234;// groups: InternalFormat SizedInternalFormat
pub const GL_R32I: GLenum = 0x8235;// groups: InternalFormat SizedInternalFormat
pub const GL_R32UI: GLenum = 0x8236;// groups: InternalFormat SizedInternalFormat
pub const GL_RG8I: GLenum = 0x8237;// groups: InternalFormat SizedInternalFormat
pub const GL_RG8UI: GLenum = 0x8238;// groups: InternalFormat SizedInternalFormat
pub const GL_RG16I: GLenum = 0x8239;// groups: InternalFormat SizedInternalFormat
pub const GL_RG16UI: GLenum = 0x823A;// groups: InternalFormat SizedInternalFormat
pub const GL_RG32I: GLenum = 0x823B;// groups: InternalFormat SizedInternalFormat
pub const GL_RG32UI: GLenum = 0x823C;// groups: InternalFormat SizedInternalFormat
pub const GL_VERTEX_ARRAY_BINDING: GetPName = 0x85B5;
pub const GL_CLAMP_VERTEX_COLOR: GLenum = 0x891A;
pub const GL_CLAMP_FRAGMENT_COLOR: GLenum = 0x891B;
pub const GL_ALPHA_INTEGER: GLenum = 0x8D97;
pub const GL_SAMPLER_2D_RECT: GLenum = 0x8B63;// groups: AttributeType UniformType
pub const GL_SAMPLER_2D_RECT_SHADOW: GLenum = 0x8B64;// groups: AttributeType UniformType
pub const GL_SAMPLER_BUFFER: GLenum = 0x8DC2;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_2D_RECT: GLenum = 0x8DCD;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_BUFFER: GLenum = 0x8DD0;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_2D_RECT: GLenum = 0x8DD5;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_BUFFER: GLenum = 0x8DD8;// groups: AttributeType UniformType
pub const GL_TEXTURE_BUFFER: GLenum = 0x8C2A;// groups: TextureTarget CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_MAX_TEXTURE_BUFFER_SIZE: GetPName = 0x8C2B;
pub const GL_TEXTURE_BINDING_BUFFER: GetPName = 0x8C2C;
pub const GL_TEXTURE_BUFFER_DATA_STORE_BINDING: GLenum = 0x8C2D;
pub const GL_TEXTURE_RECTANGLE: GLenum = 0x84F5;// groups: CopyImageSubDataTarget TextureTarget EnableCap
pub const GL_TEXTURE_BINDING_RECTANGLE: GetPName = 0x84F6;
pub const GL_PROXY_TEXTURE_RECTANGLE: TextureTarget = 0x84F7;
pub const GL_MAX_RECTANGLE_TEXTURE_SIZE: GetPName = 0x84F8;
pub const GL_R8_SNORM: GLenum = 0x8F94;// groups: InternalFormat SizedInternalFormat
pub const GL_RG8_SNORM: GLenum = 0x8F95;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB8_SNORM: GLenum = 0x8F96;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA8_SNORM: GLenum = 0x8F97;// groups: InternalFormat SizedInternalFormat
pub const GL_R16_SNORM: GLenum = 0x8F98;// groups: InternalFormat SizedInternalFormat
pub const GL_RG16_SNORM: GLenum = 0x8F99;// groups: InternalFormat SizedInternalFormat
pub const GL_RGB16_SNORM: GLenum = 0x8F9A;// groups: InternalFormat SizedInternalFormat
pub const GL_RGBA16_SNORM: GLenum = 0x8F9B;// groups: InternalFormat SizedInternalFormat
pub const GL_SIGNED_NORMALIZED: GLenum = 0x8F9C;
pub const GL_PRIMITIVE_RESTART: EnableCap = 0x8F9D;
pub const GL_PRIMITIVE_RESTART_INDEX: GetPName = 0x8F9E;
pub const GL_COPY_READ_BUFFER: GLenum = 0x8F36;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_COPY_WRITE_BUFFER: GLenum = 0x8F37;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_UNIFORM_BUFFER: GLenum = 0x8A11;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_UNIFORM_BUFFER_BINDING: GetPName = 0x8A28;
pub const GL_UNIFORM_BUFFER_START: GetPName = 0x8A29;
pub const GL_UNIFORM_BUFFER_SIZE: GetPName = 0x8A2A;
pub const GL_MAX_VERTEX_UNIFORM_BLOCKS: GetPName = 0x8A2B;
pub const GL_MAX_GEOMETRY_UNIFORM_BLOCKS: GetPName = 0x8A2C;
pub const GL_MAX_FRAGMENT_UNIFORM_BLOCKS: GetPName = 0x8A2D;
pub const GL_MAX_COMBINED_UNIFORM_BLOCKS: GetPName = 0x8A2E;
pub const GL_MAX_UNIFORM_BUFFER_BINDINGS: GetPName = 0x8A2F;
pub const GL_MAX_UNIFORM_BLOCK_SIZE: GetPName = 0x8A30;
pub const GL_MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS: GetPName = 0x8A31;
pub const GL_MAX_COMBINED_GEOMETRY_UNIFORM_COMPONENTS: GetPName = 0x8A32;
pub const GL_MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS: GetPName = 0x8A33;
pub const GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT: GetPName = 0x8A34;
pub const GL_ACTIVE_UNIFORM_BLOCK_MAX_NAME_LENGTH: ProgramPropertyARB = 0x8A35;
pub const GL_ACTIVE_UNIFORM_BLOCKS: ProgramPropertyARB = 0x8A36;
pub const GL_UNIFORM_TYPE: UniformPName = 0x8A37;
pub const GL_UNIFORM_SIZE: GLenum = 0x8A38;// groups: SubroutineParameterName UniformPName
pub const GL_UNIFORM_NAME_LENGTH: GLenum = 0x8A39;// groups: SubroutineParameterName UniformPName
pub const GL_UNIFORM_BLOCK_INDEX: UniformPName = 0x8A3A;
pub const GL_UNIFORM_OFFSET: UniformPName = 0x8A3B;
pub const GL_UNIFORM_ARRAY_STRIDE: UniformPName = 0x8A3C;
pub const GL_UNIFORM_MATRIX_STRIDE: UniformPName = 0x8A3D;
pub const GL_UNIFORM_IS_ROW_MAJOR: UniformPName = 0x8A3E;
pub const GL_UNIFORM_BLOCK_BINDING: UniformBlockPName = 0x8A3F;
pub const GL_UNIFORM_BLOCK_DATA_SIZE: UniformBlockPName = 0x8A40;
pub const GL_UNIFORM_BLOCK_NAME_LENGTH: UniformBlockPName = 0x8A41;
pub const GL_UNIFORM_BLOCK_ACTIVE_UNIFORMS: UniformBlockPName = 0x8A42;
pub const GL_UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES: UniformBlockPName = 0x8A43;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER: UniformBlockPName = 0x8A44;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_GEOMETRY_SHADER: UniformBlockPName = 0x8A45;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER: UniformBlockPName = 0x8A46;
pub const GL_INVALID_INDEX: SpecialNumbers = 0xFFFFFFFF;
pub const GL_LINES_ADJACENCY: PrimitiveType = 0xA;
pub const GL_LINE_STRIP_ADJACENCY: PrimitiveType = 0xB;
pub const GL_TRIANGLES_ADJACENCY: PrimitiveType = 0xC;
pub const GL_TRIANGLE_STRIP_ADJACENCY: PrimitiveType = 0xD;
pub const GL_PROGRAM_POINT_SIZE: GLenum = 0x8642;// groups: GetPName EnableCap
pub const GL_MAX_GEOMETRY_TEXTURE_IMAGE_UNITS: GetPName = 0x8C29;
pub const GL_FRAMEBUFFER_ATTACHMENT_LAYERED: FramebufferAttachmentParameterName = 0x8DA7;
pub const GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS: FramebufferStatus = 0x8DA8;
pub const GL_GEOMETRY_SHADER: GLenum = 0x8DD9;// groups: PipelineParameterName ShaderType
pub const GL_GEOMETRY_VERTICES_OUT: ProgramPropertyARB = 0x8916;
pub const GL_GEOMETRY_INPUT_TYPE: ProgramPropertyARB = 0x8917;
pub const GL_GEOMETRY_OUTPUT_TYPE: ProgramPropertyARB = 0x8918;
pub const GL_MAX_GEOMETRY_UNIFORM_COMPONENTS: GetPName = 0x8DDF;
pub const GL_MAX_GEOMETRY_OUTPUT_VERTICES: GLenum = 0x8DE0;
pub const GL_MAX_GEOMETRY_TOTAL_OUTPUT_COMPONENTS: GLenum = 0x8DE1;
pub const GL_MAX_VERTEX_OUTPUT_COMPONENTS: GetPName = 0x9122;
pub const GL_MAX_GEOMETRY_INPUT_COMPONENTS: GetPName = 0x9123;
pub const GL_MAX_GEOMETRY_OUTPUT_COMPONENTS: GetPName = 0x9124;
pub const GL_MAX_FRAGMENT_INPUT_COMPONENTS: GetPName = 0x9125;
pub const GL_CONTEXT_PROFILE_MASK: GetPName = 0x9126;
pub const GL_DEPTH_CLAMP: EnableCap = 0x864F;
pub const GL_QUADS_FOLLOW_PROVOKING_VERTEX_CONVENTION: GLenum = 0x8E4C;
pub const GL_FIRST_VERTEX_CONVENTION: VertexProvokingMode = 0x8E4D;
pub const GL_LAST_VERTEX_CONVENTION: VertexProvokingMode = 0x8E4E;
pub const GL_PROVOKING_VERTEX: GetPName = 0x8E4F;
pub const GL_TEXTURE_CUBE_MAP_SEAMLESS: EnableCap = 0x884F;
pub const GL_MAX_SERVER_WAIT_TIMEOUT: GetPName = 0x9111;
pub const GL_OBJECT_TYPE: SyncParameterName = 0x9112;
pub const GL_SYNC_CONDITION: SyncParameterName = 0x9113;
pub const GL_SYNC_STATUS: SyncParameterName = 0x9114;
pub const GL_SYNC_FLAGS: SyncParameterName = 0x9115;
pub const GL_SYNC_FENCE: GLenum = 0x9116;
pub const GL_SYNC_GPU_COMMANDS_COMPLETE: SyncCondition = 0x9117;
pub const GL_UNSIGNALED: GLenum = 0x9118;
pub const GL_SIGNALED: GLenum = 0x9119;
pub const GL_ALREADY_SIGNALED: SyncStatus = 0x911A;
pub const GL_TIMEOUT_EXPIRED: SyncStatus = 0x911B;
pub const GL_CONDITION_SATISFIED: SyncStatus = 0x911C;
pub const GL_WAIT_FAILED: SyncStatus = 0x911D;
pub const GL_TIMEOUT_IGNORED: SpecialNumbers = 0xFFFFFFFFFFFFFFFF;
pub const GL_SAMPLE_POSITION: GetMultisamplePNameNV = 0x8E50;
pub const GL_SAMPLE_MASK: EnableCap = 0x8E51;
pub const GL_SAMPLE_MASK_VALUE: GLenum = 0x8E52;
pub const GL_MAX_SAMPLE_MASK_WORDS: GetPName = 0x8E59;
pub const GL_TEXTURE_2D_MULTISAMPLE: GLenum = 0x9100;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_PROXY_TEXTURE_2D_MULTISAMPLE: TextureTarget = 0x9101;
pub const GL_TEXTURE_2D_MULTISAMPLE_ARRAY: GLenum = 0x9102;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_PROXY_TEXTURE_2D_MULTISAMPLE_ARRAY: TextureTarget = 0x9103;
pub const GL_TEXTURE_BINDING_2D_MULTISAMPLE: GetPName = 0x9104;
pub const GL_TEXTURE_BINDING_2D_MULTISAMPLE_ARRAY: GetPName = 0x9105;
pub const GL_TEXTURE_SAMPLES: GLenum = 0x9106;
pub const GL_TEXTURE_FIXED_SAMPLE_LOCATIONS: GLenum = 0x9107;
pub const GL_SAMPLER_2D_MULTISAMPLE: GLenum = 0x9108;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_2D_MULTISAMPLE: GLenum = 0x9109;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE: GLenum = 0x910A;// groups: AttributeType UniformType
pub const GL_SAMPLER_2D_MULTISAMPLE_ARRAY: GLenum = 0x910B;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_2D_MULTISAMPLE_ARRAY: GLenum = 0x910C;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_2D_MULTISAMPLE_ARRAY: GLenum = 0x910D;// groups: AttributeType UniformType
pub const GL_MAX_COLOR_TEXTURE_SAMPLES: GetPName = 0x910E;
pub const GL_MAX_DEPTH_TEXTURE_SAMPLES: GetPName = 0x910F;
pub const GL_MAX_INTEGER_SAMPLES: GetPName = 0x9110;
pub const GL_VERTEX_ATTRIB_ARRAY_DIVISOR: GLenum = 0x88FE;// groups: VertexAttribEnum VertexAttribPropertyARB VertexArrayPName
pub const GL_SRC1_COLOR: BlendingFactor = 0x88F9;
pub const GL_ONE_MINUS_SRC1_COLOR: BlendingFactor = 0x88FA;
pub const GL_ONE_MINUS_SRC1_ALPHA: BlendingFactor = 0x88FB;
pub const GL_MAX_DUAL_SOURCE_DRAW_BUFFERS: GetPName = 0x88FC;
pub const GL_ANY_SAMPLES_PASSED: QueryTarget = 0x8C2F;
pub const GL_SAMPLER_BINDING: GetPName = 0x8919;
pub const GL_RGB10_A2UI: GLenum = 0x906F;// groups: InternalFormat SizedInternalFormat
pub const GL_TEXTURE_SWIZZLE_R: TextureParameterName = 0x8E42;
pub const GL_TEXTURE_SWIZZLE_G: TextureParameterName = 0x8E43;
pub const GL_TEXTURE_SWIZZLE_B: TextureParameterName = 0x8E44;
pub const GL_TEXTURE_SWIZZLE_A: TextureParameterName = 0x8E45;
pub const GL_TEXTURE_SWIZZLE_RGBA: TextureParameterName = 0x8E46;
pub const GL_TIME_ELAPSED: QueryTarget = 0x88BF;
pub const GL_TIMESTAMP: GLenum = 0x8E28;// groups: QueryCounterTarget GetPName
pub const GL_INT_2_10_10_10_REV: GLenum = 0x8D9F;// groups: VertexAttribPointerType VertexAttribType
pub const GL_SAMPLE_SHADING: EnableCap = 0x8C36;
pub const GL_MIN_SAMPLE_SHADING_VALUE: GLenum = 0x8C37;
pub const GL_MIN_PROGRAM_TEXTURE_GATHER_OFFSET: GLenum = 0x8E5E;
pub const GL_MAX_PROGRAM_TEXTURE_GATHER_OFFSET: GLenum = 0x8E5F;
pub const GL_TEXTURE_CUBE_MAP_ARRAY: GLenum = 0x9009;// groups: CopyImageSubDataTarget TextureTarget
pub const GL_TEXTURE_BINDING_CUBE_MAP_ARRAY: GLenum = 0x900A;
pub const GL_PROXY_TEXTURE_CUBE_MAP_ARRAY: TextureTarget = 0x900B;
pub const GL_SAMPLER_CUBE_MAP_ARRAY: GLenum = 0x900C;// groups: AttributeType UniformType
pub const GL_SAMPLER_CUBE_MAP_ARRAY_SHADOW: GLenum = 0x900D;// groups: AttributeType UniformType
pub const GL_INT_SAMPLER_CUBE_MAP_ARRAY: GLenum = 0x900E;// groups: AttributeType UniformType
pub const GL_UNSIGNED_INT_SAMPLER_CUBE_MAP_ARRAY: GLenum = 0x900F;// groups: AttributeType UniformType
pub const GL_DRAW_INDIRECT_BUFFER: GLenum = 0x8F3F;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_DRAW_INDIRECT_BUFFER_BINDING: GLenum = 0x8F43;
pub const GL_GEOMETRY_SHADER_INVOCATIONS: GLenum = 0x887F;
pub const GL_MAX_GEOMETRY_SHADER_INVOCATIONS: GLenum = 0x8E5A;
pub const GL_MIN_FRAGMENT_INTERPOLATION_OFFSET: GLenum = 0x8E5B;
pub const GL_MAX_FRAGMENT_INTERPOLATION_OFFSET: GLenum = 0x8E5C;
pub const GL_FRAGMENT_INTERPOLATION_OFFSET_BITS: GLenum = 0x8E5D;
pub const GL_MAX_VERTEX_STREAMS: GLenum = 0x8E71;
pub const GL_DOUBLE_VEC2: GLenum = 0x8FFC;// groups: AttributeType UniformType
pub const GL_DOUBLE_VEC3: GLenum = 0x8FFD;// groups: AttributeType UniformType
pub const GL_DOUBLE_VEC4: GLenum = 0x8FFE;// groups: AttributeType UniformType
pub const GL_DOUBLE_MAT2: GLenum = 0x8F46;// groups: AttributeType UniformType
pub const GL_DOUBLE_MAT3: GLenum = 0x8F47;// groups: AttributeType UniformType
pub const GL_DOUBLE_MAT4: GLenum = 0x8F48;// groups: AttributeType UniformType
pub const GL_DOUBLE_MAT2x3: GLenum = 0x8F49;// groups: UniformType AttributeType
pub const GL_DOUBLE_MAT2x4: GLenum = 0x8F4A;// groups: UniformType AttributeType
pub const GL_DOUBLE_MAT3x2: GLenum = 0x8F4B;// groups: UniformType AttributeType
pub const GL_DOUBLE_MAT3x4: GLenum = 0x8F4C;// groups: UniformType AttributeType
pub const GL_DOUBLE_MAT4x2: GLenum = 0x8F4D;// groups: UniformType AttributeType
pub const GL_DOUBLE_MAT4x3: GLenum = 0x8F4E;// groups: UniformType AttributeType
pub const GL_ACTIVE_SUBROUTINES: ProgramStagePName = 0x8DE5;
pub const GL_ACTIVE_SUBROUTINE_UNIFORMS: ProgramStagePName = 0x8DE6;
pub const GL_ACTIVE_SUBROUTINE_UNIFORM_LOCATIONS: ProgramStagePName = 0x8E47;
pub const GL_ACTIVE_SUBROUTINE_MAX_LENGTH: ProgramStagePName = 0x8E48;
pub const GL_ACTIVE_SUBROUTINE_UNIFORM_MAX_LENGTH: ProgramStagePName = 0x8E49;
pub const GL_MAX_SUBROUTINES: GLenum = 0x8DE7;
pub const GL_MAX_SUBROUTINE_UNIFORM_LOCATIONS: GLenum = 0x8DE8;
pub const GL_NUM_COMPATIBLE_SUBROUTINES: GLenum = 0x8E4A;// groups: ProgramResourceProperty SubroutineParameterName
pub const GL_COMPATIBLE_SUBROUTINES: GLenum = 0x8E4B;// groups: ProgramResourceProperty SubroutineParameterName
pub const GL_PATCHES: PrimitiveType = 0xE;
pub const GL_PATCH_VERTICES: PatchParameterName = 0x8E72;
pub const GL_PATCH_DEFAULT_INNER_LEVEL: PatchParameterName = 0x8E73;
pub const GL_PATCH_DEFAULT_OUTER_LEVEL: PatchParameterName = 0x8E74;
pub const GL_TESS_CONTROL_OUTPUT_VERTICES: GLenum = 0x8E75;
pub const GL_TESS_GEN_MODE: GLenum = 0x8E76;
pub const GL_TESS_GEN_SPACING: GLenum = 0x8E77;
pub const GL_TESS_GEN_VERTEX_ORDER: GLenum = 0x8E78;
pub const GL_TESS_GEN_POINT_MODE: GLenum = 0x8E79;
pub const GL_ISOLINES: GLenum = 0x8E7A;
pub const GL_FRACTIONAL_ODD: GLenum = 0x8E7B;
pub const GL_FRACTIONAL_EVEN: GLenum = 0x8E7C;
pub const GL_MAX_PATCH_VERTICES: GLenum = 0x8E7D;
pub const GL_MAX_TESS_GEN_LEVEL: GLenum = 0x8E7E;
pub const GL_MAX_TESS_CONTROL_UNIFORM_COMPONENTS: GLenum = 0x8E7F;
pub const GL_MAX_TESS_EVALUATION_UNIFORM_COMPONENTS: GLenum = 0x8E80;
pub const GL_MAX_TESS_CONTROL_TEXTURE_IMAGE_UNITS: GLenum = 0x8E81;
pub const GL_MAX_TESS_EVALUATION_TEXTURE_IMAGE_UNITS: GLenum = 0x8E82;
pub const GL_MAX_TESS_CONTROL_OUTPUT_COMPONENTS: GLenum = 0x8E83;
pub const GL_MAX_TESS_PATCH_COMPONENTS: GLenum = 0x8E84;
pub const GL_MAX_TESS_CONTROL_TOTAL_OUTPUT_COMPONENTS: GLenum = 0x8E85;
pub const GL_MAX_TESS_EVALUATION_OUTPUT_COMPONENTS: GLenum = 0x8E86;
pub const GL_MAX_TESS_CONTROL_UNIFORM_BLOCKS: GetPName = 0x8E89;
pub const GL_MAX_TESS_EVALUATION_UNIFORM_BLOCKS: GetPName = 0x8E8A;
pub const GL_MAX_TESS_CONTROL_INPUT_COMPONENTS: GLenum = 0x886C;
pub const GL_MAX_TESS_EVALUATION_INPUT_COMPONENTS: GLenum = 0x886D;
pub const GL_MAX_COMBINED_TESS_CONTROL_UNIFORM_COMPONENTS: GLenum = 0x8E1E;
pub const GL_MAX_COMBINED_TESS_EVALUATION_UNIFORM_COMPONENTS: GLenum = 0x8E1F;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_CONTROL_SHADER: UniformBlockPName = 0x84F0;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_TESS_EVALUATION_SHADER: UniformBlockPName = 0x84F1;
pub const GL_TESS_EVALUATION_SHADER: GLenum = 0x8E87;// groups: PipelineParameterName ShaderType
pub const GL_TESS_CONTROL_SHADER: GLenum = 0x8E88;// groups: PipelineParameterName ShaderType
pub const GL_TRANSFORM_FEEDBACK: GLenum = 0x8E22;// groups: ObjectIdentifier BindTransformFeedbackTarget
pub const GL_TRANSFORM_FEEDBACK_BUFFER_PAUSED: GLenum = 0x8E23;
pub const GL_TRANSFORM_FEEDBACK_BUFFER_ACTIVE: GLenum = 0x8E24;
pub const GL_TRANSFORM_FEEDBACK_BINDING: GLenum = 0x8E25;
pub const GL_MAX_TRANSFORM_FEEDBACK_BUFFERS: GLenum = 0x8E70;
pub const GL_FIXED: GLenum = 0x140C;// groups: VertexAttribPointerType VertexAttribType
pub const GL_IMPLEMENTATION_COLOR_READ_TYPE: GLenum = 0x8B9A;// groups: GetFramebufferParameter GetPName
pub const GL_IMPLEMENTATION_COLOR_READ_FORMAT: GLenum = 0x8B9B;// groups: GetFramebufferParameter GetPName
pub const GL_LOW_FLOAT: PrecisionType = 0x8DF0;
pub const GL_MEDIUM_FLOAT: PrecisionType = 0x8DF1;
pub const GL_HIGH_FLOAT: PrecisionType = 0x8DF2;
pub const GL_LOW_INT: PrecisionType = 0x8DF3;
pub const GL_MEDIUM_INT: PrecisionType = 0x8DF4;
pub const GL_HIGH_INT: PrecisionType = 0x8DF5;
pub const GL_SHADER_COMPILER: GetPName = 0x8DFA;
pub const GL_SHADER_BINARY_FORMATS: GetPName = 0x8DF8;
pub const GL_NUM_SHADER_BINARY_FORMATS: GetPName = 0x8DF9;
pub const GL_MAX_VERTEX_UNIFORM_VECTORS: GetPName = 0x8DFB;
pub const GL_MAX_VARYING_VECTORS: GetPName = 0x8DFC;
pub const GL_MAX_FRAGMENT_UNIFORM_VECTORS: GetPName = 0x8DFD;
pub const GL_RGB565: GLenum = 0x8D62;// groups: InternalFormat SizedInternalFormat
pub const GL_PROGRAM_BINARY_RETRIEVABLE_HINT: GLenum = 0x8257;// groups: ProgramParameterPName HintTarget
pub const GL_PROGRAM_BINARY_LENGTH: ProgramPropertyARB = 0x8741;
pub const GL_NUM_PROGRAM_BINARY_FORMATS: GetPName = 0x87FE;
pub const GL_PROGRAM_BINARY_FORMATS: GetPName = 0x87FF;
pub const GL_PROGRAM_SEPARABLE: ProgramParameterPName = 0x8258;
pub const GL_ACTIVE_PROGRAM: PipelineParameterName = 0x8259;
pub const GL_PROGRAM_PIPELINE_BINDING: GetPName = 0x825A;
pub const GL_MAX_VIEWPORTS: GetPName = 0x825B;
pub const GL_VIEWPORT_SUBPIXEL_BITS: GetPName = 0x825C;
pub const GL_VIEWPORT_BOUNDS_RANGE: GetPName = 0x825D;
pub const GL_LAYER_PROVOKING_VERTEX: GetPName = 0x825E;
pub const GL_VIEWPORT_INDEX_PROVOKING_VERTEX: GetPName = 0x825F;
pub const GL_UNDEFINED_VERTEX: GLenum = 0x8260;
pub const GL_COPY_READ_BUFFER_BINDING: GLenum = 0x8F36;
pub const GL_COPY_WRITE_BUFFER_BINDING: GLenum = 0x8F37;
pub const GL_TRANSFORM_FEEDBACK_ACTIVE: TransformFeedbackPName = 0x8E24;
pub const GL_TRANSFORM_FEEDBACK_PAUSED: TransformFeedbackPName = 0x8E23;
pub const GL_UNPACK_COMPRESSED_BLOCK_WIDTH: GLenum = 0x9127;
pub const GL_UNPACK_COMPRESSED_BLOCK_HEIGHT: GLenum = 0x9128;
pub const GL_UNPACK_COMPRESSED_BLOCK_DEPTH: GLenum = 0x9129;
pub const GL_UNPACK_COMPRESSED_BLOCK_SIZE: GLenum = 0x912A;
pub const GL_PACK_COMPRESSED_BLOCK_WIDTH: GLenum = 0x912B;
pub const GL_PACK_COMPRESSED_BLOCK_HEIGHT: GLenum = 0x912C;
pub const GL_PACK_COMPRESSED_BLOCK_DEPTH: GLenum = 0x912D;
pub const GL_PACK_COMPRESSED_BLOCK_SIZE: GLenum = 0x912E;
pub const GL_NUM_SAMPLE_COUNTS: InternalFormatPName = 0x9380;
pub const GL_MIN_MAP_BUFFER_ALIGNMENT: GetPName = 0x90BC;
pub const GL_ATOMIC_COUNTER_BUFFER: GLenum = 0x92C0;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_ATOMIC_COUNTER_BUFFER_BINDING: AtomicCounterBufferPName = 0x92C1;
pub const GL_ATOMIC_COUNTER_BUFFER_START: GLenum = 0x92C2;
pub const GL_ATOMIC_COUNTER_BUFFER_SIZE: GLenum = 0x92C3;
pub const GL_ATOMIC_COUNTER_BUFFER_DATA_SIZE: AtomicCounterBufferPName = 0x92C4;
pub const GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTERS: AtomicCounterBufferPName = 0x92C5;
pub const GL_ATOMIC_COUNTER_BUFFER_ACTIVE_ATOMIC_COUNTER_INDICES: AtomicCounterBufferPName = 0x92C6;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_VERTEX_SHADER: AtomicCounterBufferPName = 0x92C7;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_CONTROL_SHADER: AtomicCounterBufferPName = 0x92C8;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_TESS_EVALUATION_SHADER: AtomicCounterBufferPName = 0x92C9;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_GEOMETRY_SHADER: AtomicCounterBufferPName = 0x92CA;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_FRAGMENT_SHADER: AtomicCounterBufferPName = 0x92CB;
pub const GL_MAX_VERTEX_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92CC;
pub const GL_MAX_TESS_CONTROL_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92CD;
pub const GL_MAX_TESS_EVALUATION_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92CE;
pub const GL_MAX_GEOMETRY_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92CF;
pub const GL_MAX_FRAGMENT_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92D0;
pub const GL_MAX_COMBINED_ATOMIC_COUNTER_BUFFERS: GLenum = 0x92D1;
pub const GL_MAX_VERTEX_ATOMIC_COUNTERS: GetPName = 0x92D2;
pub const GL_MAX_TESS_CONTROL_ATOMIC_COUNTERS: GetPName = 0x92D3;
pub const GL_MAX_TESS_EVALUATION_ATOMIC_COUNTERS: GetPName = 0x92D4;
pub const GL_MAX_GEOMETRY_ATOMIC_COUNTERS: GetPName = 0x92D5;
pub const GL_MAX_FRAGMENT_ATOMIC_COUNTERS: GetPName = 0x92D6;
pub const GL_MAX_COMBINED_ATOMIC_COUNTERS: GetPName = 0x92D7;
pub const GL_MAX_ATOMIC_COUNTER_BUFFER_SIZE: GLenum = 0x92D8;
pub const GL_MAX_ATOMIC_COUNTER_BUFFER_BINDINGS: GLenum = 0x92DC;
pub const GL_ACTIVE_ATOMIC_COUNTER_BUFFERS: ProgramPropertyARB = 0x92D9;
pub const GL_UNIFORM_ATOMIC_COUNTER_BUFFER_INDEX: UniformPName = 0x92DA;
pub const GL_UNSIGNED_INT_ATOMIC_COUNTER: GLenum = 0x92DB;
pub const GL_MAX_IMAGE_UNITS: GLenum = 0x8F38;
pub const GL_MAX_COMBINED_IMAGE_UNITS_AND_FRAGMENT_OUTPUTS: GLenum = 0x8F39;
pub const GL_IMAGE_BINDING_NAME: GLenum = 0x8F3A;
pub const GL_IMAGE_BINDING_LEVEL: GLenum = 0x8F3B;
pub const GL_IMAGE_BINDING_LAYERED: GLenum = 0x8F3C;
pub const GL_IMAGE_BINDING_LAYER: GLenum = 0x8F3D;
pub const GL_IMAGE_BINDING_ACCESS: GLenum = 0x8F3E;
pub const GL_IMAGE_1D: AttributeType = 0x904C;
pub const GL_IMAGE_2D: AttributeType = 0x904D;
pub const GL_IMAGE_3D: AttributeType = 0x904E;
pub const GL_IMAGE_2D_RECT: AttributeType = 0x904F;
pub const GL_IMAGE_CUBE: AttributeType = 0x9050;
pub const GL_IMAGE_BUFFER: AttributeType = 0x9051;
pub const GL_IMAGE_1D_ARRAY: AttributeType = 0x9052;
pub const GL_IMAGE_2D_ARRAY: AttributeType = 0x9053;
pub const GL_IMAGE_CUBE_MAP_ARRAY: AttributeType = 0x9054;
pub const GL_IMAGE_2D_MULTISAMPLE: AttributeType = 0x9055;
pub const GL_IMAGE_2D_MULTISAMPLE_ARRAY: AttributeType = 0x9056;
pub const GL_INT_IMAGE_1D: AttributeType = 0x9057;
pub const GL_INT_IMAGE_2D: AttributeType = 0x9058;
pub const GL_INT_IMAGE_3D: AttributeType = 0x9059;
pub const GL_INT_IMAGE_2D_RECT: AttributeType = 0x905A;
pub const GL_INT_IMAGE_CUBE: AttributeType = 0x905B;
pub const GL_INT_IMAGE_BUFFER: AttributeType = 0x905C;
pub const GL_INT_IMAGE_1D_ARRAY: AttributeType = 0x905D;
pub const GL_INT_IMAGE_2D_ARRAY: AttributeType = 0x905E;
pub const GL_INT_IMAGE_CUBE_MAP_ARRAY: AttributeType = 0x905F;
pub const GL_INT_IMAGE_2D_MULTISAMPLE: AttributeType = 0x9060;
pub const GL_INT_IMAGE_2D_MULTISAMPLE_ARRAY: AttributeType = 0x9061;
pub const GL_UNSIGNED_INT_IMAGE_1D: AttributeType = 0x9062;
pub const GL_UNSIGNED_INT_IMAGE_2D: AttributeType = 0x9063;
pub const GL_UNSIGNED_INT_IMAGE_3D: AttributeType = 0x9064;
pub const GL_UNSIGNED_INT_IMAGE_2D_RECT: AttributeType = 0x9065;
pub const GL_UNSIGNED_INT_IMAGE_CUBE: AttributeType = 0x9066;
pub const GL_UNSIGNED_INT_IMAGE_BUFFER: AttributeType = 0x9067;
pub const GL_UNSIGNED_INT_IMAGE_1D_ARRAY: AttributeType = 0x9068;
pub const GL_UNSIGNED_INT_IMAGE_2D_ARRAY: AttributeType = 0x9069;
pub const GL_UNSIGNED_INT_IMAGE_CUBE_MAP_ARRAY: AttributeType = 0x906A;
pub const GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE: AttributeType = 0x906B;
pub const GL_UNSIGNED_INT_IMAGE_2D_MULTISAMPLE_ARRAY: AttributeType = 0x906C;
pub const GL_MAX_IMAGE_SAMPLES: GLenum = 0x906D;
pub const GL_IMAGE_BINDING_FORMAT: GLenum = 0x906E;
pub const GL_IMAGE_FORMAT_COMPATIBILITY_TYPE: InternalFormatPName = 0x90C7;
pub const GL_IMAGE_FORMAT_COMPATIBILITY_BY_SIZE: GLenum = 0x90C8;
pub const GL_IMAGE_FORMAT_COMPATIBILITY_BY_CLASS: GLenum = 0x90C9;
pub const GL_MAX_VERTEX_IMAGE_UNIFORMS: GLenum = 0x90CA;
pub const GL_MAX_TESS_CONTROL_IMAGE_UNIFORMS: GLenum = 0x90CB;
pub const GL_MAX_TESS_EVALUATION_IMAGE_UNIFORMS: GLenum = 0x90CC;
pub const GL_MAX_GEOMETRY_IMAGE_UNIFORMS: GLenum = 0x90CD;
pub const GL_MAX_FRAGMENT_IMAGE_UNIFORMS: GLenum = 0x90CE;
pub const GL_MAX_COMBINED_IMAGE_UNIFORMS: GLenum = 0x90CF;
pub const GL_COMPRESSED_RGBA_BPTC_UNORM: GLenum = 0x8E8C;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SRGB_ALPHA_BPTC_UNORM: GLenum = 0x8E8D;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RGB_BPTC_SIGNED_FLOAT: GLenum = 0x8E8E;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RGB_BPTC_UNSIGNED_FLOAT: GLenum = 0x8E8F;// groups: InternalFormat SizedInternalFormat
pub const GL_TEXTURE_IMMUTABLE_FORMAT: GLenum = 0x912F;
pub const GL_NUM_SHADING_LANGUAGE_VERSIONS: GLenum = 0x82E9;
pub const GL_VERTEX_ATTRIB_ARRAY_LONG: GLenum = 0x874E;// groups: VertexArrayPName VertexAttribPropertyARB
pub const GL_COMPRESSED_RGB8_ETC2: GLenum = 0x9274;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SRGB8_ETC2: GLenum = 0x9275;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RGB8_PUNCHTHROUGH_ALPHA1_ETC2: GLenum = 0x9276;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SRGB8_PUNCHTHROUGH_ALPHA1_ETC2: GLenum = 0x9277;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RGBA8_ETC2_EAC: GLenum = 0x9278;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SRGB8_ALPHA8_ETC2_EAC: GLenum = 0x9279;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_R11_EAC: GLenum = 0x9270;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SIGNED_R11_EAC: GLenum = 0x9271;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_RG11_EAC: GLenum = 0x9272;// groups: InternalFormat SizedInternalFormat
pub const GL_COMPRESSED_SIGNED_RG11_EAC: GLenum = 0x9273;// groups: InternalFormat SizedInternalFormat
pub const GL_PRIMITIVE_RESTART_FIXED_INDEX: EnableCap = 0x8D69;
pub const GL_ANY_SAMPLES_PASSED_CONSERVATIVE: QueryTarget = 0x8D6A;
pub const GL_MAX_ELEMENT_INDEX: GetPName = 0x8D6B;
pub const GL_COMPUTE_SHADER: ShaderType = 0x91B9;
pub const GL_MAX_COMPUTE_UNIFORM_BLOCKS: GetPName = 0x91BB;
pub const GL_MAX_COMPUTE_TEXTURE_IMAGE_UNITS: GetPName = 0x91BC;
pub const GL_MAX_COMPUTE_IMAGE_UNIFORMS: GLenum = 0x91BD;
pub const GL_MAX_COMPUTE_SHARED_MEMORY_SIZE: GLenum = 0x8262;
pub const GL_MAX_COMPUTE_UNIFORM_COMPONENTS: GetPName = 0x8263;
pub const GL_MAX_COMPUTE_ATOMIC_COUNTER_BUFFERS: GetPName = 0x8264;
pub const GL_MAX_COMPUTE_ATOMIC_COUNTERS: GetPName = 0x8265;
pub const GL_MAX_COMBINED_COMPUTE_UNIFORM_COMPONENTS: GetPName = 0x8266;
pub const GL_MAX_COMPUTE_WORK_GROUP_INVOCATIONS: GetPName = 0x90EB;
pub const GL_MAX_COMPUTE_WORK_GROUP_COUNT: GetPName = 0x91BE;
pub const GL_MAX_COMPUTE_WORK_GROUP_SIZE: GetPName = 0x91BF;
pub const GL_COMPUTE_WORK_GROUP_SIZE: ProgramPropertyARB = 0x8267;
pub const GL_UNIFORM_BLOCK_REFERENCED_BY_COMPUTE_SHADER: UniformBlockPName = 0x90EC;
pub const GL_ATOMIC_COUNTER_BUFFER_REFERENCED_BY_COMPUTE_SHADER: AtomicCounterBufferPName = 0x90ED;
pub const GL_DISPATCH_INDIRECT_BUFFER: GLenum = 0x90EE;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_DISPATCH_INDIRECT_BUFFER_BINDING: GetPName = 0x90EF;
pub const GL_DEBUG_OUTPUT_SYNCHRONOUS: EnableCap = 0x8242;
pub const GL_DEBUG_NEXT_LOGGED_MESSAGE_LENGTH: GLenum = 0x8243;
pub const GL_DEBUG_CALLBACK_FUNCTION: GetPointervPName = 0x8244;
pub const GL_DEBUG_CALLBACK_USER_PARAM: GetPointervPName = 0x8245;
pub const GL_DEBUG_SOURCE_API: DebugSource = 0x8246;
pub const GL_DEBUG_SOURCE_WINDOW_SYSTEM: DebugSource = 0x8247;
pub const GL_DEBUG_SOURCE_SHADER_COMPILER: DebugSource = 0x8248;
pub const GL_DEBUG_SOURCE_THIRD_PARTY: DebugSource = 0x8249;
pub const GL_DEBUG_SOURCE_APPLICATION: DebugSource = 0x824A;
pub const GL_DEBUG_SOURCE_OTHER: DebugSource = 0x824B;
pub const GL_DEBUG_TYPE_ERROR: DebugType = 0x824C;
pub const GL_DEBUG_TYPE_DEPRECATED_BEHAVIOR: DebugType = 0x824D;
pub const GL_DEBUG_TYPE_UNDEFINED_BEHAVIOR: DebugType = 0x824E;
pub const GL_DEBUG_TYPE_PORTABILITY: DebugType = 0x824F;
pub const GL_DEBUG_TYPE_PERFORMANCE: DebugType = 0x8250;
pub const GL_DEBUG_TYPE_OTHER: DebugType = 0x8251;
pub const GL_MAX_DEBUG_MESSAGE_LENGTH: GLenum = 0x9143;
pub const GL_MAX_DEBUG_LOGGED_MESSAGES: GLenum = 0x9144;
pub const GL_DEBUG_LOGGED_MESSAGES: GLenum = 0x9145;
pub const GL_DEBUG_SEVERITY_HIGH: DebugSeverity = 0x9146;
pub const GL_DEBUG_SEVERITY_MEDIUM: DebugSeverity = 0x9147;
pub const GL_DEBUG_SEVERITY_LOW: DebugSeverity = 0x9148;
pub const GL_DEBUG_TYPE_MARKER: DebugType = 0x8268;
pub const GL_DEBUG_TYPE_PUSH_GROUP: DebugType = 0x8269;
pub const GL_DEBUG_TYPE_POP_GROUP: DebugType = 0x826A;
pub const GL_DEBUG_SEVERITY_NOTIFICATION: DebugSeverity = 0x826B;
pub const GL_MAX_DEBUG_GROUP_STACK_DEPTH: GetPName = 0x826C;
pub const GL_DEBUG_GROUP_STACK_DEPTH: GetPName = 0x826D;
pub const GL_BUFFER: ObjectIdentifier = 0x82E0;
pub const GL_SHADER: ObjectIdentifier = 0x82E1;
pub const GL_PROGRAM: ObjectIdentifier = 0x82E2;
pub const GL_QUERY: ObjectIdentifier = 0x82E3;
pub const GL_PROGRAM_PIPELINE: ObjectIdentifier = 0x82E4;
pub const GL_SAMPLER: ObjectIdentifier = 0x82E6;
pub const GL_MAX_LABEL_LENGTH: GetPName = 0x82E8;
pub const GL_DEBUG_OUTPUT: EnableCap = 0x92E0;
pub const GL_MAX_UNIFORM_LOCATIONS: GetPName = 0x826E;
pub const GL_FRAMEBUFFER_DEFAULT_WIDTH: GLenum = 0x9310;// groups: GetFramebufferParameter FramebufferParameterName
pub const GL_FRAMEBUFFER_DEFAULT_HEIGHT: GLenum = 0x9311;// groups: GetFramebufferParameter FramebufferParameterName
pub const GL_FRAMEBUFFER_DEFAULT_LAYERS: GLenum = 0x9312;// groups: GetFramebufferParameter FramebufferParameterName
pub const GL_FRAMEBUFFER_DEFAULT_SAMPLES: GLenum = 0x9313;// groups: GetFramebufferParameter FramebufferParameterName
pub const GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS: GLenum = 0x9314;// groups: GetFramebufferParameter FramebufferParameterName
pub const GL_MAX_FRAMEBUFFER_WIDTH: GetPName = 0x9315;
pub const GL_MAX_FRAMEBUFFER_HEIGHT: GetPName = 0x9316;
pub const GL_MAX_FRAMEBUFFER_LAYERS: GetPName = 0x9317;
pub const GL_MAX_FRAMEBUFFER_SAMPLES: GetPName = 0x9318;
pub const GL_INTERNALFORMAT_SUPPORTED: InternalFormatPName = 0x826F;
pub const GL_INTERNALFORMAT_PREFERRED: InternalFormatPName = 0x8270;
pub const GL_INTERNALFORMAT_RED_SIZE: InternalFormatPName = 0x8271;
pub const GL_INTERNALFORMAT_GREEN_SIZE: InternalFormatPName = 0x8272;
pub const GL_INTERNALFORMAT_BLUE_SIZE: InternalFormatPName = 0x8273;
pub const GL_INTERNALFORMAT_ALPHA_SIZE: InternalFormatPName = 0x8274;
pub const GL_INTERNALFORMAT_DEPTH_SIZE: InternalFormatPName = 0x8275;
pub const GL_INTERNALFORMAT_STENCIL_SIZE: InternalFormatPName = 0x8276;
pub const GL_INTERNALFORMAT_SHARED_SIZE: InternalFormatPName = 0x8277;
pub const GL_INTERNALFORMAT_RED_TYPE: InternalFormatPName = 0x8278;
pub const GL_INTERNALFORMAT_GREEN_TYPE: InternalFormatPName = 0x8279;
pub const GL_INTERNALFORMAT_BLUE_TYPE: InternalFormatPName = 0x827A;
pub const GL_INTERNALFORMAT_ALPHA_TYPE: InternalFormatPName = 0x827B;
pub const GL_INTERNALFORMAT_DEPTH_TYPE: InternalFormatPName = 0x827C;
pub const GL_INTERNALFORMAT_STENCIL_TYPE: InternalFormatPName = 0x827D;
pub const GL_MAX_WIDTH: InternalFormatPName = 0x827E;
pub const GL_MAX_HEIGHT: InternalFormatPName = 0x827F;
pub const GL_MAX_DEPTH: InternalFormatPName = 0x8280;
pub const GL_MAX_LAYERS: InternalFormatPName = 0x8281;
pub const GL_MAX_COMBINED_DIMENSIONS: GLenum = 0x8282;
pub const GL_COLOR_COMPONENTS: InternalFormatPName = 0x8283;
pub const GL_DEPTH_COMPONENTS: GLenum = 0x8284;
pub const GL_STENCIL_COMPONENTS: GLenum = 0x8285;
pub const GL_COLOR_RENDERABLE: InternalFormatPName = 0x8286;
pub const GL_DEPTH_RENDERABLE: InternalFormatPName = 0x8287;
pub const GL_STENCIL_RENDERABLE: InternalFormatPName = 0x8288;
pub const GL_FRAMEBUFFER_RENDERABLE: InternalFormatPName = 0x8289;
pub const GL_FRAMEBUFFER_RENDERABLE_LAYERED: InternalFormatPName = 0x828A;
pub const GL_FRAMEBUFFER_BLEND: InternalFormatPName = 0x828B;
pub const GL_READ_PIXELS: InternalFormatPName = 0x828C;
pub const GL_READ_PIXELS_FORMAT: InternalFormatPName = 0x828D;
pub const GL_READ_PIXELS_TYPE: InternalFormatPName = 0x828E;
pub const GL_TEXTURE_IMAGE_FORMAT: InternalFormatPName = 0x828F;
pub const GL_TEXTURE_IMAGE_TYPE: InternalFormatPName = 0x8290;
pub const GL_GET_TEXTURE_IMAGE_FORMAT: InternalFormatPName = 0x8291;
pub const GL_GET_TEXTURE_IMAGE_TYPE: InternalFormatPName = 0x8292;
pub const GL_MIPMAP: InternalFormatPName = 0x8293;
pub const GL_MANUAL_GENERATE_MIPMAP: GLenum = 0x8294;
pub const GL_AUTO_GENERATE_MIPMAP: InternalFormatPName = 0x8295;
pub const GL_COLOR_ENCODING: InternalFormatPName = 0x8296;
pub const GL_SRGB_READ: InternalFormatPName = 0x8297;
pub const GL_SRGB_WRITE: InternalFormatPName = 0x8298;
pub const GL_FILTER: InternalFormatPName = 0x829A;
pub const GL_VERTEX_TEXTURE: InternalFormatPName = 0x829B;
pub const GL_TESS_CONTROL_TEXTURE: InternalFormatPName = 0x829C;
pub const GL_TESS_EVALUATION_TEXTURE: InternalFormatPName = 0x829D;
pub const GL_GEOMETRY_TEXTURE: InternalFormatPName = 0x829E;
pub const GL_FRAGMENT_TEXTURE: InternalFormatPName = 0x829F;
pub const GL_COMPUTE_TEXTURE: InternalFormatPName = 0x82A0;
pub const GL_TEXTURE_SHADOW: InternalFormatPName = 0x82A1;
pub const GL_TEXTURE_GATHER: InternalFormatPName = 0x82A2;
pub const GL_TEXTURE_GATHER_SHADOW: InternalFormatPName = 0x82A3;
pub const GL_SHADER_IMAGE_LOAD: InternalFormatPName = 0x82A4;
pub const GL_SHADER_IMAGE_STORE: InternalFormatPName = 0x82A5;
pub const GL_SHADER_IMAGE_ATOMIC: InternalFormatPName = 0x82A6;
pub const GL_IMAGE_TEXEL_SIZE: InternalFormatPName = 0x82A7;
pub const GL_IMAGE_COMPATIBILITY_CLASS: InternalFormatPName = 0x82A8;
pub const GL_IMAGE_PIXEL_FORMAT: InternalFormatPName = 0x82A9;
pub const GL_IMAGE_PIXEL_TYPE: InternalFormatPName = 0x82AA;
pub const GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_TEST: InternalFormatPName = 0x82AC;
pub const GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_TEST: InternalFormatPName = 0x82AD;
pub const GL_SIMULTANEOUS_TEXTURE_AND_DEPTH_WRITE: InternalFormatPName = 0x82AE;
pub const GL_SIMULTANEOUS_TEXTURE_AND_STENCIL_WRITE: InternalFormatPName = 0x82AF;
pub const GL_TEXTURE_COMPRESSED_BLOCK_WIDTH: InternalFormatPName = 0x82B1;
pub const GL_TEXTURE_COMPRESSED_BLOCK_HEIGHT: InternalFormatPName = 0x82B2;
pub const GL_TEXTURE_COMPRESSED_BLOCK_SIZE: InternalFormatPName = 0x82B3;
pub const GL_CLEAR_BUFFER: InternalFormatPName = 0x82B4;
pub const GL_TEXTURE_VIEW: InternalFormatPName = 0x82B5;
pub const GL_VIEW_COMPATIBILITY_CLASS: InternalFormatPName = 0x82B6;
pub const GL_FULL_SUPPORT: GLenum = 0x82B7;
pub const GL_CAVEAT_SUPPORT: GLenum = 0x82B8;
pub const GL_IMAGE_CLASS_4_X_32: GLenum = 0x82B9;
pub const GL_IMAGE_CLASS_2_X_32: GLenum = 0x82BA;
pub const GL_IMAGE_CLASS_1_X_32: GLenum = 0x82BB;
pub const GL_IMAGE_CLASS_4_X_16: GLenum = 0x82BC;
pub const GL_IMAGE_CLASS_2_X_16: GLenum = 0x82BD;
pub const GL_IMAGE_CLASS_1_X_16: GLenum = 0x82BE;
pub const GL_IMAGE_CLASS_4_X_8: GLenum = 0x82BF;
pub const GL_IMAGE_CLASS_2_X_8: GLenum = 0x82C0;
pub const GL_IMAGE_CLASS_1_X_8: GLenum = 0x82C1;
pub const GL_IMAGE_CLASS_11_11_10: GLenum = 0x82C2;
pub const GL_IMAGE_CLASS_10_10_10_2: GLenum = 0x82C3;
pub const GL_VIEW_CLASS_128_BITS: GLenum = 0x82C4;
pub const GL_VIEW_CLASS_96_BITS: GLenum = 0x82C5;
pub const GL_VIEW_CLASS_64_BITS: GLenum = 0x82C6;
pub const GL_VIEW_CLASS_48_BITS: GLenum = 0x82C7;
pub const GL_VIEW_CLASS_32_BITS: GLenum = 0x82C8;
pub const GL_VIEW_CLASS_24_BITS: GLenum = 0x82C9;
pub const GL_VIEW_CLASS_16_BITS: GLenum = 0x82CA;
pub const GL_VIEW_CLASS_8_BITS: GLenum = 0x82CB;
pub const GL_VIEW_CLASS_S3TC_DXT1_RGB: GLenum = 0x82CC;
pub const GL_VIEW_CLASS_S3TC_DXT1_RGBA: GLenum = 0x82CD;
pub const GL_VIEW_CLASS_S3TC_DXT3_RGBA: GLenum = 0x82CE;
pub const GL_VIEW_CLASS_S3TC_DXT5_RGBA: GLenum = 0x82CF;
pub const GL_VIEW_CLASS_RGTC1_RED: GLenum = 0x82D0;
pub const GL_VIEW_CLASS_RGTC2_RG: GLenum = 0x82D1;
pub const GL_VIEW_CLASS_BPTC_UNORM: GLenum = 0x82D2;
pub const GL_VIEW_CLASS_BPTC_FLOAT: GLenum = 0x82D3;
pub const GL_UNIFORM: GLenum = 0x92E1;// groups: ProgramResourceProperty ProgramInterface
pub const GL_UNIFORM_BLOCK: ProgramInterface = 0x92E2;
pub const GL_PROGRAM_INPUT: ProgramInterface = 0x92E3;
pub const GL_PROGRAM_OUTPUT: ProgramInterface = 0x92E4;
pub const GL_BUFFER_VARIABLE: ProgramInterface = 0x92E5;
pub const GL_SHADER_STORAGE_BLOCK: ProgramInterface = 0x92E6;
pub const GL_VERTEX_SUBROUTINE: ProgramInterface = 0x92E8;
pub const GL_TESS_CONTROL_SUBROUTINE: ProgramInterface = 0x92E9;
pub const GL_TESS_EVALUATION_SUBROUTINE: ProgramInterface = 0x92EA;
pub const GL_GEOMETRY_SUBROUTINE: ProgramInterface = 0x92EB;
pub const GL_FRAGMENT_SUBROUTINE: ProgramInterface = 0x92EC;
pub const GL_COMPUTE_SUBROUTINE: ProgramInterface = 0x92ED;
pub const GL_VERTEX_SUBROUTINE_UNIFORM: ProgramInterface = 0x92EE;
pub const GL_TESS_CONTROL_SUBROUTINE_UNIFORM: ProgramInterface = 0x92EF;
pub const GL_TESS_EVALUATION_SUBROUTINE_UNIFORM: ProgramInterface = 0x92F0;
pub const GL_GEOMETRY_SUBROUTINE_UNIFORM: ProgramInterface = 0x92F1;
pub const GL_FRAGMENT_SUBROUTINE_UNIFORM: ProgramInterface = 0x92F2;
pub const GL_COMPUTE_SUBROUTINE_UNIFORM: ProgramInterface = 0x92F3;
pub const GL_TRANSFORM_FEEDBACK_VARYING: ProgramInterface = 0x92F4;
pub const GL_ACTIVE_RESOURCES: ProgramInterfacePName = 0x92F5;
pub const GL_MAX_NAME_LENGTH: ProgramInterfacePName = 0x92F6;
pub const GL_MAX_NUM_ACTIVE_VARIABLES: ProgramInterfacePName = 0x92F7;
pub const GL_MAX_NUM_COMPATIBLE_SUBROUTINES: ProgramInterfacePName = 0x92F8;
pub const GL_NAME_LENGTH: ProgramResourceProperty = 0x92F9;
pub const GL_TYPE: ProgramResourceProperty = 0x92FA;
pub const GL_ARRAY_SIZE: ProgramResourceProperty = 0x92FB;
pub const GL_OFFSET: ProgramResourceProperty = 0x92FC;
pub const GL_BLOCK_INDEX: ProgramResourceProperty = 0x92FD;
pub const GL_ARRAY_STRIDE: ProgramResourceProperty = 0x92FE;
pub const GL_MATRIX_STRIDE: ProgramResourceProperty = 0x92FF;
pub const GL_IS_ROW_MAJOR: ProgramResourceProperty = 0x9300;
pub const GL_ATOMIC_COUNTER_BUFFER_INDEX: ProgramResourceProperty = 0x9301;
pub const GL_BUFFER_BINDING: ProgramResourceProperty = 0x9302;
pub const GL_BUFFER_DATA_SIZE: ProgramResourceProperty = 0x9303;
pub const GL_NUM_ACTIVE_VARIABLES: ProgramResourceProperty = 0x9304;
pub const GL_ACTIVE_VARIABLES: ProgramResourceProperty = 0x9305;
pub const GL_REFERENCED_BY_VERTEX_SHADER: ProgramResourceProperty = 0x9306;
pub const GL_REFERENCED_BY_TESS_CONTROL_SHADER: ProgramResourceProperty = 0x9307;
pub const GL_REFERENCED_BY_TESS_EVALUATION_SHADER: ProgramResourceProperty = 0x9308;
pub const GL_REFERENCED_BY_GEOMETRY_SHADER: ProgramResourceProperty = 0x9309;
pub const GL_REFERENCED_BY_FRAGMENT_SHADER: ProgramResourceProperty = 0x930A;
pub const GL_REFERENCED_BY_COMPUTE_SHADER: ProgramResourceProperty = 0x930B;
pub const GL_TOP_LEVEL_ARRAY_SIZE: ProgramResourceProperty = 0x930C;
pub const GL_TOP_LEVEL_ARRAY_STRIDE: ProgramResourceProperty = 0x930D;
pub const GL_LOCATION: ProgramResourceProperty = 0x930E;
pub const GL_LOCATION_INDEX: ProgramResourceProperty = 0x930F;
pub const GL_IS_PER_PATCH: ProgramResourceProperty = 0x92E7;
pub const GL_SHADER_STORAGE_BUFFER: GLenum = 0x90D2;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_SHADER_STORAGE_BUFFER_BINDING: GetPName = 0x90D3;
pub const GL_SHADER_STORAGE_BUFFER_START: GetPName = 0x90D4;
pub const GL_SHADER_STORAGE_BUFFER_SIZE: GetPName = 0x90D5;
pub const GL_MAX_VERTEX_SHADER_STORAGE_BLOCKS: GetPName = 0x90D6;
pub const GL_MAX_GEOMETRY_SHADER_STORAGE_BLOCKS: GetPName = 0x90D7;
pub const GL_MAX_TESS_CONTROL_SHADER_STORAGE_BLOCKS: GetPName = 0x90D8;
pub const GL_MAX_TESS_EVALUATION_SHADER_STORAGE_BLOCKS: GetPName = 0x90D9;
pub const GL_MAX_FRAGMENT_SHADER_STORAGE_BLOCKS: GetPName = 0x90DA;
pub const GL_MAX_COMPUTE_SHADER_STORAGE_BLOCKS: GetPName = 0x90DB;
pub const GL_MAX_COMBINED_SHADER_STORAGE_BLOCKS: GetPName = 0x90DC;
pub const GL_MAX_SHADER_STORAGE_BUFFER_BINDINGS: GetPName = 0x90DD;
pub const GL_MAX_SHADER_STORAGE_BLOCK_SIZE: GLenum = 0x90DE;
pub const GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT: GetPName = 0x90DF;
pub const GL_MAX_COMBINED_SHADER_OUTPUT_RESOURCES: GLenum = 0x8F39;
pub const GL_DEPTH_STENCIL_TEXTURE_MODE: TextureParameterName = 0x90EA;
pub const GL_TEXTURE_BUFFER_OFFSET: GLenum = 0x919D;
pub const GL_TEXTURE_BUFFER_SIZE: GLenum = 0x919E;
pub const GL_TEXTURE_BUFFER_OFFSET_ALIGNMENT: GetPName = 0x919F;
pub const GL_TEXTURE_VIEW_MIN_LEVEL: GLenum = 0x82DB;
pub const GL_TEXTURE_VIEW_NUM_LEVELS: GLenum = 0x82DC;
pub const GL_TEXTURE_VIEW_MIN_LAYER: GLenum = 0x82DD;
pub const GL_TEXTURE_VIEW_NUM_LAYERS: GLenum = 0x82DE;
pub const GL_TEXTURE_IMMUTABLE_LEVELS: GLenum = 0x82DF;
pub const GL_VERTEX_ATTRIB_BINDING: VertexAttribPropertyARB = 0x82D4;
pub const GL_VERTEX_ATTRIB_RELATIVE_OFFSET: GLenum = 0x82D5;// groups: VertexArrayPName VertexAttribPropertyARB
pub const GL_VERTEX_BINDING_DIVISOR: GetPName = 0x82D6;
pub const GL_VERTEX_BINDING_OFFSET: GetPName = 0x82D7;
pub const GL_VERTEX_BINDING_STRIDE: GetPName = 0x82D8;
pub const GL_MAX_VERTEX_ATTRIB_RELATIVE_OFFSET: GetPName = 0x82D9;
pub const GL_MAX_VERTEX_ATTRIB_BINDINGS: GetPName = 0x82DA;
pub const GL_VERTEX_BINDING_BUFFER: GLenum = 0x8F4F;
pub const GL_DISPLAY_LIST: GLenum = 0x82E7;
pub const GL_MAX_VERTEX_ATTRIB_STRIDE: GLenum = 0x82E5;
pub const GL_PRIMITIVE_RESTART_FOR_PATCHES_SUPPORTED: GLenum = 0x8221;
pub const GL_TEXTURE_BUFFER_BINDING: GLenum = 0x8C2A;
pub const GL_BUFFER_IMMUTABLE_STORAGE: BufferPNameARB = 0x821F;
pub const GL_BUFFER_STORAGE_FLAGS: BufferPNameARB = 0x8220;
pub const GL_CLEAR_TEXTURE: InternalFormatPName = 0x9365;
pub const GL_LOCATION_COMPONENT: ProgramResourceProperty = 0x934A;
pub const GL_TRANSFORM_FEEDBACK_BUFFER_INDEX: ProgramResourceProperty = 0x934B;
pub const GL_TRANSFORM_FEEDBACK_BUFFER_STRIDE: ProgramResourceProperty = 0x934C;
pub const GL_QUERY_BUFFER: GLenum = 0x9192;// groups: CopyBufferSubDataTarget BufferTargetARB BufferStorageTarget
pub const GL_QUERY_BUFFER_BINDING: GLenum = 0x9193;
pub const GL_QUERY_RESULT_NO_WAIT: QueryObjectParameterName = 0x9194;
pub const GL_MIRROR_CLAMP_TO_EDGE: GLenum = 0x8743;
pub const GL_CONTEXT_LOST: GLenum = 0x507;
pub const GL_NEGATIVE_ONE_TO_ONE: ClipControlDepth = 0x935E;
pub const GL_ZERO_TO_ONE: ClipControlDepth = 0x935F;
pub const GL_CLIP_ORIGIN: GLenum = 0x935C;
pub const GL_CLIP_DEPTH_MODE: GLenum = 0x935D;
pub const GL_QUERY_WAIT_INVERTED: ConditionalRenderMode = 0x8E17;
pub const GL_QUERY_NO_WAIT_INVERTED: ConditionalRenderMode = 0x8E18;
pub const GL_QUERY_BY_REGION_WAIT_INVERTED: ConditionalRenderMode = 0x8E19;
pub const GL_QUERY_BY_REGION_NO_WAIT_INVERTED: ConditionalRenderMode = 0x8E1A;
pub const GL_MAX_CULL_DISTANCES: GLenum = 0x82F9;
pub const GL_MAX_COMBINED_CLIP_AND_CULL_DISTANCES: GLenum = 0x82FA;
pub const GL_TEXTURE_TARGET: GLenum = 0x1006;
pub const GL_QUERY_TARGET: QueryObjectParameterName = 0x82EA;
pub const GL_GUILTY_CONTEXT_RESET: GraphicsResetStatus = 0x8253;
pub const GL_INNOCENT_CONTEXT_RESET: GraphicsResetStatus = 0x8254;
pub const GL_UNKNOWN_CONTEXT_RESET: GraphicsResetStatus = 0x8255;
pub const GL_RESET_NOTIFICATION_STRATEGY: GLenum = 0x8256;
pub const GL_LOSE_CONTEXT_ON_RESET: GLenum = 0x8252;
pub const GL_NO_RESET_NOTIFICATION: GLenum = 0x8261;
pub const GL_COLOR_TABLE: GLenum = 0x80D0;// groups: ColorTableTarget ColorTableTargetSGI EnableCap
pub const GL_POST_CONVOLUTION_COLOR_TABLE: GLenum = 0x80D1;// groups: ColorTableTarget ColorTableTargetSGI EnableCap
pub const GL_POST_COLOR_MATRIX_COLOR_TABLE: GLenum = 0x80D2;// groups: ColorTableTarget ColorTableTargetSGI EnableCap
pub const GL_PROXY_COLOR_TABLE: GLenum = 0x80D3;// groups: ColorTableTargetSGI ColorTableTarget
pub const GL_PROXY_POST_CONVOLUTION_COLOR_TABLE: GLenum = 0x80D4;// groups: ColorTableTargetSGI ColorTableTarget
pub const GL_PROXY_POST_COLOR_MATRIX_COLOR_TABLE: GLenum = 0x80D5;// groups: ColorTableTargetSGI ColorTableTarget
pub const GL_CONVOLUTION_1D: GLenum = 0x8010;// groups: ConvolutionTarget ConvolutionTargetEXT
pub const GL_CONVOLUTION_2D: GLenum = 0x8011;// groups: ConvolutionTarget ConvolutionTargetEXT
pub const GL_SEPARABLE_2D: GLenum = 0x8012;// groups: SeparableTarget SeparableTargetEXT
pub const GL_HISTOGRAM: GLenum = 0x8024;// groups: HistogramTarget HistogramTargetEXT
pub const GL_PROXY_HISTOGRAM: GLenum = 0x8025;// groups: HistogramTarget HistogramTargetEXT
pub const GL_MINMAX: GLenum = 0x802E;// groups: MinmaxTarget MinmaxTargetEXT
pub const GL_CONTEXT_RELEASE_BEHAVIOR: GLenum = 0x82FB;
pub const GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH: GLenum = 0x82FC;
pub const GL_SHADER_BINARY_FORMAT_SPIR_V: ShaderBinaryFormat = 0x9551;
pub const GL_SPIR_V_BINARY: GLenum = 0x9552;
pub const GL_PARAMETER_BUFFER: BufferTargetARB = 0x80EE;
pub const GL_PARAMETER_BUFFER_BINDING: GLenum = 0x80EF;
pub const GL_VERTICES_SUBMITTED: QueryTarget = 0x82EE;
pub const GL_PRIMITIVES_SUBMITTED: QueryTarget = 0x82EF;
pub const GL_VERTEX_SHADER_INVOCATIONS: QueryTarget = 0x82F0;
pub const GL_TESS_CONTROL_SHADER_PATCHES: GLenum = 0x82F1;
pub const GL_TESS_EVALUATION_SHADER_INVOCATIONS: GLenum = 0x82F2;
pub const GL_GEOMETRY_SHADER_PRIMITIVES_EMITTED: GLenum = 0x82F3;
pub const GL_FRAGMENT_SHADER_INVOCATIONS: GLenum = 0x82F4;
pub const GL_COMPUTE_SHADER_INVOCATIONS: GLenum = 0x82F5;
pub const GL_CLIPPING_INPUT_PRIMITIVES: GLenum = 0x82F6;
pub const GL_CLIPPING_OUTPUT_PRIMITIVES: GLenum = 0x82F7;
pub const GL_POLYGON_OFFSET_CLAMP: GLenum = 0x8E1B;
pub const GL_SPIR_V_EXTENSIONS: GLenum = 0x9553;
pub const GL_NUM_SPIR_V_EXTENSIONS: GLenum = 0x9554;
pub const GL_TEXTURE_MAX_ANISOTROPY: GLenum = 0x84FE;// groups: SamplerParameterF TextureParameterName
pub const GL_MAX_TEXTURE_MAX_ANISOTROPY: GLenum = 0x84FF;
pub const GL_TRANSFORM_FEEDBACK_OVERFLOW: QueryTarget = 0x82EC;
pub const GL_TRANSFORM_FEEDBACK_STREAM_OVERFLOW: GLenum = 0x82ED;
pub const ProcTable = struct {
glCullFace: GLCULLFACEPROC = null,
glFrontFace: GLFRONTFACEPROC = null,
glHint: GLHINTPROC = null,
glLineWidth: GLLINEWIDTHPROC = null,
glPointSize: GLPOINTSIZEPROC = null,
glPolygonMode: GLPOLYGONMODEPROC = null,
glScissor: GLSCISSORPROC = null,
glTexParameterf: GLTEXPARAMETERFPROC = null,
glTexParameterfv: GLTEXPARAMETERFVPROC = null,
glTexParameteri: GLTEXPARAMETERIPROC = null,
glTexParameteriv: GLTEXPARAMETERIVPROC = null,
glTexImage1D: GLTEXIMAGE1DPROC = null,
glTexImage2D: GLTEXIMAGE2DPROC = null,
glDrawBuffer: GLDRAWBUFFERPROC = null,
glClear: GLCLEARPROC = null,
glClearColor: GLCLEARCOLORPROC = null,
glClearStencil: GLCLEARSTENCILPROC = null,
glClearDepth: GLCLEARDEPTHPROC = null,
glStencilMask: GLSTENCILMASKPROC = null,
glColorMask: GLCOLORMASKPROC = null,
glDepthMask: GLDEPTHMASKPROC = null,
glDisable: GLDISABLEPROC = null,
glEnable: GLENABLEPROC = null,
glFinish: GLFINISHPROC = null,
glFlush: GLFLUSHPROC = null,
glBlendFunc: GLBLENDFUNCPROC = null,
glLogicOp: GLLOGICOPPROC = null,
glStencilFunc: GLSTENCILFUNCPROC = null,
glStencilOp: GLSTENCILOPPROC = null,
glDepthFunc: GLDEPTHFUNCPROC = null,
glPixelStoref: GLPIXELSTOREFPROC = null,
glPixelStorei: GLPIXELSTOREIPROC = null,
glReadBuffer: GLREADBUFFERPROC = null,
glReadPixels: GLREADPIXELSPROC = null,
glGetBooleanv: GLGETBOOLEANVPROC = null,
glGetDoublev: GLGETDOUBLEVPROC = null,
glGetError: GLGETERRORPROC = null,
glGetFloatv: GLGETFLOATVPROC = null,
glGetIntegerv: GLGETINTEGERVPROC = null,
glGetString: GLGETSTRINGPROC = null,
glGetTexImage: GLGETTEXIMAGEPROC = null,
glGetTexParameterfv: GLGETTEXPARAMETERFVPROC = null,
glGetTexParameteriv: GLGETTEXPARAMETERIVPROC = null,
glGetTexLevelParameterfv: GLGETTEXLEVELPARAMETERFVPROC = null,
glGetTexLevelParameteriv: GLGETTEXLEVELPARAMETERIVPROC = null,
glIsEnabled: GLISENABLEDPROC = null,
glDepthRange: GLDEPTHRANGEPROC = null,
glViewport: GLVIEWPORTPROC = null,
glNewList: GLNEWLISTPROC = null,
glEndList: GLENDLISTPROC = null,
glCallList: GLCALLLISTPROC = null,
glCallLists: GLCALLLISTSPROC = null,
glDeleteLists: GLDELETELISTSPROC = null,
glGenLists: GLGENLISTSPROC = null,
glListBase: GLLISTBASEPROC = null,
glBegin: GLBEGINPROC = null,
glBitmap: GLBITMAPPROC = null,
glColor3b: GLCOLOR3BPROC = null,
glColor3bv: GLCOLOR3BVPROC = null,
glColor3d: GLCOLOR3DPROC = null,
glColor3dv: GLCOLOR3DVPROC = null,
glColor3f: GLCOLOR3FPROC = null,
glColor3fv: GLCOLOR3FVPROC = null,
glColor3i: GLCOLOR3IPROC = null,
glColor3iv: GLCOLOR3IVPROC = null,
glColor3s: GLCOLOR3SPROC = null,
glColor3sv: GLCOLOR3SVPROC = null,
glColor3ub: GLCOLOR3UBPROC = null,
glColor3ubv: GLCOLOR3UBVPROC = null,
glColor3ui: GLCOLOR3UIPROC = null,
glColor3uiv: GLCOLOR3UIVPROC = null,
glColor3us: GLCOLOR3USPROC = null,
glColor3usv: GLCOLOR3USVPROC = null,
glColor4b: GLCOLOR4BPROC = null,
glColor4bv: GLCOLOR4BVPROC = null,
glColor4d: GLCOLOR4DPROC = null,
glColor4dv: GLCOLOR4DVPROC = null,
glColor4f: GLCOLOR4FPROC = null,
glColor4fv: GLCOLOR4FVPROC = null,
glColor4i: GLCOLOR4IPROC = null,
glColor4iv: GLCOLOR4IVPROC = null,
glColor4s: GLCOLOR4SPROC = null,
glColor4sv: GLCOLOR4SVPROC = null,
glColor4ub: GLCOLOR4UBPROC = null,
glColor4ubv: GLCOLOR4UBVPROC = null,
glColor4ui: GLCOLOR4UIPROC = null,
glColor4uiv: GLCOLOR4UIVPROC = null,
glColor4us: GLCOLOR4USPROC = null,
glColor4usv: GLCOLOR4USVPROC = null,
glEdgeFlag: GLEDGEFLAGPROC = null,
glEdgeFlagv: GLEDGEFLAGVPROC = null,
glEnd: GLENDPROC = null,
glIndexd: GLINDEXDPROC = null,
glIndexdv: GLINDEXDVPROC = null,
glIndexf: GLINDEXFPROC = null,
glIndexfv: GLINDEXFVPROC = null,
glIndexi: GLINDEXIPROC = null,
glIndexiv: GLINDEXIVPROC = null,
glIndexs: GLINDEXSPROC = null,
glIndexsv: GLINDEXSVPROC = null,
glNormal3b: GLNORMAL3BPROC = null,
glNormal3bv: GLNORMAL3BVPROC = null,
glNormal3d: GLNORMAL3DPROC = null,
glNormal3dv: GLNORMAL3DVPROC = null,
glNormal3f: GLNORMAL3FPROC = null,
glNormal3fv: GLNORMAL3FVPROC = null,
glNormal3i: GLNORMAL3IPROC = null,
glNormal3iv: GLNORMAL3IVPROC = null,
glNormal3s: GLNORMAL3SPROC = null,
glNormal3sv: GLNORMAL3SVPROC = null,
glRasterPos2d: GLRASTERPOS2DPROC = null,
glRasterPos2dv: GLRASTERPOS2DVPROC = null,
glRasterPos2f: GLRASTERPOS2FPROC = null,
glRasterPos2fv: GLRASTERPOS2FVPROC = null,
glRasterPos2i: GLRASTERPOS2IPROC = null,
glRasterPos2iv: GLRASTERPOS2IVPROC = null,
glRasterPos2s: GLRASTERPOS2SPROC = null,
glRasterPos2sv: GLRASTERPOS2SVPROC = null,
glRasterPos3d: GLRASTERPOS3DPROC = null,
glRasterPos3dv: GLRASTERPOS3DVPROC = null,
glRasterPos3f: GLRASTERPOS3FPROC = null,
glRasterPos3fv: GLRASTERPOS3FVPROC = null,
glRasterPos3i: GLRASTERPOS3IPROC = null,
glRasterPos3iv: GLRASTERPOS3IVPROC = null,
glRasterPos3s: GLRASTERPOS3SPROC = null,
glRasterPos3sv: GLRASTERPOS3SVPROC = null,
glRasterPos4d: GLRASTERPOS4DPROC = null,
glRasterPos4dv: GLRASTERPOS4DVPROC = null,
glRasterPos4f: GLRASTERPOS4FPROC = null,
glRasterPos4fv: GLRASTERPOS4FVPROC = null,
glRasterPos4i: GLRASTERPOS4IPROC = null,
glRasterPos4iv: GLRASTERPOS4IVPROC = null,
glRasterPos4s: GLRASTERPOS4SPROC = null,
glRasterPos4sv: GLRASTERPOS4SVPROC = null,
glRectd: GLRECTDPROC = null,
glRectdv: GLRECTDVPROC = null,
glRectf: GLRECTFPROC = null,
glRectfv: GLRECTFVPROC = null,
glRecti: GLRECTIPROC = null,
glRectiv: GLRECTIVPROC = null,
glRects: GLRECTSPROC = null,
glRectsv: GLRECTSVPROC = null,
glTexCoord1d: GLTEXCOORD1DPROC = null,
glTexCoord1dv: GLTEXCOORD1DVPROC = null,
glTexCoord1f: GLTEXCOORD1FPROC = null,
glTexCoord1fv: GLTEXCOORD1FVPROC = null,
glTexCoord1i: GLTEXCOORD1IPROC = null,
glTexCoord1iv: GLTEXCOORD1IVPROC = null,
glTexCoord1s: GLTEXCOORD1SPROC = null,
glTexCoord1sv: GLTEXCOORD1SVPROC = null,
glTexCoord2d: GLTEXCOORD2DPROC = null,
glTexCoord2dv: GLTEXCOORD2DVPROC = null,
glTexCoord2f: GLTEXCOORD2FPROC = null,
glTexCoord2fv: GLTEXCOORD2FVPROC = null,
glTexCoord2i: GLTEXCOORD2IPROC = null,
glTexCoord2iv: GLTEXCOORD2IVPROC = null,
glTexCoord2s: GLTEXCOORD2SPROC = null,
glTexCoord2sv: GLTEXCOORD2SVPROC = null,
glTexCoord3d: GLTEXCOORD3DPROC = null,
glTexCoord3dv: GLTEXCOORD3DVPROC = null,
glTexCoord3f: GLTEXCOORD3FPROC = null,
glTexCoord3fv: GLTEXCOORD3FVPROC = null,
glTexCoord3i: GLTEXCOORD3IPROC = null,
glTexCoord3iv: GLTEXCOORD3IVPROC = null,
glTexCoord3s: GLTEXCOORD3SPROC = null,
glTexCoord3sv: GLTEXCOORD3SVPROC = null,
glTexCoord4d: GLTEXCOORD4DPROC = null,
glTexCoord4dv: GLTEXCOORD4DVPROC = null,
glTexCoord4f: GLTEXCOORD4FPROC = null,
glTexCoord4fv: GLTEXCOORD4FVPROC = null,
glTexCoord4i: GLTEXCOORD4IPROC = null,
glTexCoord4iv: GLTEXCOORD4IVPROC = null,
glTexCoord4s: GLTEXCOORD4SPROC = null,
glTexCoord4sv: GLTEXCOORD4SVPROC = null,
glVertex2d: GLVERTEX2DPROC = null,
glVertex2dv: GLVERTEX2DVPROC = null,
glVertex2f: GLVERTEX2FPROC = null,
glVertex2fv: GLVERTEX2FVPROC = null,
glVertex2i: GLVERTEX2IPROC = null,
glVertex2iv: GLVERTEX2IVPROC = null,
glVertex2s: GLVERTEX2SPROC = null,
glVertex2sv: GLVERTEX2SVPROC = null,
glVertex3d: GLVERTEX3DPROC = null,
glVertex3dv: GLVERTEX3DVPROC = null,
glVertex3f: GLVERTEX3FPROC = null,
glVertex3fv: GLVERTEX3FVPROC = null,
glVertex3i: GLVERTEX3IPROC = null,
glVertex3iv: GLVERTEX3IVPROC = null,
glVertex3s: GLVERTEX3SPROC = null,
glVertex3sv: GLVERTEX3SVPROC = null,
glVertex4d: GLVERTEX4DPROC = null,
glVertex4dv: GLVERTEX4DVPROC = null,
glVertex4f: GLVERTEX4FPROC = null,
glVertex4fv: GLVERTEX4FVPROC = null,
glVertex4i: GLVERTEX4IPROC = null,
glVertex4iv: GLVERTEX4IVPROC = null,
glVertex4s: GLVERTEX4SPROC = null,
glVertex4sv: GLVERTEX4SVPROC = null,
glClipPlane: GLCLIPPLANEPROC = null,
glColorMaterial: GLCOLORMATERIALPROC = null,
glFogf: GLFOGFPROC = null,
glFogfv: GLFOGFVPROC = null,
glFogi: GLFOGIPROC = null,
glFogiv: GLFOGIVPROC = null,
glLightf: GLLIGHTFPROC = null,
glLightfv: GLLIGHTFVPROC = null,
glLighti: GLLIGHTIPROC = null,
glLightiv: GLLIGHTIVPROC = null,
glLightModelf: GLLIGHTMODELFPROC = null,
glLightModelfv: GLLIGHTMODELFVPROC = null,
glLightModeli: GLLIGHTMODELIPROC = null,
glLightModeliv: GLLIGHTMODELIVPROC = null,
glLineStipple: GLLINESTIPPLEPROC = null,
glMaterialf: GLMATERIALFPROC = null,
glMaterialfv: GLMATERIALFVPROC = null,
glMateriali: GLMATERIALIPROC = null,
glMaterialiv: GLMATERIALIVPROC = null,
glPolygonStipple: GLPOLYGONSTIPPLEPROC = null,
glShadeModel: GLSHADEMODELPROC = null,
glTexEnvf: GLTEXENVFPROC = null,
glTexEnvfv: GLTEXENVFVPROC = null,
glTexEnvi: GLTEXENVIPROC = null,
glTexEnviv: GLTEXENVIVPROC = null,
glTexGend: GLTEXGENDPROC = null,
glTexGendv: GLTEXGENDVPROC = null,
glTexGenf: GLTEXGENFPROC = null,
glTexGenfv: GLTEXGENFVPROC = null,
glTexGeni: GLTEXGENIPROC = null,
glTexGeniv: GLTEXGENIVPROC = null,
glFeedbackBuffer: GLFEEDBACKBUFFERPROC = null,
glSelectBuffer: GLSELECTBUFFERPROC = null,
glRenderMode: GLRENDERMODEPROC = null,
glInitNames: GLINITNAMESPROC = null,
glLoadName: GLLOADNAMEPROC = null,
glPassThrough: GLPASSTHROUGHPROC = null,
glPopName: GLPOPNAMEPROC = null,
glPushName: GLPUSHNAMEPROC = null,
glClearAccum: GLCLEARACCUMPROC = null,
glClearIndex: GLCLEARINDEXPROC = null,
glIndexMask: GLINDEXMASKPROC = null,
glAccum: GLACCUMPROC = null,
glPopAttrib: GLPOPATTRIBPROC = null,
glPushAttrib: GLPUSHATTRIBPROC = null,
glMap1d: GLMAP1DPROC = null,
glMap1f: GLMAP1FPROC = null,
glMap2d: GLMAP2DPROC = null,
glMap2f: GLMAP2FPROC = null,
glMapGrid1d: GLMAPGRID1DPROC = null,
glMapGrid1f: GLMAPGRID1FPROC = null,
glMapGrid2d: GLMAPGRID2DPROC = null,
glMapGrid2f: GLMAPGRID2FPROC = null,
glEvalCoord1d: GLEVALCOORD1DPROC = null,
glEvalCoord1dv: GLEVALCOORD1DVPROC = null,
glEvalCoord1f: GLEVALCOORD1FPROC = null,
glEvalCoord1fv: GLEVALCOORD1FVPROC = null,
glEvalCoord2d: GLEVALCOORD2DPROC = null,
glEvalCoord2dv: GLEVALCOORD2DVPROC = null,
glEvalCoord2f: GLEVALCOORD2FPROC = null,
glEvalCoord2fv: GLEVALCOORD2FVPROC = null,
glEvalMesh1: GLEVALMESH1PROC = null,
glEvalPoint1: GLEVALPOINT1PROC = null,
glEvalMesh2: GLEVALMESH2PROC = null,
glEvalPoint2: GLEVALPOINT2PROC = null,
glAlphaFunc: GLALPHAFUNCPROC = null,
glPixelZoom: GLPIXELZOOMPROC = null,
glPixelTransferf: GLPIXELTRANSFERFPROC = null,
glPixelTransferi: GLPIXELTRANSFERIPROC = null,
glPixelMapfv: GLPIXELMAPFVPROC = null,
glPixelMapuiv: GLPIXELMAPUIVPROC = null,
glPixelMapusv: GLPIXELMAPUSVPROC = null,
glCopyPixels: GLCOPYPIXELSPROC = null,
glDrawPixels: GLDRAWPIXELSPROC = null,
glGetClipPlane: GLGETCLIPPLANEPROC = null,
glGetLightfv: GLGETLIGHTFVPROC = null,
glGetLightiv: GLGETLIGHTIVPROC = null,
glGetMapdv: GLGETMAPDVPROC = null,
glGetMapfv: GLGETMAPFVPROC = null,
glGetMapiv: GLGETMAPIVPROC = null,
glGetMaterialfv: GLGETMATERIALFVPROC = null,
glGetMaterialiv: GLGETMATERIALIVPROC = null,
glGetPixelMapfv: GLGETPIXELMAPFVPROC = null,
glGetPixelMapuiv: GLGETPIXELMAPUIVPROC = null,
glGetPixelMapusv: GLGETPIXELMAPUSVPROC = null,
glGetPolygonStipple: GLGETPOLYGONSTIPPLEPROC = null,
glGetTexEnvfv: GLGETTEXENVFVPROC = null,
glGetTexEnviv: GLGETTEXENVIVPROC = null,
glGetTexGendv: GLGETTEXGENDVPROC = null,
glGetTexGenfv: GLGETTEXGENFVPROC = null,
glGetTexGeniv: GLGETTEXGENIVPROC = null,
glIsList: GLISLISTPROC = null,
glFrustum: GLFRUSTUMPROC = null,
glLoadIdentity: GLLOADIDENTITYPROC = null,
glLoadMatrixf: GLLOADMATRIXFPROC = null,
glLoadMatrixd: GLLOADMATRIXDPROC = null,
glMatrixMode: GLMATRIXMODEPROC = null,
glMultMatrixf: GLMULTMATRIXFPROC = null,
glMultMatrixd: GLMULTMATRIXDPROC = null,
glOrtho: GLORTHOPROC = null,
glPopMatrix: GLPOPMATRIXPROC = null,
glPushMatrix: GLPUSHMATRIXPROC = null,
glRotated: GLROTATEDPROC = null,
glRotatef: GLROTATEFPROC = null,
glScaled: GLSCALEDPROC = null,
glScalef: GLSCALEFPROC = null,
glTranslated: GLTRANSLATEDPROC = null,
glTranslatef: GLTRANSLATEFPROC = null,
glDrawArrays: GLDRAWARRAYSPROC = null,
glDrawElements: GLDRAWELEMENTSPROC = null,
glGetPointerv: GLGETPOINTERVPROC = null,
glPolygonOffset: GLPOLYGONOFFSETPROC = null,
glCopyTexImage1D: GLCOPYTEXIMAGE1DPROC = null,
glCopyTexImage2D: GLCOPYTEXIMAGE2DPROC = null,
glCopyTexSubImage1D: GLCOPYTEXSUBIMAGE1DPROC = null,
glCopyTexSubImage2D: GLCOPYTEXSUBIMAGE2DPROC = null,
glTexSubImage1D: GLTEXSUBIMAGE1DPROC = null,
glTexSubImage2D: GLTEXSUBIMAGE2DPROC = null,
glBindTexture: GLBINDTEXTUREPROC = null,
glDeleteTextures: GLDELETETEXTURESPROC = null,
glGenTextures: GLGENTEXTURESPROC = null,
glIsTexture: GLISTEXTUREPROC = null,
glArrayElement: GLARRAYELEMENTPROC = null,
glColorPointer: GLCOLORPOINTERPROC = null,
glDisableClientState: GLDISABLECLIENTSTATEPROC = null,
glEdgeFlagPointer: GLEDGEFLAGPOINTERPROC = null,
glEnableClientState: GLENABLECLIENTSTATEPROC = null,
glIndexPointer: GLINDEXPOINTERPROC = null,
glInterleavedArrays: GLINTERLEAVEDARRAYSPROC = null,
glNormalPointer: GLNORMALPOINTERPROC = null,
glTexCoordPointer: GLTEXCOORDPOINTERPROC = null,
glVertexPointer: GLVERTEXPOINTERPROC = null,
glAreTexturesResident: GLARETEXTURESRESIDENTPROC = null,
glPrioritizeTextures: GLPRIORITIZETEXTURESPROC = null,
glIndexub: GLINDEXUBPROC = null,
glIndexubv: GLINDEXUBVPROC = null,
glPopClientAttrib: GLPOPCLIENTATTRIBPROC = null,
glPushClientAttrib: GLPUSHCLIENTATTRIBPROC = null,
glDrawRangeElements: GLDRAWRANGEELEMENTSPROC = null,
glTexImage3D: GLTEXIMAGE3DPROC = null,
glTexSubImage3D: GLTEXSUBIMAGE3DPROC = null,
glCopyTexSubImage3D: GLCOPYTEXSUBIMAGE3DPROC = null,
glActiveTexture: GLACTIVETEXTUREPROC = null,
glSampleCoverage: GLSAMPLECOVERAGEPROC = null,
glCompressedTexImage3D: GLCOMPRESSEDTEXIMAGE3DPROC = null,
glCompressedTexImage2D: GLCOMPRESSEDTEXIMAGE2DPROC = null,
glCompressedTexImage1D: GLCOMPRESSEDTEXIMAGE1DPROC = null,
glCompressedTexSubImage3D: GLCOMPRESSEDTEXSUBIMAGE3DPROC = null,
glCompressedTexSubImage2D: GLCOMPRESSEDTEXSUBIMAGE2DPROC = null,
glCompressedTexSubImage1D: GLCOMPRESSEDTEXSUBIMAGE1DPROC = null,
glGetCompressedTexImage: GLGETCOMPRESSEDTEXIMAGEPROC = null,
glClientActiveTexture: GLCLIENTACTIVETEXTUREPROC = null,
glMultiTexCoord1d: GLMULTITEXCOORD1DPROC = null,
glMultiTexCoord1dv: GLMULTITEXCOORD1DVPROC = null,
glMultiTexCoord1f: GLMULTITEXCOORD1FPROC = null,
glMultiTexCoord1fv: GLMULTITEXCOORD1FVPROC = null,
glMultiTexCoord1i: GLMULTITEXCOORD1IPROC = null,
glMultiTexCoord1iv: GLMULTITEXCOORD1IVPROC = null,
glMultiTexCoord1s: GLMULTITEXCOORD1SPROC = null,
glMultiTexCoord1sv: GLMULTITEXCOORD1SVPROC = null,
glMultiTexCoord2d: GLMULTITEXCOORD2DPROC = null,
glMultiTexCoord2dv: GLMULTITEXCOORD2DVPROC = null,
glMultiTexCoord2f: GLMULTITEXCOORD2FPROC = null,
glMultiTexCoord2fv: GLMULTITEXCOORD2FVPROC = null,
glMultiTexCoord2i: GLMULTITEXCOORD2IPROC = null,
glMultiTexCoord2iv: GLMULTITEXCOORD2IVPROC = null,
glMultiTexCoord2s: GLMULTITEXCOORD2SPROC = null,
glMultiTexCoord2sv: GLMULTITEXCOORD2SVPROC = null,
glMultiTexCoord3d: GLMULTITEXCOORD3DPROC = null,
glMultiTexCoord3dv: GLMULTITEXCOORD3DVPROC = null,
glMultiTexCoord3f: GLMULTITEXCOORD3FPROC = null,
glMultiTexCoord3fv: GLMULTITEXCOORD3FVPROC = null,
glMultiTexCoord3i: GLMULTITEXCOORD3IPROC = null,
glMultiTexCoord3iv: GLMULTITEXCOORD3IVPROC = null,
glMultiTexCoord3s: GLMULTITEXCOORD3SPROC = null,
glMultiTexCoord3sv: GLMULTITEXCOORD3SVPROC = null,
glMultiTexCoord4d: GLMULTITEXCOORD4DPROC = null,
glMultiTexCoord4dv: GLMULTITEXCOORD4DVPROC = null,
glMultiTexCoord4f: GLMULTITEXCOORD4FPROC = null,
glMultiTexCoord4fv: GLMULTITEXCOORD4FVPROC = null,
glMultiTexCoord4i: GLMULTITEXCOORD4IPROC = null,
glMultiTexCoord4iv: GLMULTITEXCOORD4IVPROC = null,
glMultiTexCoord4s: GLMULTITEXCOORD4SPROC = null,
glMultiTexCoord4sv: GLMULTITEXCOORD4SVPROC = null,
glLoadTransposeMatrixf: GLLOADTRANSPOSEMATRIXFPROC = null,
glLoadTransposeMatrixd: GLLOADTRANSPOSEMATRIXDPROC = null,
glMultTransposeMatrixf: GLMULTTRANSPOSEMATRIXFPROC = null,
glMultTransposeMatrixd: GLMULTTRANSPOSEMATRIXDPROC = null,
glBlendFuncSeparate: GLBLENDFUNCSEPARATEPROC = null,
glMultiDrawArrays: GLMULTIDRAWARRAYSPROC = null,
glMultiDrawElements: GLMULTIDRAWELEMENTSPROC = null,
glPointParameterf: GLPOINTPARAMETERFPROC = null,
glPointParameterfv: GLPOINTPARAMETERFVPROC = null,
glPointParameteri: GLPOINTPARAMETERIPROC = null,
glPointParameteriv: GLPOINTPARAMETERIVPROC = null,
glFogCoordf: GLFOGCOORDFPROC = null,
glFogCoordfv: GLFOGCOORDFVPROC = null,
glFogCoordd: GLFOGCOORDDPROC = null,
glFogCoorddv: GLFOGCOORDDVPROC = null,
glFogCoordPointer: GLFOGCOORDPOINTERPROC = null,
glSecondaryColor3b: GLSECONDARYCOLOR3BPROC = null,
glSecondaryColor3bv: GLSECONDARYCOLOR3BVPROC = null,
glSecondaryColor3d: GLSECONDARYCOLOR3DPROC = null,
glSecondaryColor3dv: GLSECONDARYCOLOR3DVPROC = null,
glSecondaryColor3f: GLSECONDARYCOLOR3FPROC = null,
glSecondaryColor3fv: GLSECONDARYCOLOR3FVPROC = null,
glSecondaryColor3i: GLSECONDARYCOLOR3IPROC = null,
glSecondaryColor3iv: GLSECONDARYCOLOR3IVPROC = null,
glSecondaryColor3s: GLSECONDARYCOLOR3SPROC = null,
glSecondaryColor3sv: GLSECONDARYCOLOR3SVPROC = null,
glSecondaryColor3ub: GLSECONDARYCOLOR3UBPROC = null,
glSecondaryColor3ubv: GLSECONDARYCOLOR3UBVPROC = null,
glSecondaryColor3ui: GLSECONDARYCOLOR3UIPROC = null,
glSecondaryColor3uiv: GLSECONDARYCOLOR3UIVPROC = null,
glSecondaryColor3us: GLSECONDARYCOLOR3USPROC = null,
glSecondaryColor3usv: GLSECONDARYCOLOR3USVPROC = null,
glSecondaryColorPointer: GLSECONDARYCOLORPOINTERPROC = null,
glWindowPos2d: GLWINDOWPOS2DPROC = null,
glWindowPos2dv: GLWINDOWPOS2DVPROC = null,
glWindowPos2f: GLWINDOWPOS2FPROC = null,
glWindowPos2fv: GLWINDOWPOS2FVPROC = null,
glWindowPos2i: GLWINDOWPOS2IPROC = null,
glWindowPos2iv: GLWINDOWPOS2IVPROC = null,
glWindowPos2s: GLWINDOWPOS2SPROC = null,
glWindowPos2sv: GLWINDOWPOS2SVPROC = null,
glWindowPos3d: GLWINDOWPOS3DPROC = null,
glWindowPos3dv: GLWINDOWPOS3DVPROC = null,
glWindowPos3f: GLWINDOWPOS3FPROC = null,
glWindowPos3fv: GLWINDOWPOS3FVPROC = null,
glWindowPos3i: GLWINDOWPOS3IPROC = null,
glWindowPos3iv: GLWINDOWPOS3IVPROC = null,
glWindowPos3s: GLWINDOWPOS3SPROC = null,
glWindowPos3sv: GLWINDOWPOS3SVPROC = null,
glBlendColor: GLBLENDCOLORPROC = null,
glBlendEquation: GLBLENDEQUATIONPROC = null,
glGenQueries: GLGENQUERIESPROC = null,
glDeleteQueries: GLDELETEQUERIESPROC = null,
glIsQuery: GLISQUERYPROC = null,
glBeginQuery: GLBEGINQUERYPROC = null,
glEndQuery: GLENDQUERYPROC = null,
glGetQueryiv: GLGETQUERYIVPROC = null,
glGetQueryObjectiv: GLGETQUERYOBJECTIVPROC = null,
glGetQueryObjectuiv: GLGETQUERYOBJECTUIVPROC = null,
glBindBuffer: GLBINDBUFFERPROC = null,
glDeleteBuffers: GLDELETEBUFFERSPROC = null,
glGenBuffers: GLGENBUFFERSPROC = null,
glIsBuffer: GLISBUFFERPROC = null,
glBufferData: GLBUFFERDATAPROC = null,
glBufferSubData: GLBUFFERSUBDATAPROC = null,
glGetBufferSubData: GLGETBUFFERSUBDATAPROC = null,
glMapBuffer: GLMAPBUFFERPROC = null,
glUnmapBuffer: GLUNMAPBUFFERPROC = null,
glGetBufferParameteriv: GLGETBUFFERPARAMETERIVPROC = null,
glGetBufferPointerv: GLGETBUFFERPOINTERVPROC = null,
glBlendEquationSeparate: GLBLENDEQUATIONSEPARATEPROC = null,
glDrawBuffers: GLDRAWBUFFERSPROC = null,
glStencilOpSeparate: GLSTENCILOPSEPARATEPROC = null,
glStencilFuncSeparate: GLSTENCILFUNCSEPARATEPROC = null,
glStencilMaskSeparate: GLSTENCILMASKSEPARATEPROC = null,
glAttachShader: GLATTACHSHADERPROC = null,
glBindAttribLocation: GLBINDATTRIBLOCATIONPROC = null,
glCompileShader: GLCOMPILESHADERPROC = null,
glCreateProgram: GLCREATEPROGRAMPROC = null,
glCreateShader: GLCREATESHADERPROC = null,
glDeleteProgram: GLDELETEPROGRAMPROC = null,
glDeleteShader: GLDELETESHADERPROC = null,
glDetachShader: GLDETACHSHADERPROC = null,
glDisableVertexAttribArray: GLDISABLEVERTEXATTRIBARRAYPROC = null,
glEnableVertexAttribArray: GLENABLEVERTEXATTRIBARRAYPROC = null,
glGetActiveAttrib: GLGETACTIVEATTRIBPROC = null,
glGetActiveUniform: GLGETACTIVEUNIFORMPROC = null,
glGetAttachedShaders: GLGETATTACHEDSHADERSPROC = null,
glGetAttribLocation: GLGETATTRIBLOCATIONPROC = null,
glGetProgramiv: GLGETPROGRAMIVPROC = null,
glGetProgramInfoLog: GLGETPROGRAMINFOLOGPROC = null,
glGetShaderiv: GLGETSHADERIVPROC = null,
glGetShaderInfoLog: GLGETSHADERINFOLOGPROC = null,
glGetShaderSource: GLGETSHADERSOURCEPROC = null,
glGetUniformLocation: GLGETUNIFORMLOCATIONPROC = null,
glGetUniformfv: GLGETUNIFORMFVPROC = null,
glGetUniformiv: GLGETUNIFORMIVPROC = null,
glGetVertexAttribdv: GLGETVERTEXATTRIBDVPROC = null,
glGetVertexAttribfv: GLGETVERTEXATTRIBFVPROC = null,
glGetVertexAttribiv: GLGETVERTEXATTRIBIVPROC = null,
glGetVertexAttribPointerv: GLGETVERTEXATTRIBPOINTERVPROC = null,
glIsProgram: GLISPROGRAMPROC = null,
glIsShader: GLISSHADERPROC = null,
glLinkProgram: GLLINKPROGRAMPROC = null,
glShaderSource: GLSHADERSOURCEPROC = null,
glUseProgram: GLUSEPROGRAMPROC = null,
glUniform1f: GLUNIFORM1FPROC = null,
glUniform2f: GLUNIFORM2FPROC = null,
glUniform3f: GLUNIFORM3FPROC = null,
glUniform4f: GLUNIFORM4FPROC = null,
glUniform1i: GLUNIFORM1IPROC = null,
glUniform2i: GLUNIFORM2IPROC = null,
glUniform3i: GLUNIFORM3IPROC = null,
glUniform4i: GLUNIFORM4IPROC = null,
glUniform1fv: GLUNIFORM1FVPROC = null,
glUniform2fv: GLUNIFORM2FVPROC = null,
glUniform3fv: GLUNIFORM3FVPROC = null,
glUniform4fv: GLUNIFORM4FVPROC = null,
glUniform1iv: GLUNIFORM1IVPROC = null,
glUniform2iv: GLUNIFORM2IVPROC = null,
glUniform3iv: GLUNIFORM3IVPROC = null,
glUniform4iv: GLUNIFORM4IVPROC = null,
glUniformMatrix2fv: GLUNIFORMMATRIX2FVPROC = null,
glUniformMatrix3fv: GLUNIFORMMATRIX3FVPROC = null,
glUniformMatrix4fv: GLUNIFORMMATRIX4FVPROC = null,
glValidateProgram: GLVALIDATEPROGRAMPROC = null,
glVertexAttrib1d: GLVERTEXATTRIB1DPROC = null,
glVertexAttrib1dv: GLVERTEXATTRIB1DVPROC = null,
glVertexAttrib1f: GLVERTEXATTRIB1FPROC = null,
glVertexAttrib1fv: GLVERTEXATTRIB1FVPROC = null,
glVertexAttrib1s: GLVERTEXATTRIB1SPROC = null,
glVertexAttrib1sv: GLVERTEXATTRIB1SVPROC = null,
glVertexAttrib2d: GLVERTEXATTRIB2DPROC = null,
glVertexAttrib2dv: GLVERTEXATTRIB2DVPROC = null,
glVertexAttrib2f: GLVERTEXATTRIB2FPROC = null,
glVertexAttrib2fv: GLVERTEXATTRIB2FVPROC = null,
glVertexAttrib2s: GLVERTEXATTRIB2SPROC = null,
glVertexAttrib2sv: GLVERTEXATTRIB2SVPROC = null,
glVertexAttrib3d: GLVERTEXATTRIB3DPROC = null,
glVertexAttrib3dv: GLVERTEXATTRIB3DVPROC = null,
glVertexAttrib3f: GLVERTEXATTRIB3FPROC = null,
glVertexAttrib3fv: GLVERTEXATTRIB3FVPROC = null,
glVertexAttrib3s: GLVERTEXATTRIB3SPROC = null,
glVertexAttrib3sv: GLVERTEXATTRIB3SVPROC = null,
glVertexAttrib4Nbv: GLVERTEXATTRIB4NBVPROC = null,
glVertexAttrib4Niv: GLVERTEXATTRIB4NIVPROC = null,
glVertexAttrib4Nsv: GLVERTEXATTRIB4NSVPROC = null,
glVertexAttrib4Nub: GLVERTEXATTRIB4NUBPROC = null,
glVertexAttrib4Nubv: GLVERTEXATTRIB4NUBVPROC = null,
glVertexAttrib4Nuiv: GLVERTEXATTRIB4NUIVPROC = null,
glVertexAttrib4Nusv: GLVERTEXATTRIB4NUSVPROC = null,
glVertexAttrib4bv: GLVERTEXATTRIB4BVPROC = null,
glVertexAttrib4d: GLVERTEXATTRIB4DPROC = null,
glVertexAttrib4dv: GLVERTEXATTRIB4DVPROC = null,
glVertexAttrib4f: GLVERTEXATTRIB4FPROC = null,
glVertexAttrib4fv: GLVERTEXATTRIB4FVPROC = null,
glVertexAttrib4iv: GLVERTEXATTRIB4IVPROC = null,
glVertexAttrib4s: GLVERTEXATTRIB4SPROC = null,
glVertexAttrib4sv: GLVERTEXATTRIB4SVPROC = null,
glVertexAttrib4ubv: GLVERTEXATTRIB4UBVPROC = null,
glVertexAttrib4uiv: GLVERTEXATTRIB4UIVPROC = null,
glVertexAttrib4usv: GLVERTEXATTRIB4USVPROC = null,
glVertexAttribPointer: GLVERTEXATTRIBPOINTERPROC = null,
glUniformMatrix2x3fv: GLUNIFORMMATRIX2X3FVPROC = null,
glUniformMatrix3x2fv: GLUNIFORMMATRIX3X2FVPROC = null,
glUniformMatrix2x4fv: GLUNIFORMMATRIX2X4FVPROC = null,
glUniformMatrix4x2fv: GLUNIFORMMATRIX4X2FVPROC = null,
glUniformMatrix3x4fv: GLUNIFORMMATRIX3X4FVPROC = null,
glUniformMatrix4x3fv: GLUNIFORMMATRIX4X3FVPROC = null,
glColorMaski: GLCOLORMASKIPROC = null,
glGetBooleani_v: GLGETBOOLEANI_VPROC = null,
glGetIntegeri_v: GLGETINTEGERI_VPROC = null,
glEnablei: GLENABLEIPROC = null,
glDisablei: GLDISABLEIPROC = null,
glIsEnabledi: GLISENABLEDIPROC = null,
glBeginTransformFeedback: GLBEGINTRANSFORMFEEDBACKPROC = null,
glEndTransformFeedback: GLENDTRANSFORMFEEDBACKPROC = null,
glBindBufferRange: GLBINDBUFFERRANGEPROC = null,
glBindBufferBase: GLBINDBUFFERBASEPROC = null,
glTransformFeedbackVaryings: GLTRANSFORMFEEDBACKVARYINGSPROC = null,
glGetTransformFeedbackVarying: GLGETTRANSFORMFEEDBACKVARYINGPROC = null,
glClampColor: GLCLAMPCOLORPROC = null,
glBeginConditionalRender: GLBEGINCONDITIONALRENDERPROC = null,
glEndConditionalRender: GLENDCONDITIONALRENDERPROC = null,
glVertexAttribIPointer: GLVERTEXATTRIBIPOINTERPROC = null,
glGetVertexAttribIiv: GLGETVERTEXATTRIBIIVPROC = null,
glGetVertexAttribIuiv: GLGETVERTEXATTRIBIUIVPROC = null,
glVertexAttribI1i: GLVERTEXATTRIBI1IPROC = null,
glVertexAttribI2i: GLVERTEXATTRIBI2IPROC = null,
glVertexAttribI3i: GLVERTEXATTRIBI3IPROC = null,
glVertexAttribI4i: GLVERTEXATTRIBI4IPROC = null,
glVertexAttribI1ui: GLVERTEXATTRIBI1UIPROC = null,
glVertexAttribI2ui: GLVERTEXATTRIBI2UIPROC = null,
glVertexAttribI3ui: GLVERTEXATTRIBI3UIPROC = null,
glVertexAttribI4ui: GLVERTEXATTRIBI4UIPROC = null,
glVertexAttribI1iv: GLVERTEXATTRIBI1IVPROC = null,
glVertexAttribI2iv: GLVERTEXATTRIBI2IVPROC = null,
glVertexAttribI3iv: GLVERTEXATTRIBI3IVPROC = null,
glVertexAttribI4iv: GLVERTEXATTRIBI4IVPROC = null,
glVertexAttribI1uiv: GLVERTEXATTRIBI1UIVPROC = null,
glVertexAttribI2uiv: GLVERTEXATTRIBI2UIVPROC = null,
glVertexAttribI3uiv: GLVERTEXATTRIBI3UIVPROC = null,
glVertexAttribI4uiv: GLVERTEXATTRIBI4UIVPROC = null,
glVertexAttribI4bv: GLVERTEXATTRIBI4BVPROC = null,
glVertexAttribI4sv: GLVERTEXATTRIBI4SVPROC = null,
glVertexAttribI4ubv: GLVERTEXATTRIBI4UBVPROC = null,
glVertexAttribI4usv: GLVERTEXATTRIBI4USVPROC = null,
glGetUniformuiv: GLGETUNIFORMUIVPROC = null,
glBindFragDataLocation: GLBINDFRAGDATALOCATIONPROC = null,
glGetFragDataLocation: GLGETFRAGDATALOCATIONPROC = null,
glUniform1ui: GLUNIFORM1UIPROC = null,
glUniform2ui: GLUNIFORM2UIPROC = null,
glUniform3ui: GLUNIFORM3UIPROC = null,
glUniform4ui: GLUNIFORM4UIPROC = null,
glUniform1uiv: GLUNIFORM1UIVPROC = null,
glUniform2uiv: GLUNIFORM2UIVPROC = null,
glUniform3uiv: GLUNIFORM3UIVPROC = null,
glUniform4uiv: GLUNIFORM4UIVPROC = null,
glTexParameterIiv: GLTEXPARAMETERIIVPROC = null,
glTexParameterIuiv: GLTEXPARAMETERIUIVPROC = null,
glGetTexParameterIiv: GLGETTEXPARAMETERIIVPROC = null,
glGetTexParameterIuiv: GLGETTEXPARAMETERIUIVPROC = null,
glClearBufferiv: GLCLEARBUFFERIVPROC = null,
glClearBufferuiv: GLCLEARBUFFERUIVPROC = null,
glClearBufferfv: GLCLEARBUFFERFVPROC = null,
glClearBufferfi: GLCLEARBUFFERFIPROC = null,
glGetStringi: GLGETSTRINGIPROC = null,
glIsRenderbuffer: GLISRENDERBUFFERPROC = null,
glBindRenderbuffer: GLBINDRENDERBUFFERPROC = null,
glDeleteRenderbuffers: GLDELETERENDERBUFFERSPROC = null,
glGenRenderbuffers: GLGENRENDERBUFFERSPROC = null,
glRenderbufferStorage: GLRENDERBUFFERSTORAGEPROC = null,
glGetRenderbufferParameteriv: GLGETRENDERBUFFERPARAMETERIVPROC = null,
glIsFramebuffer: GLISFRAMEBUFFERPROC = null,
glBindFramebuffer: GLBINDFRAMEBUFFERPROC = null,
glDeleteFramebuffers: GLDELETEFRAMEBUFFERSPROC = null,
glGenFramebuffers: GLGENFRAMEBUFFERSPROC = null,
glCheckFramebufferStatus: GLCHECKFRAMEBUFFERSTATUSPROC = null,
glFramebufferTexture1D: GLFRAMEBUFFERTEXTURE1DPROC = null,
glFramebufferTexture2D: GLFRAMEBUFFERTEXTURE2DPROC = null,
glFramebufferTexture3D: GLFRAMEBUFFERTEXTURE3DPROC = null,
glFramebufferRenderbuffer: GLFRAMEBUFFERRENDERBUFFERPROC = null,
glGetFramebufferAttachmentParameteriv: GLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC = null,
glGenerateMipmap: GLGENERATEMIPMAPPROC = null,
glBlitFramebuffer: GLBLITFRAMEBUFFERPROC = null,
glRenderbufferStorageMultisample: GLRENDERBUFFERSTORAGEMULTISAMPLEPROC = null,
glFramebufferTextureLayer: GLFRAMEBUFFERTEXTURELAYERPROC = null,
glMapBufferRange: GLMAPBUFFERRANGEPROC = null,
glFlushMappedBufferRange: GLFLUSHMAPPEDBUFFERRANGEPROC = null,
glBindVertexArray: GLBINDVERTEXARRAYPROC = null,
glDeleteVertexArrays: GLDELETEVERTEXARRAYSPROC = null,
glGenVertexArrays: GLGENVERTEXARRAYSPROC = null,
glIsVertexArray: GLISVERTEXARRAYPROC = null,
glDrawArraysInstanced: GLDRAWARRAYSINSTANCEDPROC = null,
glDrawElementsInstanced: GLDRAWELEMENTSINSTANCEDPROC = null,
glTexBuffer: GLTEXBUFFERPROC = null,
glPrimitiveRestartIndex: GLPRIMITIVERESTARTINDEXPROC = null,
glCopyBufferSubData: GLCOPYBUFFERSUBDATAPROC = null,
glGetUniformIndices: GLGETUNIFORMINDICESPROC = null,
glGetActiveUniformsiv: GLGETACTIVEUNIFORMSIVPROC = null,
glGetActiveUniformName: GLGETACTIVEUNIFORMNAMEPROC = null,
glGetUniformBlockIndex: GLGETUNIFORMBLOCKINDEXPROC = null,
glGetActiveUniformBlockiv: GLGETACTIVEUNIFORMBLOCKIVPROC = null,
glGetActiveUniformBlockName: GLGETACTIVEUNIFORMBLOCKNAMEPROC = null,
glUniformBlockBinding: GLUNIFORMBLOCKBINDINGPROC = null,
glDrawElementsBaseVertex: GLDRAWELEMENTSBASEVERTEXPROC = null,
glDrawRangeElementsBaseVertex: GLDRAWRANGEELEMENTSBASEVERTEXPROC = null,
glDrawElementsInstancedBaseVertex: GLDRAWELEMENTSINSTANCEDBASEVERTEXPROC = null,
glMultiDrawElementsBaseVertex: GLMULTIDRAWELEMENTSBASEVERTEXPROC = null,
glProvokingVertex: GLPROVOKINGVERTEXPROC = null,
glFenceSync: GLFENCESYNCPROC = null,
glIsSync: GLISSYNCPROC = null,
glDeleteSync: GLDELETESYNCPROC = null,
glClientWaitSync: GLCLIENTWAITSYNCPROC = null,
glWaitSync: GLWAITSYNCPROC = null,
glGetInteger64v: GLGETINTEGER64VPROC = null,
glGetSynciv: GLGETSYNCIVPROC = null,
glGetInteger64i_v: GLGETINTEGER64I_VPROC = null,
glGetBufferParameteri64v: GLGETBUFFERPARAMETERI64VPROC = null,
glFramebufferTexture: GLFRAMEBUFFERTEXTUREPROC = null,
glTexImage2DMultisample: GLTEXIMAGE2DMULTISAMPLEPROC = null,
glTexImage3DMultisample: GLTEXIMAGE3DMULTISAMPLEPROC = null,
glGetMultisamplefv: GLGETMULTISAMPLEFVPROC = null,
glSampleMaski: GLSAMPLEMASKIPROC = null,
glBindFragDataLocationIndexed: GLBINDFRAGDATALOCATIONINDEXEDPROC = null,
glGetFragDataIndex: GLGETFRAGDATAINDEXPROC = null,
glGenSamplers: GLGENSAMPLERSPROC = null,
glDeleteSamplers: GLDELETESAMPLERSPROC = null,
glIsSampler: GLISSAMPLERPROC = null,
glBindSampler: GLBINDSAMPLERPROC = null,
glSamplerParameteri: GLSAMPLERPARAMETERIPROC = null,
glSamplerParameteriv: GLSAMPLERPARAMETERIVPROC = null,
glSamplerParameterf: GLSAMPLERPARAMETERFPROC = null,
glSamplerParameterfv: GLSAMPLERPARAMETERFVPROC = null,
glSamplerParameterIiv: GLSAMPLERPARAMETERIIVPROC = null,
glSamplerParameterIuiv: GLSAMPLERPARAMETERIUIVPROC = null,
glGetSamplerParameteriv: GLGETSAMPLERPARAMETERIVPROC = null,
glGetSamplerParameterIiv: GLGETSAMPLERPARAMETERIIVPROC = null,
glGetSamplerParameterfv: GLGETSAMPLERPARAMETERFVPROC = null,
glGetSamplerParameterIuiv: GLGETSAMPLERPARAMETERIUIVPROC = null,
glQueryCounter: GLQUERYCOUNTERPROC = null,
glGetQueryObjecti64v: GLGETQUERYOBJECTI64VPROC = null,
glGetQueryObjectui64v: GLGETQUERYOBJECTUI64VPROC = null,
glVertexAttribDivisor: GLVERTEXATTRIBDIVISORPROC = null,
glVertexAttribP1ui: GLVERTEXATTRIBP1UIPROC = null,
glVertexAttribP1uiv: GLVERTEXATTRIBP1UIVPROC = null,
glVertexAttribP2ui: GLVERTEXATTRIBP2UIPROC = null,
glVertexAttribP2uiv: GLVERTEXATTRIBP2UIVPROC = null,
glVertexAttribP3ui: GLVERTEXATTRIBP3UIPROC = null,
glVertexAttribP3uiv: GLVERTEXATTRIBP3UIVPROC = null,
glVertexAttribP4ui: GLVERTEXATTRIBP4UIPROC = null,
glVertexAttribP4uiv: GLVERTEXATTRIBP4UIVPROC = null,
glVertexP2ui: GLVERTEXP2UIPROC = null,
glVertexP2uiv: GLVERTEXP2UIVPROC = null,
glVertexP3ui: GLVERTEXP3UIPROC = null,
glVertexP3uiv: GLVERTEXP3UIVPROC = null,
glVertexP4ui: GLVERTEXP4UIPROC = null,
glVertexP4uiv: GLVERTEXP4UIVPROC = null,
glTexCoordP1ui: GLTEXCOORDP1UIPROC = null,
glTexCoordP1uiv: GLTEXCOORDP1UIVPROC = null,
glTexCoordP2ui: GLTEXCOORDP2UIPROC = null,
glTexCoordP2uiv: GLTEXCOORDP2UIVPROC = null,
glTexCoordP3ui: GLTEXCOORDP3UIPROC = null,
glTexCoordP3uiv: GLTEXCOORDP3UIVPROC = null,
glTexCoordP4ui: GLTEXCOORDP4UIPROC = null,
glTexCoordP4uiv: GLTEXCOORDP4UIVPROC = null,
glMultiTexCoordP1ui: GLMULTITEXCOORDP1UIPROC = null,
glMultiTexCoordP1uiv: GLMULTITEXCOORDP1UIVPROC = null,
glMultiTexCoordP2ui: GLMULTITEXCOORDP2UIPROC = null,
glMultiTexCoordP2uiv: GLMULTITEXCOORDP2UIVPROC = null,
glMultiTexCoordP3ui: GLMULTITEXCOORDP3UIPROC = null,
glMultiTexCoordP3uiv: GLMULTITEXCOORDP3UIVPROC = null,
glMultiTexCoordP4ui: GLMULTITEXCOORDP4UIPROC = null,
glMultiTexCoordP4uiv: GLMULTITEXCOORDP4UIVPROC = null,
glNormalP3ui: GLNORMALP3UIPROC = null,
glNormalP3uiv: GLNORMALP3UIVPROC = null,
glColorP3ui: GLCOLORP3UIPROC = null,
glColorP3uiv: GLCOLORP3UIVPROC = null,
glColorP4ui: GLCOLORP4UIPROC = null,
glColorP4uiv: GLCOLORP4UIVPROC = null,
glSecondaryColorP3ui: GLSECONDARYCOLORP3UIPROC = null,
glSecondaryColorP3uiv: GLSECONDARYCOLORP3UIVPROC = null,
glMinSampleShading: GLMINSAMPLESHADINGPROC = null,
glBlendEquationi: GLBLENDEQUATIONIPROC = null,
glBlendEquationSeparatei: GLBLENDEQUATIONSEPARATEIPROC = null,
glBlendFunci: GLBLENDFUNCIPROC = null,
glBlendFuncSeparatei: GLBLENDFUNCSEPARATEIPROC = null,
glDrawArraysIndirect: GLDRAWARRAYSINDIRECTPROC = null,
glDrawElementsIndirect: GLDRAWELEMENTSINDIRECTPROC = null,
glUniform1d: GLUNIFORM1DPROC = null,
glUniform2d: GLUNIFORM2DPROC = null,
glUniform3d: GLUNIFORM3DPROC = null,
glUniform4d: GLUNIFORM4DPROC = null,
glUniform1dv: GLUNIFORM1DVPROC = null,
glUniform2dv: GLUNIFORM2DVPROC = null,
glUniform3dv: GLUNIFORM3DVPROC = null,
glUniform4dv: GLUNIFORM4DVPROC = null,
glUniformMatrix2dv: GLUNIFORMMATRIX2DVPROC = null,
glUniformMatrix3dv: GLUNIFORMMATRIX3DVPROC = null,
glUniformMatrix4dv: GLUNIFORMMATRIX4DVPROC = null,
glUniformMatrix2x3dv: GLUNIFORMMATRIX2X3DVPROC = null,
glUniformMatrix2x4dv: GLUNIFORMMATRIX2X4DVPROC = null,
glUniformMatrix3x2dv: GLUNIFORMMATRIX3X2DVPROC = null,
glUniformMatrix3x4dv: GLUNIFORMMATRIX3X4DVPROC = null,
glUniformMatrix4x2dv: GLUNIFORMMATRIX4X2DVPROC = null,
glUniformMatrix4x3dv: GLUNIFORMMATRIX4X3DVPROC = null,
glGetUniformdv: GLGETUNIFORMDVPROC = null,
glGetSubroutineUniformLocation: GLGETSUBROUTINEUNIFORMLOCATIONPROC = null,
glGetSubroutineIndex: GLGETSUBROUTINEINDEXPROC = null,
glGetActiveSubroutineUniformiv: GLGETACTIVESUBROUTINEUNIFORMIVPROC = null,
glGetActiveSubroutineUniformName: GLGETACTIVESUBROUTINEUNIFORMNAMEPROC = null,
glGetActiveSubroutineName: GLGETACTIVESUBROUTINENAMEPROC = null,
glUniformSubroutinesuiv: GLUNIFORMSUBROUTINESUIVPROC = null,
glGetUniformSubroutineuiv: GLGETUNIFORMSUBROUTINEUIVPROC = null,
glGetProgramStageiv: GLGETPROGRAMSTAGEIVPROC = null,
glPatchParameteri: GLPATCHPARAMETERIPROC = null,
glPatchParameterfv: GLPATCHPARAMETERFVPROC = null,
glBindTransformFeedback: GLBINDTRANSFORMFEEDBACKPROC = null,
glDeleteTransformFeedbacks: GLDELETETRANSFORMFEEDBACKSPROC = null,
glGenTransformFeedbacks: GLGENTRANSFORMFEEDBACKSPROC = null,
glIsTransformFeedback: GLISTRANSFORMFEEDBACKPROC = null,
glPauseTransformFeedback: GLPAUSETRANSFORMFEEDBACKPROC = null,
glResumeTransformFeedback: GLRESUMETRANSFORMFEEDBACKPROC = null,
glDrawTransformFeedback: GLDRAWTRANSFORMFEEDBACKPROC = null,
glDrawTransformFeedbackStream: GLDRAWTRANSFORMFEEDBACKSTREAMPROC = null,
glBeginQueryIndexed: GLBEGINQUERYINDEXEDPROC = null,
glEndQueryIndexed: GLENDQUERYINDEXEDPROC = null,
glGetQueryIndexediv: GLGETQUERYINDEXEDIVPROC = null,
glReleaseShaderCompiler: GLRELEASESHADERCOMPILERPROC = null,
glShaderBinary: GLSHADERBINARYPROC = null,
glGetShaderPrecisionFormat: GLGETSHADERPRECISIONFORMATPROC = null,
glDepthRangef: GLDEPTHRANGEFPROC = null,
glClearDepthf: GLCLEARDEPTHFPROC = null,
glGetProgramBinary: GLGETPROGRAMBINARYPROC = null,
glProgramBinary: GLPROGRAMBINARYPROC = null,
glProgramParameteri: GLPROGRAMPARAMETERIPROC = null,
glUseProgramStages: GLUSEPROGRAMSTAGESPROC = null,
glActiveShaderProgram: GLACTIVESHADERPROGRAMPROC = null,
glCreateShaderProgramv: GLCREATESHADERPROGRAMVPROC = null,
glBindProgramPipeline: GLBINDPROGRAMPIPELINEPROC = null,
glDeleteProgramPipelines: GLDELETEPROGRAMPIPELINESPROC = null,
glGenProgramPipelines: GLGENPROGRAMPIPELINESPROC = null,
glIsProgramPipeline: GLISPROGRAMPIPELINEPROC = null,
glGetProgramPipelineiv: GLGETPROGRAMPIPELINEIVPROC = null,
glProgramUniform1i: GLPROGRAMUNIFORM1IPROC = null,
glProgramUniform1iv: GLPROGRAMUNIFORM1IVPROC = null,
glProgramUniform1f: GLPROGRAMUNIFORM1FPROC = null,
glProgramUniform1fv: GLPROGRAMUNIFORM1FVPROC = null,
glProgramUniform1d: GLPROGRAMUNIFORM1DPROC = null,
glProgramUniform1dv: GLPROGRAMUNIFORM1DVPROC = null,
glProgramUniform1ui: GLPROGRAMUNIFORM1UIPROC = null,
glProgramUniform1uiv: GLPROGRAMUNIFORM1UIVPROC = null,
glProgramUniform2i: GLPROGRAMUNIFORM2IPROC = null,
glProgramUniform2iv: GLPROGRAMUNIFORM2IVPROC = null,
glProgramUniform2f: GLPROGRAMUNIFORM2FPROC = null,
glProgramUniform2fv: GLPROGRAMUNIFORM2FVPROC = null,
glProgramUniform2d: GLPROGRAMUNIFORM2DPROC = null,
glProgramUniform2dv: GLPROGRAMUNIFORM2DVPROC = null,
glProgramUniform2ui: GLPROGRAMUNIFORM2UIPROC = null,
glProgramUniform2uiv: GLPROGRAMUNIFORM2UIVPROC = null,
glProgramUniform3i: GLPROGRAMUNIFORM3IPROC = null,
glProgramUniform3iv: GLPROGRAMUNIFORM3IVPROC = null,
glProgramUniform3f: GLPROGRAMUNIFORM3FPROC = null,
glProgramUniform3fv: GLPROGRAMUNIFORM3FVPROC = null,
glProgramUniform3d: GLPROGRAMUNIFORM3DPROC = null,
glProgramUniform3dv: GLPROGRAMUNIFORM3DVPROC = null,
glProgramUniform3ui: GLPROGRAMUNIFORM3UIPROC = null,
glProgramUniform3uiv: GLPROGRAMUNIFORM3UIVPROC = null,
glProgramUniform4i: GLPROGRAMUNIFORM4IPROC = null,
glProgramUniform4iv: GLPROGRAMUNIFORM4IVPROC = null,
glProgramUniform4f: GLPROGRAMUNIFORM4FPROC = null,
glProgramUniform4fv: GLPROGRAMUNIFORM4FVPROC = null,
glProgramUniform4d: GLPROGRAMUNIFORM4DPROC = null,
glProgramUniform4dv: GLPROGRAMUNIFORM4DVPROC = null,
glProgramUniform4ui: GLPROGRAMUNIFORM4UIPROC = null,
glProgramUniform4uiv: GLPROGRAMUNIFORM4UIVPROC = null,
glProgramUniformMatrix2fv: GLPROGRAMUNIFORMMATRIX2FVPROC = null,
glProgramUniformMatrix3fv: GLPROGRAMUNIFORMMATRIX3FVPROC = null,
glProgramUniformMatrix4fv: GLPROGRAMUNIFORMMATRIX4FVPROC = null,
glProgramUniformMatrix2dv: GLPROGRAMUNIFORMMATRIX2DVPROC = null,
glProgramUniformMatrix3dv: GLPROGRAMUNIFORMMATRIX3DVPROC = null,
glProgramUniformMatrix4dv: GLPROGRAMUNIFORMMATRIX4DVPROC = null,
glProgramUniformMatrix2x3fv: GLPROGRAMUNIFORMMATRIX2X3FVPROC = null,
glProgramUniformMatrix3x2fv: GLPROGRAMUNIFORMMATRIX3X2FVPROC = null,
glProgramUniformMatrix2x4fv: GLPROGRAMUNIFORMMATRIX2X4FVPROC = null,
glProgramUniformMatrix4x2fv: GLPROGRAMUNIFORMMATRIX4X2FVPROC = null,
glProgramUniformMatrix3x4fv: GLPROGRAMUNIFORMMATRIX3X4FVPROC = null,
glProgramUniformMatrix4x3fv: GLPROGRAMUNIFORMMATRIX4X3FVPROC = null,
glProgramUniformMatrix2x3dv: GLPROGRAMUNIFORMMATRIX2X3DVPROC = null,
glProgramUniformMatrix3x2dv: GLPROGRAMUNIFORMMATRIX3X2DVPROC = null,
glProgramUniformMatrix2x4dv: GLPROGRAMUNIFORMMATRIX2X4DVPROC = null,
glProgramUniformMatrix4x2dv: GLPROGRAMUNIFORMMATRIX4X2DVPROC = null,
glProgramUniformMatrix3x4dv: GLPROGRAMUNIFORMMATRIX3X4DVPROC = null,
glProgramUniformMatrix4x3dv: GLPROGRAMUNIFORMMATRIX4X3DVPROC = null,
glValidateProgramPipeline: GLVALIDATEPROGRAMPIPELINEPROC = null,
glGetProgramPipelineInfoLog: GLGETPROGRAMPIPELINEINFOLOGPROC = null,
glVertexAttribL1d: GLVERTEXATTRIBL1DPROC = null,
glVertexAttribL2d: GLVERTEXATTRIBL2DPROC = null,
glVertexAttribL3d: GLVERTEXATTRIBL3DPROC = null,
glVertexAttribL4d: GLVERTEXATTRIBL4DPROC = null,
glVertexAttribL1dv: GLVERTEXATTRIBL1DVPROC = null,
glVertexAttribL2dv: GLVERTEXATTRIBL2DVPROC = null,
glVertexAttribL3dv: GLVERTEXATTRIBL3DVPROC = null,
glVertexAttribL4dv: GLVERTEXATTRIBL4DVPROC = null,
glVertexAttribLPointer: GLVERTEXATTRIBLPOINTERPROC = null,
glGetVertexAttribLdv: GLGETVERTEXATTRIBLDVPROC = null,
glViewportArrayv: GLVIEWPORTARRAYVPROC = null,
glViewportIndexedf: GLVIEWPORTINDEXEDFPROC = null,
glViewportIndexedfv: GLVIEWPORTINDEXEDFVPROC = null,
glScissorArrayv: GLSCISSORARRAYVPROC = null,
glScissorIndexed: GLSCISSORINDEXEDPROC = null,
glScissorIndexedv: GLSCISSORINDEXEDVPROC = null,
glDepthRangeArrayv: GLDEPTHRANGEARRAYVPROC = null,
glDepthRangeIndexed: GLDEPTHRANGEINDEXEDPROC = null,
glGetFloati_v: GLGETFLOATI_VPROC = null,
glGetDoublei_v: GLGETDOUBLEI_VPROC = null,
glDrawArraysInstancedBaseInstance: GLDRAWARRAYSINSTANCEDBASEINSTANCEPROC = null,
glDrawElementsInstancedBaseInstance: GLDRAWELEMENTSINSTANCEDBASEINSTANCEPROC = null,
glDrawElementsInstancedBaseVertexBaseInstance: GLDRAWELEMENTSINSTANCEDBASEVERTEXBASEINSTANCEPROC = null,
glGetInternalformativ: GLGETINTERNALFORMATIVPROC = null,
glGetActiveAtomicCounterBufferiv: GLGETACTIVEATOMICCOUNTERBUFFERIVPROC = null,
glBindImageTexture: GLBINDIMAGETEXTUREPROC = null,
glMemoryBarrier: GLMEMORYBARRIERPROC = null,
glTexStorage1D: GLTEXSTORAGE1DPROC = null,
glTexStorage2D: GLTEXSTORAGE2DPROC = null,
glTexStorage3D: GLTEXSTORAGE3DPROC = null,
glDrawTransformFeedbackInstanced: GLDRAWTRANSFORMFEEDBACKINSTANCEDPROC = null,
glDrawTransformFeedbackStreamInstanced: GLDRAWTRANSFORMFEEDBACKSTREAMINSTANCEDPROC = null,
glClearBufferData: GLCLEARBUFFERDATAPROC = null,
glClearBufferSubData: GLCLEARBUFFERSUBDATAPROC = null,
glDispatchCompute: GLDISPATCHCOMPUTEPROC = null,
glDispatchComputeIndirect: GLDISPATCHCOMPUTEINDIRECTPROC = null,
glCopyImageSubData: GLCOPYIMAGESUBDATAPROC = null,
glFramebufferParameteri: GLFRAMEBUFFERPARAMETERIPROC = null,
glGetFramebufferParameteriv: GLGETFRAMEBUFFERPARAMETERIVPROC = null,
glGetInternalformati64v: GLGETINTERNALFORMATI64VPROC = null,
glInvalidateTexSubImage: GLINVALIDATETEXSUBIMAGEPROC = null,
glInvalidateTexImage: GLINVALIDATETEXIMAGEPROC = null,
glInvalidateBufferSubData: GLINVALIDATEBUFFERSUBDATAPROC = null,
glInvalidateBufferData: GLINVALIDATEBUFFERDATAPROC = null,
glInvalidateFramebuffer: GLINVALIDATEFRAMEBUFFERPROC = null,
glInvalidateSubFramebuffer: GLINVALIDATESUBFRAMEBUFFERPROC = null,
glMultiDrawArraysIndirect: GLMULTIDRAWARRAYSINDIRECTPROC = null,
glMultiDrawElementsIndirect: GLMULTIDRAWELEMENTSINDIRECTPROC = null,
glGetProgramInterfaceiv: GLGETPROGRAMINTERFACEIVPROC = null,
glGetProgramResourceIndex: GLGETPROGRAMRESOURCEINDEXPROC = null,
glGetProgramResourceName: GLGETPROGRAMRESOURCENAMEPROC = null,
glGetProgramResourceiv: GLGETPROGRAMRESOURCEIVPROC = null,
glGetProgramResourceLocation: GLGETPROGRAMRESOURCELOCATIONPROC = null,
glGetProgramResourceLocationIndex: GLGETPROGRAMRESOURCELOCATIONINDEXPROC = null,
glShaderStorageBlockBinding: GLSHADERSTORAGEBLOCKBINDINGPROC = null,
glTexBufferRange: GLTEXBUFFERRANGEPROC = null,
glTexStorage2DMultisample: GLTEXSTORAGE2DMULTISAMPLEPROC = null,
glTexStorage3DMultisample: GLTEXSTORAGE3DMULTISAMPLEPROC = null,
glTextureView: GLTEXTUREVIEWPROC = null,
glBindVertexBuffer: GLBINDVERTEXBUFFERPROC = null,
glVertexAttribFormat: GLVERTEXATTRIBFORMATPROC = null,
glVertexAttribIFormat: GLVERTEXATTRIBIFORMATPROC = null,
glVertexAttribLFormat: GLVERTEXATTRIBLFORMATPROC = null,
glVertexAttribBinding: GLVERTEXATTRIBBINDINGPROC = null,
glVertexBindingDivisor: GLVERTEXBINDINGDIVISORPROC = null,
glDebugMessageControl: GLDEBUGMESSAGECONTROLPROC = null,
glDebugMessageInsert: GLDEBUGMESSAGEINSERTPROC = null,
glDebugMessageCallback: GLDEBUGMESSAGECALLBACKPROC = null,
glGetDebugMessageLog: GLGETDEBUGMESSAGELOGPROC = null,
glPushDebugGroup: GLPUSHDEBUGGROUPPROC = null,
glPopDebugGroup: GLPOPDEBUGGROUPPROC = null,
glObjectLabel: GLOBJECTLABELPROC = null,
glGetObjectLabel: GLGETOBJECTLABELPROC = null,
glObjectPtrLabel: GLOBJECTPTRLABELPROC = null,
glGetObjectPtrLabel: GLGETOBJECTPTRLABELPROC = null,
glBufferStorage: GLBUFFERSTORAGEPROC = null,
glClearTexImage: GLCLEARTEXIMAGEPROC = null,
glClearTexSubImage: GLCLEARTEXSUBIMAGEPROC = null,
glBindBuffersBase: GLBINDBUFFERSBASEPROC = null,
glBindBuffersRange: GLBINDBUFFERSRANGEPROC = null,
glBindTextures: GLBINDTEXTURESPROC = null,
glBindSamplers: GLBINDSAMPLERSPROC = null,
glBindImageTextures: GLBINDIMAGETEXTURESPROC = null,
glBindVertexBuffers: GLBINDVERTEXBUFFERSPROC = null,
glClipControl: GLCLIPCONTROLPROC = null,
glCreateTransformFeedbacks: GLCREATETRANSFORMFEEDBACKSPROC = null,
glTransformFeedbackBufferBase: GLTRANSFORMFEEDBACKBUFFERBASEPROC = null,
glTransformFeedbackBufferRange: GLTRANSFORMFEEDBACKBUFFERRANGEPROC = null,
glGetTransformFeedbackiv: GLGETTRANSFORMFEEDBACKIVPROC = null,
glGetTransformFeedbacki_v: GLGETTRANSFORMFEEDBACKI_VPROC = null,
glGetTransformFeedbacki64_v: GLGETTRANSFORMFEEDBACKI64_VPROC = null,
glCreateBuffers: GLCREATEBUFFERSPROC = null,
glNamedBufferStorage: GLNAMEDBUFFERSTORAGEPROC = null,
glNamedBufferData: GLNAMEDBUFFERDATAPROC = null,
glNamedBufferSubData: GLNAMEDBUFFERSUBDATAPROC = null,
glCopyNamedBufferSubData: GLCOPYNAMEDBUFFERSUBDATAPROC = null,
glClearNamedBufferData: GLCLEARNAMEDBUFFERDATAPROC = null,
glClearNamedBufferSubData: GLCLEARNAMEDBUFFERSUBDATAPROC = null,
glMapNamedBuffer: GLMAPNAMEDBUFFERPROC = null,
glMapNamedBufferRange: GLMAPNAMEDBUFFERRANGEPROC = null,
glUnmapNamedBuffer: GLUNMAPNAMEDBUFFERPROC = null,
glFlushMappedNamedBufferRange: GLFLUSHMAPPEDNAMEDBUFFERRANGEPROC = null,
glGetNamedBufferParameteriv: GLGETNAMEDBUFFERPARAMETERIVPROC = null,
glGetNamedBufferParameteri64v: GLGETNAMEDBUFFERPARAMETERI64VPROC = null,
glGetNamedBufferPointerv: GLGETNAMEDBUFFERPOINTERVPROC = null,
glGetNamedBufferSubData: GLGETNAMEDBUFFERSUBDATAPROC = null,
glCreateFramebuffers: GLCREATEFRAMEBUFFERSPROC = null,
glNamedFramebufferRenderbuffer: GLNAMEDFRAMEBUFFERRENDERBUFFERPROC = null,
glNamedFramebufferParameteri: GLNAMEDFRAMEBUFFERPARAMETERIPROC = null,
glNamedFramebufferTexture: GLNAMEDFRAMEBUFFERTEXTUREPROC = null,
glNamedFramebufferTextureLayer: GLNAMEDFRAMEBUFFERTEXTURELAYERPROC = null,
glNamedFramebufferDrawBuffer: GLNAMEDFRAMEBUFFERDRAWBUFFERPROC = null,
glNamedFramebufferDrawBuffers: GLNAMEDFRAMEBUFFERDRAWBUFFERSPROC = null,
glNamedFramebufferReadBuffer: GLNAMEDFRAMEBUFFERREADBUFFERPROC = null,
glInvalidateNamedFramebufferData: GLINVALIDATENAMEDFRAMEBUFFERDATAPROC = null,
glInvalidateNamedFramebufferSubData: GLINVALIDATENAMEDFRAMEBUFFERSUBDATAPROC = null,
glClearNamedFramebufferiv: GLCLEARNAMEDFRAMEBUFFERIVPROC = null,
glClearNamedFramebufferuiv: GLCLEARNAMEDFRAMEBUFFERUIVPROC = null,
glClearNamedFramebufferfv: GLCLEARNAMEDFRAMEBUFFERFVPROC = null,
glClearNamedFramebufferfi: GLCLEARNAMEDFRAMEBUFFERFIPROC = null,
glBlitNamedFramebuffer: GLBLITNAMEDFRAMEBUFFERPROC = null,
glCheckNamedFramebufferStatus: GLCHECKNAMEDFRAMEBUFFERSTATUSPROC = null,
glGetNamedFramebufferParameteriv: GLGETNAMEDFRAMEBUFFERPARAMETERIVPROC = null,
glGetNamedFramebufferAttachmentParameteriv: GLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVPROC = null,
glCreateRenderbuffers: GLCREATERENDERBUFFERSPROC = null,
glNamedRenderbufferStorage: GLNAMEDRENDERBUFFERSTORAGEPROC = null,
glNamedRenderbufferStorageMultisample: GLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEPROC = null,
glGetNamedRenderbufferParameteriv: GLGETNAMEDRENDERBUFFERPARAMETERIVPROC = null,
glCreateTextures: GLCREATETEXTURESPROC = null,
glTextureBuffer: GLTEXTUREBUFFERPROC = null,
glTextureBufferRange: GLTEXTUREBUFFERRANGEPROC = null,
glTextureStorage1D: GLTEXTURESTORAGE1DPROC = null,
glTextureStorage2D: GLTEXTURESTORAGE2DPROC = null,
glTextureStorage3D: GLTEXTURESTORAGE3DPROC = null,
glTextureStorage2DMultisample: GLTEXTURESTORAGE2DMULTISAMPLEPROC = null,
glTextureStorage3DMultisample: GLTEXTURESTORAGE3DMULTISAMPLEPROC = null,
glTextureSubImage1D: GLTEXTURESUBIMAGE1DPROC = null,
glTextureSubImage2D: GLTEXTURESUBIMAGE2DPROC = null,
glTextureSubImage3D: GLTEXTURESUBIMAGE3DPROC = null,
glCompressedTextureSubImage1D: GLCOMPRESSEDTEXTURESUBIMAGE1DPROC = null,
glCompressedTextureSubImage2D: GLCOMPRESSEDTEXTURESUBIMAGE2DPROC = null,
glCompressedTextureSubImage3D: GLCOMPRESSEDTEXTURESUBIMAGE3DPROC = null,
glCopyTextureSubImage1D: GLCOPYTEXTURESUBIMAGE1DPROC = null,
glCopyTextureSubImage2D: GLCOPYTEXTURESUBIMAGE2DPROC = null,
glCopyTextureSubImage3D: GLCOPYTEXTURESUBIMAGE3DPROC = null,
glTextureParameterf: GLTEXTUREPARAMETERFPROC = null,
glTextureParameterfv: GLTEXTUREPARAMETERFVPROC = null,
glTextureParameteri: GLTEXTUREPARAMETERIPROC = null,
glTextureParameterIiv: GLTEXTUREPARAMETERIIVPROC = null,
glTextureParameterIuiv: GLTEXTUREPARAMETERIUIVPROC = null,
glTextureParameteriv: GLTEXTUREPARAMETERIVPROC = null,
glGenerateTextureMipmap: GLGENERATETEXTUREMIPMAPPROC = null,
glBindTextureUnit: GLBINDTEXTUREUNITPROC = null,
glGetTextureImage: GLGETTEXTUREIMAGEPROC = null,
glGetCompressedTextureImage: GLGETCOMPRESSEDTEXTUREIMAGEPROC = null,
glGetTextureLevelParameterfv: GLGETTEXTURELEVELPARAMETERFVPROC = null,
glGetTextureLevelParameteriv: GLGETTEXTURELEVELPARAMETERIVPROC = null,
glGetTextureParameterfv: GLGETTEXTUREPARAMETERFVPROC = null,
glGetTextureParameterIiv: GLGETTEXTUREPARAMETERIIVPROC = null,
glGetTextureParameterIuiv: GLGETTEXTUREPARAMETERIUIVPROC = null,
glGetTextureParameteriv: GLGETTEXTUREPARAMETERIVPROC = null,
glCreateVertexArrays: GLCREATEVERTEXARRAYSPROC = null,
glDisableVertexArrayAttrib: GLDISABLEVERTEXARRAYATTRIBPROC = null,
glEnableVertexArrayAttrib: GLENABLEVERTEXARRAYATTRIBPROC = null,
glVertexArrayElementBuffer: GLVERTEXARRAYELEMENTBUFFERPROC = null,
glVertexArrayVertexBuffer: GLVERTEXARRAYVERTEXBUFFERPROC = null,
glVertexArrayVertexBuffers: GLVERTEXARRAYVERTEXBUFFERSPROC = null,
glVertexArrayAttribBinding: GLVERTEXARRAYATTRIBBINDINGPROC = null,
glVertexArrayAttribFormat: GLVERTEXARRAYATTRIBFORMATPROC = null,
glVertexArrayAttribIFormat: GLVERTEXARRAYATTRIBIFORMATPROC = null,
glVertexArrayAttribLFormat: GLVERTEXARRAYATTRIBLFORMATPROC = null,
glVertexArrayBindingDivisor: GLVERTEXARRAYBINDINGDIVISORPROC = null,
glGetVertexArrayiv: GLGETVERTEXARRAYIVPROC = null,
glGetVertexArrayIndexediv: GLGETVERTEXARRAYINDEXEDIVPROC = null,
glGetVertexArrayIndexed64iv: GLGETVERTEXARRAYINDEXED64IVPROC = null,
glCreateSamplers: GLCREATESAMPLERSPROC = null,
glCreateProgramPipelines: GLCREATEPROGRAMPIPELINESPROC = null,
glCreateQueries: GLCREATEQUERIESPROC = null,
glGetQueryBufferObjecti64v: GLGETQUERYBUFFEROBJECTI64VPROC = null,
glGetQueryBufferObjectiv: GLGETQUERYBUFFEROBJECTIVPROC = null,
glGetQueryBufferObjectui64v: GLGETQUERYBUFFEROBJECTUI64VPROC = null,
glGetQueryBufferObjectuiv: GLGETQUERYBUFFEROBJECTUIVPROC = null,
glMemoryBarrierByRegion: GLMEMORYBARRIERBYREGIONPROC = null,
glGetTextureSubImage: GLGETTEXTURESUBIMAGEPROC = null,
glGetCompressedTextureSubImage: GLGETCOMPRESSEDTEXTURESUBIMAGEPROC = null,
glGetGraphicsResetStatus: GLGETGRAPHICSRESETSTATUSPROC = null,
glGetnCompressedTexImage: GLGETNCOMPRESSEDTEXIMAGEPROC = null,
glGetnTexImage: GLGETNTEXIMAGEPROC = null,
glGetnUniformdv: GLGETNUNIFORMDVPROC = null,
glGetnUniformfv: GLGETNUNIFORMFVPROC = null,
glGetnUniformiv: GLGETNUNIFORMIVPROC = null,
glGetnUniformuiv: GLGETNUNIFORMUIVPROC = null,
glReadnPixels: GLREADNPIXELSPROC = null,
glGetnMapdv: GLGETNMAPDVPROC = null,
glGetnMapfv: GLGETNMAPFVPROC = null,
glGetnMapiv: GLGETNMAPIVPROC = null,
glGetnPixelMapfv: GLGETNPIXELMAPFVPROC = null,
glGetnPixelMapuiv: GLGETNPIXELMAPUIVPROC = null,
glGetnPixelMapusv: GLGETNPIXELMAPUSVPROC = null,
glGetnPolygonStipple: GLGETNPOLYGONSTIPPLEPROC = null,
glGetnColorTable: GLGETNCOLORTABLEPROC = null,
glGetnConvolutionFilter: GLGETNCONVOLUTIONFILTERPROC = null,
glGetnSeparableFilter: GLGETNSEPARABLEFILTERPROC = null,
glGetnHistogram: GLGETNHISTOGRAMPROC = null,
glGetnMinmax: GLGETNMINMAXPROC = null,
glTextureBarrier: GLTEXTUREBARRIERPROC = null,
glSpecializeShader: GLSPECIALIZESHADERPROC = null,
glMultiDrawArraysIndirectCount: GLMULTIDRAWARRAYSINDIRECTCOUNTPROC = null,
glMultiDrawElementsIndirectCount: GLMULTIDRAWELEMENTSINDIRECTCOUNTPROC = null,
glPolygonOffsetClamp: GLPOLYGONOFFSETCLAMPPROC = null,
pub const GLCULLFACEPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLFRONTFACEPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLHINTPROC = ?*const fn(
target: GLenum,mode: GLenum) callconv(.C) void;pub const GLLINEWIDTHPROC = ?*const fn(
width: GLfloat) callconv(.C) void;pub const GLPOINTSIZEPROC = ?*const fn(
size: GLfloat) callconv(.C) void;pub const GLPOLYGONMODEPROC = ?*const fn(
face: GLenum,mode: GLenum) callconv(.C) void;pub const GLSCISSORPROC = ?*const fn(
x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLTEXPARAMETERFPROC = ?*const fn(
target: GLenum,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLTEXPARAMETERFVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLTEXPARAMETERIPROC = ?*const fn(
target: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLTEXPARAMETERIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLTEXIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLint,width: GLsizei,border: GLint,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLTEXIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLint,width: GLsizei,height: GLsizei,border: GLint,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLDRAWBUFFERPROC = ?*const fn(
buf: GLenum) callconv(.C) void;pub const GLCLEARPROC = ?*const fn(
mask: GLbitfield) callconv(.C) void;pub const GLCLEARCOLORPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat,alpha: GLfloat) callconv(.C) void;pub const GLCLEARSTENCILPROC = ?*const fn(
s: GLint) callconv(.C) void;pub const GLCLEARDEPTHPROC = ?*const fn(
depth: GLdouble) callconv(.C) void;pub const GLSTENCILMASKPROC = ?*const fn(
mask: GLuint) callconv(.C) void;pub const GLCOLORMASKPROC = ?*const fn(
red: GLboolean,green: GLboolean,blue: GLboolean,alpha: GLboolean) callconv(.C) void;pub const GLDEPTHMASKPROC = ?*const fn(
flag: GLboolean) callconv(.C) void;pub const GLDISABLEPROC = ?*const fn(
cap: GLenum) callconv(.C) void;pub const GLENABLEPROC = ?*const fn(
cap: GLenum) callconv(.C) void;pub const GLFINISHPROC = ?*const fn(
) callconv(.C) void;pub const GLFLUSHPROC = ?*const fn(
) callconv(.C) void;pub const GLBLENDFUNCPROC = ?*const fn(
sfactor: GLenum,dfactor: GLenum) callconv(.C) void;pub const GLLOGICOPPROC = ?*const fn(
opcode: GLenum) callconv(.C) void;pub const GLSTENCILFUNCPROC = ?*const fn(
func: GLenum,ref: GLint,mask: GLuint) callconv(.C) void;pub const GLSTENCILOPPROC = ?*const fn(
fail: GLenum,zfail: GLenum,zpass: GLenum) callconv(.C) void;pub const GLDEPTHFUNCPROC = ?*const fn(
func: GLenum) callconv(.C) void;pub const GLPIXELSTOREFPROC = ?*const fn(
pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLPIXELSTOREIPROC = ?*const fn(
pname: GLenum,param: GLint) callconv(.C) void;pub const GLREADBUFFERPROC = ?*const fn(
src: GLenum) callconv(.C) void;pub const GLREADPIXELSPROC = ?*const fn(
x: GLint,y: GLint,width: GLsizei,height: GLsizei,format: GLenum,type: GLenum,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETBOOLEANVPROC = ?*const fn(
pname: GLenum,data: [*c]GLboolean) callconv(.C) void;pub const GLGETDOUBLEVPROC = ?*const fn(
pname: GLenum,data: [*c]GLdouble) callconv(.C) void;pub const GLGETERRORPROC = ?*const fn(
) callconv(.C) GLenum;pub const GLGETFLOATVPROC = ?*const fn(
pname: GLenum,data: [*c]GLfloat) callconv(.C) void;pub const GLGETINTEGERVPROC = ?*const fn(
pname: GLenum,data: [*c]GLint) callconv(.C) void;pub const GLGETSTRINGPROC = ?*const fn(
name: GLenum) callconv(.C) ?[*:0]const GLubyte;pub const GLGETTEXIMAGEPROC = ?*const fn(
target: GLenum,level: GLint,format: GLenum,type: GLenum,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETTEXPARAMETERFVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXPARAMETERIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETTEXLEVELPARAMETERFVPROC = ?*const fn(
target: GLenum,level: GLint,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXLEVELPARAMETERIVPROC = ?*const fn(
target: GLenum,level: GLint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLISENABLEDPROC = ?*const fn(
cap: GLenum) callconv(.C) GLboolean;pub const GLDEPTHRANGEPROC = ?*const fn(
n: GLdouble,f: GLdouble) callconv(.C) void;pub const GLVIEWPORTPROC = ?*const fn(
x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLNEWLISTPROC = ?*const fn(
list: GLuint,mode: GLenum) callconv(.C) void;pub const GLENDLISTPROC = ?*const fn(
) callconv(.C) void;pub const GLCALLLISTPROC = ?*const fn(
list: GLuint) callconv(.C) void;pub const GLCALLLISTSPROC = ?*const fn(
n: GLsizei,type: GLenum,lists: ?*const anyopaque) callconv(.C) void;pub const GLDELETELISTSPROC = ?*const fn(
list: GLuint,range: GLsizei) callconv(.C) void;pub const GLGENLISTSPROC = ?*const fn(
range: GLsizei) callconv(.C) GLuint;pub const GLLISTBASEPROC = ?*const fn(
base: GLuint) callconv(.C) void;pub const GLBEGINPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLBITMAPPROC = ?*const fn(
width: GLsizei,height: GLsizei,xorig: GLfloat,yorig: GLfloat,xmove: GLfloat,ymove: GLfloat,bitmap: ?[*:0]const GLubyte) callconv(.C) void;pub const GLCOLOR3BPROC = ?*const fn(
red: GLbyte,green: GLbyte,blue: GLbyte) callconv(.C) void;pub const GLCOLOR3BVPROC = ?*const fn(
v: [*c]const GLbyte) callconv(.C) void;pub const GLCOLOR3DPROC = ?*const fn(
red: GLdouble,green: GLdouble,blue: GLdouble) callconv(.C) void;pub const GLCOLOR3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLCOLOR3FPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat) callconv(.C) void;pub const GLCOLOR3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLCOLOR3IPROC = ?*const fn(
red: GLint,green: GLint,blue: GLint) callconv(.C) void;pub const GLCOLOR3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLCOLOR3SPROC = ?*const fn(
red: GLshort,green: GLshort,blue: GLshort) callconv(.C) void;pub const GLCOLOR3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLCOLOR3UBPROC = ?*const fn(
red: GLubyte,green: GLubyte,blue: GLubyte) callconv(.C) void;pub const GLCOLOR3UBVPROC = ?*const fn(
v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLCOLOR3UIPROC = ?*const fn(
red: GLuint,green: GLuint,blue: GLuint) callconv(.C) void;pub const GLCOLOR3UIVPROC = ?*const fn(
v: [*c]const GLuint) callconv(.C) void;pub const GLCOLOR3USPROC = ?*const fn(
red: GLushort,green: GLushort,blue: GLushort) callconv(.C) void;pub const GLCOLOR3USVPROC = ?*const fn(
v: [*c]const GLushort) callconv(.C) void;pub const GLCOLOR4BPROC = ?*const fn(
red: GLbyte,green: GLbyte,blue: GLbyte,alpha: GLbyte) callconv(.C) void;pub const GLCOLOR4BVPROC = ?*const fn(
v: [*c]const GLbyte) callconv(.C) void;pub const GLCOLOR4DPROC = ?*const fn(
red: GLdouble,green: GLdouble,blue: GLdouble,alpha: GLdouble) callconv(.C) void;pub const GLCOLOR4DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLCOLOR4FPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat,alpha: GLfloat) callconv(.C) void;pub const GLCOLOR4FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLCOLOR4IPROC = ?*const fn(
red: GLint,green: GLint,blue: GLint,alpha: GLint) callconv(.C) void;pub const GLCOLOR4IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLCOLOR4SPROC = ?*const fn(
red: GLshort,green: GLshort,blue: GLshort,alpha: GLshort) callconv(.C) void;pub const GLCOLOR4SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLCOLOR4UBPROC = ?*const fn(
red: GLubyte,green: GLubyte,blue: GLubyte,alpha: GLubyte) callconv(.C) void;pub const GLCOLOR4UBVPROC = ?*const fn(
v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLCOLOR4UIPROC = ?*const fn(
red: GLuint,green: GLuint,blue: GLuint,alpha: GLuint) callconv(.C) void;pub const GLCOLOR4UIVPROC = ?*const fn(
v: [*c]const GLuint) callconv(.C) void;pub const GLCOLOR4USPROC = ?*const fn(
red: GLushort,green: GLushort,blue: GLushort,alpha: GLushort) callconv(.C) void;pub const GLCOLOR4USVPROC = ?*const fn(
v: [*c]const GLushort) callconv(.C) void;pub const GLEDGEFLAGPROC = ?*const fn(
flag: GLboolean) callconv(.C) void;pub const GLEDGEFLAGVPROC = ?*const fn(
flag: [*c]const GLboolean) callconv(.C) void;pub const GLENDPROC = ?*const fn(
) callconv(.C) void;pub const GLINDEXDPROC = ?*const fn(
c: GLdouble) callconv(.C) void;pub const GLINDEXDVPROC = ?*const fn(
c: [*c]const GLdouble) callconv(.C) void;pub const GLINDEXFPROC = ?*const fn(
c: GLfloat) callconv(.C) void;pub const GLINDEXFVPROC = ?*const fn(
c: [*c]const GLfloat) callconv(.C) void;pub const GLINDEXIPROC = ?*const fn(
c: GLint) callconv(.C) void;pub const GLINDEXIVPROC = ?*const fn(
c: [*c]const GLint) callconv(.C) void;pub const GLINDEXSPROC = ?*const fn(
c: GLshort) callconv(.C) void;pub const GLINDEXSVPROC = ?*const fn(
c: [*c]const GLshort) callconv(.C) void;pub const GLNORMAL3BPROC = ?*const fn(
nx: GLbyte,ny: GLbyte,nz: GLbyte) callconv(.C) void;pub const GLNORMAL3BVPROC = ?*const fn(
v: [*c]const GLbyte) callconv(.C) void;pub const GLNORMAL3DPROC = ?*const fn(
nx: GLdouble,ny: GLdouble,nz: GLdouble) callconv(.C) void;pub const GLNORMAL3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLNORMAL3FPROC = ?*const fn(
nx: GLfloat,ny: GLfloat,nz: GLfloat) callconv(.C) void;pub const GLNORMAL3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLNORMAL3IPROC = ?*const fn(
nx: GLint,ny: GLint,nz: GLint) callconv(.C) void;pub const GLNORMAL3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLNORMAL3SPROC = ?*const fn(
nx: GLshort,ny: GLshort,nz: GLshort) callconv(.C) void;pub const GLNORMAL3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLRASTERPOS2DPROC = ?*const fn(
x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLRASTERPOS2DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLRASTERPOS2FPROC = ?*const fn(
x: GLfloat,y: GLfloat) callconv(.C) void;pub const GLRASTERPOS2FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLRASTERPOS2IPROC = ?*const fn(
x: GLint,y: GLint) callconv(.C) void;pub const GLRASTERPOS2IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLRASTERPOS2SPROC = ?*const fn(
x: GLshort,y: GLshort) callconv(.C) void;pub const GLRASTERPOS2SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLRASTERPOS3DPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLRASTERPOS3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLRASTERPOS3FPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLRASTERPOS3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLRASTERPOS3IPROC = ?*const fn(
x: GLint,y: GLint,z: GLint) callconv(.C) void;pub const GLRASTERPOS3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLRASTERPOS3SPROC = ?*const fn(
x: GLshort,y: GLshort,z: GLshort) callconv(.C) void;pub const GLRASTERPOS3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLRASTERPOS4DPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble,w: GLdouble) callconv(.C) void;pub const GLRASTERPOS4DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLRASTERPOS4FPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat,w: GLfloat) callconv(.C) void;pub const GLRASTERPOS4FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLRASTERPOS4IPROC = ?*const fn(
x: GLint,y: GLint,z: GLint,w: GLint) callconv(.C) void;pub const GLRASTERPOS4IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLRASTERPOS4SPROC = ?*const fn(
x: GLshort,y: GLshort,z: GLshort,w: GLshort) callconv(.C) void;pub const GLRASTERPOS4SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLRECTDPROC = ?*const fn(
x1: GLdouble,y1: GLdouble,x2: GLdouble,y2: GLdouble) callconv(.C) void;pub const GLRECTDVPROC = ?*const fn(
v1: [*c]const GLdouble,v2: [*c]const GLdouble) callconv(.C) void;pub const GLRECTFPROC = ?*const fn(
x1: GLfloat,y1: GLfloat,x2: GLfloat,y2: GLfloat) callconv(.C) void;pub const GLRECTFVPROC = ?*const fn(
v1: [*c]const GLfloat,v2: [*c]const GLfloat) callconv(.C) void;pub const GLRECTIPROC = ?*const fn(
x1: GLint,y1: GLint,x2: GLint,y2: GLint) callconv(.C) void;pub const GLRECTIVPROC = ?*const fn(
v1: [*c]const GLint,v2: [*c]const GLint) callconv(.C) void;pub const GLRECTSPROC = ?*const fn(
x1: GLshort,y1: GLshort,x2: GLshort,y2: GLshort) callconv(.C) void;pub const GLRECTSVPROC = ?*const fn(
v1: [*c]const GLshort,v2: [*c]const GLshort) callconv(.C) void;pub const GLTEXCOORD1DPROC = ?*const fn(
s: GLdouble) callconv(.C) void;pub const GLTEXCOORD1DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLTEXCOORD1FPROC = ?*const fn(
s: GLfloat) callconv(.C) void;pub const GLTEXCOORD1FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLTEXCOORD1IPROC = ?*const fn(
s: GLint) callconv(.C) void;pub const GLTEXCOORD1IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLTEXCOORD1SPROC = ?*const fn(
s: GLshort) callconv(.C) void;pub const GLTEXCOORD1SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLTEXCOORD2DPROC = ?*const fn(
s: GLdouble,t: GLdouble) callconv(.C) void;pub const GLTEXCOORD2DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLTEXCOORD2FPROC = ?*const fn(
s: GLfloat,t: GLfloat) callconv(.C) void;pub const GLTEXCOORD2FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLTEXCOORD2IPROC = ?*const fn(
s: GLint,t: GLint) callconv(.C) void;pub const GLTEXCOORD2IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLTEXCOORD2SPROC = ?*const fn(
s: GLshort,t: GLshort) callconv(.C) void;pub const GLTEXCOORD2SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLTEXCOORD3DPROC = ?*const fn(
s: GLdouble,t: GLdouble,r: GLdouble) callconv(.C) void;pub const GLTEXCOORD3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLTEXCOORD3FPROC = ?*const fn(
s: GLfloat,t: GLfloat,r: GLfloat) callconv(.C) void;pub const GLTEXCOORD3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLTEXCOORD3IPROC = ?*const fn(
s: GLint,t: GLint,r: GLint) callconv(.C) void;pub const GLTEXCOORD3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLTEXCOORD3SPROC = ?*const fn(
s: GLshort,t: GLshort,r: GLshort) callconv(.C) void;pub const GLTEXCOORD3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLTEXCOORD4DPROC = ?*const fn(
s: GLdouble,t: GLdouble,r: GLdouble,q: GLdouble) callconv(.C) void;pub const GLTEXCOORD4DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLTEXCOORD4FPROC = ?*const fn(
s: GLfloat,t: GLfloat,r: GLfloat,q: GLfloat) callconv(.C) void;pub const GLTEXCOORD4FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLTEXCOORD4IPROC = ?*const fn(
s: GLint,t: GLint,r: GLint,q: GLint) callconv(.C) void;pub const GLTEXCOORD4IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLTEXCOORD4SPROC = ?*const fn(
s: GLshort,t: GLshort,r: GLshort,q: GLshort) callconv(.C) void;pub const GLTEXCOORD4SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEX2DPROC = ?*const fn(
x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLVERTEX2DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEX2FPROC = ?*const fn(
x: GLfloat,y: GLfloat) callconv(.C) void;pub const GLVERTEX2FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEX2IPROC = ?*const fn(
x: GLint,y: GLint) callconv(.C) void;pub const GLVERTEX2IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLVERTEX2SPROC = ?*const fn(
x: GLshort,y: GLshort) callconv(.C) void;pub const GLVERTEX2SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEX3DPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLVERTEX3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEX3FPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLVERTEX3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEX3IPROC = ?*const fn(
x: GLint,y: GLint,z: GLint) callconv(.C) void;pub const GLVERTEX3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLVERTEX3SPROC = ?*const fn(
x: GLshort,y: GLshort,z: GLshort) callconv(.C) void;pub const GLVERTEX3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEX4DPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble,w: GLdouble) callconv(.C) void;pub const GLVERTEX4DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEX4FPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat,w: GLfloat) callconv(.C) void;pub const GLVERTEX4FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEX4IPROC = ?*const fn(
x: GLint,y: GLint,z: GLint,w: GLint) callconv(.C) void;pub const GLVERTEX4IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLVERTEX4SPROC = ?*const fn(
x: GLshort,y: GLshort,z: GLshort,w: GLshort) callconv(.C) void;pub const GLVERTEX4SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLCLIPPLANEPROC = ?*const fn(
plane: GLenum,equation: [*c]const GLdouble) callconv(.C) void;pub const GLCOLORMATERIALPROC = ?*const fn(
face: GLenum,mode: GLenum) callconv(.C) void;pub const GLFOGFPROC = ?*const fn(
pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLFOGFVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLFOGIPROC = ?*const fn(
pname: GLenum,param: GLint) callconv(.C) void;pub const GLFOGIVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLLIGHTFPROC = ?*const fn(
light: GLenum,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLLIGHTFVPROC = ?*const fn(
light: GLenum,pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLLIGHTIPROC = ?*const fn(
light: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLLIGHTIVPROC = ?*const fn(
light: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLLIGHTMODELFPROC = ?*const fn(
pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLLIGHTMODELFVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLLIGHTMODELIPROC = ?*const fn(
pname: GLenum,param: GLint) callconv(.C) void;pub const GLLIGHTMODELIVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLLINESTIPPLEPROC = ?*const fn(
factor: GLint,pattern: GLushort) callconv(.C) void;pub const GLMATERIALFPROC = ?*const fn(
face: GLenum,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLMATERIALFVPROC = ?*const fn(
face: GLenum,pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLMATERIALIPROC = ?*const fn(
face: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLMATERIALIVPROC = ?*const fn(
face: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLPOLYGONSTIPPLEPROC = ?*const fn(
mask: ?[*:0]const GLubyte) callconv(.C) void;pub const GLSHADEMODELPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLTEXENVFPROC = ?*const fn(
target: GLenum,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLTEXENVFVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLTEXENVIPROC = ?*const fn(
target: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLTEXENVIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLTEXGENDPROC = ?*const fn(
coord: GLenum,pname: GLenum,param: GLdouble) callconv(.C) void;pub const GLTEXGENDVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]const GLdouble) callconv(.C) void;pub const GLTEXGENFPROC = ?*const fn(
coord: GLenum,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLTEXGENFVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLTEXGENIPROC = ?*const fn(
coord: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLTEXGENIVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLFEEDBACKBUFFERPROC = ?*const fn(
size: GLsizei,type: GLenum,buffer: [*c]GLfloat) callconv(.C) void;pub const GLSELECTBUFFERPROC = ?*const fn(
size: GLsizei,buffer: [*c]GLuint) callconv(.C) void;pub const GLRENDERMODEPROC = ?*const fn(
mode: GLenum) callconv(.C) GLint;pub const GLINITNAMESPROC = ?*const fn(
) callconv(.C) void;pub const GLLOADNAMEPROC = ?*const fn(
name: GLuint) callconv(.C) void;pub const GLPASSTHROUGHPROC = ?*const fn(
token: GLfloat) callconv(.C) void;pub const GLPOPNAMEPROC = ?*const fn(
) callconv(.C) void;pub const GLPUSHNAMEPROC = ?*const fn(
name: GLuint) callconv(.C) void;pub const GLCLEARACCUMPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat,alpha: GLfloat) callconv(.C) void;pub const GLCLEARINDEXPROC = ?*const fn(
c: GLfloat) callconv(.C) void;pub const GLINDEXMASKPROC = ?*const fn(
mask: GLuint) callconv(.C) void;pub const GLACCUMPROC = ?*const fn(
op: GLenum,value: GLfloat) callconv(.C) void;pub const GLPOPATTRIBPROC = ?*const fn(
) callconv(.C) void;pub const GLPUSHATTRIBPROC = ?*const fn(
mask: GLbitfield) callconv(.C) void;pub const GLMAP1DPROC = ?*const fn(
target: GLenum,u1: GLdouble,u2: GLdouble,stride: GLint,order: GLint,points: [*c]const GLdouble) callconv(.C) void;pub const GLMAP1FPROC = ?*const fn(
target: GLenum,u1: GLfloat,u2: GLfloat,stride: GLint,order: GLint,points: [*c]const GLfloat) callconv(.C) void;pub const GLMAP2DPROC = ?*const fn(
target: GLenum,u1: GLdouble,u2: GLdouble,ustride: GLint,uorder: GLint,v1: GLdouble,v2: GLdouble,vstride: GLint,vorder: GLint,points: [*c]const GLdouble) callconv(.C) void;pub const GLMAP2FPROC = ?*const fn(
target: GLenum,u1: GLfloat,u2: GLfloat,ustride: GLint,uorder: GLint,v1: GLfloat,v2: GLfloat,vstride: GLint,vorder: GLint,points: [*c]const GLfloat) callconv(.C) void;pub const GLMAPGRID1DPROC = ?*const fn(
un: GLint,u1: GLdouble,u2: GLdouble) callconv(.C) void;pub const GLMAPGRID1FPROC = ?*const fn(
un: GLint,u1: GLfloat,u2: GLfloat) callconv(.C) void;pub const GLMAPGRID2DPROC = ?*const fn(
un: GLint,u1: GLdouble,u2: GLdouble,vn: GLint,v1: GLdouble,v2: GLdouble) callconv(.C) void;pub const GLMAPGRID2FPROC = ?*const fn(
un: GLint,u1: GLfloat,u2: GLfloat,vn: GLint,v1: GLfloat,v2: GLfloat) callconv(.C) void;pub const GLEVALCOORD1DPROC = ?*const fn(
u: GLdouble) callconv(.C) void;pub const GLEVALCOORD1DVPROC = ?*const fn(
u: [*c]const GLdouble) callconv(.C) void;pub const GLEVALCOORD1FPROC = ?*const fn(
u: GLfloat) callconv(.C) void;pub const GLEVALCOORD1FVPROC = ?*const fn(
u: [*c]const GLfloat) callconv(.C) void;pub const GLEVALCOORD2DPROC = ?*const fn(
u: GLdouble,v: GLdouble) callconv(.C) void;pub const GLEVALCOORD2DVPROC = ?*const fn(
u: [*c]const GLdouble) callconv(.C) void;pub const GLEVALCOORD2FPROC = ?*const fn(
u: GLfloat,v: GLfloat) callconv(.C) void;pub const GLEVALCOORD2FVPROC = ?*const fn(
u: [*c]const GLfloat) callconv(.C) void;pub const GLEVALMESH1PROC = ?*const fn(
mode: GLenum,i1: GLint,i2: GLint) callconv(.C) void;pub const GLEVALPOINT1PROC = ?*const fn(
i: GLint) callconv(.C) void;pub const GLEVALMESH2PROC = ?*const fn(
mode: GLenum,i1: GLint,i2: GLint,j1: GLint,j2: GLint) callconv(.C) void;pub const GLEVALPOINT2PROC = ?*const fn(
i: GLint,j: GLint) callconv(.C) void;pub const GLALPHAFUNCPROC = ?*const fn(
func: GLenum,ref: GLfloat) callconv(.C) void;pub const GLPIXELZOOMPROC = ?*const fn(
xfactor: GLfloat,yfactor: GLfloat) callconv(.C) void;pub const GLPIXELTRANSFERFPROC = ?*const fn(
pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLPIXELTRANSFERIPROC = ?*const fn(
pname: GLenum,param: GLint) callconv(.C) void;pub const GLPIXELMAPFVPROC = ?*const fn(
map: GLenum,mapsize: GLsizei,values: [*c]const GLfloat) callconv(.C) void;pub const GLPIXELMAPUIVPROC = ?*const fn(
map: GLenum,mapsize: GLsizei,values: [*c]const GLuint) callconv(.C) void;pub const GLPIXELMAPUSVPROC = ?*const fn(
map: GLenum,mapsize: GLsizei,values: [*c]const GLushort) callconv(.C) void;pub const GLCOPYPIXELSPROC = ?*const fn(
x: GLint,y: GLint,width: GLsizei,height: GLsizei,type: GLenum) callconv(.C) void;pub const GLDRAWPIXELSPROC = ?*const fn(
width: GLsizei,height: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLGETCLIPPLANEPROC = ?*const fn(
plane: GLenum,equation: [*c]GLdouble) callconv(.C) void;pub const GLGETLIGHTFVPROC = ?*const fn(
light: GLenum,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETLIGHTIVPROC = ?*const fn(
light: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETMAPDVPROC = ?*const fn(
target: GLenum,query: GLenum,v: [*c]GLdouble) callconv(.C) void;pub const GLGETMAPFVPROC = ?*const fn(
target: GLenum,query: GLenum,v: [*c]GLfloat) callconv(.C) void;pub const GLGETMAPIVPROC = ?*const fn(
target: GLenum,query: GLenum,v: [*c]GLint) callconv(.C) void;pub const GLGETMATERIALFVPROC = ?*const fn(
face: GLenum,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETMATERIALIVPROC = ?*const fn(
face: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETPIXELMAPFVPROC = ?*const fn(
map: GLenum,values: [*c]GLfloat) callconv(.C) void;pub const GLGETPIXELMAPUIVPROC = ?*const fn(
map: GLenum,values: [*c]GLuint) callconv(.C) void;pub const GLGETPIXELMAPUSVPROC = ?*const fn(
map: GLenum,values: [*c]GLushort) callconv(.C) void;pub const GLGETPOLYGONSTIPPLEPROC = ?*const fn(
mask: [*c]GLubyte) callconv(.C) void;pub const GLGETTEXENVFVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXENVIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETTEXGENDVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]GLdouble) callconv(.C) void;pub const GLGETTEXGENFVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXGENIVPROC = ?*const fn(
coord: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLISLISTPROC = ?*const fn(
list: GLuint) callconv(.C) GLboolean;pub const GLFRUSTUMPROC = ?*const fn(
left: GLdouble,right: GLdouble,bottom: GLdouble,top: GLdouble,zNear: GLdouble,zFar: GLdouble) callconv(.C) void;pub const GLLOADIDENTITYPROC = ?*const fn(
) callconv(.C) void;pub const GLLOADMATRIXFPROC = ?*const fn(
m: [*c]const GLfloat) callconv(.C) void;pub const GLLOADMATRIXDPROC = ?*const fn(
m: [*c]const GLdouble) callconv(.C) void;pub const GLMATRIXMODEPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLMULTMATRIXFPROC = ?*const fn(
m: [*c]const GLfloat) callconv(.C) void;pub const GLMULTMATRIXDPROC = ?*const fn(
m: [*c]const GLdouble) callconv(.C) void;pub const GLORTHOPROC = ?*const fn(
left: GLdouble,right: GLdouble,bottom: GLdouble,top: GLdouble,zNear: GLdouble,zFar: GLdouble) callconv(.C) void;pub const GLPOPMATRIXPROC = ?*const fn(
) callconv(.C) void;pub const GLPUSHMATRIXPROC = ?*const fn(
) callconv(.C) void;pub const GLROTATEDPROC = ?*const fn(
angle: GLdouble,x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLROTATEFPROC = ?*const fn(
angle: GLfloat,x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLSCALEDPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLSCALEFPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLTRANSLATEDPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLTRANSLATEFPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLDRAWARRAYSPROC = ?*const fn(
mode: GLenum,first: GLint,count: GLsizei) callconv(.C) void;pub const GLDRAWELEMENTSPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque) callconv(.C) void;pub const GLGETPOINTERVPROC = ?*const fn(
pname: GLenum,params: [*c]?*?*anyopaque) callconv(.C) void;pub const GLPOLYGONOFFSETPROC = ?*const fn(
factor: GLfloat,units: GLfloat) callconv(.C) void;pub const GLCOPYTEXIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLenum,x: GLint,y: GLint,width: GLsizei,border: GLint) callconv(.C) void;pub const GLCOPYTEXIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLenum,x: GLint,y: GLint,width: GLsizei,height: GLsizei,border: GLint) callconv(.C) void;pub const GLCOPYTEXSUBIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,x: GLint,y: GLint,width: GLsizei) callconv(.C) void;pub const GLCOPYTEXSUBIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLTEXSUBIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,width: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLTEXSUBIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,width: GLsizei,height: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLBINDTEXTUREPROC = ?*const fn(
target: GLenum,texture: GLuint) callconv(.C) void;pub const GLDELETETEXTURESPROC = ?*const fn(
n: GLsizei,textures: [*c]const GLuint) callconv(.C) void;pub const GLGENTEXTURESPROC = ?*const fn(
n: GLsizei,textures: [*c]GLuint) callconv(.C) void;pub const GLISTEXTUREPROC = ?*const fn(
texture: GLuint) callconv(.C) GLboolean;pub const GLARRAYELEMENTPROC = ?*const fn(
i: GLint) callconv(.C) void;pub const GLCOLORPOINTERPROC = ?*const fn(
size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLDISABLECLIENTSTATEPROC = ?*const fn(
array: GLenum) callconv(.C) void;pub const GLEDGEFLAGPOINTERPROC = ?*const fn(
stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLENABLECLIENTSTATEPROC = ?*const fn(
array: GLenum) callconv(.C) void;pub const GLINDEXPOINTERPROC = ?*const fn(
type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLINTERLEAVEDARRAYSPROC = ?*const fn(
format: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLNORMALPOINTERPROC = ?*const fn(
type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLTEXCOORDPOINTERPROC = ?*const fn(
size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLVERTEXPOINTERPROC = ?*const fn(
size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLARETEXTURESRESIDENTPROC = ?*const fn(
n: GLsizei,textures: [*c]const GLuint,residences: [*c]GLboolean) callconv(.C) GLboolean;pub const GLPRIORITIZETEXTURESPROC = ?*const fn(
n: GLsizei,textures: [*c]const GLuint,priorities: [*c]const GLfloat) callconv(.C) void;pub const GLINDEXUBPROC = ?*const fn(
c: GLubyte) callconv(.C) void;pub const GLINDEXUBVPROC = ?*const fn(
c: ?[*:0]const GLubyte) callconv(.C) void;pub const GLPOPCLIENTATTRIBPROC = ?*const fn(
) callconv(.C) void;pub const GLPUSHCLIENTATTRIBPROC = ?*const fn(
mask: GLbitfield) callconv(.C) void;pub const GLDRAWRANGEELEMENTSPROC = ?*const fn(
mode: GLenum,start: GLuint,end: GLuint,count: GLsizei,type: GLenum,indices: ?*const anyopaque) callconv(.C) void;pub const GLTEXIMAGE3DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,border: GLint,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLTEXSUBIMAGE3DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLCOPYTEXSUBIMAGE3DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLACTIVETEXTUREPROC = ?*const fn(
texture: GLenum) callconv(.C) void;pub const GLSAMPLECOVERAGEPROC = ?*const fn(
value: GLfloat,invert: GLboolean) callconv(.C) void;pub const GLCOMPRESSEDTEXIMAGE3DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei,border: GLint,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLenum,width: GLsizei,height: GLsizei,border: GLint,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,internalformat: GLenum,width: GLsizei,border: GLint,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXSUBIMAGE3DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXSUBIMAGE2DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,yoffset: GLint,width: GLsizei,height: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXSUBIMAGE1DPROC = ?*const fn(
target: GLenum,level: GLint,xoffset: GLint,width: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLGETCOMPRESSEDTEXIMAGEPROC = ?*const fn(
target: GLenum,level: GLint,img: ?*anyopaque) callconv(.C) void;pub const GLCLIENTACTIVETEXTUREPROC = ?*const fn(
texture: GLenum) callconv(.C) void;pub const GLMULTITEXCOORD1DPROC = ?*const fn(
target: GLenum,s: GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD1DVPROC = ?*const fn(
target: GLenum,v: [*c]const GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD1FPROC = ?*const fn(
target: GLenum,s: GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD1FVPROC = ?*const fn(
target: GLenum,v: [*c]const GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD1IPROC = ?*const fn(
target: GLenum,s: GLint) callconv(.C) void;pub const GLMULTITEXCOORD1IVPROC = ?*const fn(
target: GLenum,v: [*c]const GLint) callconv(.C) void;pub const GLMULTITEXCOORD1SPROC = ?*const fn(
target: GLenum,s: GLshort) callconv(.C) void;pub const GLMULTITEXCOORD1SVPROC = ?*const fn(
target: GLenum,v: [*c]const GLshort) callconv(.C) void;pub const GLMULTITEXCOORD2DPROC = ?*const fn(
target: GLenum,s: GLdouble,t: GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD2DVPROC = ?*const fn(
target: GLenum,v: [*c]const GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD2FPROC = ?*const fn(
target: GLenum,s: GLfloat,t: GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD2FVPROC = ?*const fn(
target: GLenum,v: [*c]const GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD2IPROC = ?*const fn(
target: GLenum,s: GLint,t: GLint) callconv(.C) void;pub const GLMULTITEXCOORD2IVPROC = ?*const fn(
target: GLenum,v: [*c]const GLint) callconv(.C) void;pub const GLMULTITEXCOORD2SPROC = ?*const fn(
target: GLenum,s: GLshort,t: GLshort) callconv(.C) void;pub const GLMULTITEXCOORD2SVPROC = ?*const fn(
target: GLenum,v: [*c]const GLshort) callconv(.C) void;pub const GLMULTITEXCOORD3DPROC = ?*const fn(
target: GLenum,s: GLdouble,t: GLdouble,r: GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD3DVPROC = ?*const fn(
target: GLenum,v: [*c]const GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD3FPROC = ?*const fn(
target: GLenum,s: GLfloat,t: GLfloat,r: GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD3FVPROC = ?*const fn(
target: GLenum,v: [*c]const GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD3IPROC = ?*const fn(
target: GLenum,s: GLint,t: GLint,r: GLint) callconv(.C) void;pub const GLMULTITEXCOORD3IVPROC = ?*const fn(
target: GLenum,v: [*c]const GLint) callconv(.C) void;pub const GLMULTITEXCOORD3SPROC = ?*const fn(
target: GLenum,s: GLshort,t: GLshort,r: GLshort) callconv(.C) void;pub const GLMULTITEXCOORD3SVPROC = ?*const fn(
target: GLenum,v: [*c]const GLshort) callconv(.C) void;pub const GLMULTITEXCOORD4DPROC = ?*const fn(
target: GLenum,s: GLdouble,t: GLdouble,r: GLdouble,q: GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD4DVPROC = ?*const fn(
target: GLenum,v: [*c]const GLdouble) callconv(.C) void;pub const GLMULTITEXCOORD4FPROC = ?*const fn(
target: GLenum,s: GLfloat,t: GLfloat,r: GLfloat,q: GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD4FVPROC = ?*const fn(
target: GLenum,v: [*c]const GLfloat) callconv(.C) void;pub const GLMULTITEXCOORD4IPROC = ?*const fn(
target: GLenum,s: GLint,t: GLint,r: GLint,q: GLint) callconv(.C) void;pub const GLMULTITEXCOORD4IVPROC = ?*const fn(
target: GLenum,v: [*c]const GLint) callconv(.C) void;pub const GLMULTITEXCOORD4SPROC = ?*const fn(
target: GLenum,s: GLshort,t: GLshort,r: GLshort,q: GLshort) callconv(.C) void;pub const GLMULTITEXCOORD4SVPROC = ?*const fn(
target: GLenum,v: [*c]const GLshort) callconv(.C) void;pub const GLLOADTRANSPOSEMATRIXFPROC = ?*const fn(
m: [*c]const GLfloat) callconv(.C) void;pub const GLLOADTRANSPOSEMATRIXDPROC = ?*const fn(
m: [*c]const GLdouble) callconv(.C) void;pub const GLMULTTRANSPOSEMATRIXFPROC = ?*const fn(
m: [*c]const GLfloat) callconv(.C) void;pub const GLMULTTRANSPOSEMATRIXDPROC = ?*const fn(
m: [*c]const GLdouble) callconv(.C) void;pub const GLBLENDFUNCSEPARATEPROC = ?*const fn(
sfactorRGB: GLenum,dfactorRGB: GLenum,sfactorAlpha: GLenum,dfactorAlpha: GLenum) callconv(.C) void;pub const GLMULTIDRAWARRAYSPROC = ?*const fn(
mode: GLenum,first: [*c]const GLint,count: [*c]const GLsizei,drawcount: GLsizei) callconv(.C) void;pub const GLMULTIDRAWELEMENTSPROC = ?*const fn(
mode: GLenum,count: [*c]const GLsizei,type: GLenum,indices: [*c]const ?*const anyopaque,drawcount: GLsizei) callconv(.C) void;pub const GLPOINTPARAMETERFPROC = ?*const fn(
pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLPOINTPARAMETERFVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLfloat) callconv(.C) void;pub const GLPOINTPARAMETERIPROC = ?*const fn(
pname: GLenum,param: GLint) callconv(.C) void;pub const GLPOINTPARAMETERIVPROC = ?*const fn(
pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLFOGCOORDFPROC = ?*const fn(
coord: GLfloat) callconv(.C) void;pub const GLFOGCOORDFVPROC = ?*const fn(
coord: [*c]const GLfloat) callconv(.C) void;pub const GLFOGCOORDDPROC = ?*const fn(
coord: GLdouble) callconv(.C) void;pub const GLFOGCOORDDVPROC = ?*const fn(
coord: [*c]const GLdouble) callconv(.C) void;pub const GLFOGCOORDPOINTERPROC = ?*const fn(
type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLSECONDARYCOLOR3BPROC = ?*const fn(
red: GLbyte,green: GLbyte,blue: GLbyte) callconv(.C) void;pub const GLSECONDARYCOLOR3BVPROC = ?*const fn(
v: [*c]const GLbyte) callconv(.C) void;pub const GLSECONDARYCOLOR3DPROC = ?*const fn(
red: GLdouble,green: GLdouble,blue: GLdouble) callconv(.C) void;pub const GLSECONDARYCOLOR3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLSECONDARYCOLOR3FPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat) callconv(.C) void;pub const GLSECONDARYCOLOR3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLSECONDARYCOLOR3IPROC = ?*const fn(
red: GLint,green: GLint,blue: GLint) callconv(.C) void;pub const GLSECONDARYCOLOR3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLSECONDARYCOLOR3SPROC = ?*const fn(
red: GLshort,green: GLshort,blue: GLshort) callconv(.C) void;pub const GLSECONDARYCOLOR3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLSECONDARYCOLOR3UBPROC = ?*const fn(
red: GLubyte,green: GLubyte,blue: GLubyte) callconv(.C) void;pub const GLSECONDARYCOLOR3UBVPROC = ?*const fn(
v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLSECONDARYCOLOR3UIPROC = ?*const fn(
red: GLuint,green: GLuint,blue: GLuint) callconv(.C) void;pub const GLSECONDARYCOLOR3UIVPROC = ?*const fn(
v: [*c]const GLuint) callconv(.C) void;pub const GLSECONDARYCOLOR3USPROC = ?*const fn(
red: GLushort,green: GLushort,blue: GLushort) callconv(.C) void;pub const GLSECONDARYCOLOR3USVPROC = ?*const fn(
v: [*c]const GLushort) callconv(.C) void;pub const GLSECONDARYCOLORPOINTERPROC = ?*const fn(
size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLWINDOWPOS2DPROC = ?*const fn(
x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLWINDOWPOS2DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLWINDOWPOS2FPROC = ?*const fn(
x: GLfloat,y: GLfloat) callconv(.C) void;pub const GLWINDOWPOS2FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLWINDOWPOS2IPROC = ?*const fn(
x: GLint,y: GLint) callconv(.C) void;pub const GLWINDOWPOS2IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLWINDOWPOS2SPROC = ?*const fn(
x: GLshort,y: GLshort) callconv(.C) void;pub const GLWINDOWPOS2SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLWINDOWPOS3DPROC = ?*const fn(
x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLWINDOWPOS3DVPROC = ?*const fn(
v: [*c]const GLdouble) callconv(.C) void;pub const GLWINDOWPOS3FPROC = ?*const fn(
x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLWINDOWPOS3FVPROC = ?*const fn(
v: [*c]const GLfloat) callconv(.C) void;pub const GLWINDOWPOS3IPROC = ?*const fn(
x: GLint,y: GLint,z: GLint) callconv(.C) void;pub const GLWINDOWPOS3IVPROC = ?*const fn(
v: [*c]const GLint) callconv(.C) void;pub const GLWINDOWPOS3SPROC = ?*const fn(
x: GLshort,y: GLshort,z: GLshort) callconv(.C) void;pub const GLWINDOWPOS3SVPROC = ?*const fn(
v: [*c]const GLshort) callconv(.C) void;pub const GLBLENDCOLORPROC = ?*const fn(
red: GLfloat,green: GLfloat,blue: GLfloat,alpha: GLfloat) callconv(.C) void;pub const GLBLENDEQUATIONPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLGENQUERIESPROC = ?*const fn(
n: GLsizei,ids: [*c]GLuint) callconv(.C) void;pub const GLDELETEQUERIESPROC = ?*const fn(
n: GLsizei,ids: [*c]const GLuint) callconv(.C) void;pub const GLISQUERYPROC = ?*const fn(
id: GLuint) callconv(.C) GLboolean;pub const GLBEGINQUERYPROC = ?*const fn(
target: GLenum,id: GLuint) callconv(.C) void;pub const GLENDQUERYPROC = ?*const fn(
target: GLenum) callconv(.C) void;pub const GLGETQUERYIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETQUERYOBJECTIVPROC = ?*const fn(
id: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETQUERYOBJECTUIVPROC = ?*const fn(
id: GLuint,pname: GLenum,params: [*c]GLuint) callconv(.C) void;pub const GLBINDBUFFERPROC = ?*const fn(
target: GLenum,buffer: GLuint) callconv(.C) void;pub const GLDELETEBUFFERSPROC = ?*const fn(
n: GLsizei,buffers: [*c]const GLuint) callconv(.C) void;pub const GLGENBUFFERSPROC = ?*const fn(
n: GLsizei,buffers: [*c]GLuint) callconv(.C) void;pub const GLISBUFFERPROC = ?*const fn(
buffer: GLuint) callconv(.C) GLboolean;pub const GLBUFFERDATAPROC = ?*const fn(
target: GLenum,size: GLsizeiptr,data: ?*const anyopaque,usage: GLenum) callconv(.C) void;pub const GLBUFFERSUBDATAPROC = ?*const fn(
target: GLenum,offset: GLintptr,size: GLsizeiptr,data: ?*const anyopaque) callconv(.C) void;pub const GLGETBUFFERSUBDATAPROC = ?*const fn(
target: GLenum,offset: GLintptr,size: GLsizeiptr,data: ?*anyopaque) callconv(.C) void;pub const GLMAPBUFFERPROC = ?*const fn(
target: GLenum,access: GLenum) callconv(.C) ?*anyopaque;pub const GLUNMAPBUFFERPROC = ?*const fn(
target: GLenum) callconv(.C) GLboolean;pub const GLGETBUFFERPARAMETERIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETBUFFERPOINTERVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]?*?*anyopaque) callconv(.C) void;pub const GLBLENDEQUATIONSEPARATEPROC = ?*const fn(
modeRGB: GLenum,modeAlpha: GLenum) callconv(.C) void;pub const GLDRAWBUFFERSPROC = ?*const fn(
n: GLsizei,bufs: [*c]const GLenum) callconv(.C) void;pub const GLSTENCILOPSEPARATEPROC = ?*const fn(
face: GLenum,sfail: GLenum,dpfail: GLenum,dppass: GLenum) callconv(.C) void;pub const GLSTENCILFUNCSEPARATEPROC = ?*const fn(
face: GLenum,func: GLenum,ref: GLint,mask: GLuint) callconv(.C) void;pub const GLSTENCILMASKSEPARATEPROC = ?*const fn(
face: GLenum,mask: GLuint) callconv(.C) void;pub const GLATTACHSHADERPROC = ?*const fn(
program: GLuint,shader: GLuint) callconv(.C) void;pub const GLBINDATTRIBLOCATIONPROC = ?*const fn(
program: GLuint,index: GLuint,name: [*c]const GLchar) callconv(.C) void;pub const GLCOMPILESHADERPROC = ?*const fn(
shader: GLuint) callconv(.C) void;pub const GLCREATEPROGRAMPROC = ?*const fn(
) callconv(.C) GLuint;pub const GLCREATESHADERPROC = ?*const fn(
type: GLenum) callconv(.C) GLuint;pub const GLDELETEPROGRAMPROC = ?*const fn(
program: GLuint) callconv(.C) void;pub const GLDELETESHADERPROC = ?*const fn(
shader: GLuint) callconv(.C) void;pub const GLDETACHSHADERPROC = ?*const fn(
program: GLuint,shader: GLuint) callconv(.C) void;pub const GLDISABLEVERTEXATTRIBARRAYPROC = ?*const fn(
index: GLuint) callconv(.C) void;pub const GLENABLEVERTEXATTRIBARRAYPROC = ?*const fn(
index: GLuint) callconv(.C) void;pub const GLGETACTIVEATTRIBPROC = ?*const fn(
program: GLuint,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,size: [*c]GLint,type: [*c]GLenum,name: [*c]GLchar) callconv(.C) void;pub const GLGETACTIVEUNIFORMPROC = ?*const fn(
program: GLuint,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,size: [*c]GLint,type: [*c]GLenum,name: [*c]GLchar) callconv(.C) void;pub const GLGETATTACHEDSHADERSPROC = ?*const fn(
program: GLuint,maxCount: GLsizei,count: [*c]GLsizei,shaders: [*c]GLuint) callconv(.C) void;pub const GLGETATTRIBLOCATIONPROC = ?*const fn(
program: GLuint,name: [*c]const GLchar) callconv(.C) GLint;pub const GLGETPROGRAMIVPROC = ?*const fn(
program: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETPROGRAMINFOLOGPROC = ?*const fn(
program: GLuint,bufSize: GLsizei,length: [*c]GLsizei,infoLog: [*c]GLchar) callconv(.C) void;pub const GLGETSHADERIVPROC = ?*const fn(
shader: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETSHADERINFOLOGPROC = ?*const fn(
shader: GLuint,bufSize: GLsizei,length: [*c]GLsizei,infoLog: [*c]GLchar) callconv(.C) void;pub const GLGETSHADERSOURCEPROC = ?*const fn(
shader: GLuint,bufSize: GLsizei,length: [*c]GLsizei,source: [*c]GLchar) callconv(.C) void;pub const GLGETUNIFORMLOCATIONPROC = ?*const fn(
program: GLuint,name: [*c]const GLchar) callconv(.C) GLint;pub const GLGETUNIFORMFVPROC = ?*const fn(
program: GLuint,location: GLint,params: [*c]GLfloat) callconv(.C) void;pub const GLGETUNIFORMIVPROC = ?*const fn(
program: GLuint,location: GLint,params: [*c]GLint) callconv(.C) void;pub const GLGETVERTEXATTRIBDVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLdouble) callconv(.C) void;pub const GLGETVERTEXATTRIBFVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETVERTEXATTRIBIVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETVERTEXATTRIBPOINTERVPROC = ?*const fn(
index: GLuint,pname: GLenum,pointer: [*c]?*?*anyopaque) callconv(.C) void;pub const GLISPROGRAMPROC = ?*const fn(
program: GLuint) callconv(.C) GLboolean;pub const GLISSHADERPROC = ?*const fn(
shader: GLuint) callconv(.C) GLboolean;pub const GLLINKPROGRAMPROC = ?*const fn(
program: GLuint) callconv(.C) void;pub const GLSHADERSOURCEPROC = ?*const fn(
shader: GLuint,count: GLsizei,string: [*c]const [*c]const GLchar,length: [*c]const GLint) callconv(.C) void;pub const GLUSEPROGRAMPROC = ?*const fn(
program: GLuint) callconv(.C) void;pub const GLUNIFORM1FPROC = ?*const fn(
location: GLint,v0: GLfloat) callconv(.C) void;pub const GLUNIFORM2FPROC = ?*const fn(
location: GLint,v0: GLfloat,v1: GLfloat) callconv(.C) void;pub const GLUNIFORM3FPROC = ?*const fn(
location: GLint,v0: GLfloat,v1: GLfloat,v2: GLfloat) callconv(.C) void;pub const GLUNIFORM4FPROC = ?*const fn(
location: GLint,v0: GLfloat,v1: GLfloat,v2: GLfloat,v3: GLfloat) callconv(.C) void;pub const GLUNIFORM1IPROC = ?*const fn(
location: GLint,v0: GLint) callconv(.C) void;pub const GLUNIFORM2IPROC = ?*const fn(
location: GLint,v0: GLint,v1: GLint) callconv(.C) void;pub const GLUNIFORM3IPROC = ?*const fn(
location: GLint,v0: GLint,v1: GLint,v2: GLint) callconv(.C) void;pub const GLUNIFORM4IPROC = ?*const fn(
location: GLint,v0: GLint,v1: GLint,v2: GLint,v3: GLint) callconv(.C) void;pub const GLUNIFORM1FVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORM2FVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORM3FVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORM4FVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORM1IVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLUNIFORM2IVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLUNIFORM3IVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLUNIFORM4IVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLUNIFORMMATRIX2FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX3FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX4FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLVALIDATEPROGRAMPROC = ?*const fn(
program: GLuint) callconv(.C) void;pub const GLVERTEXATTRIB1DPROC = ?*const fn(
index: GLuint,x: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB1DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB1FPROC = ?*const fn(
index: GLuint,x: GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB1FVPROC = ?*const fn(
index: GLuint,v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB1SPROC = ?*const fn(
index: GLuint,x: GLshort) callconv(.C) void;pub const GLVERTEXATTRIB1SVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIB2DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB2DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB2FPROC = ?*const fn(
index: GLuint,x: GLfloat,y: GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB2FVPROC = ?*const fn(
index: GLuint,v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB2SPROC = ?*const fn(
index: GLuint,x: GLshort,y: GLshort) callconv(.C) void;pub const GLVERTEXATTRIB2SVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIB3DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB3DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB3FPROC = ?*const fn(
index: GLuint,x: GLfloat,y: GLfloat,z: GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB3FVPROC = ?*const fn(
index: GLuint,v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB3SPROC = ?*const fn(
index: GLuint,x: GLshort,y: GLshort,z: GLshort) callconv(.C) void;pub const GLVERTEXATTRIB3SVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIB4NBVPROC = ?*const fn(
index: GLuint,v: [*c]const GLbyte) callconv(.C) void;pub const GLVERTEXATTRIB4NIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIB4NSVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIB4NUBPROC = ?*const fn(
index: GLuint,x: GLubyte,y: GLubyte,z: GLubyte,w: GLubyte) callconv(.C) void;pub const GLVERTEXATTRIB4NUBVPROC = ?*const fn(
index: GLuint,v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLVERTEXATTRIB4NUIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIB4NUSVPROC = ?*const fn(
index: GLuint,v: [*c]const GLushort) callconv(.C) void;pub const GLVERTEXATTRIB4BVPROC = ?*const fn(
index: GLuint,v: [*c]const GLbyte) callconv(.C) void;pub const GLVERTEXATTRIB4DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble,z: GLdouble,w: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB4DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIB4FPROC = ?*const fn(
index: GLuint,x: GLfloat,y: GLfloat,z: GLfloat,w: GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB4FVPROC = ?*const fn(
index: GLuint,v: [*c]const GLfloat) callconv(.C) void;pub const GLVERTEXATTRIB4IVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIB4SPROC = ?*const fn(
index: GLuint,x: GLshort,y: GLshort,z: GLshort,w: GLshort) callconv(.C) void;pub const GLVERTEXATTRIB4SVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIB4UBVPROC = ?*const fn(
index: GLuint,v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLVERTEXATTRIB4UIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIB4USVPROC = ?*const fn(
index: GLuint,v: [*c]const GLushort) callconv(.C) void;pub const GLVERTEXATTRIBPOINTERPROC = ?*const fn(
index: GLuint,size: GLint,type: GLenum,normalized: GLboolean,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLUNIFORMMATRIX2X3FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX3X2FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX2X4FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX4X2FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX3X4FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLUNIFORMMATRIX4X3FVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLCOLORMASKIPROC = ?*const fn(
index: GLuint,r: GLboolean,g: GLboolean,b: GLboolean,a: GLboolean) callconv(.C) void;pub const GLGETBOOLEANI_VPROC = ?*const fn(
target: GLenum,index: GLuint,data: [*c]GLboolean) callconv(.C) void;pub const GLGETINTEGERI_VPROC = ?*const fn(
target: GLenum,index: GLuint,data: [*c]GLint) callconv(.C) void;pub const GLENABLEIPROC = ?*const fn(
target: GLenum,index: GLuint) callconv(.C) void;pub const GLDISABLEIPROC = ?*const fn(
target: GLenum,index: GLuint) callconv(.C) void;pub const GLISENABLEDIPROC = ?*const fn(
target: GLenum,index: GLuint) callconv(.C) GLboolean;pub const GLBEGINTRANSFORMFEEDBACKPROC = ?*const fn(
primitiveMode: GLenum) callconv(.C) void;pub const GLENDTRANSFORMFEEDBACKPROC = ?*const fn(
) callconv(.C) void;pub const GLBINDBUFFERRANGEPROC = ?*const fn(
target: GLenum,index: GLuint,buffer: GLuint,offset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLBINDBUFFERBASEPROC = ?*const fn(
target: GLenum,index: GLuint,buffer: GLuint) callconv(.C) void;pub const GLTRANSFORMFEEDBACKVARYINGSPROC = ?*const fn(
program: GLuint,count: GLsizei,varyings: [*c]const [*c]const GLchar,bufferMode: GLenum) callconv(.C) void;pub const GLGETTRANSFORMFEEDBACKVARYINGPROC = ?*const fn(
program: GLuint,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,size: [*c]GLsizei,type: [*c]GLenum,name: [*c]GLchar) callconv(.C) void;pub const GLCLAMPCOLORPROC = ?*const fn(
target: GLenum,clamp: GLenum) callconv(.C) void;pub const GLBEGINCONDITIONALRENDERPROC = ?*const fn(
id: GLuint,mode: GLenum) callconv(.C) void;pub const GLENDCONDITIONALRENDERPROC = ?*const fn(
) callconv(.C) void;pub const GLVERTEXATTRIBIPOINTERPROC = ?*const fn(
index: GLuint,size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLGETVERTEXATTRIBIIVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETVERTEXATTRIBIUIVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI1IPROC = ?*const fn(
index: GLuint,x: GLint) callconv(.C) void;pub const GLVERTEXATTRIBI2IPROC = ?*const fn(
index: GLuint,x: GLint,y: GLint) callconv(.C) void;pub const GLVERTEXATTRIBI3IPROC = ?*const fn(
index: GLuint,x: GLint,y: GLint,z: GLint) callconv(.C) void;pub const GLVERTEXATTRIBI4IPROC = ?*const fn(
index: GLuint,x: GLint,y: GLint,z: GLint,w: GLint) callconv(.C) void;pub const GLVERTEXATTRIBI1UIPROC = ?*const fn(
index: GLuint,x: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI2UIPROC = ?*const fn(
index: GLuint,x: GLuint,y: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI3UIPROC = ?*const fn(
index: GLuint,x: GLuint,y: GLuint,z: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI4UIPROC = ?*const fn(
index: GLuint,x: GLuint,y: GLuint,z: GLuint,w: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI1IVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIBI2IVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIBI3IVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIBI4IVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLVERTEXATTRIBI1UIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI2UIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI3UIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI4UIVPROC = ?*const fn(
index: GLuint,v: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBI4BVPROC = ?*const fn(
index: GLuint,v: [*c]const GLbyte) callconv(.C) void;pub const GLVERTEXATTRIBI4SVPROC = ?*const fn(
index: GLuint,v: [*c]const GLshort) callconv(.C) void;pub const GLVERTEXATTRIBI4UBVPROC = ?*const fn(
index: GLuint,v: ?[*:0]const GLubyte) callconv(.C) void;pub const GLVERTEXATTRIBI4USVPROC = ?*const fn(
index: GLuint,v: [*c]const GLushort) callconv(.C) void;pub const GLGETUNIFORMUIVPROC = ?*const fn(
program: GLuint,location: GLint,params: [*c]GLuint) callconv(.C) void;pub const GLBINDFRAGDATALOCATIONPROC = ?*const fn(
program: GLuint,color: GLuint,name: [*c]const GLchar) callconv(.C) void;pub const GLGETFRAGDATALOCATIONPROC = ?*const fn(
program: GLuint,name: [*c]const GLchar) callconv(.C) GLint;pub const GLUNIFORM1UIPROC = ?*const fn(
location: GLint,v0: GLuint) callconv(.C) void;pub const GLUNIFORM2UIPROC = ?*const fn(
location: GLint,v0: GLuint,v1: GLuint) callconv(.C) void;pub const GLUNIFORM3UIPROC = ?*const fn(
location: GLint,v0: GLuint,v1: GLuint,v2: GLuint) callconv(.C) void;pub const GLUNIFORM4UIPROC = ?*const fn(
location: GLint,v0: GLuint,v1: GLuint,v2: GLuint,v3: GLuint) callconv(.C) void;pub const GLUNIFORM1UIVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLUNIFORM2UIVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLUNIFORM3UIVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLUNIFORM4UIVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLTEXPARAMETERIIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLTEXPARAMETERIUIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]const GLuint) callconv(.C) void;pub const GLGETTEXPARAMETERIIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETTEXPARAMETERIUIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLuint) callconv(.C) void;pub const GLCLEARBUFFERIVPROC = ?*const fn(
buffer: GLenum,drawbuffer: GLint,value: [*c]const GLint) callconv(.C) void;pub const GLCLEARBUFFERUIVPROC = ?*const fn(
buffer: GLenum,drawbuffer: GLint,value: [*c]const GLuint) callconv(.C) void;pub const GLCLEARBUFFERFVPROC = ?*const fn(
buffer: GLenum,drawbuffer: GLint,value: [*c]const GLfloat) callconv(.C) void;pub const GLCLEARBUFFERFIPROC = ?*const fn(
buffer: GLenum,drawbuffer: GLint,depth: GLfloat,stencil: GLint) callconv(.C) void;pub const GLGETSTRINGIPROC = ?*const fn(
name: GLenum,index: GLuint) callconv(.C) ?[*:0]const GLubyte;pub const GLISRENDERBUFFERPROC = ?*const fn(
renderbuffer: GLuint) callconv(.C) GLboolean;pub const GLBINDRENDERBUFFERPROC = ?*const fn(
target: GLenum,renderbuffer: GLuint) callconv(.C) void;pub const GLDELETERENDERBUFFERSPROC = ?*const fn(
n: GLsizei,renderbuffers: [*c]const GLuint) callconv(.C) void;pub const GLGENRENDERBUFFERSPROC = ?*const fn(
n: GLsizei,renderbuffers: [*c]GLuint) callconv(.C) void;pub const GLRENDERBUFFERSTORAGEPROC = ?*const fn(
target: GLenum,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLGETRENDERBUFFERPARAMETERIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLISFRAMEBUFFERPROC = ?*const fn(
framebuffer: GLuint) callconv(.C) GLboolean;pub const GLBINDFRAMEBUFFERPROC = ?*const fn(
target: GLenum,framebuffer: GLuint) callconv(.C) void;pub const GLDELETEFRAMEBUFFERSPROC = ?*const fn(
n: GLsizei,framebuffers: [*c]const GLuint) callconv(.C) void;pub const GLGENFRAMEBUFFERSPROC = ?*const fn(
n: GLsizei,framebuffers: [*c]GLuint) callconv(.C) void;pub const GLCHECKFRAMEBUFFERSTATUSPROC = ?*const fn(
target: GLenum) callconv(.C) GLenum;pub const GLFRAMEBUFFERTEXTURE1DPROC = ?*const fn(
target: GLenum,attachment: GLenum,textarget: GLenum,texture: GLuint,level: GLint) callconv(.C) void;pub const GLFRAMEBUFFERTEXTURE2DPROC = ?*const fn(
target: GLenum,attachment: GLenum,textarget: GLenum,texture: GLuint,level: GLint) callconv(.C) void;pub const GLFRAMEBUFFERTEXTURE3DPROC = ?*const fn(
target: GLenum,attachment: GLenum,textarget: GLenum,texture: GLuint,level: GLint,zoffset: GLint) callconv(.C) void;pub const GLFRAMEBUFFERRENDERBUFFERPROC = ?*const fn(
target: GLenum,attachment: GLenum,renderbuffertarget: GLenum,renderbuffer: GLuint) callconv(.C) void;pub const GLGETFRAMEBUFFERATTACHMENTPARAMETERIVPROC = ?*const fn(
target: GLenum,attachment: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGENERATEMIPMAPPROC = ?*const fn(
target: GLenum) callconv(.C) void;pub const GLBLITFRAMEBUFFERPROC = ?*const fn(
srcX0: GLint,srcY0: GLint,srcX1: GLint,srcY1: GLint,dstX0: GLint,dstY0: GLint,dstX1: GLint,dstY1: GLint,mask: GLbitfield,filter: GLenum) callconv(.C) void;pub const GLRENDERBUFFERSTORAGEMULTISAMPLEPROC = ?*const fn(
target: GLenum,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLFRAMEBUFFERTEXTURELAYERPROC = ?*const fn(
target: GLenum,attachment: GLenum,texture: GLuint,level: GLint,layer: GLint) callconv(.C) void;pub const GLMAPBUFFERRANGEPROC = ?*const fn(
target: GLenum,offset: GLintptr,length: GLsizeiptr,access: GLbitfield) callconv(.C) ?*anyopaque;pub const GLFLUSHMAPPEDBUFFERRANGEPROC = ?*const fn(
target: GLenum,offset: GLintptr,length: GLsizeiptr) callconv(.C) void;pub const GLBINDVERTEXARRAYPROC = ?*const fn(
array: GLuint) callconv(.C) void;pub const GLDELETEVERTEXARRAYSPROC = ?*const fn(
n: GLsizei,arrays: [*c]const GLuint) callconv(.C) void;pub const GLGENVERTEXARRAYSPROC = ?*const fn(
n: GLsizei,arrays: [*c]GLuint) callconv(.C) void;pub const GLISVERTEXARRAYPROC = ?*const fn(
array: GLuint) callconv(.C) GLboolean;pub const GLDRAWARRAYSINSTANCEDPROC = ?*const fn(
mode: GLenum,first: GLint,count: GLsizei,instancecount: GLsizei) callconv(.C) void;pub const GLDRAWELEMENTSINSTANCEDPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque,instancecount: GLsizei) callconv(.C) void;pub const GLTEXBUFFERPROC = ?*const fn(
target: GLenum,internalformat: GLenum,buffer: GLuint) callconv(.C) void;pub const GLPRIMITIVERESTARTINDEXPROC = ?*const fn(
index: GLuint) callconv(.C) void;pub const GLCOPYBUFFERSUBDATAPROC = ?*const fn(
readTarget: GLenum,writeTarget: GLenum,readOffset: GLintptr,writeOffset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLGETUNIFORMINDICESPROC = ?*const fn(
program: GLuint,uniformCount: GLsizei,uniformNames: [*c]const [*c]const GLchar,uniformIndices: [*c]GLuint) callconv(.C) void;pub const GLGETACTIVEUNIFORMSIVPROC = ?*const fn(
program: GLuint,uniformCount: GLsizei,uniformIndices: [*c]const GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETACTIVEUNIFORMNAMEPROC = ?*const fn(
program: GLuint,uniformIndex: GLuint,bufSize: GLsizei,length: [*c]GLsizei,uniformName: [*c]GLchar) callconv(.C) void;pub const GLGETUNIFORMBLOCKINDEXPROC = ?*const fn(
program: GLuint,uniformBlockName: [*c]const GLchar) callconv(.C) GLuint;pub const GLGETACTIVEUNIFORMBLOCKIVPROC = ?*const fn(
program: GLuint,uniformBlockIndex: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETACTIVEUNIFORMBLOCKNAMEPROC = ?*const fn(
program: GLuint,uniformBlockIndex: GLuint,bufSize: GLsizei,length: [*c]GLsizei,uniformBlockName: [*c]GLchar) callconv(.C) void;pub const GLUNIFORMBLOCKBINDINGPROC = ?*const fn(
program: GLuint,uniformBlockIndex: GLuint,uniformBlockBinding: GLuint) callconv(.C) void;pub const GLDRAWELEMENTSBASEVERTEXPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque,basevertex: GLint) callconv(.C) void;pub const GLDRAWRANGEELEMENTSBASEVERTEXPROC = ?*const fn(
mode: GLenum,start: GLuint,end: GLuint,count: GLsizei,type: GLenum,indices: ?*const anyopaque,basevertex: GLint) callconv(.C) void;pub const GLDRAWELEMENTSINSTANCEDBASEVERTEXPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque,instancecount: GLsizei,basevertex: GLint) callconv(.C) void;pub const GLMULTIDRAWELEMENTSBASEVERTEXPROC = ?*const fn(
mode: GLenum,count: [*c]const GLsizei,type: GLenum,indices: [*c]const ?*const anyopaque,drawcount: GLsizei,basevertex: [*c]const GLint) callconv(.C) void;pub const GLPROVOKINGVERTEXPROC = ?*const fn(
mode: GLenum) callconv(.C) void;pub const GLFENCESYNCPROC = ?*const fn(
condition: GLenum,flags: GLbitfield) callconv(.C) GLsync;pub const GLISSYNCPROC = ?*const fn(
sync: GLsync) callconv(.C) GLboolean;pub const GLDELETESYNCPROC = ?*const fn(
sync: GLsync) callconv(.C) void;pub const GLCLIENTWAITSYNCPROC = ?*const fn(
sync: GLsync,flags: GLbitfield,timeout: GLuint64) callconv(.C) GLenum;pub const GLWAITSYNCPROC = ?*const fn(
sync: GLsync,flags: GLbitfield,timeout: GLuint64) callconv(.C) void;pub const GLGETINTEGER64VPROC = ?*const fn(
pname: GLenum,data: [*c]GLint64) callconv(.C) void;pub const GLGETSYNCIVPROC = ?*const fn(
sync: GLsync,pname: GLenum,count: GLsizei,length: [*c]GLsizei,values: [*c]GLint) callconv(.C) void;pub const GLGETINTEGER64I_VPROC = ?*const fn(
target: GLenum,index: GLuint,data: [*c]GLint64) callconv(.C) void;pub const GLGETBUFFERPARAMETERI64VPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint64) callconv(.C) void;pub const GLFRAMEBUFFERTEXTUREPROC = ?*const fn(
target: GLenum,attachment: GLenum,texture: GLuint,level: GLint) callconv(.C) void;pub const GLTEXIMAGE2DMULTISAMPLEPROC = ?*const fn(
target: GLenum,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLTEXIMAGE3DMULTISAMPLEPROC = ?*const fn(
target: GLenum,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLGETMULTISAMPLEFVPROC = ?*const fn(
pname: GLenum,index: GLuint,val: [*c]GLfloat) callconv(.C) void;pub const GLSAMPLEMASKIPROC = ?*const fn(
maskNumber: GLuint,mask: GLbitfield) callconv(.C) void;pub const GLBINDFRAGDATALOCATIONINDEXEDPROC = ?*const fn(
program: GLuint,colorNumber: GLuint,index: GLuint,name: [*c]const GLchar) callconv(.C) void;pub const GLGETFRAGDATAINDEXPROC = ?*const fn(
program: GLuint,name: [*c]const GLchar) callconv(.C) GLint;pub const GLGENSAMPLERSPROC = ?*const fn(
count: GLsizei,samplers: [*c]GLuint) callconv(.C) void;pub const GLDELETESAMPLERSPROC = ?*const fn(
count: GLsizei,samplers: [*c]const GLuint) callconv(.C) void;pub const GLISSAMPLERPROC = ?*const fn(
sampler: GLuint) callconv(.C) GLboolean;pub const GLBINDSAMPLERPROC = ?*const fn(
unit: GLuint,sampler: GLuint) callconv(.C) void;pub const GLSAMPLERPARAMETERIPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: GLint) callconv(.C) void;pub const GLSAMPLERPARAMETERIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: [*c]const GLint) callconv(.C) void;pub const GLSAMPLERPARAMETERFPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLSAMPLERPARAMETERFVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: [*c]const GLfloat) callconv(.C) void;pub const GLSAMPLERPARAMETERIIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: [*c]const GLint) callconv(.C) void;pub const GLSAMPLERPARAMETERIUIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,param: [*c]const GLuint) callconv(.C) void;pub const GLGETSAMPLERPARAMETERIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETSAMPLERPARAMETERIIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETSAMPLERPARAMETERFVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETSAMPLERPARAMETERIUIVPROC = ?*const fn(
sampler: GLuint,pname: GLenum,params: [*c]GLuint) callconv(.C) void;pub const GLQUERYCOUNTERPROC = ?*const fn(
id: GLuint,target: GLenum) callconv(.C) void;pub const GLGETQUERYOBJECTI64VPROC = ?*const fn(
id: GLuint,pname: GLenum,params: [*c]GLint64) callconv(.C) void;pub const GLGETQUERYOBJECTUI64VPROC = ?*const fn(
id: GLuint,pname: GLenum,params: [*c]GLuint64) callconv(.C) void;pub const GLVERTEXATTRIBDIVISORPROC = ?*const fn(
index: GLuint,divisor: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP1UIPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP1UIVPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP2UIPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP2UIVPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP3UIPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP3UIVPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP4UIPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBP4UIVPROC = ?*const fn(
index: GLuint,type: GLenum,normalized: GLboolean,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXP2UIPROC = ?*const fn(
type: GLenum,value: GLuint) callconv(.C) void;pub const GLVERTEXP2UIVPROC = ?*const fn(
type: GLenum,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXP3UIPROC = ?*const fn(
type: GLenum,value: GLuint) callconv(.C) void;pub const GLVERTEXP3UIVPROC = ?*const fn(
type: GLenum,value: [*c]const GLuint) callconv(.C) void;pub const GLVERTEXP4UIPROC = ?*const fn(
type: GLenum,value: GLuint) callconv(.C) void;pub const GLVERTEXP4UIVPROC = ?*const fn(
type: GLenum,value: [*c]const GLuint) callconv(.C) void;pub const GLTEXCOORDP1UIPROC = ?*const fn(
type: GLenum,coords: GLuint) callconv(.C) void;pub const GLTEXCOORDP1UIVPROC = ?*const fn(
type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLTEXCOORDP2UIPROC = ?*const fn(
type: GLenum,coords: GLuint) callconv(.C) void;pub const GLTEXCOORDP2UIVPROC = ?*const fn(
type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLTEXCOORDP3UIPROC = ?*const fn(
type: GLenum,coords: GLuint) callconv(.C) void;pub const GLTEXCOORDP3UIVPROC = ?*const fn(
type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLTEXCOORDP4UIPROC = ?*const fn(
type: GLenum,coords: GLuint) callconv(.C) void;pub const GLTEXCOORDP4UIVPROC = ?*const fn(
type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP1UIPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP1UIVPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP2UIPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP2UIVPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP3UIPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP3UIVPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP4UIPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: GLuint) callconv(.C) void;pub const GLMULTITEXCOORDP4UIVPROC = ?*const fn(
texture: GLenum,type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLNORMALP3UIPROC = ?*const fn(
type: GLenum,coords: GLuint) callconv(.C) void;pub const GLNORMALP3UIVPROC = ?*const fn(
type: GLenum,coords: [*c]const GLuint) callconv(.C) void;pub const GLCOLORP3UIPROC = ?*const fn(
type: GLenum,color: GLuint) callconv(.C) void;pub const GLCOLORP3UIVPROC = ?*const fn(
type: GLenum,color: [*c]const GLuint) callconv(.C) void;pub const GLCOLORP4UIPROC = ?*const fn(
type: GLenum,color: GLuint) callconv(.C) void;pub const GLCOLORP4UIVPROC = ?*const fn(
type: GLenum,color: [*c]const GLuint) callconv(.C) void;pub const GLSECONDARYCOLORP3UIPROC = ?*const fn(
type: GLenum,color: GLuint) callconv(.C) void;pub const GLSECONDARYCOLORP3UIVPROC = ?*const fn(
type: GLenum,color: [*c]const GLuint) callconv(.C) void;pub const GLMINSAMPLESHADINGPROC = ?*const fn(
value: GLfloat) callconv(.C) void;pub const GLBLENDEQUATIONIPROC = ?*const fn(
buf: GLuint,mode: GLenum) callconv(.C) void;pub const GLBLENDEQUATIONSEPARATEIPROC = ?*const fn(
buf: GLuint,modeRGB: GLenum,modeAlpha: GLenum) callconv(.C) void;pub const GLBLENDFUNCIPROC = ?*const fn(
buf: GLuint,src: GLenum,dst: GLenum) callconv(.C) void;pub const GLBLENDFUNCSEPARATEIPROC = ?*const fn(
buf: GLuint,srcRGB: GLenum,dstRGB: GLenum,srcAlpha: GLenum,dstAlpha: GLenum) callconv(.C) void;pub const GLDRAWARRAYSINDIRECTPROC = ?*const fn(
mode: GLenum,indirect: ?*const anyopaque) callconv(.C) void;pub const GLDRAWELEMENTSINDIRECTPROC = ?*const fn(
mode: GLenum,type: GLenum,indirect: ?*const anyopaque) callconv(.C) void;pub const GLUNIFORM1DPROC = ?*const fn(
location: GLint,x: GLdouble) callconv(.C) void;pub const GLUNIFORM2DPROC = ?*const fn(
location: GLint,x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLUNIFORM3DPROC = ?*const fn(
location: GLint,x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLUNIFORM4DPROC = ?*const fn(
location: GLint,x: GLdouble,y: GLdouble,z: GLdouble,w: GLdouble) callconv(.C) void;pub const GLUNIFORM1DVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORM2DVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORM3DVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORM4DVPROC = ?*const fn(
location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX2DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX3DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX4DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX2X3DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX2X4DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX3X2DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX3X4DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX4X2DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLUNIFORMMATRIX4X3DVPROC = ?*const fn(
location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLGETUNIFORMDVPROC = ?*const fn(
program: GLuint,location: GLint,params: [*c]GLdouble) callconv(.C) void;pub const GLGETSUBROUTINEUNIFORMLOCATIONPROC = ?*const fn(
program: GLuint,shadertype: GLenum,name: [*c]const GLchar) callconv(.C) GLint;pub const GLGETSUBROUTINEINDEXPROC = ?*const fn(
program: GLuint,shadertype: GLenum,name: [*c]const GLchar) callconv(.C) GLuint;pub const GLGETACTIVESUBROUTINEUNIFORMIVPROC = ?*const fn(
program: GLuint,shadertype: GLenum,index: GLuint,pname: GLenum,values: [*c]GLint) callconv(.C) void;pub const GLGETACTIVESUBROUTINEUNIFORMNAMEPROC = ?*const fn(
program: GLuint,shadertype: GLenum,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,name: [*c]GLchar) callconv(.C) void;pub const GLGETACTIVESUBROUTINENAMEPROC = ?*const fn(
program: GLuint,shadertype: GLenum,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,name: [*c]GLchar) callconv(.C) void;pub const GLUNIFORMSUBROUTINESUIVPROC = ?*const fn(
shadertype: GLenum,count: GLsizei,indices: [*c]const GLuint) callconv(.C) void;pub const GLGETUNIFORMSUBROUTINEUIVPROC = ?*const fn(
shadertype: GLenum,location: GLint,params: [*c]GLuint) callconv(.C) void;pub const GLGETPROGRAMSTAGEIVPROC = ?*const fn(
program: GLuint,shadertype: GLenum,pname: GLenum,values: [*c]GLint) callconv(.C) void;pub const GLPATCHPARAMETERIPROC = ?*const fn(
pname: GLenum,value: GLint) callconv(.C) void;pub const GLPATCHPARAMETERFVPROC = ?*const fn(
pname: GLenum,values: [*c]const GLfloat) callconv(.C) void;pub const GLBINDTRANSFORMFEEDBACKPROC = ?*const fn(
target: GLenum,id: GLuint) callconv(.C) void;pub const GLDELETETRANSFORMFEEDBACKSPROC = ?*const fn(
n: GLsizei,ids: [*c]const GLuint) callconv(.C) void;pub const GLGENTRANSFORMFEEDBACKSPROC = ?*const fn(
n: GLsizei,ids: [*c]GLuint) callconv(.C) void;pub const GLISTRANSFORMFEEDBACKPROC = ?*const fn(
id: GLuint) callconv(.C) GLboolean;pub const GLPAUSETRANSFORMFEEDBACKPROC = ?*const fn(
) callconv(.C) void;pub const GLRESUMETRANSFORMFEEDBACKPROC = ?*const fn(
) callconv(.C) void;pub const GLDRAWTRANSFORMFEEDBACKPROC = ?*const fn(
mode: GLenum,id: GLuint) callconv(.C) void;pub const GLDRAWTRANSFORMFEEDBACKSTREAMPROC = ?*const fn(
mode: GLenum,id: GLuint,stream: GLuint) callconv(.C) void;pub const GLBEGINQUERYINDEXEDPROC = ?*const fn(
target: GLenum,index: GLuint,id: GLuint) callconv(.C) void;pub const GLENDQUERYINDEXEDPROC = ?*const fn(
target: GLenum,index: GLuint) callconv(.C) void;pub const GLGETQUERYINDEXEDIVPROC = ?*const fn(
target: GLenum,index: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLRELEASESHADERCOMPILERPROC = ?*const fn(
) callconv(.C) void;pub const GLSHADERBINARYPROC = ?*const fn(
count: GLsizei,shaders: [*c]const GLuint,binaryFormat: GLenum,binary: ?*const anyopaque,length: GLsizei) callconv(.C) void;pub const GLGETSHADERPRECISIONFORMATPROC = ?*const fn(
shadertype: GLenum,precisiontype: GLenum,range: [*c]GLint,precision: [*c]GLint) callconv(.C) void;pub const GLDEPTHRANGEFPROC = ?*const fn(
n: GLfloat,f: GLfloat) callconv(.C) void;pub const GLCLEARDEPTHFPROC = ?*const fn(
d: GLfloat) callconv(.C) void;pub const GLGETPROGRAMBINARYPROC = ?*const fn(
program: GLuint,bufSize: GLsizei,length: [*c]GLsizei,binaryFormat: [*c]GLenum,binary: ?*anyopaque) callconv(.C) void;pub const GLPROGRAMBINARYPROC = ?*const fn(
program: GLuint,binaryFormat: GLenum,binary: ?*const anyopaque,length: GLsizei) callconv(.C) void;pub const GLPROGRAMPARAMETERIPROC = ?*const fn(
program: GLuint,pname: GLenum,value: GLint) callconv(.C) void;pub const GLUSEPROGRAMSTAGESPROC = ?*const fn(
pipeline: GLuint,stages: GLbitfield,program: GLuint) callconv(.C) void;pub const GLACTIVESHADERPROGRAMPROC = ?*const fn(
pipeline: GLuint,program: GLuint) callconv(.C) void;pub const GLCREATESHADERPROGRAMVPROC = ?*const fn(
type: GLenum,count: GLsizei,strings: [*c]const [*c]const GLchar) callconv(.C) GLuint;pub const GLBINDPROGRAMPIPELINEPROC = ?*const fn(
pipeline: GLuint) callconv(.C) void;pub const GLDELETEPROGRAMPIPELINESPROC = ?*const fn(
n: GLsizei,pipelines: [*c]const GLuint) callconv(.C) void;pub const GLGENPROGRAMPIPELINESPROC = ?*const fn(
n: GLsizei,pipelines: [*c]GLuint) callconv(.C) void;pub const GLISPROGRAMPIPELINEPROC = ?*const fn(
pipeline: GLuint) callconv(.C) GLboolean;pub const GLGETPROGRAMPIPELINEIVPROC = ?*const fn(
pipeline: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM1IPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM1IVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM1FPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM1FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM1DPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM1DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM1UIPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM1UIVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM2IPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLint,v1: GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM2IVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM2FPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLfloat,v1: GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM2FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM2DPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLdouble,v1: GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM2DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM2UIPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLuint,v1: GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM2UIVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM3IPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLint,v1: GLint,v2: GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM3IVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM3FPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLfloat,v1: GLfloat,v2: GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM3FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM3DPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLdouble,v1: GLdouble,v2: GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM3DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM3UIPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLuint,v1: GLuint,v2: GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM3UIVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM4IPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLint,v1: GLint,v2: GLint,v3: GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM4IVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLint) callconv(.C) void;pub const GLPROGRAMUNIFORM4FPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLfloat,v1: GLfloat,v2: GLfloat,v3: GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM4FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORM4DPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLdouble,v1: GLdouble,v2: GLdouble,v3: GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM4DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORM4UIPROC = ?*const fn(
program: GLuint,location: GLint,v0: GLuint,v1: GLuint,v2: GLuint,v3: GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORM4UIVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,value: [*c]const GLuint) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2X3FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3X2FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2X4FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4X2FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3X4FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4X3FVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLfloat) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2X3DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3X2DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX2X4DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4X2DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX3X4DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLPROGRAMUNIFORMMATRIX4X3DVPROC = ?*const fn(
program: GLuint,location: GLint,count: GLsizei,transpose: GLboolean,value: [*c]const GLdouble) callconv(.C) void;pub const GLVALIDATEPROGRAMPIPELINEPROC = ?*const fn(
pipeline: GLuint) callconv(.C) void;pub const GLGETPROGRAMPIPELINEINFOLOGPROC = ?*const fn(
pipeline: GLuint,bufSize: GLsizei,length: [*c]GLsizei,infoLog: [*c]GLchar) callconv(.C) void;pub const GLVERTEXATTRIBL1DPROC = ?*const fn(
index: GLuint,x: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL2DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL3DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble,z: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL4DPROC = ?*const fn(
index: GLuint,x: GLdouble,y: GLdouble,z: GLdouble,w: GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL1DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL2DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL3DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBL4DVPROC = ?*const fn(
index: GLuint,v: [*c]const GLdouble) callconv(.C) void;pub const GLVERTEXATTRIBLPOINTERPROC = ?*const fn(
index: GLuint,size: GLint,type: GLenum,stride: GLsizei,pointer: ?*const anyopaque) callconv(.C) void;pub const GLGETVERTEXATTRIBLDVPROC = ?*const fn(
index: GLuint,pname: GLenum,params: [*c]GLdouble) callconv(.C) void;pub const GLVIEWPORTARRAYVPROC = ?*const fn(
first: GLuint,count: GLsizei,v: [*c]const GLfloat) callconv(.C) void;pub const GLVIEWPORTINDEXEDFPROC = ?*const fn(
index: GLuint,x: GLfloat,y: GLfloat,w: GLfloat,h: GLfloat) callconv(.C) void;pub const GLVIEWPORTINDEXEDFVPROC = ?*const fn(
index: GLuint,v: [*c]const GLfloat) callconv(.C) void;pub const GLSCISSORARRAYVPROC = ?*const fn(
first: GLuint,count: GLsizei,v: [*c]const GLint) callconv(.C) void;pub const GLSCISSORINDEXEDPROC = ?*const fn(
index: GLuint,left: GLint,bottom: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLSCISSORINDEXEDVPROC = ?*const fn(
index: GLuint,v: [*c]const GLint) callconv(.C) void;pub const GLDEPTHRANGEARRAYVPROC = ?*const fn(
first: GLuint,count: GLsizei,v: [*c]const GLdouble) callconv(.C) void;pub const GLDEPTHRANGEINDEXEDPROC = ?*const fn(
index: GLuint,n: GLdouble,f: GLdouble) callconv(.C) void;pub const GLGETFLOATI_VPROC = ?*const fn(
target: GLenum,index: GLuint,data: [*c]GLfloat) callconv(.C) void;pub const GLGETDOUBLEI_VPROC = ?*const fn(
target: GLenum,index: GLuint,data: [*c]GLdouble) callconv(.C) void;pub const GLDRAWARRAYSINSTANCEDBASEINSTANCEPROC = ?*const fn(
mode: GLenum,first: GLint,count: GLsizei,instancecount: GLsizei,baseinstance: GLuint) callconv(.C) void;pub const GLDRAWELEMENTSINSTANCEDBASEINSTANCEPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque,instancecount: GLsizei,baseinstance: GLuint) callconv(.C) void;pub const GLDRAWELEMENTSINSTANCEDBASEVERTEXBASEINSTANCEPROC = ?*const fn(
mode: GLenum,count: GLsizei,type: GLenum,indices: ?*const anyopaque,instancecount: GLsizei,basevertex: GLint,baseinstance: GLuint) callconv(.C) void;pub const GLGETINTERNALFORMATIVPROC = ?*const fn(
target: GLenum,internalformat: GLenum,pname: GLenum,count: GLsizei,params: [*c]GLint) callconv(.C) void;pub const GLGETACTIVEATOMICCOUNTERBUFFERIVPROC = ?*const fn(
program: GLuint,bufferIndex: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLBINDIMAGETEXTUREPROC = ?*const fn(
unit: GLuint,texture: GLuint,level: GLint,layered: GLboolean,layer: GLint,access: GLenum,format: GLenum) callconv(.C) void;pub const GLMEMORYBARRIERPROC = ?*const fn(
barriers: GLbitfield) callconv(.C) void;pub const GLTEXSTORAGE1DPROC = ?*const fn(
target: GLenum,levels: GLsizei,internalformat: GLenum,width: GLsizei) callconv(.C) void;pub const GLTEXSTORAGE2DPROC = ?*const fn(
target: GLenum,levels: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLTEXSTORAGE3DPROC = ?*const fn(
target: GLenum,levels: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei) callconv(.C) void;pub const GLDRAWTRANSFORMFEEDBACKINSTANCEDPROC = ?*const fn(
mode: GLenum,id: GLuint,instancecount: GLsizei) callconv(.C) void;pub const GLDRAWTRANSFORMFEEDBACKSTREAMINSTANCEDPROC = ?*const fn(
mode: GLenum,id: GLuint,stream: GLuint,instancecount: GLsizei) callconv(.C) void;pub const GLCLEARBUFFERDATAPROC = ?*const fn(
target: GLenum,internalformat: GLenum,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLCLEARBUFFERSUBDATAPROC = ?*const fn(
target: GLenum,internalformat: GLenum,offset: GLintptr,size: GLsizeiptr,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLDISPATCHCOMPUTEPROC = ?*const fn(
num_groups_x: GLuint,num_groups_y: GLuint,num_groups_z: GLuint) callconv(.C) void;pub const GLDISPATCHCOMPUTEINDIRECTPROC = ?*const fn(
indirect: GLintptr) callconv(.C) void;pub const GLCOPYIMAGESUBDATAPROC = ?*const fn(
srcName: GLuint,srcTarget: GLenum,srcLevel: GLint,srcX: GLint,srcY: GLint,srcZ: GLint,dstName: GLuint,dstTarget: GLenum,dstLevel: GLint,dstX: GLint,dstY: GLint,dstZ: GLint,srcWidth: GLsizei,srcHeight: GLsizei,srcDepth: GLsizei) callconv(.C) void;pub const GLFRAMEBUFFERPARAMETERIPROC = ?*const fn(
target: GLenum,pname: GLenum,param: GLint) callconv(.C) void;pub const GLGETFRAMEBUFFERPARAMETERIVPROC = ?*const fn(
target: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETINTERNALFORMATI64VPROC = ?*const fn(
target: GLenum,internalformat: GLenum,pname: GLenum,count: GLsizei,params: [*c]GLint64) callconv(.C) void;pub const GLINVALIDATETEXSUBIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei) callconv(.C) void;pub const GLINVALIDATETEXIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint) callconv(.C) void;pub const GLINVALIDATEBUFFERSUBDATAPROC = ?*const fn(
buffer: GLuint,offset: GLintptr,length: GLsizeiptr) callconv(.C) void;pub const GLINVALIDATEBUFFERDATAPROC = ?*const fn(
buffer: GLuint) callconv(.C) void;pub const GLINVALIDATEFRAMEBUFFERPROC = ?*const fn(
target: GLenum,numAttachments: GLsizei,attachments: [*c]const GLenum) callconv(.C) void;pub const GLINVALIDATESUBFRAMEBUFFERPROC = ?*const fn(
target: GLenum,numAttachments: GLsizei,attachments: [*c]const GLenum,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLMULTIDRAWARRAYSINDIRECTPROC = ?*const fn(
mode: GLenum,indirect: ?*const anyopaque,drawcount: GLsizei,stride: GLsizei) callconv(.C) void;pub const GLMULTIDRAWELEMENTSINDIRECTPROC = ?*const fn(
mode: GLenum,type: GLenum,indirect: ?*const anyopaque,drawcount: GLsizei,stride: GLsizei) callconv(.C) void;pub const GLGETPROGRAMINTERFACEIVPROC = ?*const fn(
program: GLuint,programInterface: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETPROGRAMRESOURCEINDEXPROC = ?*const fn(
program: GLuint,programInterface: GLenum,name: [*c]const GLchar) callconv(.C) GLuint;pub const GLGETPROGRAMRESOURCENAMEPROC = ?*const fn(
program: GLuint,programInterface: GLenum,index: GLuint,bufSize: GLsizei,length: [*c]GLsizei,name: [*c]GLchar) callconv(.C) void;pub const GLGETPROGRAMRESOURCEIVPROC = ?*const fn(
program: GLuint,programInterface: GLenum,index: GLuint,propCount: GLsizei,props: [*c]const GLenum,count: GLsizei,length: [*c]GLsizei,params: [*c]GLint) callconv(.C) void;pub const GLGETPROGRAMRESOURCELOCATIONPROC = ?*const fn(
program: GLuint,programInterface: GLenum,name: [*c]const GLchar) callconv(.C) GLint;pub const GLGETPROGRAMRESOURCELOCATIONINDEXPROC = ?*const fn(
program: GLuint,programInterface: GLenum,name: [*c]const GLchar) callconv(.C) GLint;pub const GLSHADERSTORAGEBLOCKBINDINGPROC = ?*const fn(
program: GLuint,storageBlockIndex: GLuint,storageBlockBinding: GLuint) callconv(.C) void;pub const GLTEXBUFFERRANGEPROC = ?*const fn(
target: GLenum,internalformat: GLenum,buffer: GLuint,offset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLTEXSTORAGE2DMULTISAMPLEPROC = ?*const fn(
target: GLenum,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLTEXSTORAGE3DMULTISAMPLEPROC = ?*const fn(
target: GLenum,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLTEXTUREVIEWPROC = ?*const fn(
texture: GLuint,target: GLenum,origtexture: GLuint,internalformat: GLenum,minlevel: GLuint,numlevels: GLuint,minlayer: GLuint,numlayers: GLuint) callconv(.C) void;pub const GLBINDVERTEXBUFFERPROC = ?*const fn(
bindingindex: GLuint,buffer: GLuint,offset: GLintptr,stride: GLsizei) callconv(.C) void;pub const GLVERTEXATTRIBFORMATPROC = ?*const fn(
attribindex: GLuint,size: GLint,type: GLenum,normalized: GLboolean,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBIFORMATPROC = ?*const fn(
attribindex: GLuint,size: GLint,type: GLenum,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBLFORMATPROC = ?*const fn(
attribindex: GLuint,size: GLint,type: GLenum,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXATTRIBBINDINGPROC = ?*const fn(
attribindex: GLuint,bindingindex: GLuint) callconv(.C) void;pub const GLVERTEXBINDINGDIVISORPROC = ?*const fn(
bindingindex: GLuint,divisor: GLuint) callconv(.C) void;pub const GLDEBUGMESSAGECONTROLPROC = ?*const fn(
source: GLenum,type: GLenum,severity: GLenum,count: GLsizei,ids: [*c]const GLuint,enabled: GLboolean) callconv(.C) void;pub const GLDEBUGMESSAGEINSERTPROC = ?*const fn(
source: GLenum,type: GLenum,id: GLuint,severity: GLenum,length: GLsizei,buf: [*c]const GLchar) callconv(.C) void;pub const GLDEBUGMESSAGECALLBACKPROC = ?*const fn(
callback: GLDEBUGPROC,userParam: ?*const anyopaque) callconv(.C) void;pub const GLGETDEBUGMESSAGELOGPROC = ?*const fn(
count: GLuint,bufSize: GLsizei,sources: [*c]GLenum,types: [*c]GLenum,ids: [*c]GLuint,severities: [*c]GLenum,lengths: [*c]GLsizei,messageLog: [*c]GLchar) callconv(.C) GLuint;pub const GLPUSHDEBUGGROUPPROC = ?*const fn(
source: GLenum,id: GLuint,length: GLsizei,message: [*c]const GLchar) callconv(.C) void;pub const GLPOPDEBUGGROUPPROC = ?*const fn(
) callconv(.C) void;pub const GLOBJECTLABELPROC = ?*const fn(
identifier: GLenum,name: GLuint,length: GLsizei,label: [*c]const GLchar) callconv(.C) void;pub const GLGETOBJECTLABELPROC = ?*const fn(
identifier: GLenum,name: GLuint,bufSize: GLsizei,length: [*c]GLsizei,label: [*c]GLchar) callconv(.C) void;pub const GLOBJECTPTRLABELPROC = ?*const fn(
ptr: ?*const anyopaque,length: GLsizei,label: [*c]const GLchar) callconv(.C) void;pub const GLGETOBJECTPTRLABELPROC = ?*const fn(
ptr: ?*const anyopaque,bufSize: GLsizei,length: [*c]GLsizei,label: [*c]GLchar) callconv(.C) void;pub const GLBUFFERSTORAGEPROC = ?*const fn(
target: GLenum,size: GLsizeiptr,data: ?*const anyopaque,flags: GLbitfield) callconv(.C) void;pub const GLCLEARTEXIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLCLEARTEXSUBIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLBINDBUFFERSBASEPROC = ?*const fn(
target: GLenum,first: GLuint,count: GLsizei,buffers: [*c]const GLuint) callconv(.C) void;pub const GLBINDBUFFERSRANGEPROC = ?*const fn(
target: GLenum,first: GLuint,count: GLsizei,buffers: [*c]const GLuint,offsets: [*c]const GLintptr,sizes: [*c]const GLsizeiptr) callconv(.C) void;pub const GLBINDTEXTURESPROC = ?*const fn(
first: GLuint,count: GLsizei,textures: [*c]const GLuint) callconv(.C) void;pub const GLBINDSAMPLERSPROC = ?*const fn(
first: GLuint,count: GLsizei,samplers: [*c]const GLuint) callconv(.C) void;pub const GLBINDIMAGETEXTURESPROC = ?*const fn(
first: GLuint,count: GLsizei,textures: [*c]const GLuint) callconv(.C) void;pub const GLBINDVERTEXBUFFERSPROC = ?*const fn(
first: GLuint,count: GLsizei,buffers: [*c]const GLuint,offsets: [*c]const GLintptr,strides: [*c]const GLsizei) callconv(.C) void;pub const GLCLIPCONTROLPROC = ?*const fn(
origin: GLenum,depth: GLenum) callconv(.C) void;pub const GLCREATETRANSFORMFEEDBACKSPROC = ?*const fn(
n: GLsizei,ids: [*c]GLuint) callconv(.C) void;pub const GLTRANSFORMFEEDBACKBUFFERBASEPROC = ?*const fn(
xfb: GLuint,index: GLuint,buffer: GLuint) callconv(.C) void;pub const GLTRANSFORMFEEDBACKBUFFERRANGEPROC = ?*const fn(
xfb: GLuint,index: GLuint,buffer: GLuint,offset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLGETTRANSFORMFEEDBACKIVPROC = ?*const fn(
xfb: GLuint,pname: GLenum,param: [*c]GLint) callconv(.C) void;pub const GLGETTRANSFORMFEEDBACKI_VPROC = ?*const fn(
xfb: GLuint,pname: GLenum,index: GLuint,param: [*c]GLint) callconv(.C) void;pub const GLGETTRANSFORMFEEDBACKI64_VPROC = ?*const fn(
xfb: GLuint,pname: GLenum,index: GLuint,param: [*c]GLint64) callconv(.C) void;pub const GLCREATEBUFFERSPROC = ?*const fn(
n: GLsizei,buffers: [*c]GLuint) callconv(.C) void;pub const GLNAMEDBUFFERSTORAGEPROC = ?*const fn(
buffer: GLuint,size: GLsizeiptr,data: ?*const anyopaque,flags: GLbitfield) callconv(.C) void;pub const GLNAMEDBUFFERDATAPROC = ?*const fn(
buffer: GLuint,size: GLsizeiptr,data: ?*const anyopaque,usage: GLenum) callconv(.C) void;pub const GLNAMEDBUFFERSUBDATAPROC = ?*const fn(
buffer: GLuint,offset: GLintptr,size: GLsizeiptr,data: ?*const anyopaque) callconv(.C) void;pub const GLCOPYNAMEDBUFFERSUBDATAPROC = ?*const fn(
readBuffer: GLuint,writeBuffer: GLuint,readOffset: GLintptr,writeOffset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLCLEARNAMEDBUFFERDATAPROC = ?*const fn(
buffer: GLuint,internalformat: GLenum,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLCLEARNAMEDBUFFERSUBDATAPROC = ?*const fn(
buffer: GLuint,internalformat: GLenum,offset: GLintptr,size: GLsizeiptr,format: GLenum,type: GLenum,data: ?*const anyopaque) callconv(.C) void;pub const GLMAPNAMEDBUFFERPROC = ?*const fn(
buffer: GLuint,access: GLenum) callconv(.C) ?*anyopaque;pub const GLMAPNAMEDBUFFERRANGEPROC = ?*const fn(
buffer: GLuint,offset: GLintptr,length: GLsizeiptr,access: GLbitfield) callconv(.C) ?*anyopaque;pub const GLUNMAPNAMEDBUFFERPROC = ?*const fn(
buffer: GLuint) callconv(.C) GLboolean;pub const GLFLUSHMAPPEDNAMEDBUFFERRANGEPROC = ?*const fn(
buffer: GLuint,offset: GLintptr,length: GLsizeiptr) callconv(.C) void;pub const GLGETNAMEDBUFFERPARAMETERIVPROC = ?*const fn(
buffer: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETNAMEDBUFFERPARAMETERI64VPROC = ?*const fn(
buffer: GLuint,pname: GLenum,params: [*c]GLint64) callconv(.C) void;pub const GLGETNAMEDBUFFERPOINTERVPROC = ?*const fn(
buffer: GLuint,pname: GLenum,params: [*c]?*?*anyopaque) callconv(.C) void;pub const GLGETNAMEDBUFFERSUBDATAPROC = ?*const fn(
buffer: GLuint,offset: GLintptr,size: GLsizeiptr,data: ?*anyopaque) callconv(.C) void;pub const GLCREATEFRAMEBUFFERSPROC = ?*const fn(
n: GLsizei,framebuffers: [*c]GLuint) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERRENDERBUFFERPROC = ?*const fn(
framebuffer: GLuint,attachment: GLenum,renderbuffertarget: GLenum,renderbuffer: GLuint) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERPARAMETERIPROC = ?*const fn(
framebuffer: GLuint,pname: GLenum,param: GLint) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERTEXTUREPROC = ?*const fn(
framebuffer: GLuint,attachment: GLenum,texture: GLuint,level: GLint) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERTEXTURELAYERPROC = ?*const fn(
framebuffer: GLuint,attachment: GLenum,texture: GLuint,level: GLint,layer: GLint) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERDRAWBUFFERPROC = ?*const fn(
framebuffer: GLuint,buf: GLenum) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERDRAWBUFFERSPROC = ?*const fn(
framebuffer: GLuint,n: GLsizei,bufs: [*c]const GLenum) callconv(.C) void;pub const GLNAMEDFRAMEBUFFERREADBUFFERPROC = ?*const fn(
framebuffer: GLuint,src: GLenum) callconv(.C) void;pub const GLINVALIDATENAMEDFRAMEBUFFERDATAPROC = ?*const fn(
framebuffer: GLuint,numAttachments: GLsizei,attachments: [*c]const GLenum) callconv(.C) void;pub const GLINVALIDATENAMEDFRAMEBUFFERSUBDATAPROC = ?*const fn(
framebuffer: GLuint,numAttachments: GLsizei,attachments: [*c]const GLenum,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLCLEARNAMEDFRAMEBUFFERIVPROC = ?*const fn(
framebuffer: GLuint,buffer: GLenum,drawbuffer: GLint,value: [*c]const GLint) callconv(.C) void;pub const GLCLEARNAMEDFRAMEBUFFERUIVPROC = ?*const fn(
framebuffer: GLuint,buffer: GLenum,drawbuffer: GLint,value: [*c]const GLuint) callconv(.C) void;pub const GLCLEARNAMEDFRAMEBUFFERFVPROC = ?*const fn(
framebuffer: GLuint,buffer: GLenum,drawbuffer: GLint,value: [*c]const GLfloat) callconv(.C) void;pub const GLCLEARNAMEDFRAMEBUFFERFIPROC = ?*const fn(
framebuffer: GLuint,buffer: GLenum,drawbuffer: GLint,depth: GLfloat,stencil: GLint) callconv(.C) void;pub const GLBLITNAMEDFRAMEBUFFERPROC = ?*const fn(
readFramebuffer: GLuint,drawFramebuffer: GLuint,srcX0: GLint,srcY0: GLint,srcX1: GLint,srcY1: GLint,dstX0: GLint,dstY0: GLint,dstX1: GLint,dstY1: GLint,mask: GLbitfield,filter: GLenum) callconv(.C) void;pub const GLCHECKNAMEDFRAMEBUFFERSTATUSPROC = ?*const fn(
framebuffer: GLuint,target: GLenum) callconv(.C) GLenum;pub const GLGETNAMEDFRAMEBUFFERPARAMETERIVPROC = ?*const fn(
framebuffer: GLuint,pname: GLenum,param: [*c]GLint) callconv(.C) void;pub const GLGETNAMEDFRAMEBUFFERATTACHMENTPARAMETERIVPROC = ?*const fn(
framebuffer: GLuint,attachment: GLenum,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLCREATERENDERBUFFERSPROC = ?*const fn(
n: GLsizei,renderbuffers: [*c]GLuint) callconv(.C) void;pub const GLNAMEDRENDERBUFFERSTORAGEPROC = ?*const fn(
renderbuffer: GLuint,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLNAMEDRENDERBUFFERSTORAGEMULTISAMPLEPROC = ?*const fn(
renderbuffer: GLuint,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLGETNAMEDRENDERBUFFERPARAMETERIVPROC = ?*const fn(
renderbuffer: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLCREATETEXTURESPROC = ?*const fn(
target: GLenum,n: GLsizei,textures: [*c]GLuint) callconv(.C) void;pub const GLTEXTUREBUFFERPROC = ?*const fn(
texture: GLuint,internalformat: GLenum,buffer: GLuint) callconv(.C) void;pub const GLTEXTUREBUFFERRANGEPROC = ?*const fn(
texture: GLuint,internalformat: GLenum,buffer: GLuint,offset: GLintptr,size: GLsizeiptr) callconv(.C) void;pub const GLTEXTURESTORAGE1DPROC = ?*const fn(
texture: GLuint,levels: GLsizei,internalformat: GLenum,width: GLsizei) callconv(.C) void;pub const GLTEXTURESTORAGE2DPROC = ?*const fn(
texture: GLuint,levels: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLTEXTURESTORAGE3DPROC = ?*const fn(
texture: GLuint,levels: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei) callconv(.C) void;pub const GLTEXTURESTORAGE2DMULTISAMPLEPROC = ?*const fn(
texture: GLuint,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLTEXTURESTORAGE3DMULTISAMPLEPROC = ?*const fn(
texture: GLuint,samples: GLsizei,internalformat: GLenum,width: GLsizei,height: GLsizei,depth: GLsizei,fixedsamplelocations: GLboolean) callconv(.C) void;pub const GLTEXTURESUBIMAGE1DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,width: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLTEXTURESUBIMAGE2DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,width: GLsizei,height: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLTEXTURESUBIMAGE3DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,type: GLenum,pixels: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXTURESUBIMAGE1DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,width: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXTURESUBIMAGE2DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,width: GLsizei,height: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOMPRESSEDTEXTURESUBIMAGE3DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,imageSize: GLsizei,data: ?*const anyopaque) callconv(.C) void;pub const GLCOPYTEXTURESUBIMAGE1DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,x: GLint,y: GLint,width: GLsizei) callconv(.C) void;pub const GLCOPYTEXTURESUBIMAGE2DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLCOPYTEXTURESUBIMAGE3DPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,x: GLint,y: GLint,width: GLsizei,height: GLsizei) callconv(.C) void;pub const GLTEXTUREPARAMETERFPROC = ?*const fn(
texture: GLuint,pname: GLenum,param: GLfloat) callconv(.C) void;pub const GLTEXTUREPARAMETERFVPROC = ?*const fn(
texture: GLuint,pname: GLenum,param: [*c]const GLfloat) callconv(.C) void;pub const GLTEXTUREPARAMETERIPROC = ?*const fn(
texture: GLuint,pname: GLenum,param: GLint) callconv(.C) void;pub const GLTEXTUREPARAMETERIIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]const GLint) callconv(.C) void;pub const GLTEXTUREPARAMETERIUIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]const GLuint) callconv(.C) void;pub const GLTEXTUREPARAMETERIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,param: [*c]const GLint) callconv(.C) void;pub const GLGENERATETEXTUREMIPMAPPROC = ?*const fn(
texture: GLuint) callconv(.C) void;pub const GLBINDTEXTUREUNITPROC = ?*const fn(
unit: GLuint,texture: GLuint) callconv(.C) void;pub const GLGETTEXTUREIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,format: GLenum,type: GLenum,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETCOMPRESSEDTEXTUREIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETTEXTURELEVELPARAMETERFVPROC = ?*const fn(
texture: GLuint,level: GLint,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXTURELEVELPARAMETERIVPROC = ?*const fn(
texture: GLuint,level: GLint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETTEXTUREPARAMETERFVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]GLfloat) callconv(.C) void;pub const GLGETTEXTUREPARAMETERIIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLGETTEXTUREPARAMETERIUIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]GLuint) callconv(.C) void;pub const GLGETTEXTUREPARAMETERIVPROC = ?*const fn(
texture: GLuint,pname: GLenum,params: [*c]GLint) callconv(.C) void;pub const GLCREATEVERTEXARRAYSPROC = ?*const fn(
n: GLsizei,arrays: [*c]GLuint) callconv(.C) void;pub const GLDISABLEVERTEXARRAYATTRIBPROC = ?*const fn(
vaobj: GLuint,index: GLuint) callconv(.C) void;pub const GLENABLEVERTEXARRAYATTRIBPROC = ?*const fn(
vaobj: GLuint,index: GLuint) callconv(.C) void;pub const GLVERTEXARRAYELEMENTBUFFERPROC = ?*const fn(
vaobj: GLuint,buffer: GLuint) callconv(.C) void;pub const GLVERTEXARRAYVERTEXBUFFERPROC = ?*const fn(
vaobj: GLuint,bindingindex: GLuint,buffer: GLuint,offset: GLintptr,stride: GLsizei) callconv(.C) void;pub const GLVERTEXARRAYVERTEXBUFFERSPROC = ?*const fn(
vaobj: GLuint,first: GLuint,count: GLsizei,buffers: [*c]const GLuint,offsets: [*c]const GLintptr,strides: [*c]const GLsizei) callconv(.C) void;pub const GLVERTEXARRAYATTRIBBINDINGPROC = ?*const fn(
vaobj: GLuint,attribindex: GLuint,bindingindex: GLuint) callconv(.C) void;pub const GLVERTEXARRAYATTRIBFORMATPROC = ?*const fn(
vaobj: GLuint,attribindex: GLuint,size: GLint,type: GLenum,normalized: GLboolean,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXARRAYATTRIBIFORMATPROC = ?*const fn(
vaobj: GLuint,attribindex: GLuint,size: GLint,type: GLenum,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXARRAYATTRIBLFORMATPROC = ?*const fn(
vaobj: GLuint,attribindex: GLuint,size: GLint,type: GLenum,relativeoffset: GLuint) callconv(.C) void;pub const GLVERTEXARRAYBINDINGDIVISORPROC = ?*const fn(
vaobj: GLuint,bindingindex: GLuint,divisor: GLuint) callconv(.C) void;pub const GLGETVERTEXARRAYIVPROC = ?*const fn(
vaobj: GLuint,pname: GLenum,param: [*c]GLint) callconv(.C) void;pub const GLGETVERTEXARRAYINDEXEDIVPROC = ?*const fn(
vaobj: GLuint,index: GLuint,pname: GLenum,param: [*c]GLint) callconv(.C) void;pub const GLGETVERTEXARRAYINDEXED64IVPROC = ?*const fn(
vaobj: GLuint,index: GLuint,pname: GLenum,param: [*c]GLint64) callconv(.C) void;pub const GLCREATESAMPLERSPROC = ?*const fn(
n: GLsizei,samplers: [*c]GLuint) callconv(.C) void;pub const GLCREATEPROGRAMPIPELINESPROC = ?*const fn(
n: GLsizei,pipelines: [*c]GLuint) callconv(.C) void;pub const GLCREATEQUERIESPROC = ?*const fn(
target: GLenum,n: GLsizei,ids: [*c]GLuint) callconv(.C) void;pub const GLGETQUERYBUFFEROBJECTI64VPROC = ?*const fn(
id: GLuint,buffer: GLuint,pname: GLenum,offset: GLintptr) callconv(.C) void;pub const GLGETQUERYBUFFEROBJECTIVPROC = ?*const fn(
id: GLuint,buffer: GLuint,pname: GLenum,offset: GLintptr) callconv(.C) void;pub const GLGETQUERYBUFFEROBJECTUI64VPROC = ?*const fn(
id: GLuint,buffer: GLuint,pname: GLenum,offset: GLintptr) callconv(.C) void;pub const GLGETQUERYBUFFEROBJECTUIVPROC = ?*const fn(
id: GLuint,buffer: GLuint,pname: GLenum,offset: GLintptr) callconv(.C) void;pub const GLMEMORYBARRIERBYREGIONPROC = ?*const fn(
barriers: GLbitfield) callconv(.C) void;pub const GLGETTEXTURESUBIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,format: GLenum,type: GLenum,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETCOMPRESSEDTEXTURESUBIMAGEPROC = ?*const fn(
texture: GLuint,level: GLint,xoffset: GLint,yoffset: GLint,zoffset: GLint,width: GLsizei,height: GLsizei,depth: GLsizei,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETGRAPHICSRESETSTATUSPROC = ?*const fn(
) callconv(.C) GLenum;pub const GLGETNCOMPRESSEDTEXIMAGEPROC = ?*const fn(
target: GLenum,lod: GLint,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETNTEXIMAGEPROC = ?*const fn(
target: GLenum,level: GLint,format: GLenum,type: GLenum,bufSize: GLsizei,pixels: ?*anyopaque) callconv(.C) void;pub const GLGETNUNIFORMDVPROC = ?*const fn(
program: GLuint,location: GLint,bufSize: GLsizei,params: [*c]GLdouble) callconv(.C) void;pub const GLGETNUNIFORMFVPROC = ?*const fn(
program: GLuint,location: GLint,bufSize: GLsizei,params: [*c]GLfloat) callconv(.C) void;pub const GLGETNUNIFORMIVPROC = ?*const fn(
program: GLuint,location: GLint,bufSize: GLsizei,params: [*c]GLint) callconv(.C) void;pub const GLGETNUNIFORMUIVPROC = ?*const fn(
program: GLuint,location: GLint,bufSize: GLsizei,params: [*c]GLuint) callconv(.C) void;pub const GLREADNPIXELSPROC = ?*const fn(
x: GLint,y: GLint,width: GLsizei,height: GLsizei,format: GLenum,type: GLenum,bufSize: GLsizei,data: ?*anyopaque) callconv(.C) void;pub const GLGETNMAPDVPROC = ?*const fn(
target: GLenum,query: GLenum,bufSize: GLsizei,v: [*c]GLdouble) callconv(.C) void;pub const GLGETNMAPFVPROC = ?*const fn(
target: GLenum,query: GLenum,bufSize: GLsizei,v: [*c]GLfloat) callconv(.C) void;pub const GLGETNMAPIVPROC = ?*const fn(
target: GLenum,query: GLenum,bufSize: GLsizei,v: [*c]GLint) callconv(.C) void;pub const GLGETNPIXELMAPFVPROC = ?*const fn(
map: GLenum,bufSize: GLsizei,values: [*c]GLfloat) callconv(.C) void;pub const GLGETNPIXELMAPUIVPROC = ?*const fn(
map: GLenum,bufSize: GLsizei,values: [*c]GLuint) callconv(.C) void;pub const GLGETNPIXELMAPUSVPROC = ?*const fn(
map: GLenum,bufSize: GLsizei,values: [*c]GLushort) callconv(.C) void;pub const GLGETNPOLYGONSTIPPLEPROC = ?*const fn(
bufSize: GLsizei,pattern: [*c]GLubyte) callconv(.C) void;pub const GLGETNCOLORTABLEPROC = ?*const fn(
target: GLenum,format: GLenum,type: GLenum,bufSize: GLsizei,table: ?*anyopaque) callconv(.C) void;pub const GLGETNCONVOLUTIONFILTERPROC = ?*const fn(
target: GLenum,format: GLenum,type: GLenum,bufSize: GLsizei,image: ?*anyopaque) callconv(.C) void;pub const GLGETNSEPARABLEFILTERPROC = ?*const fn(
target: GLenum,format: GLenum,type: GLenum,rowBufSize: GLsizei,row: ?*anyopaque,columnBufSize: GLsizei,column: ?*anyopaque,span: ?*anyopaque) callconv(.C) void;pub const GLGETNHISTOGRAMPROC = ?*const fn(
target: GLenum,reset: GLboolean,format: GLenum,type: GLenum,bufSize: GLsizei,values: ?*anyopaque) callconv(.C) void;pub const GLGETNMINMAXPROC = ?*const fn(
target: GLenum,reset: GLboolean,format: GLenum,type: GLenum,bufSize: GLsizei,values: ?*anyopaque) callconv(.C) void;pub const GLTEXTUREBARRIERPROC = ?*const fn(
) callconv(.C) void;pub const GLSPECIALIZESHADERPROC = ?*const fn(
shader: GLuint,pEntryPoint: [*c]const GLchar,numSpecializationConstants: GLuint,pConstantIndex: [*c]const GLuint,pConstantValue: [*c]const GLuint) callconv(.C) void;pub const GLMULTIDRAWARRAYSINDIRECTCOUNTPROC = ?*const fn(
mode: GLenum,indirect: ?*const anyopaque,drawcount: GLintptr,maxdrawcount: GLsizei,stride: GLsizei) callconv(.C) void;pub const GLMULTIDRAWELEMENTSINDIRECTCOUNTPROC = ?*const fn(
mode: GLenum,type: GLenum,indirect: ?*const anyopaque,drawcount: GLintptr,maxdrawcount: GLsizei,stride: GLsizei) callconv(.C) void;pub const GLPOLYGONOFFSETCLAMPPROC = ?*const fn(
factor: GLfloat,units: GLfloat,clamp: GLfloat) callconv(.C) void;};
pub fn glCullFace (mode:TriangleFace) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCullFace.?, .{mode});
}
pub fn glFrontFace (mode:FrontFaceDirection) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFrontFace.?, .{mode});
}
pub fn glHint (target:HintTarget,mode:HintMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glHint.?, .{target,mode});
}
pub fn glLineWidth (width:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLineWidth.?, .{width});
}
pub fn glPointSize (size:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPointSize.?, .{size});
}
pub fn glPolygonMode (face:TriangleFace,mode:PolygonMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPolygonMode.?, .{face,mode});
}
pub fn glScissor (x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScissor.?, .{x,y,width,height});
}
pub fn glTexParameterf (target:TextureTarget,pname:TextureParameterName,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameterf.?, .{target,pname,param});
}
pub fn glTexParameterfv (target:TextureTarget,pname:TextureParameterName,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameterfv.?, .{target,pname,params});
}
pub fn glTexParameteri (target:TextureTarget,pname:TextureParameterName,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameteri.?, .{target,pname,param});
}
pub fn glTexParameteriv (target:TextureTarget,pname:TextureParameterName,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameteriv.?, .{target,pname,params});
}
pub fn glTexImage1D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,border:GLint,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexImage1D.?, .{target,level,internalformat,width,border,format,@"type",pixels});
}
pub fn glTexImage2D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,height:GLsizei,border:GLint,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexImage2D.?, .{target,level,internalformat,width,height,border,format,@"type",pixels});
}
pub fn glDrawBuffer (buf:DrawBufferMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawBuffer.?, .{buf});
}
pub fn glClear (mask:ClearBufferMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClear.?, .{@as(GLbitfield, @bitCast(mask))});
}
pub fn glClearColor (red:GLfloat,green:GLfloat,blue:GLfloat,alpha:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearColor.?, .{red,green,blue,alpha});
}
pub fn glClearStencil (s:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearStencil.?, .{s});
}
pub fn glClearDepth (depth:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearDepth.?, .{depth});
}
pub fn glStencilMask (mask:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilMask.?, .{mask});
}
pub fn glColorMask (red:GLboolean,green:GLboolean,blue:GLboolean,alpha:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorMask.?, .{red,green,blue,alpha});
}
pub fn glDepthMask (flag:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthMask.?, .{flag});
}
pub fn glDisable (cap:EnableCap) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDisable.?, .{cap});
}
pub fn glEnable (cap:EnableCap) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnable.?, .{cap});
}
pub fn glFinish () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFinish.?, .{});
}
pub fn glFlush () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFlush.?, .{});
}
pub fn glBlendFunc (sfactor:BlendingFactor,dfactor:BlendingFactor) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendFunc.?, .{sfactor,dfactor});
}
pub fn glLogicOp (opcode:LogicOp) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLogicOp.?, .{opcode});
}
pub fn glStencilFunc (func:StencilFunction,ref:GLint,mask:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilFunc.?, .{func,ref,mask});
}
pub fn glStencilOp (fail:StencilOp,zfail:StencilOp,zpass:StencilOp) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilOp.?, .{fail,zfail,zpass});
}
pub fn glDepthFunc (func:DepthFunction) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthFunc.?, .{func});
}
pub fn glPixelStoref (pname:PixelStoreParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelStoref.?, .{pname,param});
}
pub fn glPixelStorei (pname:PixelStoreParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelStorei.?, .{pname,param});
}
pub fn glReadBuffer (src:ReadBufferMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glReadBuffer.?, .{src});
}
pub fn glReadPixels (x:GLint,y:GLint,width:GLsizei,height:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glReadPixels.?, .{x,y,width,height,format,@"type",pixels});
}
pub fn glGetBooleanv (pname:GetPName,data:[*c]GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBooleanv.?, .{pname,data});
}
pub fn glGetDoublev (pname:GetPName,data:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetDoublev.?, .{pname,data});
}
pub fn glGetError () callconv(.C) GLenum {
return @call(.always_tail, current_proc_table.?.glGetError.?, .{});
}
pub fn glGetFloatv (pname:GetPName,data:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetFloatv.?, .{pname,data});
}
pub fn glGetIntegerv (pname:GetPName,data:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetIntegerv.?, .{pname,data});
}
pub fn glGetString (name:StringName) callconv(.C) ?[*:0]const GLubyte {
return @call(.always_tail, current_proc_table.?.glGetString.?, .{name});
}
pub fn glGetTexImage (target:TextureTarget,level:GLint,format:PixelFormat,@"type":PixelType,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexImage.?, .{target,level,format,@"type",pixels});
}
pub fn glGetTexParameterfv (target:TextureTarget,pname:GetTextureParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexParameterfv.?, .{target,pname,params});
}
pub fn glGetTexParameteriv (target:TextureTarget,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexParameteriv.?, .{target,pname,params});
}
pub fn glGetTexLevelParameterfv (target:TextureTarget,level:GLint,pname:GetTextureParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexLevelParameterfv.?, .{target,level,pname,params});
}
pub fn glGetTexLevelParameteriv (target:TextureTarget,level:GLint,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexLevelParameteriv.?, .{target,level,pname,params});
}
pub fn glIsEnabled (cap:EnableCap) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsEnabled.?, .{cap});
}
pub fn glDepthRange (n:GLdouble,f:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthRange.?, .{n,f});
}
pub fn glViewport (x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glViewport.?, .{x,y,width,height});
}
pub fn glNewList (list:GLuint,mode:ListMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNewList.?, .{list,mode});
}
pub fn glEndList () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEndList.?, .{});
}
pub fn glCallList (list:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCallList.?, .{list});
}
pub fn glCallLists (n:GLsizei,@"type":ListNameType,lists:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCallLists.?, .{n,@"type",lists});
}
pub fn glDeleteLists (list:GLuint,range:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteLists.?, .{list,range});
}
pub fn glGenLists (range:GLsizei) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glGenLists.?, .{range});
}
pub fn glListBase (base:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glListBase.?, .{base});
}
pub fn glBegin (mode:PrimitiveType) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBegin.?, .{mode});
}
pub fn glBitmap (width:GLsizei,height:GLsizei,xorig:GLfloat,yorig:GLfloat,xmove:GLfloat,ymove:GLfloat,bitmap:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBitmap.?, .{width,height,xorig,yorig,xmove,ymove,bitmap});
}
pub fn glColor3b (red:GLbyte,green:GLbyte,blue:GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3b.?, .{red,green,blue});
}
pub fn glColor3bv (v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3bv.?, .{v});
}
pub fn glColor3d (red:GLdouble,green:GLdouble,blue:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3d.?, .{red,green,blue});
}
pub fn glColor3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3dv.?, .{v});
}
pub fn glColor3f (red:GLfloat,green:GLfloat,blue:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3f.?, .{red,green,blue});
}
pub fn glColor3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3fv.?, .{v});
}
pub fn glColor3i (red:GLint,green:GLint,blue:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3i.?, .{red,green,blue});
}
pub fn glColor3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3iv.?, .{v});
}
pub fn glColor3s (red:GLshort,green:GLshort,blue:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3s.?, .{red,green,blue});
}
pub fn glColor3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3sv.?, .{v});
}
pub fn glColor3ub (red:GLubyte,green:GLubyte,blue:GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3ub.?, .{red,green,blue});
}
pub fn glColor3ubv (v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3ubv.?, .{v});
}
pub fn glColor3ui (red:GLuint,green:GLuint,blue:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3ui.?, .{red,green,blue});
}
pub fn glColor3uiv (v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3uiv.?, .{v});
}
pub fn glColor3us (red:GLushort,green:GLushort,blue:GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3us.?, .{red,green,blue});
}
pub fn glColor3usv (v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor3usv.?, .{v});
}
pub fn glColor4b (red:GLbyte,green:GLbyte,blue:GLbyte,alpha:GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4b.?, .{red,green,blue,alpha});
}
pub fn glColor4bv (v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4bv.?, .{v});
}
pub fn glColor4d (red:GLdouble,green:GLdouble,blue:GLdouble,alpha:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4d.?, .{red,green,blue,alpha});
}
pub fn glColor4dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4dv.?, .{v});
}
pub fn glColor4f (red:GLfloat,green:GLfloat,blue:GLfloat,alpha:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4f.?, .{red,green,blue,alpha});
}
pub fn glColor4fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4fv.?, .{v});
}
pub fn glColor4i (red:GLint,green:GLint,blue:GLint,alpha:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4i.?, .{red,green,blue,alpha});
}
pub fn glColor4iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4iv.?, .{v});
}
pub fn glColor4s (red:GLshort,green:GLshort,blue:GLshort,alpha:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4s.?, .{red,green,blue,alpha});
}
pub fn glColor4sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4sv.?, .{v});
}
pub fn glColor4ub (red:GLubyte,green:GLubyte,blue:GLubyte,alpha:GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4ub.?, .{red,green,blue,alpha});
}
pub fn glColor4ubv (v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4ubv.?, .{v});
}
pub fn glColor4ui (red:GLuint,green:GLuint,blue:GLuint,alpha:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4ui.?, .{red,green,blue,alpha});
}
pub fn glColor4uiv (v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4uiv.?, .{v});
}
pub fn glColor4us (red:GLushort,green:GLushort,blue:GLushort,alpha:GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4us.?, .{red,green,blue,alpha});
}
pub fn glColor4usv (v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColor4usv.?, .{v});
}
pub fn glEdgeFlag (flag:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEdgeFlag.?, .{flag});
}
pub fn glEdgeFlagv (flag:[*c]const GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEdgeFlagv.?, .{flag});
}
pub fn glEnd () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnd.?, .{});
}
pub fn glIndexd (c:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexd.?, .{c});
}
pub fn glIndexdv (c:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexdv.?, .{c});
}
pub fn glIndexf (c:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexf.?, .{c});
}
pub fn glIndexfv (c:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexfv.?, .{c});
}
pub fn glIndexi (c:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexi.?, .{c});
}
pub fn glIndexiv (c:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexiv.?, .{c});
}
pub fn glIndexs (c:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexs.?, .{c});
}
pub fn glIndexsv (c:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexsv.?, .{c});
}
pub fn glNormal3b (nx:GLbyte,ny:GLbyte,nz:GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3b.?, .{nx,ny,nz});
}
pub fn glNormal3bv (v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3bv.?, .{v});
}
pub fn glNormal3d (nx:GLdouble,ny:GLdouble,nz:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3d.?, .{nx,ny,nz});
}
pub fn glNormal3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3dv.?, .{v});
}
pub fn glNormal3f (nx:GLfloat,ny:GLfloat,nz:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3f.?, .{nx,ny,nz});
}
pub fn glNormal3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3fv.?, .{v});
}
pub fn glNormal3i (nx:GLint,ny:GLint,nz:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3i.?, .{nx,ny,nz});
}
pub fn glNormal3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3iv.?, .{v});
}
pub fn glNormal3s (nx:GLshort,ny:GLshort,nz:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3s.?, .{nx,ny,nz});
}
pub fn glNormal3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormal3sv.?, .{v});
}
pub fn glRasterPos2d (x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2d.?, .{x,y});
}
pub fn glRasterPos2dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2dv.?, .{v});
}
pub fn glRasterPos2f (x:GLfloat,y:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2f.?, .{x,y});
}
pub fn glRasterPos2fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2fv.?, .{v});
}
pub fn glRasterPos2i (x:GLint,y:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2i.?, .{x,y});
}
pub fn glRasterPos2iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2iv.?, .{v});
}
pub fn glRasterPos2s (x:GLshort,y:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2s.?, .{x,y});
}
pub fn glRasterPos2sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos2sv.?, .{v});
}
pub fn glRasterPos3d (x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3d.?, .{x,y,z});
}
pub fn glRasterPos3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3dv.?, .{v});
}
pub fn glRasterPos3f (x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3f.?, .{x,y,z});
}
pub fn glRasterPos3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3fv.?, .{v});
}
pub fn glRasterPos3i (x:GLint,y:GLint,z:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3i.?, .{x,y,z});
}
pub fn glRasterPos3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3iv.?, .{v});
}
pub fn glRasterPos3s (x:GLshort,y:GLshort,z:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3s.?, .{x,y,z});
}
pub fn glRasterPos3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos3sv.?, .{v});
}
pub fn glRasterPos4d (x:GLdouble,y:GLdouble,z:GLdouble,w:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4d.?, .{x,y,z,w});
}
pub fn glRasterPos4dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4dv.?, .{v});
}
pub fn glRasterPos4f (x:GLfloat,y:GLfloat,z:GLfloat,w:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4f.?, .{x,y,z,w});
}
pub fn glRasterPos4fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4fv.?, .{v});
}
pub fn glRasterPos4i (x:GLint,y:GLint,z:GLint,w:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4i.?, .{x,y,z,w});
}
pub fn glRasterPos4iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4iv.?, .{v});
}
pub fn glRasterPos4s (x:GLshort,y:GLshort,z:GLshort,w:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4s.?, .{x,y,z,w});
}
pub fn glRasterPos4sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRasterPos4sv.?, .{v});
}
pub fn glRectd (x1:GLdouble,y1:GLdouble,x2:GLdouble,y2:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectd.?, .{x1,y1,x2,y2});
}
pub fn glRectdv (v1:[*c]const GLdouble,v2:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectdv.?, .{v1,v2});
}
pub fn glRectf (x1:GLfloat,y1:GLfloat,x2:GLfloat,y2:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectf.?, .{x1,y1,x2,y2});
}
pub fn glRectfv (v1:[*c]const GLfloat,v2:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectfv.?, .{v1,v2});
}
pub fn glRecti (x1:GLint,y1:GLint,x2:GLint,y2:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRecti.?, .{x1,y1,x2,y2});
}
pub fn glRectiv (v1:[*c]const GLint,v2:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectiv.?, .{v1,v2});
}
pub fn glRects (x1:GLshort,y1:GLshort,x2:GLshort,y2:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRects.?, .{x1,y1,x2,y2});
}
pub fn glRectsv (v1:[*c]const GLshort,v2:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRectsv.?, .{v1,v2});
}
pub fn glTexCoord1d (s:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1d.?, .{s});
}
pub fn glTexCoord1dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1dv.?, .{v});
}
pub fn glTexCoord1f (s:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1f.?, .{s});
}
pub fn glTexCoord1fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1fv.?, .{v});
}
pub fn glTexCoord1i (s:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1i.?, .{s});
}
pub fn glTexCoord1iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1iv.?, .{v});
}
pub fn glTexCoord1s (s:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1s.?, .{s});
}
pub fn glTexCoord1sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord1sv.?, .{v});
}
pub fn glTexCoord2d (s:GLdouble,t:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2d.?, .{s,t});
}
pub fn glTexCoord2dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2dv.?, .{v});
}
pub fn glTexCoord2f (s:GLfloat,t:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2f.?, .{s,t});
}
pub fn glTexCoord2fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2fv.?, .{v});
}
pub fn glTexCoord2i (s:GLint,t:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2i.?, .{s,t});
}
pub fn glTexCoord2iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2iv.?, .{v});
}
pub fn glTexCoord2s (s:GLshort,t:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2s.?, .{s,t});
}
pub fn glTexCoord2sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord2sv.?, .{v});
}
pub fn glTexCoord3d (s:GLdouble,t:GLdouble,r:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3d.?, .{s,t,r});
}
pub fn glTexCoord3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3dv.?, .{v});
}
pub fn glTexCoord3f (s:GLfloat,t:GLfloat,r:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3f.?, .{s,t,r});
}
pub fn glTexCoord3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3fv.?, .{v});
}
pub fn glTexCoord3i (s:GLint,t:GLint,r:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3i.?, .{s,t,r});
}
pub fn glTexCoord3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3iv.?, .{v});
}
pub fn glTexCoord3s (s:GLshort,t:GLshort,r:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3s.?, .{s,t,r});
}
pub fn glTexCoord3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord3sv.?, .{v});
}
pub fn glTexCoord4d (s:GLdouble,t:GLdouble,r:GLdouble,q:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4d.?, .{s,t,r,q});
}
pub fn glTexCoord4dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4dv.?, .{v});
}
pub fn glTexCoord4f (s:GLfloat,t:GLfloat,r:GLfloat,q:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4f.?, .{s,t,r,q});
}
pub fn glTexCoord4fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4fv.?, .{v});
}
pub fn glTexCoord4i (s:GLint,t:GLint,r:GLint,q:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4i.?, .{s,t,r,q});
}
pub fn glTexCoord4iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4iv.?, .{v});
}
pub fn glTexCoord4s (s:GLshort,t:GLshort,r:GLshort,q:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4s.?, .{s,t,r,q});
}
pub fn glTexCoord4sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoord4sv.?, .{v});
}
pub fn glVertex2d (x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2d.?, .{x,y});
}
pub fn glVertex2dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2dv.?, .{v});
}
pub fn glVertex2f (x:GLfloat,y:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2f.?, .{x,y});
}
pub fn glVertex2fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2fv.?, .{v});
}
pub fn glVertex2i (x:GLint,y:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2i.?, .{x,y});
}
pub fn glVertex2iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2iv.?, .{v});
}
pub fn glVertex2s (x:GLshort,y:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2s.?, .{x,y});
}
pub fn glVertex2sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex2sv.?, .{v});
}
pub fn glVertex3d (x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3d.?, .{x,y,z});
}
pub fn glVertex3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3dv.?, .{v});
}
pub fn glVertex3f (x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3f.?, .{x,y,z});
}
pub fn glVertex3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3fv.?, .{v});
}
pub fn glVertex3i (x:GLint,y:GLint,z:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3i.?, .{x,y,z});
}
pub fn glVertex3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3iv.?, .{v});
}
pub fn glVertex3s (x:GLshort,y:GLshort,z:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3s.?, .{x,y,z});
}
pub fn glVertex3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex3sv.?, .{v});
}
pub fn glVertex4d (x:GLdouble,y:GLdouble,z:GLdouble,w:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4d.?, .{x,y,z,w});
}
pub fn glVertex4dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4dv.?, .{v});
}
pub fn glVertex4f (x:GLfloat,y:GLfloat,z:GLfloat,w:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4f.?, .{x,y,z,w});
}
pub fn glVertex4fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4fv.?, .{v});
}
pub fn glVertex4i (x:GLint,y:GLint,z:GLint,w:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4i.?, .{x,y,z,w});
}
pub fn glVertex4iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4iv.?, .{v});
}
pub fn glVertex4s (x:GLshort,y:GLshort,z:GLshort,w:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4s.?, .{x,y,z,w});
}
pub fn glVertex4sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertex4sv.?, .{v});
}
pub fn glClipPlane (plane:ClipPlaneName,equation:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClipPlane.?, .{plane,equation});
}
pub fn glColorMaterial (face:TriangleFace,mode:ColorMaterialParameter) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorMaterial.?, .{face,mode});
}
pub fn glFogf (pname:FogParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogf.?, .{pname,param});
}
pub fn glFogfv (pname:FogParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogfv.?, .{pname,params});
}
pub fn glFogi (pname:FogParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogi.?, .{pname,param});
}
pub fn glFogiv (pname:FogParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogiv.?, .{pname,params});
}
pub fn glLightf (light:LightName,pname:LightParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightf.?, .{light,pname,param});
}
pub fn glLightfv (light:LightName,pname:LightParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightfv.?, .{light,pname,params});
}
pub fn glLighti (light:LightName,pname:LightParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLighti.?, .{light,pname,param});
}
pub fn glLightiv (light:LightName,pname:LightParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightiv.?, .{light,pname,params});
}
pub fn glLightModelf (pname:LightModelParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightModelf.?, .{pname,param});
}
pub fn glLightModelfv (pname:LightModelParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightModelfv.?, .{pname,params});
}
pub fn glLightModeli (pname:LightModelParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightModeli.?, .{pname,param});
}
pub fn glLightModeliv (pname:LightModelParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLightModeliv.?, .{pname,params});
}
pub fn glLineStipple (factor:GLint,pattern:GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLineStipple.?, .{factor,pattern});
}
pub fn glMaterialf (face:TriangleFace,pname:MaterialParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMaterialf.?, .{face,pname,param});
}
pub fn glMaterialfv (face:TriangleFace,pname:MaterialParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMaterialfv.?, .{face,pname,params});
}
pub fn glMateriali (face:TriangleFace,pname:MaterialParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMateriali.?, .{face,pname,param});
}
pub fn glMaterialiv (face:TriangleFace,pname:MaterialParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMaterialiv.?, .{face,pname,params});
}
pub fn glPolygonStipple (mask:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPolygonStipple.?, .{mask});
}
pub fn glShadeModel (mode:ShadingModel) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glShadeModel.?, .{mode});
}
pub fn glTexEnvf (target:TextureEnvTarget,pname:TextureEnvParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexEnvf.?, .{target,pname,param});
}
pub fn glTexEnvfv (target:TextureEnvTarget,pname:TextureEnvParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexEnvfv.?, .{target,pname,params});
}
pub fn glTexEnvi (target:TextureEnvTarget,pname:TextureEnvParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexEnvi.?, .{target,pname,param});
}
pub fn glTexEnviv (target:TextureEnvTarget,pname:TextureEnvParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexEnviv.?, .{target,pname,params});
}
pub fn glTexGend (coord:TextureCoordName,pname:TextureGenParameter,param:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGend.?, .{coord,pname,param});
}
pub fn glTexGendv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGendv.?, .{coord,pname,params});
}
pub fn glTexGenf (coord:TextureCoordName,pname:TextureGenParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGenf.?, .{coord,pname,param});
}
pub fn glTexGenfv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGenfv.?, .{coord,pname,params});
}
pub fn glTexGeni (coord:TextureCoordName,pname:TextureGenParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGeni.?, .{coord,pname,param});
}
pub fn glTexGeniv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexGeniv.?, .{coord,pname,params});
}
pub fn glFeedbackBuffer (size:GLsizei,@"type":FeedbackType,buffer:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFeedbackBuffer.?, .{size,@"type",buffer});
}
pub fn glSelectBuffer (size:GLsizei,buffer:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSelectBuffer.?, .{size,buffer});
}
pub fn glRenderMode (mode:RenderingMode) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glRenderMode.?, .{mode});
}
pub fn glInitNames () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInitNames.?, .{});
}
pub fn glLoadName (name:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadName.?, .{name});
}
pub fn glPassThrough (token:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPassThrough.?, .{token});
}
pub fn glPopName () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPopName.?, .{});
}
pub fn glPushName (name:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPushName.?, .{name});
}
pub fn glClearAccum (red:GLfloat,green:GLfloat,blue:GLfloat,alpha:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearAccum.?, .{red,green,blue,alpha});
}
pub fn glClearIndex (c:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearIndex.?, .{c});
}
pub fn glIndexMask (mask:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexMask.?, .{mask});
}
pub fn glAccum (op:AccumOp,value:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glAccum.?, .{op,value});
}
pub fn glPopAttrib () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPopAttrib.?, .{});
}
pub fn glPushAttrib (mask:AttribMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPushAttrib.?, .{@as(GLbitfield, @bitCast(mask))});
}
pub fn glMap1d (target:MapTarget,@"u1":GLdouble,@"u2":GLdouble,stride:GLint,order:GLint,points:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMap1d.?, .{target,@"u1",@"u2",stride,order,points});
}
pub fn glMap1f (target:MapTarget,@"u1":GLfloat,@"u2":GLfloat,stride:GLint,order:GLint,points:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMap1f.?, .{target,@"u1",@"u2",stride,order,points});
}
pub fn glMap2d (target:MapTarget,@"u1":GLdouble,@"u2":GLdouble,ustride:GLint,uorder:GLint,v1:GLdouble,v2:GLdouble,vstride:GLint,vorder:GLint,points:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMap2d.?, .{target,@"u1",@"u2",ustride,uorder,v1,v2,vstride,vorder,points});
}
pub fn glMap2f (target:MapTarget,@"u1":GLfloat,@"u2":GLfloat,ustride:GLint,uorder:GLint,v1:GLfloat,v2:GLfloat,vstride:GLint,vorder:GLint,points:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMap2f.?, .{target,@"u1",@"u2",ustride,uorder,v1,v2,vstride,vorder,points});
}
pub fn glMapGrid1d (un:GLint,@"u1":GLdouble,@"u2":GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMapGrid1d.?, .{un,@"u1",@"u2"});
}
pub fn glMapGrid1f (un:GLint,@"u1":GLfloat,@"u2":GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMapGrid1f.?, .{un,@"u1",@"u2"});
}
pub fn glMapGrid2d (un:GLint,@"u1":GLdouble,@"u2":GLdouble,vn:GLint,v1:GLdouble,v2:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMapGrid2d.?, .{un,@"u1",@"u2",vn,v1,v2});
}
pub fn glMapGrid2f (un:GLint,@"u1":GLfloat,@"u2":GLfloat,vn:GLint,v1:GLfloat,v2:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMapGrid2f.?, .{un,@"u1",@"u2",vn,v1,v2});
}
pub fn glEvalCoord1d (u:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord1d.?, .{u});
}
pub fn glEvalCoord1dv (u:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord1dv.?, .{u});
}
pub fn glEvalCoord1f (u:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord1f.?, .{u});
}
pub fn glEvalCoord1fv (u:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord1fv.?, .{u});
}
pub fn glEvalCoord2d (u:GLdouble,v:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord2d.?, .{u,v});
}
pub fn glEvalCoord2dv (u:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord2dv.?, .{u});
}
pub fn glEvalCoord2f (u:GLfloat,v:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord2f.?, .{u,v});
}
pub fn glEvalCoord2fv (u:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalCoord2fv.?, .{u});
}
pub fn glEvalMesh1 (mode:MeshMode1,@"i1":GLint,@"i2":GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalMesh1.?, .{mode,@"i1",@"i2"});
}
pub fn glEvalPoint1 (i:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalPoint1.?, .{i});
}
pub fn glEvalMesh2 (mode:MeshMode2,@"i1":GLint,@"i2":GLint,j1:GLint,j2:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalMesh2.?, .{mode,@"i1",@"i2",j1,j2});
}
pub fn glEvalPoint2 (i:GLint,j:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEvalPoint2.?, .{i,j});
}
pub fn glAlphaFunc (func:AlphaFunction,ref:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glAlphaFunc.?, .{func,ref});
}
pub fn glPixelZoom (xfactor:GLfloat,yfactor:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelZoom.?, .{xfactor,yfactor});
}
pub fn glPixelTransferf (pname:PixelTransferParameter,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelTransferf.?, .{pname,param});
}
pub fn glPixelTransferi (pname:PixelTransferParameter,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelTransferi.?, .{pname,param});
}
pub fn glPixelMapfv (map:PixelMap,mapsize:GLsizei,values:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelMapfv.?, .{map,mapsize,values});
}
pub fn glPixelMapuiv (map:PixelMap,mapsize:GLsizei,values:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelMapuiv.?, .{map,mapsize,values});
}
pub fn glPixelMapusv (map:PixelMap,mapsize:GLsizei,values:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPixelMapusv.?, .{map,mapsize,values});
}
pub fn glCopyPixels (x:GLint,y:GLint,width:GLsizei,height:GLsizei,@"type":PixelCopyType) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyPixels.?, .{x,y,width,height,@"type"});
}
pub fn glDrawPixels (width:GLsizei,height:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawPixels.?, .{width,height,format,@"type",pixels});
}
pub fn glGetClipPlane (plane:ClipPlaneName,equation:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetClipPlane.?, .{plane,equation});
}
pub fn glGetLightfv (light:LightName,pname:LightParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetLightfv.?, .{light,pname,params});
}
pub fn glGetLightiv (light:LightName,pname:LightParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetLightiv.?, .{light,pname,params});
}
pub fn glGetMapdv (target:MapTarget,query:GetMapQuery,v:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMapdv.?, .{target,query,v});
}
pub fn glGetMapfv (target:MapTarget,query:GetMapQuery,v:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMapfv.?, .{target,query,v});
}
pub fn glGetMapiv (target:MapTarget,query:GetMapQuery,v:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMapiv.?, .{target,query,v});
}
pub fn glGetMaterialfv (face:TriangleFace,pname:MaterialParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMaterialfv.?, .{face,pname,params});
}
pub fn glGetMaterialiv (face:TriangleFace,pname:MaterialParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMaterialiv.?, .{face,pname,params});
}
pub fn glGetPixelMapfv (map:PixelMap,values:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetPixelMapfv.?, .{map,values});
}
pub fn glGetPixelMapuiv (map:PixelMap,values:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetPixelMapuiv.?, .{map,values});
}
pub fn glGetPixelMapusv (map:PixelMap,values:[*c]GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetPixelMapusv.?, .{map,values});
}
pub fn glGetPolygonStipple (mask:[*c]GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetPolygonStipple.?, .{mask});
}
pub fn glGetTexEnvfv (target:TextureEnvTarget,pname:TextureEnvParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexEnvfv.?, .{target,pname,params});
}
pub fn glGetTexEnviv (target:TextureEnvTarget,pname:TextureEnvParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexEnviv.?, .{target,pname,params});
}
pub fn glGetTexGendv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexGendv.?, .{coord,pname,params});
}
pub fn glGetTexGenfv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexGenfv.?, .{coord,pname,params});
}
pub fn glGetTexGeniv (coord:TextureCoordName,pname:TextureGenParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexGeniv.?, .{coord,pname,params});
}
pub fn glIsList (list:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsList.?, .{list});
}
pub fn glFrustum (left:GLdouble,right:GLdouble,bottom:GLdouble,top:GLdouble,zNear:GLdouble,zFar:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFrustum.?, .{left,right,bottom,top,zNear,zFar});
}
pub fn glLoadIdentity () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadIdentity.?, .{});
}
pub fn glLoadMatrixf (m:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadMatrixf.?, .{m});
}
pub fn glLoadMatrixd (m:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadMatrixd.?, .{m});
}
pub fn glMatrixMode (mode:MatrixMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMatrixMode.?, .{mode});
}
pub fn glMultMatrixf (m:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultMatrixf.?, .{m});
}
pub fn glMultMatrixd (m:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultMatrixd.?, .{m});
}
pub fn glOrtho (left:GLdouble,right:GLdouble,bottom:GLdouble,top:GLdouble,zNear:GLdouble,zFar:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glOrtho.?, .{left,right,bottom,top,zNear,zFar});
}
pub fn glPopMatrix () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPopMatrix.?, .{});
}
pub fn glPushMatrix () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPushMatrix.?, .{});
}
pub fn glRotated (angle:GLdouble,x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRotated.?, .{angle,x,y,z});
}
pub fn glRotatef (angle:GLfloat,x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRotatef.?, .{angle,x,y,z});
}
pub fn glScaled (x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScaled.?, .{x,y,z});
}
pub fn glScalef (x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScalef.?, .{x,y,z});
}
pub fn glTranslated (x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTranslated.?, .{x,y,z});
}
pub fn glTranslatef (x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTranslatef.?, .{x,y,z});
}
pub fn glDrawArrays (mode:PrimitiveType,first:GLint,count:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawArrays.?, .{mode,first,count});
}
pub fn glDrawElements (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElements.?, .{mode,count,@"type",indices});
}
pub fn glGetPointerv (pname:GetPointervPName,params:[*c]?*?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetPointerv.?, .{pname,params});
}
pub fn glPolygonOffset (factor:GLfloat,units:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPolygonOffset.?, .{factor,units});
}
pub fn glCopyTexImage1D (target:TextureTarget,level:GLint,internalformat:InternalFormat,x:GLint,y:GLint,width:GLsizei,border:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTexImage1D.?, .{target,level,internalformat,x,y,width,border});
}
pub fn glCopyTexImage2D (target:TextureTarget,level:GLint,internalformat:InternalFormat,x:GLint,y:GLint,width:GLsizei,height:GLsizei,border:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTexImage2D.?, .{target,level,internalformat,x,y,width,height,border});
}
pub fn glCopyTexSubImage1D (target:TextureTarget,level:GLint,xoffset:GLint,x:GLint,y:GLint,width:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTexSubImage1D.?, .{target,level,xoffset,x,y,width});
}
pub fn glCopyTexSubImage2D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTexSubImage2D.?, .{target,level,xoffset,yoffset,x,y,width,height});
}
pub fn glTexSubImage1D (target:TextureTarget,level:GLint,xoffset:GLint,width:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexSubImage1D.?, .{target,level,xoffset,width,format,@"type",pixels});
}
pub fn glTexSubImage2D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,width:GLsizei,height:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexSubImage2D.?, .{target,level,xoffset,yoffset,width,height,format,@"type",pixels});
}
pub fn glBindTexture (target:TextureTarget,texture:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindTexture.?, .{target,texture});
}
pub fn glDeleteTextures (n:GLsizei,textures:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteTextures.?, .{n,textures});
}
pub fn glGenTextures (n:GLsizei,textures:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenTextures.?, .{n,textures});
}
pub fn glIsTexture (texture:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsTexture.?, .{texture});
}
pub fn glArrayElement (i:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glArrayElement.?, .{i});
}
pub fn glColorPointer (size:GLint,@"type":ColorPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorPointer.?, .{size,@"type",stride,pointer});
}
pub fn glDisableClientState (array:EnableCap) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDisableClientState.?, .{array});
}
pub fn glEdgeFlagPointer (stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEdgeFlagPointer.?, .{stride,pointer});
}
pub fn glEnableClientState (array:EnableCap) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnableClientState.?, .{array});
}
pub fn glIndexPointer (@"type":IndexPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexPointer.?, .{@"type",stride,pointer});
}
pub fn glInterleavedArrays (format:InterleavedArrayFormat,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInterleavedArrays.?, .{format,stride,pointer});
}
pub fn glNormalPointer (@"type":NormalPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormalPointer.?, .{@"type",stride,pointer});
}
pub fn glTexCoordPointer (size:GLint,@"type":TexCoordPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordPointer.?, .{size,@"type",stride,pointer});
}
pub fn glVertexPointer (size:GLint,@"type":VertexPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexPointer.?, .{size,@"type",stride,pointer});
}
pub fn glAreTexturesResident (n:GLsizei,textures:[*c]const GLuint,residences:[*c]GLboolean) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glAreTexturesResident.?, .{n,textures,residences});
}
pub fn glPrioritizeTextures (n:GLsizei,textures:[*c]const GLuint,priorities:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPrioritizeTextures.?, .{n,textures,priorities});
}
pub fn glIndexub (c:GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexub.?, .{c});
}
pub fn glIndexubv (c:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glIndexubv.?, .{c});
}
pub fn glPopClientAttrib () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPopClientAttrib.?, .{});
}
pub fn glPushClientAttrib (mask:ClientAttribMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPushClientAttrib.?, .{@as(GLbitfield, @bitCast(mask))});
}
pub fn glDrawRangeElements (mode:PrimitiveType,start:GLuint,end:GLuint,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawRangeElements.?, .{mode,start,end,count,@"type",indices});
}
pub fn glTexImage3D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei,border:GLint,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexImage3D.?, .{target,level,internalformat,width,height,depth,border,format,@"type",pixels});
}
pub fn glTexSubImage3D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexSubImage3D.?, .{target,level,xoffset,yoffset,zoffset,width,height,depth,format,@"type",pixels});
}
pub fn glCopyTexSubImage3D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTexSubImage3D.?, .{target,level,xoffset,yoffset,zoffset,x,y,width,height});
}
pub fn glActiveTexture (texture:TextureUnit) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glActiveTexture.?, .{texture});
}
pub fn glSampleCoverage (value:GLfloat,invert:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSampleCoverage.?, .{value,invert});
}
pub fn glCompressedTexImage3D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei,border:GLint,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexImage3D.?, .{target,level,internalformat,width,height,depth,border,imageSize,data});
}
pub fn glCompressedTexImage2D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,height:GLsizei,border:GLint,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexImage2D.?, .{target,level,internalformat,width,height,border,imageSize,data});
}
pub fn glCompressedTexImage1D (target:TextureTarget,level:GLint,internalformat:InternalFormat,width:GLsizei,border:GLint,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexImage1D.?, .{target,level,internalformat,width,border,imageSize,data});
}
pub fn glCompressedTexSubImage3D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexSubImage3D.?, .{target,level,xoffset,yoffset,zoffset,width,height,depth,format,imageSize,data});
}
pub fn glCompressedTexSubImage2D (target:TextureTarget,level:GLint,xoffset:GLint,yoffset:GLint,width:GLsizei,height:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexSubImage2D.?, .{target,level,xoffset,yoffset,width,height,format,imageSize,data});
}
pub fn glCompressedTexSubImage1D (target:TextureTarget,level:GLint,xoffset:GLint,width:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTexSubImage1D.?, .{target,level,xoffset,width,format,imageSize,data});
}
pub fn glGetCompressedTexImage (target:TextureTarget,level:GLint,img:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetCompressedTexImage.?, .{target,level,img});
}
pub fn glClientActiveTexture (texture:TextureUnit) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClientActiveTexture.?, .{texture});
}
pub fn glMultiTexCoord1d (target:TextureUnit,s:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1d.?, .{target,s});
}
pub fn glMultiTexCoord1dv (target:TextureUnit,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1dv.?, .{target,v});
}
pub fn glMultiTexCoord1f (target:TextureUnit,s:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1f.?, .{target,s});
}
pub fn glMultiTexCoord1fv (target:TextureUnit,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1fv.?, .{target,v});
}
pub fn glMultiTexCoord1i (target:TextureUnit,s:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1i.?, .{target,s});
}
pub fn glMultiTexCoord1iv (target:TextureUnit,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1iv.?, .{target,v});
}
pub fn glMultiTexCoord1s (target:TextureUnit,s:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1s.?, .{target,s});
}
pub fn glMultiTexCoord1sv (target:TextureUnit,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord1sv.?, .{target,v});
}
pub fn glMultiTexCoord2d (target:TextureUnit,s:GLdouble,t:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2d.?, .{target,s,t});
}
pub fn glMultiTexCoord2dv (target:TextureUnit,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2dv.?, .{target,v});
}
pub fn glMultiTexCoord2f (target:TextureUnit,s:GLfloat,t:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2f.?, .{target,s,t});
}
pub fn glMultiTexCoord2fv (target:TextureUnit,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2fv.?, .{target,v});
}
pub fn glMultiTexCoord2i (target:TextureUnit,s:GLint,t:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2i.?, .{target,s,t});
}
pub fn glMultiTexCoord2iv (target:TextureUnit,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2iv.?, .{target,v});
}
pub fn glMultiTexCoord2s (target:TextureUnit,s:GLshort,t:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2s.?, .{target,s,t});
}
pub fn glMultiTexCoord2sv (target:TextureUnit,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord2sv.?, .{target,v});
}
pub fn glMultiTexCoord3d (target:TextureUnit,s:GLdouble,t:GLdouble,r:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3d.?, .{target,s,t,r});
}
pub fn glMultiTexCoord3dv (target:TextureUnit,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3dv.?, .{target,v});
}
pub fn glMultiTexCoord3f (target:TextureUnit,s:GLfloat,t:GLfloat,r:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3f.?, .{target,s,t,r});
}
pub fn glMultiTexCoord3fv (target:TextureUnit,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3fv.?, .{target,v});
}
pub fn glMultiTexCoord3i (target:TextureUnit,s:GLint,t:GLint,r:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3i.?, .{target,s,t,r});
}
pub fn glMultiTexCoord3iv (target:TextureUnit,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3iv.?, .{target,v});
}
pub fn glMultiTexCoord3s (target:TextureUnit,s:GLshort,t:GLshort,r:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3s.?, .{target,s,t,r});
}
pub fn glMultiTexCoord3sv (target:TextureUnit,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord3sv.?, .{target,v});
}
pub fn glMultiTexCoord4d (target:TextureUnit,s:GLdouble,t:GLdouble,r:GLdouble,q:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4d.?, .{target,s,t,r,q});
}
pub fn glMultiTexCoord4dv (target:TextureUnit,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4dv.?, .{target,v});
}
pub fn glMultiTexCoord4f (target:TextureUnit,s:GLfloat,t:GLfloat,r:GLfloat,q:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4f.?, .{target,s,t,r,q});
}
pub fn glMultiTexCoord4fv (target:TextureUnit,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4fv.?, .{target,v});
}
pub fn glMultiTexCoord4i (target:TextureUnit,s:GLint,t:GLint,r:GLint,q:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4i.?, .{target,s,t,r,q});
}
pub fn glMultiTexCoord4iv (target:TextureUnit,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4iv.?, .{target,v});
}
pub fn glMultiTexCoord4s (target:TextureUnit,s:GLshort,t:GLshort,r:GLshort,q:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4s.?, .{target,s,t,r,q});
}
pub fn glMultiTexCoord4sv (target:TextureUnit,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoord4sv.?, .{target,v});
}
pub fn glLoadTransposeMatrixf (m:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadTransposeMatrixf.?, .{m});
}
pub fn glLoadTransposeMatrixd (m:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLoadTransposeMatrixd.?, .{m});
}
pub fn glMultTransposeMatrixf (m:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultTransposeMatrixf.?, .{m});
}
pub fn glMultTransposeMatrixd (m:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultTransposeMatrixd.?, .{m});
}
pub fn glBlendFuncSeparate (sfactorRGB:BlendingFactor,dfactorRGB:BlendingFactor,sfactorAlpha:BlendingFactor,dfactorAlpha:BlendingFactor) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendFuncSeparate.?, .{sfactorRGB,dfactorRGB,sfactorAlpha,dfactorAlpha});
}
pub fn glMultiDrawArrays (mode:PrimitiveType,first:[*c]const GLint,count:[*c]const GLsizei,drawcount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawArrays.?, .{mode,first,count,drawcount});
}
pub fn glMultiDrawElements (mode:PrimitiveType,count:[*c]const GLsizei,@"type":DrawElementsType,indices:[*c]const ?*const anyopaque,drawcount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawElements.?, .{mode,count,@"type",indices,drawcount});
}
pub fn glPointParameterf (pname:PointParameterNameARB,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPointParameterf.?, .{pname,param});
}
pub fn glPointParameterfv (pname:PointParameterNameARB,params:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPointParameterfv.?, .{pname,params});
}
pub fn glPointParameteri (pname:PointParameterNameARB,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPointParameteri.?, .{pname,param});
}
pub fn glPointParameteriv (pname:PointParameterNameARB,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPointParameteriv.?, .{pname,params});
}
pub fn glFogCoordf (coord:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogCoordf.?, .{coord});
}
pub fn glFogCoordfv (coord:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogCoordfv.?, .{coord});
}
pub fn glFogCoordd (coord:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogCoordd.?, .{coord});
}
pub fn glFogCoorddv (coord:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogCoorddv.?, .{coord});
}
pub fn glFogCoordPointer (@"type":FogPointerTypeEXT,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFogCoordPointer.?, .{@"type",stride,pointer});
}
pub fn glSecondaryColor3b (red:GLbyte,green:GLbyte,blue:GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3b.?, .{red,green,blue});
}
pub fn glSecondaryColor3bv (v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3bv.?, .{v});
}
pub fn glSecondaryColor3d (red:GLdouble,green:GLdouble,blue:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3d.?, .{red,green,blue});
}
pub fn glSecondaryColor3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3dv.?, .{v});
}
pub fn glSecondaryColor3f (red:GLfloat,green:GLfloat,blue:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3f.?, .{red,green,blue});
}
pub fn glSecondaryColor3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3fv.?, .{v});
}
pub fn glSecondaryColor3i (red:GLint,green:GLint,blue:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3i.?, .{red,green,blue});
}
pub fn glSecondaryColor3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3iv.?, .{v});
}
pub fn glSecondaryColor3s (red:GLshort,green:GLshort,blue:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3s.?, .{red,green,blue});
}
pub fn glSecondaryColor3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3sv.?, .{v});
}
pub fn glSecondaryColor3ub (red:GLubyte,green:GLubyte,blue:GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3ub.?, .{red,green,blue});
}
pub fn glSecondaryColor3ubv (v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3ubv.?, .{v});
}
pub fn glSecondaryColor3ui (red:GLuint,green:GLuint,blue:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3ui.?, .{red,green,blue});
}
pub fn glSecondaryColor3uiv (v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3uiv.?, .{v});
}
pub fn glSecondaryColor3us (red:GLushort,green:GLushort,blue:GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3us.?, .{red,green,blue});
}
pub fn glSecondaryColor3usv (v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColor3usv.?, .{v});
}
pub fn glSecondaryColorPointer (size:GLint,@"type":ColorPointerType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColorPointer.?, .{size,@"type",stride,pointer});
}
pub fn glWindowPos2d (x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2d.?, .{x,y});
}
pub fn glWindowPos2dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2dv.?, .{v});
}
pub fn glWindowPos2f (x:GLfloat,y:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2f.?, .{x,y});
}
pub fn glWindowPos2fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2fv.?, .{v});
}
pub fn glWindowPos2i (x:GLint,y:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2i.?, .{x,y});
}
pub fn glWindowPos2iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2iv.?, .{v});
}
pub fn glWindowPos2s (x:GLshort,y:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2s.?, .{x,y});
}
pub fn glWindowPos2sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos2sv.?, .{v});
}
pub fn glWindowPos3d (x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3d.?, .{x,y,z});
}
pub fn glWindowPos3dv (v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3dv.?, .{v});
}
pub fn glWindowPos3f (x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3f.?, .{x,y,z});
}
pub fn glWindowPos3fv (v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3fv.?, .{v});
}
pub fn glWindowPos3i (x:GLint,y:GLint,z:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3i.?, .{x,y,z});
}
pub fn glWindowPos3iv (v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3iv.?, .{v});
}
pub fn glWindowPos3s (x:GLshort,y:GLshort,z:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3s.?, .{x,y,z});
}
pub fn glWindowPos3sv (v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWindowPos3sv.?, .{v});
}
pub fn glBlendColor (red:GLfloat,green:GLfloat,blue:GLfloat,alpha:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendColor.?, .{red,green,blue,alpha});
}
pub fn glBlendEquation (mode:BlendEquationModeEXT) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendEquation.?, .{mode});
}
pub fn glGenQueries (n:GLsizei,ids:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenQueries.?, .{n,ids});
}
pub fn glDeleteQueries (n:GLsizei,ids:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteQueries.?, .{n,ids});
}
pub fn glIsQuery (id:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsQuery.?, .{id});
}
pub fn glBeginQuery (target:QueryTarget,id:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBeginQuery.?, .{target,id});
}
pub fn glEndQuery (target:QueryTarget) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEndQuery.?, .{target});
}
pub fn glGetQueryiv (target:QueryTarget,pname:QueryParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryiv.?, .{target,pname,params});
}
pub fn glGetQueryObjectiv (id:GLuint,pname:QueryObjectParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryObjectiv.?, .{id,pname,params});
}
pub fn glGetQueryObjectuiv (id:GLuint,pname:QueryObjectParameterName,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryObjectuiv.?, .{id,pname,params});
}
pub fn glBindBuffer (target:BufferTargetARB,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindBuffer.?, .{target,buffer});
}
pub fn glDeleteBuffers (n:GLsizei,buffers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteBuffers.?, .{n,buffers});
}
pub fn glGenBuffers (n:GLsizei,buffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenBuffers.?, .{n,buffers});
}
pub fn glIsBuffer (buffer:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsBuffer.?, .{buffer});
}
pub fn glBufferData (target:BufferTargetARB,size:GLsizeiptr,data:?*const anyopaque,usage:BufferUsageARB) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBufferData.?, .{target,size,data,usage});
}
pub fn glBufferSubData (target:BufferTargetARB,offset:GLintptr,size:GLsizeiptr,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBufferSubData.?, .{target,offset,size,data});
}
pub fn glGetBufferSubData (target:BufferTargetARB,offset:GLintptr,size:GLsizeiptr,data:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBufferSubData.?, .{target,offset,size,data});
}
pub fn glMapBuffer (target:BufferTargetARB,access:BufferAccessARB) callconv(.C) ?*anyopaque {
return @call(.always_tail, current_proc_table.?.glMapBuffer.?, .{target,access});
}
pub fn glUnmapBuffer (target:BufferTargetARB) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glUnmapBuffer.?, .{target});
}
pub fn glGetBufferParameteriv (target:BufferTargetARB,pname:BufferPNameARB,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBufferParameteriv.?, .{target,pname,params});
}
pub fn glGetBufferPointerv (target:BufferTargetARB,pname:BufferPointerNameARB,params:[*c]?*?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBufferPointerv.?, .{target,pname,params});
}
pub fn glBlendEquationSeparate (modeRGB:BlendEquationModeEXT,modeAlpha:BlendEquationModeEXT) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendEquationSeparate.?, .{modeRGB,modeAlpha});
}
pub fn glDrawBuffers (n:GLsizei,bufs:DrawBufferMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawBuffers.?, .{n,bufs});
}
pub fn glStencilOpSeparate (face:TriangleFace,sfail:StencilOp,dpfail:StencilOp,dppass:StencilOp) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilOpSeparate.?, .{face,sfail,dpfail,dppass});
}
pub fn glStencilFuncSeparate (face:TriangleFace,func:StencilFunction,ref:GLint,mask:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilFuncSeparate.?, .{face,func,ref,mask});
}
pub fn glStencilMaskSeparate (face:TriangleFace,mask:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glStencilMaskSeparate.?, .{face,mask});
}
pub fn glAttachShader (program:GLuint,shader:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glAttachShader.?, .{program,shader});
}
pub fn glBindAttribLocation (program:GLuint,index:GLuint,name:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindAttribLocation.?, .{program,index,name});
}
pub fn glCompileShader (shader:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompileShader.?, .{shader});
}
pub fn glCreateProgram () callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glCreateProgram.?, .{});
}
pub fn glCreateShader (@"type":ShaderType) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glCreateShader.?, .{@"type"});
}
pub fn glDeleteProgram (program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteProgram.?, .{program});
}
pub fn glDeleteShader (shader:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteShader.?, .{shader});
}
pub fn glDetachShader (program:GLuint,shader:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDetachShader.?, .{program,shader});
}
pub fn glDisableVertexAttribArray (index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDisableVertexAttribArray.?, .{index});
}
pub fn glEnableVertexAttribArray (index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnableVertexAttribArray.?, .{index});
}
pub fn glGetActiveAttrib (program:GLuint,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,size:[*c]GLint,@"type":AttributeType,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveAttrib.?, .{program,index,bufSize,length,size,@"type",name});
}
pub fn glGetActiveUniform (program:GLuint,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,size:[*c]GLint,@"type":UniformType,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveUniform.?, .{program,index,bufSize,length,size,@"type",name});
}
pub fn glGetAttachedShaders (program:GLuint,maxCount:GLsizei,count:[*c]GLsizei,shaders:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetAttachedShaders.?, .{program,maxCount,count,shaders});
}
pub fn glGetAttribLocation (program:GLuint,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetAttribLocation.?, .{program,name});
}
pub fn glGetProgramiv (program:GLuint,pname:ProgramPropertyARB,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramiv.?, .{program,pname,params});
}
pub fn glGetProgramInfoLog (program:GLuint,bufSize:GLsizei,length:[*c]GLsizei,infoLog:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramInfoLog.?, .{program,bufSize,length,infoLog});
}
pub fn glGetShaderiv (shader:GLuint,pname:ShaderParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetShaderiv.?, .{shader,pname,params});
}
pub fn glGetShaderInfoLog (shader:GLuint,bufSize:GLsizei,length:[*c]GLsizei,infoLog:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetShaderInfoLog.?, .{shader,bufSize,length,infoLog});
}
pub fn glGetShaderSource (shader:GLuint,bufSize:GLsizei,length:[*c]GLsizei,source:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetShaderSource.?, .{shader,bufSize,length,source});
}
pub fn glGetUniformLocation (program:GLuint,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetUniformLocation.?, .{program,name});
}
pub fn glGetUniformfv (program:GLuint,location:GLint,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformfv.?, .{program,location,params});
}
pub fn glGetUniformiv (program:GLuint,location:GLint,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformiv.?, .{program,location,params});
}
pub fn glGetVertexAttribdv (index:GLuint,pname:VertexAttribPropertyARB,params:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribdv.?, .{index,pname,params});
}
pub fn glGetVertexAttribfv (index:GLuint,pname:VertexAttribPropertyARB,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribfv.?, .{index,pname,params});
}
pub fn glGetVertexAttribiv (index:GLuint,pname:VertexAttribPropertyARB,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribiv.?, .{index,pname,params});
}
pub fn glGetVertexAttribPointerv (index:GLuint,pname:VertexAttribPointerPropertyARB,pointer:[*c]?*?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribPointerv.?, .{index,pname,pointer});
}
pub fn glIsProgram (program:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsProgram.?, .{program});
}
pub fn glIsShader (shader:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsShader.?, .{shader});
}
pub fn glLinkProgram (program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glLinkProgram.?, .{program});
}
pub fn glShaderSource (shader:GLuint,count:GLsizei,string:[*c]const [*c]const GLchar,length:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glShaderSource.?, .{shader,count,string,length});
}
pub fn glUseProgram (program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUseProgram.?, .{program});
}
pub fn glUniform1f (location:GLint,v0:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1f.?, .{location,v0});
}
pub fn glUniform2f (location:GLint,v0:GLfloat,v1:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2f.?, .{location,v0,v1});
}
pub fn glUniform3f (location:GLint,v0:GLfloat,v1:GLfloat,v2:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3f.?, .{location,v0,v1,v2});
}
pub fn glUniform4f (location:GLint,v0:GLfloat,v1:GLfloat,v2:GLfloat,v3:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4f.?, .{location,v0,v1,v2,v3});
}
pub fn glUniform1i (location:GLint,v0:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1i.?, .{location,v0});
}
pub fn glUniform2i (location:GLint,v0:GLint,v1:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2i.?, .{location,v0,v1});
}
pub fn glUniform3i (location:GLint,v0:GLint,v1:GLint,v2:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3i.?, .{location,v0,v1,v2});
}
pub fn glUniform4i (location:GLint,v0:GLint,v1:GLint,v2:GLint,v3:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4i.?, .{location,v0,v1,v2,v3});
}
pub fn glUniform1fv (location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1fv.?, .{location,count,value});
}
pub fn glUniform2fv (location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2fv.?, .{location,count,value});
}
pub fn glUniform3fv (location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3fv.?, .{location,count,value});
}
pub fn glUniform4fv (location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4fv.?, .{location,count,value});
}
pub fn glUniform1iv (location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1iv.?, .{location,count,value});
}
pub fn glUniform2iv (location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2iv.?, .{location,count,value});
}
pub fn glUniform3iv (location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3iv.?, .{location,count,value});
}
pub fn glUniform4iv (location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4iv.?, .{location,count,value});
}
pub fn glUniformMatrix2fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4fv.?, .{location,count,transpose,value});
}
pub fn glValidateProgram (program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glValidateProgram.?, .{program});
}
pub fn glVertexAttrib1d (index:GLuint,x:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1d.?, .{index,x});
}
pub fn glVertexAttrib1dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1dv.?, .{index,v});
}
pub fn glVertexAttrib1f (index:GLuint,x:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1f.?, .{index,x});
}
pub fn glVertexAttrib1fv (index:GLuint,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1fv.?, .{index,v});
}
pub fn glVertexAttrib1s (index:GLuint,x:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1s.?, .{index,x});
}
pub fn glVertexAttrib1sv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib1sv.?, .{index,v});
}
pub fn glVertexAttrib2d (index:GLuint,x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2d.?, .{index,x,y});
}
pub fn glVertexAttrib2dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2dv.?, .{index,v});
}
pub fn glVertexAttrib2f (index:GLuint,x:GLfloat,y:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2f.?, .{index,x,y});
}
pub fn glVertexAttrib2fv (index:GLuint,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2fv.?, .{index,v});
}
pub fn glVertexAttrib2s (index:GLuint,x:GLshort,y:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2s.?, .{index,x,y});
}
pub fn glVertexAttrib2sv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib2sv.?, .{index,v});
}
pub fn glVertexAttrib3d (index:GLuint,x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3d.?, .{index,x,y,z});
}
pub fn glVertexAttrib3dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3dv.?, .{index,v});
}
pub fn glVertexAttrib3f (index:GLuint,x:GLfloat,y:GLfloat,z:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3f.?, .{index,x,y,z});
}
pub fn glVertexAttrib3fv (index:GLuint,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3fv.?, .{index,v});
}
pub fn glVertexAttrib3s (index:GLuint,x:GLshort,y:GLshort,z:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3s.?, .{index,x,y,z});
}
pub fn glVertexAttrib3sv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib3sv.?, .{index,v});
}
pub fn glVertexAttrib4Nbv (index:GLuint,v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nbv.?, .{index,v});
}
pub fn glVertexAttrib4Niv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Niv.?, .{index,v});
}
pub fn glVertexAttrib4Nsv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nsv.?, .{index,v});
}
pub fn glVertexAttrib4Nub (index:GLuint,x:GLubyte,y:GLubyte,z:GLubyte,w:GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nub.?, .{index,x,y,z,w});
}
pub fn glVertexAttrib4Nubv (index:GLuint,v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nubv.?, .{index,v});
}
pub fn glVertexAttrib4Nuiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nuiv.?, .{index,v});
}
pub fn glVertexAttrib4Nusv (index:GLuint,v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4Nusv.?, .{index,v});
}
pub fn glVertexAttrib4bv (index:GLuint,v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4bv.?, .{index,v});
}
pub fn glVertexAttrib4d (index:GLuint,x:GLdouble,y:GLdouble,z:GLdouble,w:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4d.?, .{index,x,y,z,w});
}
pub fn glVertexAttrib4dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4dv.?, .{index,v});
}
pub fn glVertexAttrib4f (index:GLuint,x:GLfloat,y:GLfloat,z:GLfloat,w:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4f.?, .{index,x,y,z,w});
}
pub fn glVertexAttrib4fv (index:GLuint,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4fv.?, .{index,v});
}
pub fn glVertexAttrib4iv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4iv.?, .{index,v});
}
pub fn glVertexAttrib4s (index:GLuint,x:GLshort,y:GLshort,z:GLshort,w:GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4s.?, .{index,x,y,z,w});
}
pub fn glVertexAttrib4sv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4sv.?, .{index,v});
}
pub fn glVertexAttrib4ubv (index:GLuint,v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4ubv.?, .{index,v});
}
pub fn glVertexAttrib4uiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4uiv.?, .{index,v});
}
pub fn glVertexAttrib4usv (index:GLuint,v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttrib4usv.?, .{index,v});
}
pub fn glVertexAttribPointer (index:GLuint,size:GLint,@"type":VertexAttribPointerType,normalized:GLboolean,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribPointer.?, .{index,size,@"type",normalized,stride,pointer});
}
pub fn glUniformMatrix2x3fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2x3fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3x2fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3x2fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix2x4fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2x4fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4x2fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4x2fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3x4fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3x4fv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4x3fv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4x3fv.?, .{location,count,transpose,value});
}
pub fn glColorMaski (index:GLuint,r:GLboolean,g:GLboolean,b:GLboolean,a:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorMaski.?, .{index,r,g,b,a});
}
pub fn glGetBooleani_v (target:BufferTargetARB,index:GLuint,data:[*c]GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBooleani_v.?, .{target,index,data});
}
pub fn glGetIntegeri_v (target:GetPName,index:GLuint,data:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetIntegeri_v.?, .{target,index,data});
}
pub fn glEnablei (target:EnableCap,index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnablei.?, .{target,index});
}
pub fn glDisablei (target:EnableCap,index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDisablei.?, .{target,index});
}
pub fn glIsEnabledi (target:EnableCap,index:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsEnabledi.?, .{target,index});
}
pub fn glBeginTransformFeedback (primitiveMode:PrimitiveType) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBeginTransformFeedback.?, .{primitiveMode});
}
pub fn glEndTransformFeedback () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEndTransformFeedback.?, .{});
}
pub fn glBindBufferRange (target:BufferTargetARB,index:GLuint,buffer:GLuint,offset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindBufferRange.?, .{target,index,buffer,offset,size});
}
pub fn glBindBufferBase (target:BufferTargetARB,index:GLuint,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindBufferBase.?, .{target,index,buffer});
}
pub fn glTransformFeedbackVaryings (program:GLuint,count:GLsizei,varyings:[*c]const [*c]const GLchar,bufferMode:TransformFeedbackBufferMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTransformFeedbackVaryings.?, .{program,count,varyings,bufferMode});
}
pub fn glGetTransformFeedbackVarying (program:GLuint,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,size:[*c]GLsizei,@"type":AttributeType,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTransformFeedbackVarying.?, .{program,index,bufSize,length,size,@"type",name});
}
pub fn glClampColor (target:ClampColorTargetARB,clamp:ClampColorModeARB) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClampColor.?, .{target,clamp});
}
pub fn glBeginConditionalRender (id:GLuint,mode:ConditionalRenderMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBeginConditionalRender.?, .{id,mode});
}
pub fn glEndConditionalRender () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEndConditionalRender.?, .{});
}
pub fn glVertexAttribIPointer (index:GLuint,size:GLint,@"type":VertexAttribIType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribIPointer.?, .{index,size,@"type",stride,pointer});
}
pub fn glGetVertexAttribIiv (index:GLuint,pname:VertexAttribEnum,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribIiv.?, .{index,pname,params});
}
pub fn glGetVertexAttribIuiv (index:GLuint,pname:VertexAttribEnum,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribIuiv.?, .{index,pname,params});
}
pub fn glVertexAttribI1i (index:GLuint,x:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI1i.?, .{index,x});
}
pub fn glVertexAttribI2i (index:GLuint,x:GLint,y:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI2i.?, .{index,x,y});
}
pub fn glVertexAttribI3i (index:GLuint,x:GLint,y:GLint,z:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI3i.?, .{index,x,y,z});
}
pub fn glVertexAttribI4i (index:GLuint,x:GLint,y:GLint,z:GLint,w:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4i.?, .{index,x,y,z,w});
}
pub fn glVertexAttribI1ui (index:GLuint,x:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI1ui.?, .{index,x});
}
pub fn glVertexAttribI2ui (index:GLuint,x:GLuint,y:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI2ui.?, .{index,x,y});
}
pub fn glVertexAttribI3ui (index:GLuint,x:GLuint,y:GLuint,z:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI3ui.?, .{index,x,y,z});
}
pub fn glVertexAttribI4ui (index:GLuint,x:GLuint,y:GLuint,z:GLuint,w:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4ui.?, .{index,x,y,z,w});
}
pub fn glVertexAttribI1iv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI1iv.?, .{index,v});
}
pub fn glVertexAttribI2iv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI2iv.?, .{index,v});
}
pub fn glVertexAttribI3iv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI3iv.?, .{index,v});
}
pub fn glVertexAttribI4iv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4iv.?, .{index,v});
}
pub fn glVertexAttribI1uiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI1uiv.?, .{index,v});
}
pub fn glVertexAttribI2uiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI2uiv.?, .{index,v});
}
pub fn glVertexAttribI3uiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI3uiv.?, .{index,v});
}
pub fn glVertexAttribI4uiv (index:GLuint,v:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4uiv.?, .{index,v});
}
pub fn glVertexAttribI4bv (index:GLuint,v:[*c]const GLbyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4bv.?, .{index,v});
}
pub fn glVertexAttribI4sv (index:GLuint,v:[*c]const GLshort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4sv.?, .{index,v});
}
pub fn glVertexAttribI4ubv (index:GLuint,v:?[*:0]const GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4ubv.?, .{index,v});
}
pub fn glVertexAttribI4usv (index:GLuint,v:[*c]const GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribI4usv.?, .{index,v});
}
pub fn glGetUniformuiv (program:GLuint,location:GLint,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformuiv.?, .{program,location,params});
}
pub fn glBindFragDataLocation (program:GLuint,color:GLuint,name:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindFragDataLocation.?, .{program,color,name});
}
pub fn glGetFragDataLocation (program:GLuint,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetFragDataLocation.?, .{program,name});
}
pub fn glUniform1ui (location:GLint,v0:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1ui.?, .{location,v0});
}
pub fn glUniform2ui (location:GLint,v0:GLuint,v1:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2ui.?, .{location,v0,v1});
}
pub fn glUniform3ui (location:GLint,v0:GLuint,v1:GLuint,v2:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3ui.?, .{location,v0,v1,v2});
}
pub fn glUniform4ui (location:GLint,v0:GLuint,v1:GLuint,v2:GLuint,v3:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4ui.?, .{location,v0,v1,v2,v3});
}
pub fn glUniform1uiv (location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1uiv.?, .{location,count,value});
}
pub fn glUniform2uiv (location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2uiv.?, .{location,count,value});
}
pub fn glUniform3uiv (location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3uiv.?, .{location,count,value});
}
pub fn glUniform4uiv (location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4uiv.?, .{location,count,value});
}
pub fn glTexParameterIiv (target:TextureTarget,pname:TextureParameterName,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameterIiv.?, .{target,pname,params});
}
pub fn glTexParameterIuiv (target:TextureTarget,pname:TextureParameterName,params:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexParameterIuiv.?, .{target,pname,params});
}
pub fn glGetTexParameterIiv (target:TextureTarget,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexParameterIiv.?, .{target,pname,params});
}
pub fn glGetTexParameterIuiv (target:TextureTarget,pname:GetTextureParameter,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTexParameterIuiv.?, .{target,pname,params});
}
pub fn glClearBufferiv (buffer:Buffer,drawbuffer:GLint,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferiv.?, .{buffer,drawbuffer,value});
}
pub fn glClearBufferuiv (buffer:Buffer,drawbuffer:GLint,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferuiv.?, .{buffer,drawbuffer,value});
}
pub fn glClearBufferfv (buffer:Buffer,drawbuffer:GLint,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferfv.?, .{buffer,drawbuffer,value});
}
pub fn glClearBufferfi (buffer:Buffer,drawbuffer:GLint,depth:GLfloat,stencil:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferfi.?, .{buffer,drawbuffer,depth,stencil});
}
pub fn glGetStringi (name:StringName,index:GLuint) callconv(.C) ?[*:0]const GLubyte {
return @call(.always_tail, current_proc_table.?.glGetStringi.?, .{name,index});
}
pub fn glIsRenderbuffer (renderbuffer:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsRenderbuffer.?, .{renderbuffer});
}
pub fn glBindRenderbuffer (target:RenderbufferTarget,renderbuffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindRenderbuffer.?, .{target,renderbuffer});
}
pub fn glDeleteRenderbuffers (n:GLsizei,renderbuffers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteRenderbuffers.?, .{n,renderbuffers});
}
pub fn glGenRenderbuffers (n:GLsizei,renderbuffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenRenderbuffers.?, .{n,renderbuffers});
}
pub fn glRenderbufferStorage (target:RenderbufferTarget,internalformat:InternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRenderbufferStorage.?, .{target,internalformat,width,height});
}
pub fn glGetRenderbufferParameteriv (target:RenderbufferTarget,pname:RenderbufferParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetRenderbufferParameteriv.?, .{target,pname,params});
}
pub fn glIsFramebuffer (framebuffer:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsFramebuffer.?, .{framebuffer});
}
pub fn glBindFramebuffer (target:FramebufferTarget,framebuffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindFramebuffer.?, .{target,framebuffer});
}
pub fn glDeleteFramebuffers (n:GLsizei,framebuffers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteFramebuffers.?, .{n,framebuffers});
}
pub fn glGenFramebuffers (n:GLsizei,framebuffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenFramebuffers.?, .{n,framebuffers});
}
pub fn glCheckFramebufferStatus (target:FramebufferTarget) callconv(.C) GLenum {
return @call(.always_tail, current_proc_table.?.glCheckFramebufferStatus.?, .{target});
}
pub fn glFramebufferTexture1D (target:FramebufferTarget,attachment:FramebufferAttachment,textarget:TextureTarget,texture:GLuint,level:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferTexture1D.?, .{target,attachment,textarget,texture,level});
}
pub fn glFramebufferTexture2D (target:FramebufferTarget,attachment:FramebufferAttachment,textarget:TextureTarget,texture:GLuint,level:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferTexture2D.?, .{target,attachment,textarget,texture,level});
}
pub fn glFramebufferTexture3D (target:FramebufferTarget,attachment:FramebufferAttachment,textarget:TextureTarget,texture:GLuint,level:GLint,zoffset:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferTexture3D.?, .{target,attachment,textarget,texture,level,zoffset});
}
pub fn glFramebufferRenderbuffer (target:FramebufferTarget,attachment:FramebufferAttachment,renderbuffertarget:RenderbufferTarget,renderbuffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferRenderbuffer.?, .{target,attachment,renderbuffertarget,renderbuffer});
}
pub fn glGetFramebufferAttachmentParameteriv (target:FramebufferTarget,attachment:FramebufferAttachment,pname:FramebufferAttachmentParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetFramebufferAttachmentParameteriv.?, .{target,attachment,pname,params});
}
pub fn glGenerateMipmap (target:TextureTarget) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenerateMipmap.?, .{target});
}
pub fn glBlitFramebuffer (srcX0:GLint,srcY0:GLint,srcX1:GLint,srcY1:GLint,dstX0:GLint,dstY0:GLint,dstX1:GLint,dstY1:GLint,mask:ClearBufferMask,filter:BlitFramebufferFilter) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlitFramebuffer.?, .{srcX0,srcY0,srcX1,srcY1,dstX0,dstY0,dstX1,dstY1,@as(GLbitfield, @bitCast(mask)),filter});
}
pub fn glRenderbufferStorageMultisample (target:RenderbufferTarget,samples:GLsizei,internalformat:InternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glRenderbufferStorageMultisample.?, .{target,samples,internalformat,width,height});
}
pub fn glFramebufferTextureLayer (target:FramebufferTarget,attachment:FramebufferAttachment,texture:GLuint,level:GLint,layer:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferTextureLayer.?, .{target,attachment,texture,level,layer});
}
pub fn glMapBufferRange (target:BufferTargetARB,offset:GLintptr,length:GLsizeiptr,access:MapBufferAccessMask) callconv(.C) ?*anyopaque {
return @call(.always_tail, current_proc_table.?.glMapBufferRange.?, .{target,offset,length,@as(GLbitfield, @bitCast(access))});
}
pub fn glFlushMappedBufferRange (target:BufferTargetARB,offset:GLintptr,length:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFlushMappedBufferRange.?, .{target,offset,length});
}
pub fn glBindVertexArray (array:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindVertexArray.?, .{array});
}
pub fn glDeleteVertexArrays (n:GLsizei,arrays:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteVertexArrays.?, .{n,arrays});
}
pub fn glGenVertexArrays (n:GLsizei,arrays:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenVertexArrays.?, .{n,arrays});
}
pub fn glIsVertexArray (array:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsVertexArray.?, .{array});
}
pub fn glDrawArraysInstanced (mode:PrimitiveType,first:GLint,count:GLsizei,instancecount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawArraysInstanced.?, .{mode,first,count,instancecount});
}
pub fn glDrawElementsInstanced (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,instancecount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsInstanced.?, .{mode,count,@"type",indices,instancecount});
}
pub fn glTexBuffer (target:TextureTarget,internalformat:SizedInternalFormat,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexBuffer.?, .{target,internalformat,buffer});
}
pub fn glPrimitiveRestartIndex (index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPrimitiveRestartIndex.?, .{index});
}
pub fn glCopyBufferSubData (readTarget:CopyBufferSubDataTarget,writeTarget:CopyBufferSubDataTarget,readOffset:GLintptr,writeOffset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyBufferSubData.?, .{readTarget,writeTarget,readOffset,writeOffset,size});
}
pub fn glGetUniformIndices (program:GLuint,uniformCount:GLsizei,uniformNames:[*c]const [*c]const GLchar,uniformIndices:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformIndices.?, .{program,uniformCount,uniformNames,uniformIndices});
}
pub fn glGetActiveUniformsiv (program:GLuint,uniformCount:GLsizei,uniformIndices:[*c]const GLuint,pname:UniformPName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveUniformsiv.?, .{program,uniformCount,uniformIndices,pname,params});
}
pub fn glGetActiveUniformName (program:GLuint,uniformIndex:GLuint,bufSize:GLsizei,length:[*c]GLsizei,uniformName:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveUniformName.?, .{program,uniformIndex,bufSize,length,uniformName});
}
pub fn glGetUniformBlockIndex (program:GLuint,uniformBlockName:[*c]const GLchar) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glGetUniformBlockIndex.?, .{program,uniformBlockName});
}
pub fn glGetActiveUniformBlockiv (program:GLuint,uniformBlockIndex:GLuint,pname:UniformBlockPName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveUniformBlockiv.?, .{program,uniformBlockIndex,pname,params});
}
pub fn glGetActiveUniformBlockName (program:GLuint,uniformBlockIndex:GLuint,bufSize:GLsizei,length:[*c]GLsizei,uniformBlockName:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveUniformBlockName.?, .{program,uniformBlockIndex,bufSize,length,uniformBlockName});
}
pub fn glUniformBlockBinding (program:GLuint,uniformBlockIndex:GLuint,uniformBlockBinding:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformBlockBinding.?, .{program,uniformBlockIndex,uniformBlockBinding});
}
pub fn glDrawElementsBaseVertex (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,basevertex:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsBaseVertex.?, .{mode,count,@"type",indices,basevertex});
}
pub fn glDrawRangeElementsBaseVertex (mode:PrimitiveType,start:GLuint,end:GLuint,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,basevertex:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawRangeElementsBaseVertex.?, .{mode,start,end,count,@"type",indices,basevertex});
}
pub fn glDrawElementsInstancedBaseVertex (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,instancecount:GLsizei,basevertex:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsInstancedBaseVertex.?, .{mode,count,@"type",indices,instancecount,basevertex});
}
pub fn glMultiDrawElementsBaseVertex (mode:PrimitiveType,count:[*c]const GLsizei,@"type":DrawElementsType,indices:[*c]const ?*const anyopaque,drawcount:GLsizei,basevertex:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawElementsBaseVertex.?, .{mode,count,@"type",indices,drawcount,basevertex});
}
pub fn glProvokingVertex (mode:VertexProvokingMode) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProvokingVertex.?, .{mode});
}
pub fn glFenceSync (condition:SyncCondition,flags:SyncBehaviorFlags) callconv(.C) GLsync {
return @call(.always_tail, current_proc_table.?.glFenceSync.?, .{condition,flags});
}
pub fn glIsSync (sync:GLsync) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsSync.?, .{sync});
}
pub fn glDeleteSync (sync:GLsync) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteSync.?, .{sync});
}
pub fn glClientWaitSync (sync:GLsync,flags:SyncObjectMask,timeout:GLuint64) callconv(.C) GLenum {
return @call(.always_tail, current_proc_table.?.glClientWaitSync.?, .{sync,@as(GLbitfield, @bitCast(flags)),timeout});
}
pub fn glWaitSync (sync:GLsync,flags:SyncBehaviorFlags,timeout:GLuint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glWaitSync.?, .{sync,flags,timeout});
}
pub fn glGetInteger64v (pname:GetPName,data:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetInteger64v.?, .{pname,data});
}
pub fn glGetSynciv (sync:GLsync,pname:SyncParameterName,count:GLsizei,length:[*c]GLsizei,values:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetSynciv.?, .{sync,pname,count,length,values});
}
pub fn glGetInteger64i_v (target:GetPName,index:GLuint,data:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetInteger64i_v.?, .{target,index,data});
}
pub fn glGetBufferParameteri64v (target:BufferTargetARB,pname:BufferPNameARB,params:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetBufferParameteri64v.?, .{target,pname,params});
}
pub fn glFramebufferTexture (target:FramebufferTarget,attachment:FramebufferAttachment,texture:GLuint,level:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferTexture.?, .{target,attachment,texture,level});
}
pub fn glTexImage2DMultisample (target:TextureTarget,samples:GLsizei,internalformat:InternalFormat,width:GLsizei,height:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexImage2DMultisample.?, .{target,samples,internalformat,width,height,fixedsamplelocations});
}
pub fn glTexImage3DMultisample (target:TextureTarget,samples:GLsizei,internalformat:InternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexImage3DMultisample.?, .{target,samples,internalformat,width,height,depth,fixedsamplelocations});
}
pub fn glGetMultisamplefv (pname:GetMultisamplePNameNV,index:GLuint,val:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetMultisamplefv.?, .{pname,index,val});
}
pub fn glSampleMaski (maskNumber:GLuint,mask:GLbitfield) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSampleMaski.?, .{maskNumber,mask});
}
pub fn glBindFragDataLocationIndexed (program:GLuint,colorNumber:GLuint,index:GLuint,name:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindFragDataLocationIndexed.?, .{program,colorNumber,index,name});
}
pub fn glGetFragDataIndex (program:GLuint,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetFragDataIndex.?, .{program,name});
}
pub fn glGenSamplers (count:GLsizei,samplers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenSamplers.?, .{count,samplers});
}
pub fn glDeleteSamplers (count:GLsizei,samplers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteSamplers.?, .{count,samplers});
}
pub fn glIsSampler (sampler:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsSampler.?, .{sampler});
}
pub fn glBindSampler (unit:GLuint,sampler:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindSampler.?, .{unit,sampler});
}
pub fn glSamplerParameteri (sampler:GLuint,pname:SamplerParameterI,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameteri.?, .{sampler,pname,param});
}
pub fn glSamplerParameteriv (sampler:GLuint,pname:SamplerParameterI,param:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameteriv.?, .{sampler,pname,param});
}
pub fn glSamplerParameterf (sampler:GLuint,pname:SamplerParameterF,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameterf.?, .{sampler,pname,param});
}
pub fn glSamplerParameterfv (sampler:GLuint,pname:SamplerParameterF,param:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameterfv.?, .{sampler,pname,param});
}
pub fn glSamplerParameterIiv (sampler:GLuint,pname:SamplerParameterI,param:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameterIiv.?, .{sampler,pname,param});
}
pub fn glSamplerParameterIuiv (sampler:GLuint,pname:SamplerParameterI,param:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSamplerParameterIuiv.?, .{sampler,pname,param});
}
pub fn glGetSamplerParameteriv (sampler:GLuint,pname:SamplerParameterI,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetSamplerParameteriv.?, .{sampler,pname,params});
}
pub fn glGetSamplerParameterIiv (sampler:GLuint,pname:SamplerParameterI,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetSamplerParameterIiv.?, .{sampler,pname,params});
}
pub fn glGetSamplerParameterfv (sampler:GLuint,pname:SamplerParameterF,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetSamplerParameterfv.?, .{sampler,pname,params});
}
pub fn glGetSamplerParameterIuiv (sampler:GLuint,pname:SamplerParameterI,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetSamplerParameterIuiv.?, .{sampler,pname,params});
}
pub fn glQueryCounter (id:GLuint,target:QueryCounterTarget) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glQueryCounter.?, .{id,target});
}
pub fn glGetQueryObjecti64v (id:GLuint,pname:QueryObjectParameterName,params:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryObjecti64v.?, .{id,pname,params});
}
pub fn glGetQueryObjectui64v (id:GLuint,pname:QueryObjectParameterName,params:[*c]GLuint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryObjectui64v.?, .{id,pname,params});
}
pub fn glVertexAttribDivisor (index:GLuint,divisor:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribDivisor.?, .{index,divisor});
}
pub fn glVertexAttribP1ui (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP1ui.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP1uiv (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP1uiv.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP2ui (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP2ui.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP2uiv (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP2uiv.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP3ui (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP3ui.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP3uiv (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP3uiv.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP4ui (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP4ui.?, .{index,@"type",normalized,value});
}
pub fn glVertexAttribP4uiv (index:GLuint,@"type":VertexAttribPointerType,normalized:GLboolean,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribP4uiv.?, .{index,@"type",normalized,value});
}
pub fn glVertexP2ui (@"type":VertexPointerType,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP2ui.?, .{@"type",value});
}
pub fn glVertexP2uiv (@"type":VertexPointerType,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP2uiv.?, .{@"type",value});
}
pub fn glVertexP3ui (@"type":VertexPointerType,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP3ui.?, .{@"type",value});
}
pub fn glVertexP3uiv (@"type":VertexPointerType,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP3uiv.?, .{@"type",value});
}
pub fn glVertexP4ui (@"type":VertexPointerType,value:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP4ui.?, .{@"type",value});
}
pub fn glVertexP4uiv (@"type":VertexPointerType,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexP4uiv.?, .{@"type",value});
}
pub fn glTexCoordP1ui (@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP1ui.?, .{@"type",coords});
}
pub fn glTexCoordP1uiv (@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP1uiv.?, .{@"type",coords});
}
pub fn glTexCoordP2ui (@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP2ui.?, .{@"type",coords});
}
pub fn glTexCoordP2uiv (@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP2uiv.?, .{@"type",coords});
}
pub fn glTexCoordP3ui (@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP3ui.?, .{@"type",coords});
}
pub fn glTexCoordP3uiv (@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP3uiv.?, .{@"type",coords});
}
pub fn glTexCoordP4ui (@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP4ui.?, .{@"type",coords});
}
pub fn glTexCoordP4uiv (@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexCoordP4uiv.?, .{@"type",coords});
}
pub fn glMultiTexCoordP1ui (texture:TextureUnit,@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP1ui.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP1uiv (texture:TextureUnit,@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP1uiv.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP2ui (texture:TextureUnit,@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP2ui.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP2uiv (texture:TextureUnit,@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP2uiv.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP3ui (texture:TextureUnit,@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP3ui.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP3uiv (texture:TextureUnit,@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP3uiv.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP4ui (texture:TextureUnit,@"type":TexCoordPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP4ui.?, .{texture,@"type",coords});
}
pub fn glMultiTexCoordP4uiv (texture:TextureUnit,@"type":TexCoordPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiTexCoordP4uiv.?, .{texture,@"type",coords});
}
pub fn glNormalP3ui (@"type":NormalPointerType,coords:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormalP3ui.?, .{@"type",coords});
}
pub fn glNormalP3uiv (@"type":NormalPointerType,coords:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNormalP3uiv.?, .{@"type",coords});
}
pub fn glColorP3ui (@"type":ColorPointerType,color:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorP3ui.?, .{@"type",color});
}
pub fn glColorP3uiv (@"type":ColorPointerType,color:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorP3uiv.?, .{@"type",color});
}
pub fn glColorP4ui (@"type":ColorPointerType,color:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorP4ui.?, .{@"type",color});
}
pub fn glColorP4uiv (@"type":ColorPointerType,color:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glColorP4uiv.?, .{@"type",color});
}
pub fn glSecondaryColorP3ui (@"type":ColorPointerType,color:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColorP3ui.?, .{@"type",color});
}
pub fn glSecondaryColorP3uiv (@"type":ColorPointerType,color:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSecondaryColorP3uiv.?, .{@"type",color});
}
pub fn glMinSampleShading (value:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMinSampleShading.?, .{value});
}
pub fn glBlendEquationi (buf:GLuint,mode:BlendEquationModeEXT) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendEquationi.?, .{buf,mode});
}
pub fn glBlendEquationSeparatei (buf:GLuint,modeRGB:BlendEquationModeEXT,modeAlpha:BlendEquationModeEXT) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendEquationSeparatei.?, .{buf,modeRGB,modeAlpha});
}
pub fn glBlendFunci (buf:GLuint,src:BlendingFactor,dst:BlendingFactor) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendFunci.?, .{buf,src,dst});
}
pub fn glBlendFuncSeparatei (buf:GLuint,srcRGB:BlendingFactor,dstRGB:BlendingFactor,srcAlpha:BlendingFactor,dstAlpha:BlendingFactor) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlendFuncSeparatei.?, .{buf,srcRGB,dstRGB,srcAlpha,dstAlpha});
}
pub fn glDrawArraysIndirect (mode:PrimitiveType,indirect:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawArraysIndirect.?, .{mode,indirect});
}
pub fn glDrawElementsIndirect (mode:PrimitiveType,@"type":DrawElementsType,indirect:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsIndirect.?, .{mode,@"type",indirect});
}
pub fn glUniform1d (location:GLint,x:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1d.?, .{location,x});
}
pub fn glUniform2d (location:GLint,x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2d.?, .{location,x,y});
}
pub fn glUniform3d (location:GLint,x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3d.?, .{location,x,y,z});
}
pub fn glUniform4d (location:GLint,x:GLdouble,y:GLdouble,z:GLdouble,w:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4d.?, .{location,x,y,z,w});
}
pub fn glUniform1dv (location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform1dv.?, .{location,count,value});
}
pub fn glUniform2dv (location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform2dv.?, .{location,count,value});
}
pub fn glUniform3dv (location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform3dv.?, .{location,count,value});
}
pub fn glUniform4dv (location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniform4dv.?, .{location,count,value});
}
pub fn glUniformMatrix2dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix2x3dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2x3dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix2x4dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix2x4dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3x2dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3x2dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix3x4dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix3x4dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4x2dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4x2dv.?, .{location,count,transpose,value});
}
pub fn glUniformMatrix4x3dv (location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformMatrix4x3dv.?, .{location,count,transpose,value});
}
pub fn glGetUniformdv (program:GLuint,location:GLint,params:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformdv.?, .{program,location,params});
}
pub fn glGetSubroutineUniformLocation (program:GLuint,shadertype:ShaderType,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetSubroutineUniformLocation.?, .{program,shadertype,name});
}
pub fn glGetSubroutineIndex (program:GLuint,shadertype:ShaderType,name:[*c]const GLchar) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glGetSubroutineIndex.?, .{program,shadertype,name});
}
pub fn glGetActiveSubroutineUniformiv (program:GLuint,shadertype:ShaderType,index:GLuint,pname:SubroutineParameterName,values:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveSubroutineUniformiv.?, .{program,shadertype,index,pname,values});
}
pub fn glGetActiveSubroutineUniformName (program:GLuint,shadertype:ShaderType,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveSubroutineUniformName.?, .{program,shadertype,index,bufSize,length,name});
}
pub fn glGetActiveSubroutineName (program:GLuint,shadertype:ShaderType,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveSubroutineName.?, .{program,shadertype,index,bufSize,length,name});
}
pub fn glUniformSubroutinesuiv (shadertype:ShaderType,count:GLsizei,indices:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUniformSubroutinesuiv.?, .{shadertype,count,indices});
}
pub fn glGetUniformSubroutineuiv (shadertype:ShaderType,location:GLint,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetUniformSubroutineuiv.?, .{shadertype,location,params});
}
pub fn glGetProgramStageiv (program:GLuint,shadertype:ShaderType,pname:ProgramStagePName,values:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramStageiv.?, .{program,shadertype,pname,values});
}
pub fn glPatchParameteri (pname:PatchParameterName,value:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPatchParameteri.?, .{pname,value});
}
pub fn glPatchParameterfv (pname:PatchParameterName,values:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPatchParameterfv.?, .{pname,values});
}
pub fn glBindTransformFeedback (target:BindTransformFeedbackTarget,id:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindTransformFeedback.?, .{target,id});
}
pub fn glDeleteTransformFeedbacks (n:GLsizei,ids:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteTransformFeedbacks.?, .{n,ids});
}
pub fn glGenTransformFeedbacks (n:GLsizei,ids:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenTransformFeedbacks.?, .{n,ids});
}
pub fn glIsTransformFeedback (id:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsTransformFeedback.?, .{id});
}
pub fn glPauseTransformFeedback () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPauseTransformFeedback.?, .{});
}
pub fn glResumeTransformFeedback () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glResumeTransformFeedback.?, .{});
}
pub fn glDrawTransformFeedback (mode:PrimitiveType,id:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawTransformFeedback.?, .{mode,id});
}
pub fn glDrawTransformFeedbackStream (mode:PrimitiveType,id:GLuint,stream:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawTransformFeedbackStream.?, .{mode,id,stream});
}
pub fn glBeginQueryIndexed (target:QueryTarget,index:GLuint,id:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBeginQueryIndexed.?, .{target,index,id});
}
pub fn glEndQueryIndexed (target:QueryTarget,index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEndQueryIndexed.?, .{target,index});
}
pub fn glGetQueryIndexediv (target:QueryTarget,index:GLuint,pname:QueryParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryIndexediv.?, .{target,index,pname,params});
}
pub fn glReleaseShaderCompiler () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glReleaseShaderCompiler.?, .{});
}
pub fn glShaderBinary (count:GLsizei,shaders:[*c]const GLuint,binaryFormat:ShaderBinaryFormat,binary:?*const anyopaque,length:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glShaderBinary.?, .{count,shaders,binaryFormat,binary,length});
}
pub fn glGetShaderPrecisionFormat (shadertype:ShaderType,precisiontype:PrecisionType,range:[*c]GLint,precision:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetShaderPrecisionFormat.?, .{shadertype,precisiontype,range,precision});
}
pub fn glDepthRangef (n:GLfloat,f:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthRangef.?, .{n,f});
}
pub fn glClearDepthf (d:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearDepthf.?, .{d});
}
pub fn glGetProgramBinary (program:GLuint,bufSize:GLsizei,length:[*c]GLsizei,binaryFormat:[*c]GLenum,binary:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramBinary.?, .{program,bufSize,length,binaryFormat,binary});
}
pub fn glProgramBinary (program:GLuint,binaryFormat:GLenum,binary:?*const anyopaque,length:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramBinary.?, .{program,binaryFormat,binary,length});
}
pub fn glProgramParameteri (program:GLuint,pname:ProgramParameterPName,value:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramParameteri.?, .{program,pname,value});
}
pub fn glUseProgramStages (pipeline:GLuint,stages:UseProgramStageMask,program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glUseProgramStages.?, .{pipeline,@as(GLbitfield, @bitCast(stages)),program});
}
pub fn glActiveShaderProgram (pipeline:GLuint,program:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glActiveShaderProgram.?, .{pipeline,program});
}
pub fn glCreateShaderProgramv (@"type":ShaderType,count:GLsizei,strings:[*c]const [*c]const GLchar) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glCreateShaderProgramv.?, .{@"type",count,strings});
}
pub fn glBindProgramPipeline (pipeline:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindProgramPipeline.?, .{pipeline});
}
pub fn glDeleteProgramPipelines (n:GLsizei,pipelines:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDeleteProgramPipelines.?, .{n,pipelines});
}
pub fn glGenProgramPipelines (n:GLsizei,pipelines:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenProgramPipelines.?, .{n,pipelines});
}
pub fn glIsProgramPipeline (pipeline:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glIsProgramPipeline.?, .{pipeline});
}
pub fn glGetProgramPipelineiv (pipeline:GLuint,pname:PipelineParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramPipelineiv.?, .{pipeline,pname,params});
}
pub fn glProgramUniform1i (program:GLuint,location:GLint,v0:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1i.?, .{program,location,v0});
}
pub fn glProgramUniform1iv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1iv.?, .{program,location,count,value});
}
pub fn glProgramUniform1f (program:GLuint,location:GLint,v0:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1f.?, .{program,location,v0});
}
pub fn glProgramUniform1fv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1fv.?, .{program,location,count,value});
}
pub fn glProgramUniform1d (program:GLuint,location:GLint,v0:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1d.?, .{program,location,v0});
}
pub fn glProgramUniform1dv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1dv.?, .{program,location,count,value});
}
pub fn glProgramUniform1ui (program:GLuint,location:GLint,v0:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1ui.?, .{program,location,v0});
}
pub fn glProgramUniform1uiv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform1uiv.?, .{program,location,count,value});
}
pub fn glProgramUniform2i (program:GLuint,location:GLint,v0:GLint,v1:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2i.?, .{program,location,v0,v1});
}
pub fn glProgramUniform2iv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2iv.?, .{program,location,count,value});
}
pub fn glProgramUniform2f (program:GLuint,location:GLint,v0:GLfloat,v1:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2f.?, .{program,location,v0,v1});
}
pub fn glProgramUniform2fv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2fv.?, .{program,location,count,value});
}
pub fn glProgramUniform2d (program:GLuint,location:GLint,v0:GLdouble,v1:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2d.?, .{program,location,v0,v1});
}
pub fn glProgramUniform2dv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2dv.?, .{program,location,count,value});
}
pub fn glProgramUniform2ui (program:GLuint,location:GLint,v0:GLuint,v1:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2ui.?, .{program,location,v0,v1});
}
pub fn glProgramUniform2uiv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform2uiv.?, .{program,location,count,value});
}
pub fn glProgramUniform3i (program:GLuint,location:GLint,v0:GLint,v1:GLint,v2:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3i.?, .{program,location,v0,v1,v2});
}
pub fn glProgramUniform3iv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3iv.?, .{program,location,count,value});
}
pub fn glProgramUniform3f (program:GLuint,location:GLint,v0:GLfloat,v1:GLfloat,v2:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3f.?, .{program,location,v0,v1,v2});
}
pub fn glProgramUniform3fv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3fv.?, .{program,location,count,value});
}
pub fn glProgramUniform3d (program:GLuint,location:GLint,v0:GLdouble,v1:GLdouble,v2:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3d.?, .{program,location,v0,v1,v2});
}
pub fn glProgramUniform3dv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3dv.?, .{program,location,count,value});
}
pub fn glProgramUniform3ui (program:GLuint,location:GLint,v0:GLuint,v1:GLuint,v2:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3ui.?, .{program,location,v0,v1,v2});
}
pub fn glProgramUniform3uiv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform3uiv.?, .{program,location,count,value});
}
pub fn glProgramUniform4i (program:GLuint,location:GLint,v0:GLint,v1:GLint,v2:GLint,v3:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4i.?, .{program,location,v0,v1,v2,v3});
}
pub fn glProgramUniform4iv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4iv.?, .{program,location,count,value});
}
pub fn glProgramUniform4f (program:GLuint,location:GLint,v0:GLfloat,v1:GLfloat,v2:GLfloat,v3:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4f.?, .{program,location,v0,v1,v2,v3});
}
pub fn glProgramUniform4fv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4fv.?, .{program,location,count,value});
}
pub fn glProgramUniform4d (program:GLuint,location:GLint,v0:GLdouble,v1:GLdouble,v2:GLdouble,v3:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4d.?, .{program,location,v0,v1,v2,v3});
}
pub fn glProgramUniform4dv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4dv.?, .{program,location,count,value});
}
pub fn glProgramUniform4ui (program:GLuint,location:GLint,v0:GLuint,v1:GLuint,v2:GLuint,v3:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4ui.?, .{program,location,v0,v1,v2,v3});
}
pub fn glProgramUniform4uiv (program:GLuint,location:GLint,count:GLsizei,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniform4uiv.?, .{program,location,count,value});
}
pub fn glProgramUniformMatrix2fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix2dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix2x3fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2x3fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3x2fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3x2fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix2x4fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2x4fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4x2fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4x2fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3x4fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3x4fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4x3fv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4x3fv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix2x3dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2x3dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3x2dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3x2dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix2x4dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix2x4dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4x2dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4x2dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix3x4dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix3x4dv.?, .{program,location,count,transpose,value});
}
pub fn glProgramUniformMatrix4x3dv (program:GLuint,location:GLint,count:GLsizei,transpose:GLboolean,value:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glProgramUniformMatrix4x3dv.?, .{program,location,count,transpose,value});
}
pub fn glValidateProgramPipeline (pipeline:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glValidateProgramPipeline.?, .{pipeline});
}
pub fn glGetProgramPipelineInfoLog (pipeline:GLuint,bufSize:GLsizei,length:[*c]GLsizei,infoLog:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramPipelineInfoLog.?, .{pipeline,bufSize,length,infoLog});
}
pub fn glVertexAttribL1d (index:GLuint,x:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL1d.?, .{index,x});
}
pub fn glVertexAttribL2d (index:GLuint,x:GLdouble,y:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL2d.?, .{index,x,y});
}
pub fn glVertexAttribL3d (index:GLuint,x:GLdouble,y:GLdouble,z:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL3d.?, .{index,x,y,z});
}
pub fn glVertexAttribL4d (index:GLuint,x:GLdouble,y:GLdouble,z:GLdouble,w:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL4d.?, .{index,x,y,z,w});
}
pub fn glVertexAttribL1dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL1dv.?, .{index,v});
}
pub fn glVertexAttribL2dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL2dv.?, .{index,v});
}
pub fn glVertexAttribL3dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL3dv.?, .{index,v});
}
pub fn glVertexAttribL4dv (index:GLuint,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribL4dv.?, .{index,v});
}
pub fn glVertexAttribLPointer (index:GLuint,size:GLint,@"type":VertexAttribLType,stride:GLsizei,pointer:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribLPointer.?, .{index,size,@"type",stride,pointer});
}
pub fn glGetVertexAttribLdv (index:GLuint,pname:VertexAttribEnum,params:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexAttribLdv.?, .{index,pname,params});
}
pub fn glViewportArrayv (first:GLuint,count:GLsizei,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glViewportArrayv.?, .{first,count,v});
}
pub fn glViewportIndexedf (index:GLuint,x:GLfloat,y:GLfloat,w:GLfloat,h:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glViewportIndexedf.?, .{index,x,y,w,h});
}
pub fn glViewportIndexedfv (index:GLuint,v:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glViewportIndexedfv.?, .{index,v});
}
pub fn glScissorArrayv (first:GLuint,count:GLsizei,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScissorArrayv.?, .{first,count,v});
}
pub fn glScissorIndexed (index:GLuint,left:GLint,bottom:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScissorIndexed.?, .{index,left,bottom,width,height});
}
pub fn glScissorIndexedv (index:GLuint,v:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glScissorIndexedv.?, .{index,v});
}
pub fn glDepthRangeArrayv (first:GLuint,count:GLsizei,v:[*c]const GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthRangeArrayv.?, .{first,count,v});
}
pub fn glDepthRangeIndexed (index:GLuint,n:GLdouble,f:GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDepthRangeIndexed.?, .{index,n,f});
}
pub fn glGetFloati_v (target:GetPName,index:GLuint,data:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetFloati_v.?, .{target,index,data});
}
pub fn glGetDoublei_v (target:GetPName,index:GLuint,data:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetDoublei_v.?, .{target,index,data});
}
pub fn glDrawArraysInstancedBaseInstance (mode:PrimitiveType,first:GLint,count:GLsizei,instancecount:GLsizei,baseinstance:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawArraysInstancedBaseInstance.?, .{mode,first,count,instancecount,baseinstance});
}
pub fn glDrawElementsInstancedBaseInstance (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,instancecount:GLsizei,baseinstance:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsInstancedBaseInstance.?, .{mode,count,@"type",indices,instancecount,baseinstance});
}
pub fn glDrawElementsInstancedBaseVertexBaseInstance (mode:PrimitiveType,count:GLsizei,@"type":DrawElementsType,indices:?*const anyopaque,instancecount:GLsizei,basevertex:GLint,baseinstance:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawElementsInstancedBaseVertexBaseInstance.?, .{mode,count,@"type",indices,instancecount,basevertex,baseinstance});
}
pub fn glGetInternalformativ (target:TextureTarget,internalformat:InternalFormat,pname:InternalFormatPName,count:GLsizei,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetInternalformativ.?, .{target,internalformat,pname,count,params});
}
pub fn glGetActiveAtomicCounterBufferiv (program:GLuint,bufferIndex:GLuint,pname:AtomicCounterBufferPName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetActiveAtomicCounterBufferiv.?, .{program,bufferIndex,pname,params});
}
pub fn glBindImageTexture (unit:GLuint,texture:GLuint,level:GLint,layered:GLboolean,layer:GLint,access:BufferAccessARB,format:InternalFormat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindImageTexture.?, .{unit,texture,level,layered,layer,access,format});
}
pub fn glMemoryBarrier (barriers:MemoryBarrierMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMemoryBarrier.?, .{@as(GLbitfield, @bitCast(barriers))});
}
pub fn glTexStorage1D (target:TextureTarget,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexStorage1D.?, .{target,levels,internalformat,width});
}
pub fn glTexStorage2D (target:TextureTarget,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexStorage2D.?, .{target,levels,internalformat,width,height});
}
pub fn glTexStorage3D (target:TextureTarget,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexStorage3D.?, .{target,levels,internalformat,width,height,depth});
}
pub fn glDrawTransformFeedbackInstanced (mode:PrimitiveType,id:GLuint,instancecount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawTransformFeedbackInstanced.?, .{mode,id,instancecount});
}
pub fn glDrawTransformFeedbackStreamInstanced (mode:PrimitiveType,id:GLuint,stream:GLuint,instancecount:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDrawTransformFeedbackStreamInstanced.?, .{mode,id,stream,instancecount});
}
pub fn glClearBufferData (target:BufferStorageTarget,internalformat:SizedInternalFormat,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferData.?, .{target,internalformat,format,@"type",data});
}
pub fn glClearBufferSubData (target:BufferTargetARB,internalformat:SizedInternalFormat,offset:GLintptr,size:GLsizeiptr,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearBufferSubData.?, .{target,internalformat,offset,size,format,@"type",data});
}
pub fn glDispatchCompute (num_groups_x:GLuint,num_groups_y:GLuint,num_groups_z:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDispatchCompute.?, .{num_groups_x,num_groups_y,num_groups_z});
}
pub fn glDispatchComputeIndirect (indirect:GLintptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDispatchComputeIndirect.?, .{indirect});
}
pub fn glCopyImageSubData (srcName:GLuint,srcTarget:CopyImageSubDataTarget,srcLevel:GLint,srcX:GLint,srcY:GLint,srcZ:GLint,dstName:GLuint,dstTarget:CopyImageSubDataTarget,dstLevel:GLint,dstX:GLint,dstY:GLint,dstZ:GLint,srcWidth:GLsizei,srcHeight:GLsizei,srcDepth:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyImageSubData.?, .{srcName,srcTarget,srcLevel,srcX,srcY,srcZ,dstName,dstTarget,dstLevel,dstX,dstY,dstZ,srcWidth,srcHeight,srcDepth});
}
pub fn glFramebufferParameteri (target:FramebufferTarget,pname:FramebufferParameterName,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFramebufferParameteri.?, .{target,pname,param});
}
pub fn glGetFramebufferParameteriv (target:FramebufferTarget,pname:FramebufferAttachmentParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetFramebufferParameteriv.?, .{target,pname,params});
}
pub fn glGetInternalformati64v (target:TextureTarget,internalformat:InternalFormat,pname:InternalFormatPName,count:GLsizei,params:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetInternalformati64v.?, .{target,internalformat,pname,count,params});
}
pub fn glInvalidateTexSubImage (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateTexSubImage.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth});
}
pub fn glInvalidateTexImage (texture:GLuint,level:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateTexImage.?, .{texture,level});
}
pub fn glInvalidateBufferSubData (buffer:GLuint,offset:GLintptr,length:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateBufferSubData.?, .{buffer,offset,length});
}
pub fn glInvalidateBufferData (buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateBufferData.?, .{buffer});
}
pub fn glInvalidateFramebuffer (target:FramebufferTarget,numAttachments:GLsizei,attachments:InvalidateFramebufferAttachment) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateFramebuffer.?, .{target,numAttachments,attachments});
}
pub fn glInvalidateSubFramebuffer (target:FramebufferTarget,numAttachments:GLsizei,attachments:InvalidateFramebufferAttachment,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateSubFramebuffer.?, .{target,numAttachments,attachments,x,y,width,height});
}
pub fn glMultiDrawArraysIndirect (mode:PrimitiveType,indirect:?*const anyopaque,drawcount:GLsizei,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawArraysIndirect.?, .{mode,indirect,drawcount,stride});
}
pub fn glMultiDrawElementsIndirect (mode:PrimitiveType,@"type":DrawElementsType,indirect:?*const anyopaque,drawcount:GLsizei,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawElementsIndirect.?, .{mode,@"type",indirect,drawcount,stride});
}
pub fn glGetProgramInterfaceiv (program:GLuint,programInterface:ProgramInterface,pname:ProgramInterfacePName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramInterfaceiv.?, .{program,programInterface,pname,params});
}
pub fn glGetProgramResourceIndex (program:GLuint,programInterface:ProgramInterface,name:[*c]const GLchar) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glGetProgramResourceIndex.?, .{program,programInterface,name});
}
pub fn glGetProgramResourceName (program:GLuint,programInterface:ProgramInterface,index:GLuint,bufSize:GLsizei,length:[*c]GLsizei,name:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramResourceName.?, .{program,programInterface,index,bufSize,length,name});
}
pub fn glGetProgramResourceiv (program:GLuint,programInterface:ProgramInterface,index:GLuint,propCount:GLsizei,props:ProgramResourceProperty,count:GLsizei,length:[*c]GLsizei,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetProgramResourceiv.?, .{program,programInterface,index,propCount,props,count,length,params});
}
pub fn glGetProgramResourceLocation (program:GLuint,programInterface:ProgramInterface,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetProgramResourceLocation.?, .{program,programInterface,name});
}
pub fn glGetProgramResourceLocationIndex (program:GLuint,programInterface:ProgramInterface,name:[*c]const GLchar) callconv(.C) GLint {
return @call(.always_tail, current_proc_table.?.glGetProgramResourceLocationIndex.?, .{program,programInterface,name});
}
pub fn glShaderStorageBlockBinding (program:GLuint,storageBlockIndex:GLuint,storageBlockBinding:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glShaderStorageBlockBinding.?, .{program,storageBlockIndex,storageBlockBinding});
}
pub fn glTexBufferRange (target:TextureTarget,internalformat:SizedInternalFormat,buffer:GLuint,offset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexBufferRange.?, .{target,internalformat,buffer,offset,size});
}
pub fn glTexStorage2DMultisample (target:TextureTarget,samples:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexStorage2DMultisample.?, .{target,samples,internalformat,width,height,fixedsamplelocations});
}
pub fn glTexStorage3DMultisample (target:TextureTarget,samples:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTexStorage3DMultisample.?, .{target,samples,internalformat,width,height,depth,fixedsamplelocations});
}
pub fn glTextureView (texture:GLuint,target:TextureTarget,origtexture:GLuint,internalformat:SizedInternalFormat,minlevel:GLuint,numlevels:GLuint,minlayer:GLuint,numlayers:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureView.?, .{texture,target,origtexture,internalformat,minlevel,numlevels,minlayer,numlayers});
}
pub fn glBindVertexBuffer (bindingindex:GLuint,buffer:GLuint,offset:GLintptr,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindVertexBuffer.?, .{bindingindex,buffer,offset,stride});
}
pub fn glVertexAttribFormat (attribindex:GLuint,size:GLint,@"type":VertexAttribType,normalized:GLboolean,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribFormat.?, .{attribindex,size,@"type",normalized,relativeoffset});
}
pub fn glVertexAttribIFormat (attribindex:GLuint,size:GLint,@"type":VertexAttribIType,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribIFormat.?, .{attribindex,size,@"type",relativeoffset});
}
pub fn glVertexAttribLFormat (attribindex:GLuint,size:GLint,@"type":VertexAttribLType,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribLFormat.?, .{attribindex,size,@"type",relativeoffset});
}
pub fn glVertexAttribBinding (attribindex:GLuint,bindingindex:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexAttribBinding.?, .{attribindex,bindingindex});
}
pub fn glVertexBindingDivisor (bindingindex:GLuint,divisor:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexBindingDivisor.?, .{bindingindex,divisor});
}
pub fn glDebugMessageControl (source:DebugSource,@"type":DebugType,severity:DebugSeverity,count:GLsizei,ids:[*c]const GLuint,enabled:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDebugMessageControl.?, .{source,@"type",severity,count,ids,enabled});
}
pub fn glDebugMessageInsert (source:DebugSource,@"type":DebugType,id:GLuint,severity:DebugSeverity,length:GLsizei,buf:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDebugMessageInsert.?, .{source,@"type",id,severity,length,buf});
}
pub fn glDebugMessageCallback (callback:GLDEBUGPROC,userParam:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDebugMessageCallback.?, .{callback,userParam});
}
pub fn glGetDebugMessageLog (count:GLuint,bufSize:GLsizei,sources:DebugSource,types:DebugType,ids:[*c]GLuint,severities:DebugSeverity,lengths:[*c]GLsizei,messageLog:[*c]GLchar) callconv(.C) GLuint {
return @call(.always_tail, current_proc_table.?.glGetDebugMessageLog.?, .{count,bufSize,sources,types,ids,severities,lengths,messageLog});
}
pub fn glPushDebugGroup (source:DebugSource,id:GLuint,length:GLsizei,message:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPushDebugGroup.?, .{source,id,length,message});
}
pub fn glPopDebugGroup () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPopDebugGroup.?, .{});
}
pub fn glObjectLabel (identifier:ObjectIdentifier,name:GLuint,length:GLsizei,label:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glObjectLabel.?, .{identifier,name,length,label});
}
pub fn glGetObjectLabel (identifier:ObjectIdentifier,name:GLuint,bufSize:GLsizei,length:[*c]GLsizei,label:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetObjectLabel.?, .{identifier,name,bufSize,length,label});
}
pub fn glObjectPtrLabel (ptr:?*const anyopaque,length:GLsizei,label:[*c]const GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glObjectPtrLabel.?, .{ptr,length,label});
}
pub fn glGetObjectPtrLabel (ptr:?*const anyopaque,bufSize:GLsizei,length:[*c]GLsizei,label:[*c]GLchar) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetObjectPtrLabel.?, .{ptr,bufSize,length,label});
}
pub fn glBufferStorage (target:BufferStorageTarget,size:GLsizeiptr,data:?*const anyopaque,flags:BufferStorageMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBufferStorage.?, .{target,size,data,@as(GLbitfield, @bitCast(flags))});
}
pub fn glClearTexImage (texture:GLuint,level:GLint,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearTexImage.?, .{texture,level,format,@"type",data});
}
pub fn glClearTexSubImage (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearTexSubImage.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth,format,@"type",data});
}
pub fn glBindBuffersBase (target:BufferTargetARB,first:GLuint,count:GLsizei,buffers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindBuffersBase.?, .{target,first,count,buffers});
}
pub fn glBindBuffersRange (target:BufferTargetARB,first:GLuint,count:GLsizei,buffers:[*c]const GLuint,offsets:[*c]const GLintptr,sizes:[*c]const GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindBuffersRange.?, .{target,first,count,buffers,offsets,sizes});
}
pub fn glBindTextures (first:GLuint,count:GLsizei,textures:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindTextures.?, .{first,count,textures});
}
pub fn glBindSamplers (first:GLuint,count:GLsizei,samplers:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindSamplers.?, .{first,count,samplers});
}
pub fn glBindImageTextures (first:GLuint,count:GLsizei,textures:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindImageTextures.?, .{first,count,textures});
}
pub fn glBindVertexBuffers (first:GLuint,count:GLsizei,buffers:[*c]const GLuint,offsets:[*c]const GLintptr,strides:[*c]const GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindVertexBuffers.?, .{first,count,buffers,offsets,strides});
}
pub fn glClipControl (origin:ClipControlOrigin,depth:ClipControlDepth) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClipControl.?, .{origin,depth});
}
pub fn glCreateTransformFeedbacks (n:GLsizei,ids:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateTransformFeedbacks.?, .{n,ids});
}
pub fn glTransformFeedbackBufferBase (xfb:GLuint,index:GLuint,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTransformFeedbackBufferBase.?, .{xfb,index,buffer});
}
pub fn glTransformFeedbackBufferRange (xfb:GLuint,index:GLuint,buffer:GLuint,offset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTransformFeedbackBufferRange.?, .{xfb,index,buffer,offset,size});
}
pub fn glGetTransformFeedbackiv (xfb:GLuint,pname:TransformFeedbackPName,param:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTransformFeedbackiv.?, .{xfb,pname,param});
}
pub fn glGetTransformFeedbacki_v (xfb:GLuint,pname:TransformFeedbackPName,index:GLuint,param:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTransformFeedbacki_v.?, .{xfb,pname,index,param});
}
pub fn glGetTransformFeedbacki64_v (xfb:GLuint,pname:TransformFeedbackPName,index:GLuint,param:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTransformFeedbacki64_v.?, .{xfb,pname,index,param});
}
pub fn glCreateBuffers (n:GLsizei,buffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateBuffers.?, .{n,buffers});
}
pub fn glNamedBufferStorage (buffer:GLuint,size:GLsizeiptr,data:?*const anyopaque,flags:BufferStorageMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedBufferStorage.?, .{buffer,size,data,@as(GLbitfield, @bitCast(flags))});
}
pub fn glNamedBufferData (buffer:GLuint,size:GLsizeiptr,data:?*const anyopaque,usage:VertexBufferObjectUsage) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedBufferData.?, .{buffer,size,data,usage});
}
pub fn glNamedBufferSubData (buffer:GLuint,offset:GLintptr,size:GLsizeiptr,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedBufferSubData.?, .{buffer,offset,size,data});
}
pub fn glCopyNamedBufferSubData (readBuffer:GLuint,writeBuffer:GLuint,readOffset:GLintptr,writeOffset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyNamedBufferSubData.?, .{readBuffer,writeBuffer,readOffset,writeOffset,size});
}
pub fn glClearNamedBufferData (buffer:GLuint,internalformat:SizedInternalFormat,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedBufferData.?, .{buffer,internalformat,format,@"type",data});
}
pub fn glClearNamedBufferSubData (buffer:GLuint,internalformat:SizedInternalFormat,offset:GLintptr,size:GLsizeiptr,format:PixelFormat,@"type":PixelType,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedBufferSubData.?, .{buffer,internalformat,offset,size,format,@"type",data});
}
pub fn glMapNamedBuffer (buffer:GLuint,access:BufferAccessARB) callconv(.C) ?*anyopaque {
return @call(.always_tail, current_proc_table.?.glMapNamedBuffer.?, .{buffer,access});
}
pub fn glMapNamedBufferRange (buffer:GLuint,offset:GLintptr,length:GLsizeiptr,access:MapBufferAccessMask) callconv(.C) ?*anyopaque {
return @call(.always_tail, current_proc_table.?.glMapNamedBufferRange.?, .{buffer,offset,length,@as(GLbitfield, @bitCast(access))});
}
pub fn glUnmapNamedBuffer (buffer:GLuint) callconv(.C) GLboolean {
return @call(.always_tail, current_proc_table.?.glUnmapNamedBuffer.?, .{buffer});
}
pub fn glFlushMappedNamedBufferRange (buffer:GLuint,offset:GLintptr,length:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glFlushMappedNamedBufferRange.?, .{buffer,offset,length});
}
pub fn glGetNamedBufferParameteriv (buffer:GLuint,pname:BufferPNameARB,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedBufferParameteriv.?, .{buffer,pname,params});
}
pub fn glGetNamedBufferParameteri64v (buffer:GLuint,pname:BufferPNameARB,params:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedBufferParameteri64v.?, .{buffer,pname,params});
}
pub fn glGetNamedBufferPointerv (buffer:GLuint,pname:BufferPointerNameARB,params:[*c]?*?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedBufferPointerv.?, .{buffer,pname,params});
}
pub fn glGetNamedBufferSubData (buffer:GLuint,offset:GLintptr,size:GLsizeiptr,data:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedBufferSubData.?, .{buffer,offset,size,data});
}
pub fn glCreateFramebuffers (n:GLsizei,framebuffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateFramebuffers.?, .{n,framebuffers});
}
pub fn glNamedFramebufferRenderbuffer (framebuffer:GLuint,attachment:FramebufferAttachment,renderbuffertarget:RenderbufferTarget,renderbuffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferRenderbuffer.?, .{framebuffer,attachment,renderbuffertarget,renderbuffer});
}
pub fn glNamedFramebufferParameteri (framebuffer:GLuint,pname:FramebufferParameterName,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferParameteri.?, .{framebuffer,pname,param});
}
pub fn glNamedFramebufferTexture (framebuffer:GLuint,attachment:FramebufferAttachment,texture:GLuint,level:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferTexture.?, .{framebuffer,attachment,texture,level});
}
pub fn glNamedFramebufferTextureLayer (framebuffer:GLuint,attachment:FramebufferAttachment,texture:GLuint,level:GLint,layer:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferTextureLayer.?, .{framebuffer,attachment,texture,level,layer});
}
pub fn glNamedFramebufferDrawBuffer (framebuffer:GLuint,buf:ColorBuffer) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferDrawBuffer.?, .{framebuffer,buf});
}
pub fn glNamedFramebufferDrawBuffers (framebuffer:GLuint,n:GLsizei,bufs:ColorBuffer) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferDrawBuffers.?, .{framebuffer,n,bufs});
}
pub fn glNamedFramebufferReadBuffer (framebuffer:GLuint,src:ColorBuffer) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedFramebufferReadBuffer.?, .{framebuffer,src});
}
pub fn glInvalidateNamedFramebufferData (framebuffer:GLuint,numAttachments:GLsizei,attachments:FramebufferAttachment) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateNamedFramebufferData.?, .{framebuffer,numAttachments,attachments});
}
pub fn glInvalidateNamedFramebufferSubData (framebuffer:GLuint,numAttachments:GLsizei,attachments:FramebufferAttachment,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glInvalidateNamedFramebufferSubData.?, .{framebuffer,numAttachments,attachments,x,y,width,height});
}
pub fn glClearNamedFramebufferiv (framebuffer:GLuint,buffer:Buffer,drawbuffer:GLint,value:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedFramebufferiv.?, .{framebuffer,buffer,drawbuffer,value});
}
pub fn glClearNamedFramebufferuiv (framebuffer:GLuint,buffer:Buffer,drawbuffer:GLint,value:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedFramebufferuiv.?, .{framebuffer,buffer,drawbuffer,value});
}
pub fn glClearNamedFramebufferfv (framebuffer:GLuint,buffer:Buffer,drawbuffer:GLint,value:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedFramebufferfv.?, .{framebuffer,buffer,drawbuffer,value});
}
pub fn glClearNamedFramebufferfi (framebuffer:GLuint,buffer:Buffer,drawbuffer:GLint,depth:GLfloat,stencil:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glClearNamedFramebufferfi.?, .{framebuffer,buffer,drawbuffer,depth,stencil});
}
pub fn glBlitNamedFramebuffer (readFramebuffer:GLuint,drawFramebuffer:GLuint,srcX0:GLint,srcY0:GLint,srcX1:GLint,srcY1:GLint,dstX0:GLint,dstY0:GLint,dstX1:GLint,dstY1:GLint,mask:ClearBufferMask,filter:BlitFramebufferFilter) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBlitNamedFramebuffer.?, .{readFramebuffer,drawFramebuffer,srcX0,srcY0,srcX1,srcY1,dstX0,dstY0,dstX1,dstY1,@as(GLbitfield, @bitCast(mask)),filter});
}
pub fn glCheckNamedFramebufferStatus (framebuffer:GLuint,target:FramebufferTarget) callconv(.C) GLenum {
return @call(.always_tail, current_proc_table.?.glCheckNamedFramebufferStatus.?, .{framebuffer,target});
}
pub fn glGetNamedFramebufferParameteriv (framebuffer:GLuint,pname:GetFramebufferParameter,param:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedFramebufferParameteriv.?, .{framebuffer,pname,param});
}
pub fn glGetNamedFramebufferAttachmentParameteriv (framebuffer:GLuint,attachment:FramebufferAttachment,pname:FramebufferAttachmentParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedFramebufferAttachmentParameteriv.?, .{framebuffer,attachment,pname,params});
}
pub fn glCreateRenderbuffers (n:GLsizei,renderbuffers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateRenderbuffers.?, .{n,renderbuffers});
}
pub fn glNamedRenderbufferStorage (renderbuffer:GLuint,internalformat:InternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedRenderbufferStorage.?, .{renderbuffer,internalformat,width,height});
}
pub fn glNamedRenderbufferStorageMultisample (renderbuffer:GLuint,samples:GLsizei,internalformat:InternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glNamedRenderbufferStorageMultisample.?, .{renderbuffer,samples,internalformat,width,height});
}
pub fn glGetNamedRenderbufferParameteriv (renderbuffer:GLuint,pname:RenderbufferParameterName,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetNamedRenderbufferParameteriv.?, .{renderbuffer,pname,params});
}
pub fn glCreateTextures (target:TextureTarget,n:GLsizei,textures:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateTextures.?, .{target,n,textures});
}
pub fn glTextureBuffer (texture:GLuint,internalformat:SizedInternalFormat,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureBuffer.?, .{texture,internalformat,buffer});
}
pub fn glTextureBufferRange (texture:GLuint,internalformat:SizedInternalFormat,buffer:GLuint,offset:GLintptr,size:GLsizeiptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureBufferRange.?, .{texture,internalformat,buffer,offset,size});
}
pub fn glTextureStorage1D (texture:GLuint,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureStorage1D.?, .{texture,levels,internalformat,width});
}
pub fn glTextureStorage2D (texture:GLuint,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureStorage2D.?, .{texture,levels,internalformat,width,height});
}
pub fn glTextureStorage3D (texture:GLuint,levels:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureStorage3D.?, .{texture,levels,internalformat,width,height,depth});
}
pub fn glTextureStorage2DMultisample (texture:GLuint,samples:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureStorage2DMultisample.?, .{texture,samples,internalformat,width,height,fixedsamplelocations});
}
pub fn glTextureStorage3DMultisample (texture:GLuint,samples:GLsizei,internalformat:SizedInternalFormat,width:GLsizei,height:GLsizei,depth:GLsizei,fixedsamplelocations:GLboolean) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureStorage3DMultisample.?, .{texture,samples,internalformat,width,height,depth,fixedsamplelocations});
}
pub fn glTextureSubImage1D (texture:GLuint,level:GLint,xoffset:GLint,width:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureSubImage1D.?, .{texture,level,xoffset,width,format,@"type",pixels});
}
pub fn glTextureSubImage2D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,width:GLsizei,height:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureSubImage2D.?, .{texture,level,xoffset,yoffset,width,height,format,@"type",pixels});
}
pub fn glTextureSubImage3D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:PixelFormat,@"type":PixelType,pixels:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureSubImage3D.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth,format,@"type",pixels});
}
pub fn glCompressedTextureSubImage1D (texture:GLuint,level:GLint,xoffset:GLint,width:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTextureSubImage1D.?, .{texture,level,xoffset,width,format,imageSize,data});
}
pub fn glCompressedTextureSubImage2D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,width:GLsizei,height:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTextureSubImage2D.?, .{texture,level,xoffset,yoffset,width,height,format,imageSize,data});
}
pub fn glCompressedTextureSubImage3D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:InternalFormat,imageSize:GLsizei,data:?*const anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCompressedTextureSubImage3D.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth,format,imageSize,data});
}
pub fn glCopyTextureSubImage1D (texture:GLuint,level:GLint,xoffset:GLint,x:GLint,y:GLint,width:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTextureSubImage1D.?, .{texture,level,xoffset,x,y,width});
}
pub fn glCopyTextureSubImage2D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTextureSubImage2D.?, .{texture,level,xoffset,yoffset,x,y,width,height});
}
pub fn glCopyTextureSubImage3D (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,x:GLint,y:GLint,width:GLsizei,height:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCopyTextureSubImage3D.?, .{texture,level,xoffset,yoffset,zoffset,x,y,width,height});
}
pub fn glTextureParameterf (texture:GLuint,pname:TextureParameterName,param:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameterf.?, .{texture,pname,param});
}
pub fn glTextureParameterfv (texture:GLuint,pname:TextureParameterName,param:[*c]const GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameterfv.?, .{texture,pname,param});
}
pub fn glTextureParameteri (texture:GLuint,pname:TextureParameterName,param:GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameteri.?, .{texture,pname,param});
}
pub fn glTextureParameterIiv (texture:GLuint,pname:TextureParameterName,params:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameterIiv.?, .{texture,pname,params});
}
pub fn glTextureParameterIuiv (texture:GLuint,pname:TextureParameterName,params:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameterIuiv.?, .{texture,pname,params});
}
pub fn glTextureParameteriv (texture:GLuint,pname:TextureParameterName,param:[*c]const GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureParameteriv.?, .{texture,pname,param});
}
pub fn glGenerateTextureMipmap (texture:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGenerateTextureMipmap.?, .{texture});
}
pub fn glBindTextureUnit (unit:GLuint,texture:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glBindTextureUnit.?, .{unit,texture});
}
pub fn glGetTextureImage (texture:GLuint,level:GLint,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureImage.?, .{texture,level,format,@"type",bufSize,pixels});
}
pub fn glGetCompressedTextureImage (texture:GLuint,level:GLint,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetCompressedTextureImage.?, .{texture,level,bufSize,pixels});
}
pub fn glGetTextureLevelParameterfv (texture:GLuint,level:GLint,pname:GetTextureParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureLevelParameterfv.?, .{texture,level,pname,params});
}
pub fn glGetTextureLevelParameteriv (texture:GLuint,level:GLint,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureLevelParameteriv.?, .{texture,level,pname,params});
}
pub fn glGetTextureParameterfv (texture:GLuint,pname:GetTextureParameter,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureParameterfv.?, .{texture,pname,params});
}
pub fn glGetTextureParameterIiv (texture:GLuint,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureParameterIiv.?, .{texture,pname,params});
}
pub fn glGetTextureParameterIuiv (texture:GLuint,pname:GetTextureParameter,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureParameterIuiv.?, .{texture,pname,params});
}
pub fn glGetTextureParameteriv (texture:GLuint,pname:GetTextureParameter,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureParameteriv.?, .{texture,pname,params});
}
pub fn glCreateVertexArrays (n:GLsizei,arrays:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateVertexArrays.?, .{n,arrays});
}
pub fn glDisableVertexArrayAttrib (vaobj:GLuint,index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glDisableVertexArrayAttrib.?, .{vaobj,index});
}
pub fn glEnableVertexArrayAttrib (vaobj:GLuint,index:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glEnableVertexArrayAttrib.?, .{vaobj,index});
}
pub fn glVertexArrayElementBuffer (vaobj:GLuint,buffer:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayElementBuffer.?, .{vaobj,buffer});
}
pub fn glVertexArrayVertexBuffer (vaobj:GLuint,bindingindex:GLuint,buffer:GLuint,offset:GLintptr,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayVertexBuffer.?, .{vaobj,bindingindex,buffer,offset,stride});
}
pub fn glVertexArrayVertexBuffers (vaobj:GLuint,first:GLuint,count:GLsizei,buffers:[*c]const GLuint,offsets:[*c]const GLintptr,strides:[*c]const GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayVertexBuffers.?, .{vaobj,first,count,buffers,offsets,strides});
}
pub fn glVertexArrayAttribBinding (vaobj:GLuint,attribindex:GLuint,bindingindex:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayAttribBinding.?, .{vaobj,attribindex,bindingindex});
}
pub fn glVertexArrayAttribFormat (vaobj:GLuint,attribindex:GLuint,size:GLint,@"type":VertexAttribType,normalized:GLboolean,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayAttribFormat.?, .{vaobj,attribindex,size,@"type",normalized,relativeoffset});
}
pub fn glVertexArrayAttribIFormat (vaobj:GLuint,attribindex:GLuint,size:GLint,@"type":VertexAttribIType,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayAttribIFormat.?, .{vaobj,attribindex,size,@"type",relativeoffset});
}
pub fn glVertexArrayAttribLFormat (vaobj:GLuint,attribindex:GLuint,size:GLint,@"type":VertexAttribLType,relativeoffset:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayAttribLFormat.?, .{vaobj,attribindex,size,@"type",relativeoffset});
}
pub fn glVertexArrayBindingDivisor (vaobj:GLuint,bindingindex:GLuint,divisor:GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glVertexArrayBindingDivisor.?, .{vaobj,bindingindex,divisor});
}
pub fn glGetVertexArrayiv (vaobj:GLuint,pname:VertexArrayPName,param:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexArrayiv.?, .{vaobj,pname,param});
}
pub fn glGetVertexArrayIndexediv (vaobj:GLuint,index:GLuint,pname:VertexArrayPName,param:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexArrayIndexediv.?, .{vaobj,index,pname,param});
}
pub fn glGetVertexArrayIndexed64iv (vaobj:GLuint,index:GLuint,pname:VertexArrayPName,param:[*c]GLint64) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetVertexArrayIndexed64iv.?, .{vaobj,index,pname,param});
}
pub fn glCreateSamplers (n:GLsizei,samplers:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateSamplers.?, .{n,samplers});
}
pub fn glCreateProgramPipelines (n:GLsizei,pipelines:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateProgramPipelines.?, .{n,pipelines});
}
pub fn glCreateQueries (target:QueryTarget,n:GLsizei,ids:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glCreateQueries.?, .{target,n,ids});
}
pub fn glGetQueryBufferObjecti64v (id:GLuint,buffer:GLuint,pname:QueryObjectParameterName,offset:GLintptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryBufferObjecti64v.?, .{id,buffer,pname,offset});
}
pub fn glGetQueryBufferObjectiv (id:GLuint,buffer:GLuint,pname:QueryObjectParameterName,offset:GLintptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryBufferObjectiv.?, .{id,buffer,pname,offset});
}
pub fn glGetQueryBufferObjectui64v (id:GLuint,buffer:GLuint,pname:QueryObjectParameterName,offset:GLintptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryBufferObjectui64v.?, .{id,buffer,pname,offset});
}
pub fn glGetQueryBufferObjectuiv (id:GLuint,buffer:GLuint,pname:QueryObjectParameterName,offset:GLintptr) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetQueryBufferObjectuiv.?, .{id,buffer,pname,offset});
}
pub fn glMemoryBarrierByRegion (barriers:MemoryBarrierMask) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMemoryBarrierByRegion.?, .{@as(GLbitfield, @bitCast(barriers))});
}
pub fn glGetTextureSubImage (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetTextureSubImage.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth,format,@"type",bufSize,pixels});
}
pub fn glGetCompressedTextureSubImage (texture:GLuint,level:GLint,xoffset:GLint,yoffset:GLint,zoffset:GLint,width:GLsizei,height:GLsizei,depth:GLsizei,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetCompressedTextureSubImage.?, .{texture,level,xoffset,yoffset,zoffset,width,height,depth,bufSize,pixels});
}
pub fn glGetGraphicsResetStatus () callconv(.C) GLenum {
return @call(.always_tail, current_proc_table.?.glGetGraphicsResetStatus.?, .{});
}
pub fn glGetnCompressedTexImage (target:TextureTarget,lod:GLint,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnCompressedTexImage.?, .{target,lod,bufSize,pixels});
}
pub fn glGetnTexImage (target:TextureTarget,level:GLint,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,pixels:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnTexImage.?, .{target,level,format,@"type",bufSize,pixels});
}
pub fn glGetnUniformdv (program:GLuint,location:GLint,bufSize:GLsizei,params:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnUniformdv.?, .{program,location,bufSize,params});
}
pub fn glGetnUniformfv (program:GLuint,location:GLint,bufSize:GLsizei,params:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnUniformfv.?, .{program,location,bufSize,params});
}
pub fn glGetnUniformiv (program:GLuint,location:GLint,bufSize:GLsizei,params:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnUniformiv.?, .{program,location,bufSize,params});
}
pub fn glGetnUniformuiv (program:GLuint,location:GLint,bufSize:GLsizei,params:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnUniformuiv.?, .{program,location,bufSize,params});
}
pub fn glReadnPixels (x:GLint,y:GLint,width:GLsizei,height:GLsizei,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,data:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glReadnPixels.?, .{x,y,width,height,format,@"type",bufSize,data});
}
pub fn glGetnMapdv (target:MapTarget,query:MapQuery,bufSize:GLsizei,v:[*c]GLdouble) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnMapdv.?, .{target,query,bufSize,v});
}
pub fn glGetnMapfv (target:MapTarget,query:MapQuery,bufSize:GLsizei,v:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnMapfv.?, .{target,query,bufSize,v});
}
pub fn glGetnMapiv (target:MapTarget,query:MapQuery,bufSize:GLsizei,v:[*c]GLint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnMapiv.?, .{target,query,bufSize,v});
}
pub fn glGetnPixelMapfv (map:PixelMap,bufSize:GLsizei,values:[*c]GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnPixelMapfv.?, .{map,bufSize,values});
}
pub fn glGetnPixelMapuiv (map:PixelMap,bufSize:GLsizei,values:[*c]GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnPixelMapuiv.?, .{map,bufSize,values});
}
pub fn glGetnPixelMapusv (map:PixelMap,bufSize:GLsizei,values:[*c]GLushort) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnPixelMapusv.?, .{map,bufSize,values});
}
pub fn glGetnPolygonStipple (bufSize:GLsizei,pattern:[*c]GLubyte) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnPolygonStipple.?, .{bufSize,pattern});
}
pub fn glGetnColorTable (target:ColorTableTarget,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,table:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnColorTable.?, .{target,format,@"type",bufSize,table});
}
pub fn glGetnConvolutionFilter (target:ConvolutionTarget,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,image:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnConvolutionFilter.?, .{target,format,@"type",bufSize,image});
}
pub fn glGetnSeparableFilter (target:SeparableTarget,format:PixelFormat,@"type":PixelType,rowBufSize:GLsizei,row:?*anyopaque,columnBufSize:GLsizei,column:?*anyopaque,span:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnSeparableFilter.?, .{target,format,@"type",rowBufSize,row,columnBufSize,column,span});
}
pub fn glGetnHistogram (target:HistogramTarget,reset:GLboolean,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,values:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnHistogram.?, .{target,reset,format,@"type",bufSize,values});
}
pub fn glGetnMinmax (target:MinmaxTarget,reset:GLboolean,format:PixelFormat,@"type":PixelType,bufSize:GLsizei,values:?*anyopaque) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glGetnMinmax.?, .{target,reset,format,@"type",bufSize,values});
}
pub fn glTextureBarrier () callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glTextureBarrier.?, .{});
}
pub fn glSpecializeShader (shader:GLuint,pEntryPoint:[*c]const GLchar,numSpecializationConstants:GLuint,pConstantIndex:[*c]const GLuint,pConstantValue:[*c]const GLuint) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glSpecializeShader.?, .{shader,pEntryPoint,numSpecializationConstants,pConstantIndex,pConstantValue});
}
pub fn glMultiDrawArraysIndirectCount (mode:PrimitiveType,indirect:?*const anyopaque,drawcount:GLintptr,maxdrawcount:GLsizei,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawArraysIndirectCount.?, .{mode,indirect,drawcount,maxdrawcount,stride});
}
pub fn glMultiDrawElementsIndirectCount (mode:PrimitiveType,@"type":DrawElementsType,indirect:?*const anyopaque,drawcount:GLintptr,maxdrawcount:GLsizei,stride:GLsizei) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glMultiDrawElementsIndirectCount.?, .{mode,@"type",indirect,drawcount,maxdrawcount,stride});
}
pub fn glPolygonOffsetClamp (factor:GLfloat,units:GLfloat,clamp:GLfloat) callconv(.C) void {
return @call(.always_tail, current_proc_table.?.glPolygonOffsetClamp.?, .{factor,units,clamp});
}
threadlocal var current_proc_table: ?ProcTable = null;

pub fn loadGL(getProcAddress: GETPROCADDRESSPROC) !ProcTable {
  return ProcTable {.glCullFace = @ptrCast(getProcAddress("glCullFace") orelse return error.LoadError),
.glFrontFace = @ptrCast(getProcAddress("glFrontFace") orelse return error.LoadError),
.glHint = @ptrCast(getProcAddress("glHint") orelse return error.LoadError),
.glLineWidth = @ptrCast(getProcAddress("glLineWidth") orelse return error.LoadError),
.glPointSize = @ptrCast(getProcAddress("glPointSize") orelse return error.LoadError),
.glPolygonMode = @ptrCast(getProcAddress("glPolygonMode") orelse return error.LoadError),
.glScissor = @ptrCast(getProcAddress("glScissor") orelse return error.LoadError),
.glTexParameterf = @ptrCast(getProcAddress("glTexParameterf") orelse return error.LoadError),
.glTexParameterfv = @ptrCast(getProcAddress("glTexParameterfv") orelse return error.LoadError),
.glTexParameteri = @ptrCast(getProcAddress("glTexParameteri") orelse return error.LoadError),
.glTexParameteriv = @ptrCast(getProcAddress("glTexParameteriv") orelse return error.LoadError),
.glTexImage1D = @ptrCast(getProcAddress("glTexImage1D") orelse return error.LoadError),
.glTexImage2D = @ptrCast(getProcAddress("glTexImage2D") orelse return error.LoadError),
.glDrawBuffer = @ptrCast(getProcAddress("glDrawBuffer") orelse return error.LoadError),
.glClear = @ptrCast(getProcAddress("glClear") orelse return error.LoadError),
.glClearColor = @ptrCast(getProcAddress("glClearColor") orelse return error.LoadError),
.glClearStencil = @ptrCast(getProcAddress("glClearStencil") orelse return error.LoadError),
.glClearDepth = @ptrCast(getProcAddress("glClearDepth") orelse return error.LoadError),
.glStencilMask = @ptrCast(getProcAddress("glStencilMask") orelse return error.LoadError),
.glColorMask = @ptrCast(getProcAddress("glColorMask") orelse return error.LoadError),
.glDepthMask = @ptrCast(getProcAddress("glDepthMask") orelse return error.LoadError),
.glDisable = @ptrCast(getProcAddress("glDisable") orelse return error.LoadError),
.glEnable = @ptrCast(getProcAddress("glEnable") orelse return error.LoadError),
.glFinish = @ptrCast(getProcAddress("glFinish") orelse return error.LoadError),
.glFlush = @ptrCast(getProcAddress("glFlush") orelse return error.LoadError),
.glBlendFunc = @ptrCast(getProcAddress("glBlendFunc") orelse return error.LoadError),
.glLogicOp = @ptrCast(getProcAddress("glLogicOp") orelse return error.LoadError),
.glStencilFunc = @ptrCast(getProcAddress("glStencilFunc") orelse return error.LoadError),
.glStencilOp = @ptrCast(getProcAddress("glStencilOp") orelse return error.LoadError),
.glDepthFunc = @ptrCast(getProcAddress("glDepthFunc") orelse return error.LoadError),
.glPixelStoref = @ptrCast(getProcAddress("glPixelStoref") orelse return error.LoadError),
.glPixelStorei = @ptrCast(getProcAddress("glPixelStorei") orelse return error.LoadError),
.glReadBuffer = @ptrCast(getProcAddress("glReadBuffer") orelse return error.LoadError),
.glReadPixels = @ptrCast(getProcAddress("glReadPixels") orelse return error.LoadError),
.glGetBooleanv = @ptrCast(getProcAddress("glGetBooleanv") orelse return error.LoadError),
.glGetDoublev = @ptrCast(getProcAddress("glGetDoublev") orelse return error.LoadError),
.glGetError = @ptrCast(getProcAddress("glGetError") orelse return error.LoadError),
.glGetFloatv = @ptrCast(getProcAddress("glGetFloatv") orelse return error.LoadError),
.glGetIntegerv = @ptrCast(getProcAddress("glGetIntegerv") orelse return error.LoadError),
.glGetString = @ptrCast(getProcAddress("glGetString") orelse return error.LoadError),
.glGetTexImage = @ptrCast(getProcAddress("glGetTexImage") orelse return error.LoadError),
.glGetTexParameterfv = @ptrCast(getProcAddress("glGetTexParameterfv") orelse return error.LoadError),
.glGetTexParameteriv = @ptrCast(getProcAddress("glGetTexParameteriv") orelse return error.LoadError),
.glGetTexLevelParameterfv = @ptrCast(getProcAddress("glGetTexLevelParameterfv") orelse return error.LoadError),
.glGetTexLevelParameteriv = @ptrCast(getProcAddress("glGetTexLevelParameteriv") orelse return error.LoadError),
.glIsEnabled = @ptrCast(getProcAddress("glIsEnabled") orelse return error.LoadError),
.glDepthRange = @ptrCast(getProcAddress("glDepthRange") orelse return error.LoadError),
.glViewport = @ptrCast(getProcAddress("glViewport") orelse return error.LoadError),
.glNewList = @ptrCast(getProcAddress("glNewList") orelse return error.LoadError),
.glEndList = @ptrCast(getProcAddress("glEndList") orelse return error.LoadError),
.glCallList = @ptrCast(getProcAddress("glCallList") orelse return error.LoadError),
.glCallLists = @ptrCast(getProcAddress("glCallLists") orelse return error.LoadError),
.glDeleteLists = @ptrCast(getProcAddress("glDeleteLists") orelse return error.LoadError),
.glGenLists = @ptrCast(getProcAddress("glGenLists") orelse return error.LoadError),
.glListBase = @ptrCast(getProcAddress("glListBase") orelse return error.LoadError),
.glBegin = @ptrCast(getProcAddress("glBegin") orelse return error.LoadError),
.glBitmap = @ptrCast(getProcAddress("glBitmap") orelse return error.LoadError),
.glColor3b = @ptrCast(getProcAddress("glColor3b") orelse return error.LoadError),
.glColor3bv = @ptrCast(getProcAddress("glColor3bv") orelse return error.LoadError),
.glColor3d = @ptrCast(getProcAddress("glColor3d") orelse return error.LoadError),
.glColor3dv = @ptrCast(getProcAddress("glColor3dv") orelse return error.LoadError),
.glColor3f = @ptrCast(getProcAddress("glColor3f") orelse return error.LoadError),
.glColor3fv = @ptrCast(getProcAddress("glColor3fv") orelse return error.LoadError),
.glColor3i = @ptrCast(getProcAddress("glColor3i") orelse return error.LoadError),
.glColor3iv = @ptrCast(getProcAddress("glColor3iv") orelse return error.LoadError),
.glColor3s = @ptrCast(getProcAddress("glColor3s") orelse return error.LoadError),
.glColor3sv = @ptrCast(getProcAddress("glColor3sv") orelse return error.LoadError),
.glColor3ub = @ptrCast(getProcAddress("glColor3ub") orelse return error.LoadError),
.glColor3ubv = @ptrCast(getProcAddress("glColor3ubv") orelse return error.LoadError),
.glColor3ui = @ptrCast(getProcAddress("glColor3ui") orelse return error.LoadError),
.glColor3uiv = @ptrCast(getProcAddress("glColor3uiv") orelse return error.LoadError),
.glColor3us = @ptrCast(getProcAddress("glColor3us") orelse return error.LoadError),
.glColor3usv = @ptrCast(getProcAddress("glColor3usv") orelse return error.LoadError),
.glColor4b = @ptrCast(getProcAddress("glColor4b") orelse return error.LoadError),
.glColor4bv = @ptrCast(getProcAddress("glColor4bv") orelse return error.LoadError),
.glColor4d = @ptrCast(getProcAddress("glColor4d") orelse return error.LoadError),
.glColor4dv = @ptrCast(getProcAddress("glColor4dv") orelse return error.LoadError),
.glColor4f = @ptrCast(getProcAddress("glColor4f") orelse return error.LoadError),
.glColor4fv = @ptrCast(getProcAddress("glColor4fv") orelse return error.LoadError),
.glColor4i = @ptrCast(getProcAddress("glColor4i") orelse return error.LoadError),
.glColor4iv = @ptrCast(getProcAddress("glColor4iv") orelse return error.LoadError),
.glColor4s = @ptrCast(getProcAddress("glColor4s") orelse return error.LoadError),
.glColor4sv = @ptrCast(getProcAddress("glColor4sv") orelse return error.LoadError),
.glColor4ub = @ptrCast(getProcAddress("glColor4ub") orelse return error.LoadError),
.glColor4ubv = @ptrCast(getProcAddress("glColor4ubv") orelse return error.LoadError),
.glColor4ui = @ptrCast(getProcAddress("glColor4ui") orelse return error.LoadError),
.glColor4uiv = @ptrCast(getProcAddress("glColor4uiv") orelse return error.LoadError),
.glColor4us = @ptrCast(getProcAddress("glColor4us") orelse return error.LoadError),
.glColor4usv = @ptrCast(getProcAddress("glColor4usv") orelse return error.LoadError),
.glEdgeFlag = @ptrCast(getProcAddress("glEdgeFlag") orelse return error.LoadError),
.glEdgeFlagv = @ptrCast(getProcAddress("glEdgeFlagv") orelse return error.LoadError),
.glEnd = @ptrCast(getProcAddress("glEnd") orelse return error.LoadError),
.glIndexd = @ptrCast(getProcAddress("glIndexd") orelse return error.LoadError),
.glIndexdv = @ptrCast(getProcAddress("glIndexdv") orelse return error.LoadError),
.glIndexf = @ptrCast(getProcAddress("glIndexf") orelse return error.LoadError),
.glIndexfv = @ptrCast(getProcAddress("glIndexfv") orelse return error.LoadError),
.glIndexi = @ptrCast(getProcAddress("glIndexi") orelse return error.LoadError),
.glIndexiv = @ptrCast(getProcAddress("glIndexiv") orelse return error.LoadError),
.glIndexs = @ptrCast(getProcAddress("glIndexs") orelse return error.LoadError),
.glIndexsv = @ptrCast(getProcAddress("glIndexsv") orelse return error.LoadError),
.glNormal3b = @ptrCast(getProcAddress("glNormal3b") orelse return error.LoadError),
.glNormal3bv = @ptrCast(getProcAddress("glNormal3bv") orelse return error.LoadError),
.glNormal3d = @ptrCast(getProcAddress("glNormal3d") orelse return error.LoadError),
.glNormal3dv = @ptrCast(getProcAddress("glNormal3dv") orelse return error.LoadError),
.glNormal3f = @ptrCast(getProcAddress("glNormal3f") orelse return error.LoadError),
.glNormal3fv = @ptrCast(getProcAddress("glNormal3fv") orelse return error.LoadError),
.glNormal3i = @ptrCast(getProcAddress("glNormal3i") orelse return error.LoadError),
.glNormal3iv = @ptrCast(getProcAddress("glNormal3iv") orelse return error.LoadError),
.glNormal3s = @ptrCast(getProcAddress("glNormal3s") orelse return error.LoadError),
.glNormal3sv = @ptrCast(getProcAddress("glNormal3sv") orelse return error.LoadError),
.glRasterPos2d = @ptrCast(getProcAddress("glRasterPos2d") orelse return error.LoadError),
.glRasterPos2dv = @ptrCast(getProcAddress("glRasterPos2dv") orelse return error.LoadError),
.glRasterPos2f = @ptrCast(getProcAddress("glRasterPos2f") orelse return error.LoadError),
.glRasterPos2fv = @ptrCast(getProcAddress("glRasterPos2fv") orelse return error.LoadError),
.glRasterPos2i = @ptrCast(getProcAddress("glRasterPos2i") orelse return error.LoadError),
.glRasterPos2iv = @ptrCast(getProcAddress("glRasterPos2iv") orelse return error.LoadError),
.glRasterPos2s = @ptrCast(getProcAddress("glRasterPos2s") orelse return error.LoadError),
.glRasterPos2sv = @ptrCast(getProcAddress("glRasterPos2sv") orelse return error.LoadError),
.glRasterPos3d = @ptrCast(getProcAddress("glRasterPos3d") orelse return error.LoadError),
.glRasterPos3dv = @ptrCast(getProcAddress("glRasterPos3dv") orelse return error.LoadError),
.glRasterPos3f = @ptrCast(getProcAddress("glRasterPos3f") orelse return error.LoadError),
.glRasterPos3fv = @ptrCast(getProcAddress("glRasterPos3fv") orelse return error.LoadError),
.glRasterPos3i = @ptrCast(getProcAddress("glRasterPos3i") orelse return error.LoadError),
.glRasterPos3iv = @ptrCast(getProcAddress("glRasterPos3iv") orelse return error.LoadError),
.glRasterPos3s = @ptrCast(getProcAddress("glRasterPos3s") orelse return error.LoadError),
.glRasterPos3sv = @ptrCast(getProcAddress("glRasterPos3sv") orelse return error.LoadError),
.glRasterPos4d = @ptrCast(getProcAddress("glRasterPos4d") orelse return error.LoadError),
.glRasterPos4dv = @ptrCast(getProcAddress("glRasterPos4dv") orelse return error.LoadError),
.glRasterPos4f = @ptrCast(getProcAddress("glRasterPos4f") orelse return error.LoadError),
.glRasterPos4fv = @ptrCast(getProcAddress("glRasterPos4fv") orelse return error.LoadError),
.glRasterPos4i = @ptrCast(getProcAddress("glRasterPos4i") orelse return error.LoadError),
.glRasterPos4iv = @ptrCast(getProcAddress("glRasterPos4iv") orelse return error.LoadError),
.glRasterPos4s = @ptrCast(getProcAddress("glRasterPos4s") orelse return error.LoadError),
.glRasterPos4sv = @ptrCast(getProcAddress("glRasterPos4sv") orelse return error.LoadError),
.glRectd = @ptrCast(getProcAddress("glRectd") orelse return error.LoadError),
.glRectdv = @ptrCast(getProcAddress("glRectdv") orelse return error.LoadError),
.glRectf = @ptrCast(getProcAddress("glRectf") orelse return error.LoadError),
.glRectfv = @ptrCast(getProcAddress("glRectfv") orelse return error.LoadError),
.glRecti = @ptrCast(getProcAddress("glRecti") orelse return error.LoadError),
.glRectiv = @ptrCast(getProcAddress("glRectiv") orelse return error.LoadError),
.glRects = @ptrCast(getProcAddress("glRects") orelse return error.LoadError),
.glRectsv = @ptrCast(getProcAddress("glRectsv") orelse return error.LoadError),
.glTexCoord1d = @ptrCast(getProcAddress("glTexCoord1d") orelse return error.LoadError),
.glTexCoord1dv = @ptrCast(getProcAddress("glTexCoord1dv") orelse return error.LoadError),
.glTexCoord1f = @ptrCast(getProcAddress("glTexCoord1f") orelse return error.LoadError),
.glTexCoord1fv = @ptrCast(getProcAddress("glTexCoord1fv") orelse return error.LoadError),
.glTexCoord1i = @ptrCast(getProcAddress("glTexCoord1i") orelse return error.LoadError),
.glTexCoord1iv = @ptrCast(getProcAddress("glTexCoord1iv") orelse return error.LoadError),
.glTexCoord1s = @ptrCast(getProcAddress("glTexCoord1s") orelse return error.LoadError),
.glTexCoord1sv = @ptrCast(getProcAddress("glTexCoord1sv") orelse return error.LoadError),
.glTexCoord2d = @ptrCast(getProcAddress("glTexCoord2d") orelse return error.LoadError),
.glTexCoord2dv = @ptrCast(getProcAddress("glTexCoord2dv") orelse return error.LoadError),
.glTexCoord2f = @ptrCast(getProcAddress("glTexCoord2f") orelse return error.LoadError),
.glTexCoord2fv = @ptrCast(getProcAddress("glTexCoord2fv") orelse return error.LoadError),
.glTexCoord2i = @ptrCast(getProcAddress("glTexCoord2i") orelse return error.LoadError),
.glTexCoord2iv = @ptrCast(getProcAddress("glTexCoord2iv") orelse return error.LoadError),
.glTexCoord2s = @ptrCast(getProcAddress("glTexCoord2s") orelse return error.LoadError),
.glTexCoord2sv = @ptrCast(getProcAddress("glTexCoord2sv") orelse return error.LoadError),
.glTexCoord3d = @ptrCast(getProcAddress("glTexCoord3d") orelse return error.LoadError),
.glTexCoord3dv = @ptrCast(getProcAddress("glTexCoord3dv") orelse return error.LoadError),
.glTexCoord3f = @ptrCast(getProcAddress("glTexCoord3f") orelse return error.LoadError),
.glTexCoord3fv = @ptrCast(getProcAddress("glTexCoord3fv") orelse return error.LoadError),
.glTexCoord3i = @ptrCast(getProcAddress("glTexCoord3i") orelse return error.LoadError),
.glTexCoord3iv = @ptrCast(getProcAddress("glTexCoord3iv") orelse return error.LoadError),
.glTexCoord3s = @ptrCast(getProcAddress("glTexCoord3s") orelse return error.LoadError),
.glTexCoord3sv = @ptrCast(getProcAddress("glTexCoord3sv") orelse return error.LoadError),
.glTexCoord4d = @ptrCast(getProcAddress("glTexCoord4d") orelse return error.LoadError),
.glTexCoord4dv = @ptrCast(getProcAddress("glTexCoord4dv") orelse return error.LoadError),
.glTexCoord4f = @ptrCast(getProcAddress("glTexCoord4f") orelse return error.LoadError),
.glTexCoord4fv = @ptrCast(getProcAddress("glTexCoord4fv") orelse return error.LoadError),
.glTexCoord4i = @ptrCast(getProcAddress("glTexCoord4i") orelse return error.LoadError),
.glTexCoord4iv = @ptrCast(getProcAddress("glTexCoord4iv") orelse return error.LoadError),
.glTexCoord4s = @ptrCast(getProcAddress("glTexCoord4s") orelse return error.LoadError),
.glTexCoord4sv = @ptrCast(getProcAddress("glTexCoord4sv") orelse return error.LoadError),
.glVertex2d = @ptrCast(getProcAddress("glVertex2d") orelse return error.LoadError),
.glVertex2dv = @ptrCast(getProcAddress("glVertex2dv") orelse return error.LoadError),
.glVertex2f = @ptrCast(getProcAddress("glVertex2f") orelse return error.LoadError),
.glVertex2fv = @ptrCast(getProcAddress("glVertex2fv") orelse return error.LoadError),
.glVertex2i = @ptrCast(getProcAddress("glVertex2i") orelse return error.LoadError),
.glVertex2iv = @ptrCast(getProcAddress("glVertex2iv") orelse return error.LoadError),
.glVertex2s = @ptrCast(getProcAddress("glVertex2s") orelse return error.LoadError),
.glVertex2sv = @ptrCast(getProcAddress("glVertex2sv") orelse return error.LoadError),
.glVertex3d = @ptrCast(getProcAddress("glVertex3d") orelse return error.LoadError),
.glVertex3dv = @ptrCast(getProcAddress("glVertex3dv") orelse return error.LoadError),
.glVertex3f = @ptrCast(getProcAddress("glVertex3f") orelse return error.LoadError),
.glVertex3fv = @ptrCast(getProcAddress("glVertex3fv") orelse return error.LoadError),
.glVertex3i = @ptrCast(getProcAddress("glVertex3i") orelse return error.LoadError),
.glVertex3iv = @ptrCast(getProcAddress("glVertex3iv") orelse return error.LoadError),
.glVertex3s = @ptrCast(getProcAddress("glVertex3s") orelse return error.LoadError),
.glVertex3sv = @ptrCast(getProcAddress("glVertex3sv") orelse return error.LoadError),
.glVertex4d = @ptrCast(getProcAddress("glVertex4d") orelse return error.LoadError),
.glVertex4dv = @ptrCast(getProcAddress("glVertex4dv") orelse return error.LoadError),
.glVertex4f = @ptrCast(getProcAddress("glVertex4f") orelse return error.LoadError),
.glVertex4fv = @ptrCast(getProcAddress("glVertex4fv") orelse return error.LoadError),
.glVertex4i = @ptrCast(getProcAddress("glVertex4i") orelse return error.LoadError),
.glVertex4iv = @ptrCast(getProcAddress("glVertex4iv") orelse return error.LoadError),
.glVertex4s = @ptrCast(getProcAddress("glVertex4s") orelse return error.LoadError),
.glVertex4sv = @ptrCast(getProcAddress("glVertex4sv") orelse return error.LoadError),
.glClipPlane = @ptrCast(getProcAddress("glClipPlane") orelse return error.LoadError),
.glColorMaterial = @ptrCast(getProcAddress("glColorMaterial") orelse return error.LoadError),
.glFogf = @ptrCast(getProcAddress("glFogf") orelse return error.LoadError),
.glFogfv = @ptrCast(getProcAddress("glFogfv") orelse return error.LoadError),
.glFogi = @ptrCast(getProcAddress("glFogi") orelse return error.LoadError),
.glFogiv = @ptrCast(getProcAddress("glFogiv") orelse return error.LoadError),
.glLightf = @ptrCast(getProcAddress("glLightf") orelse return error.LoadError),
.glLightfv = @ptrCast(getProcAddress("glLightfv") orelse return error.LoadError),
.glLighti = @ptrCast(getProcAddress("glLighti") orelse return error.LoadError),
.glLightiv = @ptrCast(getProcAddress("glLightiv") orelse return error.LoadError),
.glLightModelf = @ptrCast(getProcAddress("glLightModelf") orelse return error.LoadError),
.glLightModelfv = @ptrCast(getProcAddress("glLightModelfv") orelse return error.LoadError),
.glLightModeli = @ptrCast(getProcAddress("glLightModeli") orelse return error.LoadError),
.glLightModeliv = @ptrCast(getProcAddress("glLightModeliv") orelse return error.LoadError),
.glLineStipple = @ptrCast(getProcAddress("glLineStipple") orelse return error.LoadError),
.glMaterialf = @ptrCast(getProcAddress("glMaterialf") orelse return error.LoadError),
.glMaterialfv = @ptrCast(getProcAddress("glMaterialfv") orelse return error.LoadError),
.glMateriali = @ptrCast(getProcAddress("glMateriali") orelse return error.LoadError),
.glMaterialiv = @ptrCast(getProcAddress("glMaterialiv") orelse return error.LoadError),
.glPolygonStipple = @ptrCast(getProcAddress("glPolygonStipple") orelse return error.LoadError),
.glShadeModel = @ptrCast(getProcAddress("glShadeModel") orelse return error.LoadError),
.glTexEnvf = @ptrCast(getProcAddress("glTexEnvf") orelse return error.LoadError),
.glTexEnvfv = @ptrCast(getProcAddress("glTexEnvfv") orelse return error.LoadError),
.glTexEnvi = @ptrCast(getProcAddress("glTexEnvi") orelse return error.LoadError),
.glTexEnviv = @ptrCast(getProcAddress("glTexEnviv") orelse return error.LoadError),
.glTexGend = @ptrCast(getProcAddress("glTexGend") orelse return error.LoadError),
.glTexGendv = @ptrCast(getProcAddress("glTexGendv") orelse return error.LoadError),
.glTexGenf = @ptrCast(getProcAddress("glTexGenf") orelse return error.LoadError),
.glTexGenfv = @ptrCast(getProcAddress("glTexGenfv") orelse return error.LoadError),
.glTexGeni = @ptrCast(getProcAddress("glTexGeni") orelse return error.LoadError),
.glTexGeniv = @ptrCast(getProcAddress("glTexGeniv") orelse return error.LoadError),
.glFeedbackBuffer = @ptrCast(getProcAddress("glFeedbackBuffer") orelse return error.LoadError),
.glSelectBuffer = @ptrCast(getProcAddress("glSelectBuffer") orelse return error.LoadError),
.glRenderMode = @ptrCast(getProcAddress("glRenderMode") orelse return error.LoadError),
.glInitNames = @ptrCast(getProcAddress("glInitNames") orelse return error.LoadError),
.glLoadName = @ptrCast(getProcAddress("glLoadName") orelse return error.LoadError),
.glPassThrough = @ptrCast(getProcAddress("glPassThrough") orelse return error.LoadError),
.glPopName = @ptrCast(getProcAddress("glPopName") orelse return error.LoadError),
.glPushName = @ptrCast(getProcAddress("glPushName") orelse return error.LoadError),
.glClearAccum = @ptrCast(getProcAddress("glClearAccum") orelse return error.LoadError),
.glClearIndex = @ptrCast(getProcAddress("glClearIndex") orelse return error.LoadError),
.glIndexMask = @ptrCast(getProcAddress("glIndexMask") orelse return error.LoadError),
.glAccum = @ptrCast(getProcAddress("glAccum") orelse return error.LoadError),
.glPopAttrib = @ptrCast(getProcAddress("glPopAttrib") orelse return error.LoadError),
.glPushAttrib = @ptrCast(getProcAddress("glPushAttrib") orelse return error.LoadError),
.glMap1d = @ptrCast(getProcAddress("glMap1d") orelse return error.LoadError),
.glMap1f = @ptrCast(getProcAddress("glMap1f") orelse return error.LoadError),
.glMap2d = @ptrCast(getProcAddress("glMap2d") orelse return error.LoadError),
.glMap2f = @ptrCast(getProcAddress("glMap2f") orelse return error.LoadError),
.glMapGrid1d = @ptrCast(getProcAddress("glMapGrid1d") orelse return error.LoadError),
.glMapGrid1f = @ptrCast(getProcAddress("glMapGrid1f") orelse return error.LoadError),
.glMapGrid2d = @ptrCast(getProcAddress("glMapGrid2d") orelse return error.LoadError),
.glMapGrid2f = @ptrCast(getProcAddress("glMapGrid2f") orelse return error.LoadError),
.glEvalCoord1d = @ptrCast(getProcAddress("glEvalCoord1d") orelse return error.LoadError),
.glEvalCoord1dv = @ptrCast(getProcAddress("glEvalCoord1dv") orelse return error.LoadError),
.glEvalCoord1f = @ptrCast(getProcAddress("glEvalCoord1f") orelse return error.LoadError),
.glEvalCoord1fv = @ptrCast(getProcAddress("glEvalCoord1fv") orelse return error.LoadError),
.glEvalCoord2d = @ptrCast(getProcAddress("glEvalCoord2d") orelse return error.LoadError),
.glEvalCoord2dv = @ptrCast(getProcAddress("glEvalCoord2dv") orelse return error.LoadError),
.glEvalCoord2f = @ptrCast(getProcAddress("glEvalCoord2f") orelse return error.LoadError),
.glEvalCoord2fv = @ptrCast(getProcAddress("glEvalCoord2fv") orelse return error.LoadError),
.glEvalMesh1 = @ptrCast(getProcAddress("glEvalMesh1") orelse return error.LoadError),
.glEvalPoint1 = @ptrCast(getProcAddress("glEvalPoint1") orelse return error.LoadError),
.glEvalMesh2 = @ptrCast(getProcAddress("glEvalMesh2") orelse return error.LoadError),
.glEvalPoint2 = @ptrCast(getProcAddress("glEvalPoint2") orelse return error.LoadError),
.glAlphaFunc = @ptrCast(getProcAddress("glAlphaFunc") orelse return error.LoadError),
.glPixelZoom = @ptrCast(getProcAddress("glPixelZoom") orelse return error.LoadError),
.glPixelTransferf = @ptrCast(getProcAddress("glPixelTransferf") orelse return error.LoadError),
.glPixelTransferi = @ptrCast(getProcAddress("glPixelTransferi") orelse return error.LoadError),
.glPixelMapfv = @ptrCast(getProcAddress("glPixelMapfv") orelse return error.LoadError),
.glPixelMapuiv = @ptrCast(getProcAddress("glPixelMapuiv") orelse return error.LoadError),
.glPixelMapusv = @ptrCast(getProcAddress("glPixelMapusv") orelse return error.LoadError),
.glCopyPixels = @ptrCast(getProcAddress("glCopyPixels") orelse return error.LoadError),
.glDrawPixels = @ptrCast(getProcAddress("glDrawPixels") orelse return error.LoadError),
.glGetClipPlane = @ptrCast(getProcAddress("glGetClipPlane") orelse return error.LoadError),
.glGetLightfv = @ptrCast(getProcAddress("glGetLightfv") orelse return error.LoadError),
.glGetLightiv = @ptrCast(getProcAddress("glGetLightiv") orelse return error.LoadError),
.glGetMapdv = @ptrCast(getProcAddress("glGetMapdv") orelse return error.LoadError),
.glGetMapfv = @ptrCast(getProcAddress("glGetMapfv") orelse return error.LoadError),
.glGetMapiv = @ptrCast(getProcAddress("glGetMapiv") orelse return error.LoadError),
.glGetMaterialfv = @ptrCast(getProcAddress("glGetMaterialfv") orelse return error.LoadError),
.glGetMaterialiv = @ptrCast(getProcAddress("glGetMaterialiv") orelse return error.LoadError),
.glGetPixelMapfv = @ptrCast(getProcAddress("glGetPixelMapfv") orelse return error.LoadError),
.glGetPixelMapuiv = @ptrCast(getProcAddress("glGetPixelMapuiv") orelse return error.LoadError),
.glGetPixelMapusv = @ptrCast(getProcAddress("glGetPixelMapusv") orelse return error.LoadError),
.glGetPolygonStipple = @ptrCast(getProcAddress("glGetPolygonStipple") orelse return error.LoadError),
.glGetTexEnvfv = @ptrCast(getProcAddress("glGetTexEnvfv") orelse return error.LoadError),
.glGetTexEnviv = @ptrCast(getProcAddress("glGetTexEnviv") orelse return error.LoadError),
.glGetTexGendv = @ptrCast(getProcAddress("glGetTexGendv") orelse return error.LoadError),
.glGetTexGenfv = @ptrCast(getProcAddress("glGetTexGenfv") orelse return error.LoadError),
.glGetTexGeniv = @ptrCast(getProcAddress("glGetTexGeniv") orelse return error.LoadError),
.glIsList = @ptrCast(getProcAddress("glIsList") orelse return error.LoadError),
.glFrustum = @ptrCast(getProcAddress("glFrustum") orelse return error.LoadError),
.glLoadIdentity = @ptrCast(getProcAddress("glLoadIdentity") orelse return error.LoadError),
.glLoadMatrixf = @ptrCast(getProcAddress("glLoadMatrixf") orelse return error.LoadError),
.glLoadMatrixd = @ptrCast(getProcAddress("glLoadMatrixd") orelse return error.LoadError),
.glMatrixMode = @ptrCast(getProcAddress("glMatrixMode") orelse return error.LoadError),
.glMultMatrixf = @ptrCast(getProcAddress("glMultMatrixf") orelse return error.LoadError),
.glMultMatrixd = @ptrCast(getProcAddress("glMultMatrixd") orelse return error.LoadError),
.glOrtho = @ptrCast(getProcAddress("glOrtho") orelse return error.LoadError),
.glPopMatrix = @ptrCast(getProcAddress("glPopMatrix") orelse return error.LoadError),
.glPushMatrix = @ptrCast(getProcAddress("glPushMatrix") orelse return error.LoadError),
.glRotated = @ptrCast(getProcAddress("glRotated") orelse return error.LoadError),
.glRotatef = @ptrCast(getProcAddress("glRotatef") orelse return error.LoadError),
.glScaled = @ptrCast(getProcAddress("glScaled") orelse return error.LoadError),
.glScalef = @ptrCast(getProcAddress("glScalef") orelse return error.LoadError),
.glTranslated = @ptrCast(getProcAddress("glTranslated") orelse return error.LoadError),
.glTranslatef = @ptrCast(getProcAddress("glTranslatef") orelse return error.LoadError),
.glDrawArrays = @ptrCast(getProcAddress("glDrawArrays") orelse return error.LoadError),
.glDrawElements = @ptrCast(getProcAddress("glDrawElements") orelse return error.LoadError),
.glGetPointerv = @ptrCast(getProcAddress("glGetPointerv") orelse return error.LoadError),
.glPolygonOffset = @ptrCast(getProcAddress("glPolygonOffset") orelse return error.LoadError),
.glCopyTexImage1D = @ptrCast(getProcAddress("glCopyTexImage1D") orelse return error.LoadError),
.glCopyTexImage2D = @ptrCast(getProcAddress("glCopyTexImage2D") orelse return error.LoadError),
.glCopyTexSubImage1D = @ptrCast(getProcAddress("glCopyTexSubImage1D") orelse return error.LoadError),
.glCopyTexSubImage2D = @ptrCast(getProcAddress("glCopyTexSubImage2D") orelse return error.LoadError),
.glTexSubImage1D = @ptrCast(getProcAddress("glTexSubImage1D") orelse return error.LoadError),
.glTexSubImage2D = @ptrCast(getProcAddress("glTexSubImage2D") orelse return error.LoadError),
.glBindTexture = @ptrCast(getProcAddress("glBindTexture") orelse return error.LoadError),
.glDeleteTextures = @ptrCast(getProcAddress("glDeleteTextures") orelse return error.LoadError),
.glGenTextures = @ptrCast(getProcAddress("glGenTextures") orelse return error.LoadError),
.glIsTexture = @ptrCast(getProcAddress("glIsTexture") orelse return error.LoadError),
.glArrayElement = @ptrCast(getProcAddress("glArrayElement") orelse return error.LoadError),
.glColorPointer = @ptrCast(getProcAddress("glColorPointer") orelse return error.LoadError),
.glDisableClientState = @ptrCast(getProcAddress("glDisableClientState") orelse return error.LoadError),
.glEdgeFlagPointer = @ptrCast(getProcAddress("glEdgeFlagPointer") orelse return error.LoadError),
.glEnableClientState = @ptrCast(getProcAddress("glEnableClientState") orelse return error.LoadError),
.glIndexPointer = @ptrCast(getProcAddress("glIndexPointer") orelse return error.LoadError),
.glInterleavedArrays = @ptrCast(getProcAddress("glInterleavedArrays") orelse return error.LoadError),
.glNormalPointer = @ptrCast(getProcAddress("glNormalPointer") orelse return error.LoadError),
.glTexCoordPointer = @ptrCast(getProcAddress("glTexCoordPointer") orelse return error.LoadError),
.glVertexPointer = @ptrCast(getProcAddress("glVertexPointer") orelse return error.LoadError),
.glAreTexturesResident = @ptrCast(getProcAddress("glAreTexturesResident") orelse return error.LoadError),
.glPrioritizeTextures = @ptrCast(getProcAddress("glPrioritizeTextures") orelse return error.LoadError),
.glIndexub = @ptrCast(getProcAddress("glIndexub") orelse return error.LoadError),
.glIndexubv = @ptrCast(getProcAddress("glIndexubv") orelse return error.LoadError),
.glPopClientAttrib = @ptrCast(getProcAddress("glPopClientAttrib") orelse return error.LoadError),
.glPushClientAttrib = @ptrCast(getProcAddress("glPushClientAttrib") orelse return error.LoadError),
.glDrawRangeElements = @ptrCast(getProcAddress("glDrawRangeElements") orelse return error.LoadError),
.glTexImage3D = @ptrCast(getProcAddress("glTexImage3D") orelse return error.LoadError),
.glTexSubImage3D = @ptrCast(getProcAddress("glTexSubImage3D") orelse return error.LoadError),
.glCopyTexSubImage3D = @ptrCast(getProcAddress("glCopyTexSubImage3D") orelse return error.LoadError),
.glActiveTexture = @ptrCast(getProcAddress("glActiveTexture") orelse return error.LoadError),
.glSampleCoverage = @ptrCast(getProcAddress("glSampleCoverage") orelse return error.LoadError),
.glCompressedTexImage3D = @ptrCast(getProcAddress("glCompressedTexImage3D") orelse return error.LoadError),
.glCompressedTexImage2D = @ptrCast(getProcAddress("glCompressedTexImage2D") orelse return error.LoadError),
.glCompressedTexImage1D = @ptrCast(getProcAddress("glCompressedTexImage1D") orelse return error.LoadError),
.glCompressedTexSubImage3D = @ptrCast(getProcAddress("glCompressedTexSubImage3D") orelse return error.LoadError),
.glCompressedTexSubImage2D = @ptrCast(getProcAddress("glCompressedTexSubImage2D") orelse return error.LoadError),
.glCompressedTexSubImage1D = @ptrCast(getProcAddress("glCompressedTexSubImage1D") orelse return error.LoadError),
.glGetCompressedTexImage = @ptrCast(getProcAddress("glGetCompressedTexImage") orelse return error.LoadError),
.glClientActiveTexture = @ptrCast(getProcAddress("glClientActiveTexture") orelse return error.LoadError),
.glMultiTexCoord1d = @ptrCast(getProcAddress("glMultiTexCoord1d") orelse return error.LoadError),
.glMultiTexCoord1dv = @ptrCast(getProcAddress("glMultiTexCoord1dv") orelse return error.LoadError),
.glMultiTexCoord1f = @ptrCast(getProcAddress("glMultiTexCoord1f") orelse return error.LoadError),
.glMultiTexCoord1fv = @ptrCast(getProcAddress("glMultiTexCoord1fv") orelse return error.LoadError),
.glMultiTexCoord1i = @ptrCast(getProcAddress("glMultiTexCoord1i") orelse return error.LoadError),
.glMultiTexCoord1iv = @ptrCast(getProcAddress("glMultiTexCoord1iv") orelse return error.LoadError),
.glMultiTexCoord1s = @ptrCast(getProcAddress("glMultiTexCoord1s") orelse return error.LoadError),
.glMultiTexCoord1sv = @ptrCast(getProcAddress("glMultiTexCoord1sv") orelse return error.LoadError),
.glMultiTexCoord2d = @ptrCast(getProcAddress("glMultiTexCoord2d") orelse return error.LoadError),
.glMultiTexCoord2dv = @ptrCast(getProcAddress("glMultiTexCoord2dv") orelse return error.LoadError),
.glMultiTexCoord2f = @ptrCast(getProcAddress("glMultiTexCoord2f") orelse return error.LoadError),
.glMultiTexCoord2fv = @ptrCast(getProcAddress("glMultiTexCoord2fv") orelse return error.LoadError),
.glMultiTexCoord2i = @ptrCast(getProcAddress("glMultiTexCoord2i") orelse return error.LoadError),
.glMultiTexCoord2iv = @ptrCast(getProcAddress("glMultiTexCoord2iv") orelse return error.LoadError),
.glMultiTexCoord2s = @ptrCast(getProcAddress("glMultiTexCoord2s") orelse return error.LoadError),
.glMultiTexCoord2sv = @ptrCast(getProcAddress("glMultiTexCoord2sv") orelse return error.LoadError),
.glMultiTexCoord3d = @ptrCast(getProcAddress("glMultiTexCoord3d") orelse return error.LoadError),
.glMultiTexCoord3dv = @ptrCast(getProcAddress("glMultiTexCoord3dv") orelse return error.LoadError),
.glMultiTexCoord3f = @ptrCast(getProcAddress("glMultiTexCoord3f") orelse return error.LoadError),
.glMultiTexCoord3fv = @ptrCast(getProcAddress("glMultiTexCoord3fv") orelse return error.LoadError),
.glMultiTexCoord3i = @ptrCast(getProcAddress("glMultiTexCoord3i") orelse return error.LoadError),
.glMultiTexCoord3iv = @ptrCast(getProcAddress("glMultiTexCoord3iv") orelse return error.LoadError),
.glMultiTexCoord3s = @ptrCast(getProcAddress("glMultiTexCoord3s") orelse return error.LoadError),
.glMultiTexCoord3sv = @ptrCast(getProcAddress("glMultiTexCoord3sv") orelse return error.LoadError),
.glMultiTexCoord4d = @ptrCast(getProcAddress("glMultiTexCoord4d") orelse return error.LoadError),
.glMultiTexCoord4dv = @ptrCast(getProcAddress("glMultiTexCoord4dv") orelse return error.LoadError),
.glMultiTexCoord4f = @ptrCast(getProcAddress("glMultiTexCoord4f") orelse return error.LoadError),
.glMultiTexCoord4fv = @ptrCast(getProcAddress("glMultiTexCoord4fv") orelse return error.LoadError),
.glMultiTexCoord4i = @ptrCast(getProcAddress("glMultiTexCoord4i") orelse return error.LoadError),
.glMultiTexCoord4iv = @ptrCast(getProcAddress("glMultiTexCoord4iv") orelse return error.LoadError),
.glMultiTexCoord4s = @ptrCast(getProcAddress("glMultiTexCoord4s") orelse return error.LoadError),
.glMultiTexCoord4sv = @ptrCast(getProcAddress("glMultiTexCoord4sv") orelse return error.LoadError),
.glLoadTransposeMatrixf = @ptrCast(getProcAddress("glLoadTransposeMatrixf") orelse return error.LoadError),
.glLoadTransposeMatrixd = @ptrCast(getProcAddress("glLoadTransposeMatrixd") orelse return error.LoadError),
.glMultTransposeMatrixf = @ptrCast(getProcAddress("glMultTransposeMatrixf") orelse return error.LoadError),
.glMultTransposeMatrixd = @ptrCast(getProcAddress("glMultTransposeMatrixd") orelse return error.LoadError),
.glBlendFuncSeparate = @ptrCast(getProcAddress("glBlendFuncSeparate") orelse return error.LoadError),
.glMultiDrawArrays = @ptrCast(getProcAddress("glMultiDrawArrays") orelse return error.LoadError),
.glMultiDrawElements = @ptrCast(getProcAddress("glMultiDrawElements") orelse return error.LoadError),
.glPointParameterf = @ptrCast(getProcAddress("glPointParameterf") orelse return error.LoadError),
.glPointParameterfv = @ptrCast(getProcAddress("glPointParameterfv") orelse return error.LoadError),
.glPointParameteri = @ptrCast(getProcAddress("glPointParameteri") orelse return error.LoadError),
.glPointParameteriv = @ptrCast(getProcAddress("glPointParameteriv") orelse return error.LoadError),
.glFogCoordf = @ptrCast(getProcAddress("glFogCoordf") orelse return error.LoadError),
.glFogCoordfv = @ptrCast(getProcAddress("glFogCoordfv") orelse return error.LoadError),
.glFogCoordd = @ptrCast(getProcAddress("glFogCoordd") orelse return error.LoadError),
.glFogCoorddv = @ptrCast(getProcAddress("glFogCoorddv") orelse return error.LoadError),
.glFogCoordPointer = @ptrCast(getProcAddress("glFogCoordPointer") orelse return error.LoadError),
.glSecondaryColor3b = @ptrCast(getProcAddress("glSecondaryColor3b") orelse return error.LoadError),
.glSecondaryColor3bv = @ptrCast(getProcAddress("glSecondaryColor3bv") orelse return error.LoadError),
.glSecondaryColor3d = @ptrCast(getProcAddress("glSecondaryColor3d") orelse return error.LoadError),
.glSecondaryColor3dv = @ptrCast(getProcAddress("glSecondaryColor3dv") orelse return error.LoadError),
.glSecondaryColor3f = @ptrCast(getProcAddress("glSecondaryColor3f") orelse return error.LoadError),
.glSecondaryColor3fv = @ptrCast(getProcAddress("glSecondaryColor3fv") orelse return error.LoadError),
.glSecondaryColor3i = @ptrCast(getProcAddress("glSecondaryColor3i") orelse return error.LoadError),
.glSecondaryColor3iv = @ptrCast(getProcAddress("glSecondaryColor3iv") orelse return error.LoadError),
.glSecondaryColor3s = @ptrCast(getProcAddress("glSecondaryColor3s") orelse return error.LoadError),
.glSecondaryColor3sv = @ptrCast(getProcAddress("glSecondaryColor3sv") orelse return error.LoadError),
.glSecondaryColor3ub = @ptrCast(getProcAddress("glSecondaryColor3ub") orelse return error.LoadError),
.glSecondaryColor3ubv = @ptrCast(getProcAddress("glSecondaryColor3ubv") orelse return error.LoadError),
.glSecondaryColor3ui = @ptrCast(getProcAddress("glSecondaryColor3ui") orelse return error.LoadError),
.glSecondaryColor3uiv = @ptrCast(getProcAddress("glSecondaryColor3uiv") orelse return error.LoadError),
.glSecondaryColor3us = @ptrCast(getProcAddress("glSecondaryColor3us") orelse return error.LoadError),
.glSecondaryColor3usv = @ptrCast(getProcAddress("glSecondaryColor3usv") orelse return error.LoadError),
.glSecondaryColorPointer = @ptrCast(getProcAddress("glSecondaryColorPointer") orelse return error.LoadError),
.glWindowPos2d = @ptrCast(getProcAddress("glWindowPos2d") orelse return error.LoadError),
.glWindowPos2dv = @ptrCast(getProcAddress("glWindowPos2dv") orelse return error.LoadError),
.glWindowPos2f = @ptrCast(getProcAddress("glWindowPos2f") orelse return error.LoadError),
.glWindowPos2fv = @ptrCast(getProcAddress("glWindowPos2fv") orelse return error.LoadError),
.glWindowPos2i = @ptrCast(getProcAddress("glWindowPos2i") orelse return error.LoadError),
.glWindowPos2iv = @ptrCast(getProcAddress("glWindowPos2iv") orelse return error.LoadError),
.glWindowPos2s = @ptrCast(getProcAddress("glWindowPos2s") orelse return error.LoadError),
.glWindowPos2sv = @ptrCast(getProcAddress("glWindowPos2sv") orelse return error.LoadError),
.glWindowPos3d = @ptrCast(getProcAddress("glWindowPos3d") orelse return error.LoadError),
.glWindowPos3dv = @ptrCast(getProcAddress("glWindowPos3dv") orelse return error.LoadError),
.glWindowPos3f = @ptrCast(getProcAddress("glWindowPos3f") orelse return error.LoadError),
.glWindowPos3fv = @ptrCast(getProcAddress("glWindowPos3fv") orelse return error.LoadError),
.glWindowPos3i = @ptrCast(getProcAddress("glWindowPos3i") orelse return error.LoadError),
.glWindowPos3iv = @ptrCast(getProcAddress("glWindowPos3iv") orelse return error.LoadError),
.glWindowPos3s = @ptrCast(getProcAddress("glWindowPos3s") orelse return error.LoadError),
.glWindowPos3sv = @ptrCast(getProcAddress("glWindowPos3sv") orelse return error.LoadError),
.glBlendColor = @ptrCast(getProcAddress("glBlendColor") orelse return error.LoadError),
.glBlendEquation = @ptrCast(getProcAddress("glBlendEquation") orelse return error.LoadError),
.glGenQueries = @ptrCast(getProcAddress("glGenQueries") orelse return error.LoadError),
.glDeleteQueries = @ptrCast(getProcAddress("glDeleteQueries") orelse return error.LoadError),
.glIsQuery = @ptrCast(getProcAddress("glIsQuery") orelse return error.LoadError),
.glBeginQuery = @ptrCast(getProcAddress("glBeginQuery") orelse return error.LoadError),
.glEndQuery = @ptrCast(getProcAddress("glEndQuery") orelse return error.LoadError),
.glGetQueryiv = @ptrCast(getProcAddress("glGetQueryiv") orelse return error.LoadError),
.glGetQueryObjectiv = @ptrCast(getProcAddress("glGetQueryObjectiv") orelse return error.LoadError),
.glGetQueryObjectuiv = @ptrCast(getProcAddress("glGetQueryObjectuiv") orelse return error.LoadError),
.glBindBuffer = @ptrCast(getProcAddress("glBindBuffer") orelse return error.LoadError),
.glDeleteBuffers = @ptrCast(getProcAddress("glDeleteBuffers") orelse return error.LoadError),
.glGenBuffers = @ptrCast(getProcAddress("glGenBuffers") orelse return error.LoadError),
.glIsBuffer = @ptrCast(getProcAddress("glIsBuffer") orelse return error.LoadError),
.glBufferData = @ptrCast(getProcAddress("glBufferData") orelse return error.LoadError),
.glBufferSubData = @ptrCast(getProcAddress("glBufferSubData") orelse return error.LoadError),
.glGetBufferSubData = @ptrCast(getProcAddress("glGetBufferSubData") orelse return error.LoadError),
.glMapBuffer = @ptrCast(getProcAddress("glMapBuffer") orelse return error.LoadError),
.glUnmapBuffer = @ptrCast(getProcAddress("glUnmapBuffer") orelse return error.LoadError),
.glGetBufferParameteriv = @ptrCast(getProcAddress("glGetBufferParameteriv") orelse return error.LoadError),
.glGetBufferPointerv = @ptrCast(getProcAddress("glGetBufferPointerv") orelse return error.LoadError),
.glBlendEquationSeparate = @ptrCast(getProcAddress("glBlendEquationSeparate") orelse return error.LoadError),
.glDrawBuffers = @ptrCast(getProcAddress("glDrawBuffers") orelse return error.LoadError),
.glStencilOpSeparate = @ptrCast(getProcAddress("glStencilOpSeparate") orelse return error.LoadError),
.glStencilFuncSeparate = @ptrCast(getProcAddress("glStencilFuncSeparate") orelse return error.LoadError),
.glStencilMaskSeparate = @ptrCast(getProcAddress("glStencilMaskSeparate") orelse return error.LoadError),
.glAttachShader = @ptrCast(getProcAddress("glAttachShader") orelse return error.LoadError),
.glBindAttribLocation = @ptrCast(getProcAddress("glBindAttribLocation") orelse return error.LoadError),
.glCompileShader = @ptrCast(getProcAddress("glCompileShader") orelse return error.LoadError),
.glCreateProgram = @ptrCast(getProcAddress("glCreateProgram") orelse return error.LoadError),
.glCreateShader = @ptrCast(getProcAddress("glCreateShader") orelse return error.LoadError),
.glDeleteProgram = @ptrCast(getProcAddress("glDeleteProgram") orelse return error.LoadError),
.glDeleteShader = @ptrCast(getProcAddress("glDeleteShader") orelse return error.LoadError),
.glDetachShader = @ptrCast(getProcAddress("glDetachShader") orelse return error.LoadError),
.glDisableVertexAttribArray = @ptrCast(getProcAddress("glDisableVertexAttribArray") orelse return error.LoadError),
.glEnableVertexAttribArray = @ptrCast(getProcAddress("glEnableVertexAttribArray") orelse return error.LoadError),
.glGetActiveAttrib = @ptrCast(getProcAddress("glGetActiveAttrib") orelse return error.LoadError),
.glGetActiveUniform = @ptrCast(getProcAddress("glGetActiveUniform") orelse return error.LoadError),
.glGetAttachedShaders = @ptrCast(getProcAddress("glGetAttachedShaders") orelse return error.LoadError),
.glGetAttribLocation = @ptrCast(getProcAddress("glGetAttribLocation") orelse return error.LoadError),
.glGetProgramiv = @ptrCast(getProcAddress("glGetProgramiv") orelse return error.LoadError),
.glGetProgramInfoLog = @ptrCast(getProcAddress("glGetProgramInfoLog") orelse return error.LoadError),
.glGetShaderiv = @ptrCast(getProcAddress("glGetShaderiv") orelse return error.LoadError),
.glGetShaderInfoLog = @ptrCast(getProcAddress("glGetShaderInfoLog") orelse return error.LoadError),
.glGetShaderSource = @ptrCast(getProcAddress("glGetShaderSource") orelse return error.LoadError),
.glGetUniformLocation = @ptrCast(getProcAddress("glGetUniformLocation") orelse return error.LoadError),
.glGetUniformfv = @ptrCast(getProcAddress("glGetUniformfv") orelse return error.LoadError),
.glGetUniformiv = @ptrCast(getProcAddress("glGetUniformiv") orelse return error.LoadError),
.glGetVertexAttribdv = @ptrCast(getProcAddress("glGetVertexAttribdv") orelse return error.LoadError),
.glGetVertexAttribfv = @ptrCast(getProcAddress("glGetVertexAttribfv") orelse return error.LoadError),
.glGetVertexAttribiv = @ptrCast(getProcAddress("glGetVertexAttribiv") orelse return error.LoadError),
.glGetVertexAttribPointerv = @ptrCast(getProcAddress("glGetVertexAttribPointerv") orelse return error.LoadError),
.glIsProgram = @ptrCast(getProcAddress("glIsProgram") orelse return error.LoadError),
.glIsShader = @ptrCast(getProcAddress("glIsShader") orelse return error.LoadError),
.glLinkProgram = @ptrCast(getProcAddress("glLinkProgram") orelse return error.LoadError),
.glShaderSource = @ptrCast(getProcAddress("glShaderSource") orelse return error.LoadError),
.glUseProgram = @ptrCast(getProcAddress("glUseProgram") orelse return error.LoadError),
.glUniform1f = @ptrCast(getProcAddress("glUniform1f") orelse return error.LoadError),
.glUniform2f = @ptrCast(getProcAddress("glUniform2f") orelse return error.LoadError),
.glUniform3f = @ptrCast(getProcAddress("glUniform3f") orelse return error.LoadError),
.glUniform4f = @ptrCast(getProcAddress("glUniform4f") orelse return error.LoadError),
.glUniform1i = @ptrCast(getProcAddress("glUniform1i") orelse return error.LoadError),
.glUniform2i = @ptrCast(getProcAddress("glUniform2i") orelse return error.LoadError),
.glUniform3i = @ptrCast(getProcAddress("glUniform3i") orelse return error.LoadError),
.glUniform4i = @ptrCast(getProcAddress("glUniform4i") orelse return error.LoadError),
.glUniform1fv = @ptrCast(getProcAddress("glUniform1fv") orelse return error.LoadError),
.glUniform2fv = @ptrCast(getProcAddress("glUniform2fv") orelse return error.LoadError),
.glUniform3fv = @ptrCast(getProcAddress("glUniform3fv") orelse return error.LoadError),
.glUniform4fv = @ptrCast(getProcAddress("glUniform4fv") orelse return error.LoadError),
.glUniform1iv = @ptrCast(getProcAddress("glUniform1iv") orelse return error.LoadError),
.glUniform2iv = @ptrCast(getProcAddress("glUniform2iv") orelse return error.LoadError),
.glUniform3iv = @ptrCast(getProcAddress("glUniform3iv") orelse return error.LoadError),
.glUniform4iv = @ptrCast(getProcAddress("glUniform4iv") orelse return error.LoadError),
.glUniformMatrix2fv = @ptrCast(getProcAddress("glUniformMatrix2fv") orelse return error.LoadError),
.glUniformMatrix3fv = @ptrCast(getProcAddress("glUniformMatrix3fv") orelse return error.LoadError),
.glUniformMatrix4fv = @ptrCast(getProcAddress("glUniformMatrix4fv") orelse return error.LoadError),
.glValidateProgram = @ptrCast(getProcAddress("glValidateProgram") orelse return error.LoadError),
.glVertexAttrib1d = @ptrCast(getProcAddress("glVertexAttrib1d") orelse return error.LoadError),
.glVertexAttrib1dv = @ptrCast(getProcAddress("glVertexAttrib1dv") orelse return error.LoadError),
.glVertexAttrib1f = @ptrCast(getProcAddress("glVertexAttrib1f") orelse return error.LoadError),
.glVertexAttrib1fv = @ptrCast(getProcAddress("glVertexAttrib1fv") orelse return error.LoadError),
.glVertexAttrib1s = @ptrCast(getProcAddress("glVertexAttrib1s") orelse return error.LoadError),
.glVertexAttrib1sv = @ptrCast(getProcAddress("glVertexAttrib1sv") orelse return error.LoadError),
.glVertexAttrib2d = @ptrCast(getProcAddress("glVertexAttrib2d") orelse return error.LoadError),
.glVertexAttrib2dv = @ptrCast(getProcAddress("glVertexAttrib2dv") orelse return error.LoadError),
.glVertexAttrib2f = @ptrCast(getProcAddress("glVertexAttrib2f") orelse return error.LoadError),
.glVertexAttrib2fv = @ptrCast(getProcAddress("glVertexAttrib2fv") orelse return error.LoadError),
.glVertexAttrib2s = @ptrCast(getProcAddress("glVertexAttrib2s") orelse return error.LoadError),
.glVertexAttrib2sv = @ptrCast(getProcAddress("glVertexAttrib2sv") orelse return error.LoadError),
.glVertexAttrib3d = @ptrCast(getProcAddress("glVertexAttrib3d") orelse return error.LoadError),
.glVertexAttrib3dv = @ptrCast(getProcAddress("glVertexAttrib3dv") orelse return error.LoadError),
.glVertexAttrib3f = @ptrCast(getProcAddress("glVertexAttrib3f") orelse return error.LoadError),
.glVertexAttrib3fv = @ptrCast(getProcAddress("glVertexAttrib3fv") orelse return error.LoadError),
.glVertexAttrib3s = @ptrCast(getProcAddress("glVertexAttrib3s") orelse return error.LoadError),
.glVertexAttrib3sv = @ptrCast(getProcAddress("glVertexAttrib3sv") orelse return error.LoadError),
.glVertexAttrib4Nbv = @ptrCast(getProcAddress("glVertexAttrib4Nbv") orelse return error.LoadError),
.glVertexAttrib4Niv = @ptrCast(getProcAddress("glVertexAttrib4Niv") orelse return error.LoadError),
.glVertexAttrib4Nsv = @ptrCast(getProcAddress("glVertexAttrib4Nsv") orelse return error.LoadError),
.glVertexAttrib4Nub = @ptrCast(getProcAddress("glVertexAttrib4Nub") orelse return error.LoadError),
.glVertexAttrib4Nubv = @ptrCast(getProcAddress("glVertexAttrib4Nubv") orelse return error.LoadError),
.glVertexAttrib4Nuiv = @ptrCast(getProcAddress("glVertexAttrib4Nuiv") orelse return error.LoadError),
.glVertexAttrib4Nusv = @ptrCast(getProcAddress("glVertexAttrib4Nusv") orelse return error.LoadError),
.glVertexAttrib4bv = @ptrCast(getProcAddress("glVertexAttrib4bv") orelse return error.LoadError),
.glVertexAttrib4d = @ptrCast(getProcAddress("glVertexAttrib4d") orelse return error.LoadError),
.glVertexAttrib4dv = @ptrCast(getProcAddress("glVertexAttrib4dv") orelse return error.LoadError),
.glVertexAttrib4f = @ptrCast(getProcAddress("glVertexAttrib4f") orelse return error.LoadError),
.glVertexAttrib4fv = @ptrCast(getProcAddress("glVertexAttrib4fv") orelse return error.LoadError),
.glVertexAttrib4iv = @ptrCast(getProcAddress("glVertexAttrib4iv") orelse return error.LoadError),
.glVertexAttrib4s = @ptrCast(getProcAddress("glVertexAttrib4s") orelse return error.LoadError),
.glVertexAttrib4sv = @ptrCast(getProcAddress("glVertexAttrib4sv") orelse return error.LoadError),
.glVertexAttrib4ubv = @ptrCast(getProcAddress("glVertexAttrib4ubv") orelse return error.LoadError),
.glVertexAttrib4uiv = @ptrCast(getProcAddress("glVertexAttrib4uiv") orelse return error.LoadError),
.glVertexAttrib4usv = @ptrCast(getProcAddress("glVertexAttrib4usv") orelse return error.LoadError),
.glVertexAttribPointer = @ptrCast(getProcAddress("glVertexAttribPointer") orelse return error.LoadError),
.glUniformMatrix2x3fv = @ptrCast(getProcAddress("glUniformMatrix2x3fv") orelse return error.LoadError),
.glUniformMatrix3x2fv = @ptrCast(getProcAddress("glUniformMatrix3x2fv") orelse return error.LoadError),
.glUniformMatrix2x4fv = @ptrCast(getProcAddress("glUniformMatrix2x4fv") orelse return error.LoadError),
.glUniformMatrix4x2fv = @ptrCast(getProcAddress("glUniformMatrix4x2fv") orelse return error.LoadError),
.glUniformMatrix3x4fv = @ptrCast(getProcAddress("glUniformMatrix3x4fv") orelse return error.LoadError),
.glUniformMatrix4x3fv = @ptrCast(getProcAddress("glUniformMatrix4x3fv") orelse return error.LoadError),
.glColorMaski = @ptrCast(getProcAddress("glColorMaski") orelse return error.LoadError),
.glGetBooleani_v = @ptrCast(getProcAddress("glGetBooleani_v") orelse return error.LoadError),
.glGetIntegeri_v = @ptrCast(getProcAddress("glGetIntegeri_v") orelse return error.LoadError),
.glEnablei = @ptrCast(getProcAddress("glEnablei") orelse return error.LoadError),
.glDisablei = @ptrCast(getProcAddress("glDisablei") orelse return error.LoadError),
.glIsEnabledi = @ptrCast(getProcAddress("glIsEnabledi") orelse return error.LoadError),
.glBeginTransformFeedback = @ptrCast(getProcAddress("glBeginTransformFeedback") orelse return error.LoadError),
.glEndTransformFeedback = @ptrCast(getProcAddress("glEndTransformFeedback") orelse return error.LoadError),
.glBindBufferRange = @ptrCast(getProcAddress("glBindBufferRange") orelse return error.LoadError),
.glBindBufferBase = @ptrCast(getProcAddress("glBindBufferBase") orelse return error.LoadError),
.glTransformFeedbackVaryings = @ptrCast(getProcAddress("glTransformFeedbackVaryings") orelse return error.LoadError),
.glGetTransformFeedbackVarying = @ptrCast(getProcAddress("glGetTransformFeedbackVarying") orelse return error.LoadError),
.glClampColor = @ptrCast(getProcAddress("glClampColor") orelse return error.LoadError),
.glBeginConditionalRender = @ptrCast(getProcAddress("glBeginConditionalRender") orelse return error.LoadError),
.glEndConditionalRender = @ptrCast(getProcAddress("glEndConditionalRender") orelse return error.LoadError),
.glVertexAttribIPointer = @ptrCast(getProcAddress("glVertexAttribIPointer") orelse return error.LoadError),
.glGetVertexAttribIiv = @ptrCast(getProcAddress("glGetVertexAttribIiv") orelse return error.LoadError),
.glGetVertexAttribIuiv = @ptrCast(getProcAddress("glGetVertexAttribIuiv") orelse return error.LoadError),
.glVertexAttribI1i = @ptrCast(getProcAddress("glVertexAttribI1i") orelse return error.LoadError),
.glVertexAttribI2i = @ptrCast(getProcAddress("glVertexAttribI2i") orelse return error.LoadError),
.glVertexAttribI3i = @ptrCast(getProcAddress("glVertexAttribI3i") orelse return error.LoadError),
.glVertexAttribI4i = @ptrCast(getProcAddress("glVertexAttribI4i") orelse return error.LoadError),
.glVertexAttribI1ui = @ptrCast(getProcAddress("glVertexAttribI1ui") orelse return error.LoadError),
.glVertexAttribI2ui = @ptrCast(getProcAddress("glVertexAttribI2ui") orelse return error.LoadError),
.glVertexAttribI3ui = @ptrCast(getProcAddress("glVertexAttribI3ui") orelse return error.LoadError),
.glVertexAttribI4ui = @ptrCast(getProcAddress("glVertexAttribI4ui") orelse return error.LoadError),
.glVertexAttribI1iv = @ptrCast(getProcAddress("glVertexAttribI1iv") orelse return error.LoadError),
.glVertexAttribI2iv = @ptrCast(getProcAddress("glVertexAttribI2iv") orelse return error.LoadError),
.glVertexAttribI3iv = @ptrCast(getProcAddress("glVertexAttribI3iv") orelse return error.LoadError),
.glVertexAttribI4iv = @ptrCast(getProcAddress("glVertexAttribI4iv") orelse return error.LoadError),
.glVertexAttribI1uiv = @ptrCast(getProcAddress("glVertexAttribI1uiv") orelse return error.LoadError),
.glVertexAttribI2uiv = @ptrCast(getProcAddress("glVertexAttribI2uiv") orelse return error.LoadError),
.glVertexAttribI3uiv = @ptrCast(getProcAddress("glVertexAttribI3uiv") orelse return error.LoadError),
.glVertexAttribI4uiv = @ptrCast(getProcAddress("glVertexAttribI4uiv") orelse return error.LoadError),
.glVertexAttribI4bv = @ptrCast(getProcAddress("glVertexAttribI4bv") orelse return error.LoadError),
.glVertexAttribI4sv = @ptrCast(getProcAddress("glVertexAttribI4sv") orelse return error.LoadError),
.glVertexAttribI4ubv = @ptrCast(getProcAddress("glVertexAttribI4ubv") orelse return error.LoadError),
.glVertexAttribI4usv = @ptrCast(getProcAddress("glVertexAttribI4usv") orelse return error.LoadError),
.glGetUniformuiv = @ptrCast(getProcAddress("glGetUniformuiv") orelse return error.LoadError),
.glBindFragDataLocation = @ptrCast(getProcAddress("glBindFragDataLocation") orelse return error.LoadError),
.glGetFragDataLocation = @ptrCast(getProcAddress("glGetFragDataLocation") orelse return error.LoadError),
.glUniform1ui = @ptrCast(getProcAddress("glUniform1ui") orelse return error.LoadError),
.glUniform2ui = @ptrCast(getProcAddress("glUniform2ui") orelse return error.LoadError),
.glUniform3ui = @ptrCast(getProcAddress("glUniform3ui") orelse return error.LoadError),
.glUniform4ui = @ptrCast(getProcAddress("glUniform4ui") orelse return error.LoadError),
.glUniform1uiv = @ptrCast(getProcAddress("glUniform1uiv") orelse return error.LoadError),
.glUniform2uiv = @ptrCast(getProcAddress("glUniform2uiv") orelse return error.LoadError),
.glUniform3uiv = @ptrCast(getProcAddress("glUniform3uiv") orelse return error.LoadError),
.glUniform4uiv = @ptrCast(getProcAddress("glUniform4uiv") orelse return error.LoadError),
.glTexParameterIiv = @ptrCast(getProcAddress("glTexParameterIiv") orelse return error.LoadError),
.glTexParameterIuiv = @ptrCast(getProcAddress("glTexParameterIuiv") orelse return error.LoadError),
.glGetTexParameterIiv = @ptrCast(getProcAddress("glGetTexParameterIiv") orelse return error.LoadError),
.glGetTexParameterIuiv = @ptrCast(getProcAddress("glGetTexParameterIuiv") orelse return error.LoadError),
.glClearBufferiv = @ptrCast(getProcAddress("glClearBufferiv") orelse return error.LoadError),
.glClearBufferuiv = @ptrCast(getProcAddress("glClearBufferuiv") orelse return error.LoadError),
.glClearBufferfv = @ptrCast(getProcAddress("glClearBufferfv") orelse return error.LoadError),
.glClearBufferfi = @ptrCast(getProcAddress("glClearBufferfi") orelse return error.LoadError),
.glGetStringi = @ptrCast(getProcAddress("glGetStringi") orelse return error.LoadError),
.glIsRenderbuffer = @ptrCast(getProcAddress("glIsRenderbuffer") orelse return error.LoadError),
.glBindRenderbuffer = @ptrCast(getProcAddress("glBindRenderbuffer") orelse return error.LoadError),
.glDeleteRenderbuffers = @ptrCast(getProcAddress("glDeleteRenderbuffers") orelse return error.LoadError),
.glGenRenderbuffers = @ptrCast(getProcAddress("glGenRenderbuffers") orelse return error.LoadError),
.glRenderbufferStorage = @ptrCast(getProcAddress("glRenderbufferStorage") orelse return error.LoadError),
.glGetRenderbufferParameteriv = @ptrCast(getProcAddress("glGetRenderbufferParameteriv") orelse return error.LoadError),
.glIsFramebuffer = @ptrCast(getProcAddress("glIsFramebuffer") orelse return error.LoadError),
.glBindFramebuffer = @ptrCast(getProcAddress("glBindFramebuffer") orelse return error.LoadError),
.glDeleteFramebuffers = @ptrCast(getProcAddress("glDeleteFramebuffers") orelse return error.LoadError),
.glGenFramebuffers = @ptrCast(getProcAddress("glGenFramebuffers") orelse return error.LoadError),
.glCheckFramebufferStatus = @ptrCast(getProcAddress("glCheckFramebufferStatus") orelse return error.LoadError),
.glFramebufferTexture1D = @ptrCast(getProcAddress("glFramebufferTexture1D") orelse return error.LoadError),
.glFramebufferTexture2D = @ptrCast(getProcAddress("glFramebufferTexture2D") orelse return error.LoadError),
.glFramebufferTexture3D = @ptrCast(getProcAddress("glFramebufferTexture3D") orelse return error.LoadError),
.glFramebufferRenderbuffer = @ptrCast(getProcAddress("glFramebufferRenderbuffer") orelse return error.LoadError),
.glGetFramebufferAttachmentParameteriv = @ptrCast(getProcAddress("glGetFramebufferAttachmentParameteriv") orelse return error.LoadError),
.glGenerateMipmap = @ptrCast(getProcAddress("glGenerateMipmap") orelse return error.LoadError),
.glBlitFramebuffer = @ptrCast(getProcAddress("glBlitFramebuffer") orelse return error.LoadError),
.glRenderbufferStorageMultisample = @ptrCast(getProcAddress("glRenderbufferStorageMultisample") orelse return error.LoadError),
.glFramebufferTextureLayer = @ptrCast(getProcAddress("glFramebufferTextureLayer") orelse return error.LoadError),
.glMapBufferRange = @ptrCast(getProcAddress("glMapBufferRange") orelse return error.LoadError),
.glFlushMappedBufferRange = @ptrCast(getProcAddress("glFlushMappedBufferRange") orelse return error.LoadError),
.glBindVertexArray = @ptrCast(getProcAddress("glBindVertexArray") orelse return error.LoadError),
.glDeleteVertexArrays = @ptrCast(getProcAddress("glDeleteVertexArrays") orelse return error.LoadError),
.glGenVertexArrays = @ptrCast(getProcAddress("glGenVertexArrays") orelse return error.LoadError),
.glIsVertexArray = @ptrCast(getProcAddress("glIsVertexArray") orelse return error.LoadError),
.glDrawArraysInstanced = @ptrCast(getProcAddress("glDrawArraysInstanced") orelse return error.LoadError),
.glDrawElementsInstanced = @ptrCast(getProcAddress("glDrawElementsInstanced") orelse return error.LoadError),
.glTexBuffer = @ptrCast(getProcAddress("glTexBuffer") orelse return error.LoadError),
.glPrimitiveRestartIndex = @ptrCast(getProcAddress("glPrimitiveRestartIndex") orelse return error.LoadError),
.glCopyBufferSubData = @ptrCast(getProcAddress("glCopyBufferSubData") orelse return error.LoadError),
.glGetUniformIndices = @ptrCast(getProcAddress("glGetUniformIndices") orelse return error.LoadError),
.glGetActiveUniformsiv = @ptrCast(getProcAddress("glGetActiveUniformsiv") orelse return error.LoadError),
.glGetActiveUniformName = @ptrCast(getProcAddress("glGetActiveUniformName") orelse return error.LoadError),
.glGetUniformBlockIndex = @ptrCast(getProcAddress("glGetUniformBlockIndex") orelse return error.LoadError),
.glGetActiveUniformBlockiv = @ptrCast(getProcAddress("glGetActiveUniformBlockiv") orelse return error.LoadError),
.glGetActiveUniformBlockName = @ptrCast(getProcAddress("glGetActiveUniformBlockName") orelse return error.LoadError),
.glUniformBlockBinding = @ptrCast(getProcAddress("glUniformBlockBinding") orelse return error.LoadError),
.glDrawElementsBaseVertex = @ptrCast(getProcAddress("glDrawElementsBaseVertex") orelse return error.LoadError),
.glDrawRangeElementsBaseVertex = @ptrCast(getProcAddress("glDrawRangeElementsBaseVertex") orelse return error.LoadError),
.glDrawElementsInstancedBaseVertex = @ptrCast(getProcAddress("glDrawElementsInstancedBaseVertex") orelse return error.LoadError),
.glMultiDrawElementsBaseVertex = @ptrCast(getProcAddress("glMultiDrawElementsBaseVertex") orelse return error.LoadError),
.glProvokingVertex = @ptrCast(getProcAddress("glProvokingVertex") orelse return error.LoadError),
.glFenceSync = @ptrCast(getProcAddress("glFenceSync") orelse return error.LoadError),
.glIsSync = @ptrCast(getProcAddress("glIsSync") orelse return error.LoadError),
.glDeleteSync = @ptrCast(getProcAddress("glDeleteSync") orelse return error.LoadError),
.glClientWaitSync = @ptrCast(getProcAddress("glClientWaitSync") orelse return error.LoadError),
.glWaitSync = @ptrCast(getProcAddress("glWaitSync") orelse return error.LoadError),
.glGetInteger64v = @ptrCast(getProcAddress("glGetInteger64v") orelse return error.LoadError),
.glGetSynciv = @ptrCast(getProcAddress("glGetSynciv") orelse return error.LoadError),
.glGetInteger64i_v = @ptrCast(getProcAddress("glGetInteger64i_v") orelse return error.LoadError),
.glGetBufferParameteri64v = @ptrCast(getProcAddress("glGetBufferParameteri64v") orelse return error.LoadError),
.glFramebufferTexture = @ptrCast(getProcAddress("glFramebufferTexture") orelse return error.LoadError),
.glTexImage2DMultisample = @ptrCast(getProcAddress("glTexImage2DMultisample") orelse return error.LoadError),
.glTexImage3DMultisample = @ptrCast(getProcAddress("glTexImage3DMultisample") orelse return error.LoadError),
.glGetMultisamplefv = @ptrCast(getProcAddress("glGetMultisamplefv") orelse return error.LoadError),
.glSampleMaski = @ptrCast(getProcAddress("glSampleMaski") orelse return error.LoadError),
.glBindFragDataLocationIndexed = @ptrCast(getProcAddress("glBindFragDataLocationIndexed") orelse return error.LoadError),
.glGetFragDataIndex = @ptrCast(getProcAddress("glGetFragDataIndex") orelse return error.LoadError),
.glGenSamplers = @ptrCast(getProcAddress("glGenSamplers") orelse return error.LoadError),
.glDeleteSamplers = @ptrCast(getProcAddress("glDeleteSamplers") orelse return error.LoadError),
.glIsSampler = @ptrCast(getProcAddress("glIsSampler") orelse return error.LoadError),
.glBindSampler = @ptrCast(getProcAddress("glBindSampler") orelse return error.LoadError),
.glSamplerParameteri = @ptrCast(getProcAddress("glSamplerParameteri") orelse return error.LoadError),
.glSamplerParameteriv = @ptrCast(getProcAddress("glSamplerParameteriv") orelse return error.LoadError),
.glSamplerParameterf = @ptrCast(getProcAddress("glSamplerParameterf") orelse return error.LoadError),
.glSamplerParameterfv = @ptrCast(getProcAddress("glSamplerParameterfv") orelse return error.LoadError),
.glSamplerParameterIiv = @ptrCast(getProcAddress("glSamplerParameterIiv") orelse return error.LoadError),
.glSamplerParameterIuiv = @ptrCast(getProcAddress("glSamplerParameterIuiv") orelse return error.LoadError),
.glGetSamplerParameteriv = @ptrCast(getProcAddress("glGetSamplerParameteriv") orelse return error.LoadError),
.glGetSamplerParameterIiv = @ptrCast(getProcAddress("glGetSamplerParameterIiv") orelse return error.LoadError),
.glGetSamplerParameterfv = @ptrCast(getProcAddress("glGetSamplerParameterfv") orelse return error.LoadError),
.glGetSamplerParameterIuiv = @ptrCast(getProcAddress("glGetSamplerParameterIuiv") orelse return error.LoadError),
.glQueryCounter = @ptrCast(getProcAddress("glQueryCounter") orelse return error.LoadError),
.glGetQueryObjecti64v = @ptrCast(getProcAddress("glGetQueryObjecti64v") orelse return error.LoadError),
.glGetQueryObjectui64v = @ptrCast(getProcAddress("glGetQueryObjectui64v") orelse return error.LoadError),
.glVertexAttribDivisor = @ptrCast(getProcAddress("glVertexAttribDivisor") orelse return error.LoadError),
.glVertexAttribP1ui = @ptrCast(getProcAddress("glVertexAttribP1ui") orelse return error.LoadError),
.glVertexAttribP1uiv = @ptrCast(getProcAddress("glVertexAttribP1uiv") orelse return error.LoadError),
.glVertexAttribP2ui = @ptrCast(getProcAddress("glVertexAttribP2ui") orelse return error.LoadError),
.glVertexAttribP2uiv = @ptrCast(getProcAddress("glVertexAttribP2uiv") orelse return error.LoadError),
.glVertexAttribP3ui = @ptrCast(getProcAddress("glVertexAttribP3ui") orelse return error.LoadError),
.glVertexAttribP3uiv = @ptrCast(getProcAddress("glVertexAttribP3uiv") orelse return error.LoadError),
.glVertexAttribP4ui = @ptrCast(getProcAddress("glVertexAttribP4ui") orelse return error.LoadError),
.glVertexAttribP4uiv = @ptrCast(getProcAddress("glVertexAttribP4uiv") orelse return error.LoadError),
.glVertexP2ui = @ptrCast(getProcAddress("glVertexP2ui") orelse return error.LoadError),
.glVertexP2uiv = @ptrCast(getProcAddress("glVertexP2uiv") orelse return error.LoadError),
.glVertexP3ui = @ptrCast(getProcAddress("glVertexP3ui") orelse return error.LoadError),
.glVertexP3uiv = @ptrCast(getProcAddress("glVertexP3uiv") orelse return error.LoadError),
.glVertexP4ui = @ptrCast(getProcAddress("glVertexP4ui") orelse return error.LoadError),
.glVertexP4uiv = @ptrCast(getProcAddress("glVertexP4uiv") orelse return error.LoadError),
.glTexCoordP1ui = @ptrCast(getProcAddress("glTexCoordP1ui") orelse return error.LoadError),
.glTexCoordP1uiv = @ptrCast(getProcAddress("glTexCoordP1uiv") orelse return error.LoadError),
.glTexCoordP2ui = @ptrCast(getProcAddress("glTexCoordP2ui") orelse return error.LoadError),
.glTexCoordP2uiv = @ptrCast(getProcAddress("glTexCoordP2uiv") orelse return error.LoadError),
.glTexCoordP3ui = @ptrCast(getProcAddress("glTexCoordP3ui") orelse return error.LoadError),
.glTexCoordP3uiv = @ptrCast(getProcAddress("glTexCoordP3uiv") orelse return error.LoadError),
.glTexCoordP4ui = @ptrCast(getProcAddress("glTexCoordP4ui") orelse return error.LoadError),
.glTexCoordP4uiv = @ptrCast(getProcAddress("glTexCoordP4uiv") orelse return error.LoadError),
.glMultiTexCoordP1ui = @ptrCast(getProcAddress("glMultiTexCoordP1ui") orelse return error.LoadError),
.glMultiTexCoordP1uiv = @ptrCast(getProcAddress("glMultiTexCoordP1uiv") orelse return error.LoadError),
.glMultiTexCoordP2ui = @ptrCast(getProcAddress("glMultiTexCoordP2ui") orelse return error.LoadError),
.glMultiTexCoordP2uiv = @ptrCast(getProcAddress("glMultiTexCoordP2uiv") orelse return error.LoadError),
.glMultiTexCoordP3ui = @ptrCast(getProcAddress("glMultiTexCoordP3ui") orelse return error.LoadError),
.glMultiTexCoordP3uiv = @ptrCast(getProcAddress("glMultiTexCoordP3uiv") orelse return error.LoadError),
.glMultiTexCoordP4ui = @ptrCast(getProcAddress("glMultiTexCoordP4ui") orelse return error.LoadError),
.glMultiTexCoordP4uiv = @ptrCast(getProcAddress("glMultiTexCoordP4uiv") orelse return error.LoadError),
.glNormalP3ui = @ptrCast(getProcAddress("glNormalP3ui") orelse return error.LoadError),
.glNormalP3uiv = @ptrCast(getProcAddress("glNormalP3uiv") orelse return error.LoadError),
.glColorP3ui = @ptrCast(getProcAddress("glColorP3ui") orelse return error.LoadError),
.glColorP3uiv = @ptrCast(getProcAddress("glColorP3uiv") orelse return error.LoadError),
.glColorP4ui = @ptrCast(getProcAddress("glColorP4ui") orelse return error.LoadError),
.glColorP4uiv = @ptrCast(getProcAddress("glColorP4uiv") orelse return error.LoadError),
.glSecondaryColorP3ui = @ptrCast(getProcAddress("glSecondaryColorP3ui") orelse return error.LoadError),
.glSecondaryColorP3uiv = @ptrCast(getProcAddress("glSecondaryColorP3uiv") orelse return error.LoadError),
.glMinSampleShading = @ptrCast(getProcAddress("glMinSampleShading") orelse return error.LoadError),
.glBlendEquationi = @ptrCast(getProcAddress("glBlendEquationi") orelse return error.LoadError),
.glBlendEquationSeparatei = @ptrCast(getProcAddress("glBlendEquationSeparatei") orelse return error.LoadError),
.glBlendFunci = @ptrCast(getProcAddress("glBlendFunci") orelse return error.LoadError),
.glBlendFuncSeparatei = @ptrCast(getProcAddress("glBlendFuncSeparatei") orelse return error.LoadError),
.glDrawArraysIndirect = @ptrCast(getProcAddress("glDrawArraysIndirect") orelse return error.LoadError),
.glDrawElementsIndirect = @ptrCast(getProcAddress("glDrawElementsIndirect") orelse return error.LoadError),
.glUniform1d = @ptrCast(getProcAddress("glUniform1d") orelse return error.LoadError),
.glUniform2d = @ptrCast(getProcAddress("glUniform2d") orelse return error.LoadError),
.glUniform3d = @ptrCast(getProcAddress("glUniform3d") orelse return error.LoadError),
.glUniform4d = @ptrCast(getProcAddress("glUniform4d") orelse return error.LoadError),
.glUniform1dv = @ptrCast(getProcAddress("glUniform1dv") orelse return error.LoadError),
.glUniform2dv = @ptrCast(getProcAddress("glUniform2dv") orelse return error.LoadError),
.glUniform3dv = @ptrCast(getProcAddress("glUniform3dv") orelse return error.LoadError),
.glUniform4dv = @ptrCast(getProcAddress("glUniform4dv") orelse return error.LoadError),
.glUniformMatrix2dv = @ptrCast(getProcAddress("glUniformMatrix2dv") orelse return error.LoadError),
.glUniformMatrix3dv = @ptrCast(getProcAddress("glUniformMatrix3dv") orelse return error.LoadError),
.glUniformMatrix4dv = @ptrCast(getProcAddress("glUniformMatrix4dv") orelse return error.LoadError),
.glUniformMatrix2x3dv = @ptrCast(getProcAddress("glUniformMatrix2x3dv") orelse return error.LoadError),
.glUniformMatrix2x4dv = @ptrCast(getProcAddress("glUniformMatrix2x4dv") orelse return error.LoadError),
.glUniformMatrix3x2dv = @ptrCast(getProcAddress("glUniformMatrix3x2dv") orelse return error.LoadError),
.glUniformMatrix3x4dv = @ptrCast(getProcAddress("glUniformMatrix3x4dv") orelse return error.LoadError),
.glUniformMatrix4x2dv = @ptrCast(getProcAddress("glUniformMatrix4x2dv") orelse return error.LoadError),
.glUniformMatrix4x3dv = @ptrCast(getProcAddress("glUniformMatrix4x3dv") orelse return error.LoadError),
.glGetUniformdv = @ptrCast(getProcAddress("glGetUniformdv") orelse return error.LoadError),
.glGetSubroutineUniformLocation = @ptrCast(getProcAddress("glGetSubroutineUniformLocation") orelse return error.LoadError),
.glGetSubroutineIndex = @ptrCast(getProcAddress("glGetSubroutineIndex") orelse return error.LoadError),
.glGetActiveSubroutineUniformiv = @ptrCast(getProcAddress("glGetActiveSubroutineUniformiv") orelse return error.LoadError),
.glGetActiveSubroutineUniformName = @ptrCast(getProcAddress("glGetActiveSubroutineUniformName") orelse return error.LoadError),
.glGetActiveSubroutineName = @ptrCast(getProcAddress("glGetActiveSubroutineName") orelse return error.LoadError),
.glUniformSubroutinesuiv = @ptrCast(getProcAddress("glUniformSubroutinesuiv") orelse return error.LoadError),
.glGetUniformSubroutineuiv = @ptrCast(getProcAddress("glGetUniformSubroutineuiv") orelse return error.LoadError),
.glGetProgramStageiv = @ptrCast(getProcAddress("glGetProgramStageiv") orelse return error.LoadError),
.glPatchParameteri = @ptrCast(getProcAddress("glPatchParameteri") orelse return error.LoadError),
.glPatchParameterfv = @ptrCast(getProcAddress("glPatchParameterfv") orelse return error.LoadError),
.glBindTransformFeedback = @ptrCast(getProcAddress("glBindTransformFeedback") orelse return error.LoadError),
.glDeleteTransformFeedbacks = @ptrCast(getProcAddress("glDeleteTransformFeedbacks") orelse return error.LoadError),
.glGenTransformFeedbacks = @ptrCast(getProcAddress("glGenTransformFeedbacks") orelse return error.LoadError),
.glIsTransformFeedback = @ptrCast(getProcAddress("glIsTransformFeedback") orelse return error.LoadError),
.glPauseTransformFeedback = @ptrCast(getProcAddress("glPauseTransformFeedback") orelse return error.LoadError),
.glResumeTransformFeedback = @ptrCast(getProcAddress("glResumeTransformFeedback") orelse return error.LoadError),
.glDrawTransformFeedback = @ptrCast(getProcAddress("glDrawTransformFeedback") orelse return error.LoadError),
.glDrawTransformFeedbackStream = @ptrCast(getProcAddress("glDrawTransformFeedbackStream") orelse return error.LoadError),
.glBeginQueryIndexed = @ptrCast(getProcAddress("glBeginQueryIndexed") orelse return error.LoadError),
.glEndQueryIndexed = @ptrCast(getProcAddress("glEndQueryIndexed") orelse return error.LoadError),
.glGetQueryIndexediv = @ptrCast(getProcAddress("glGetQueryIndexediv") orelse return error.LoadError),
.glReleaseShaderCompiler = @ptrCast(getProcAddress("glReleaseShaderCompiler") orelse return error.LoadError),
.glShaderBinary = @ptrCast(getProcAddress("glShaderBinary") orelse return error.LoadError),
.glGetShaderPrecisionFormat = @ptrCast(getProcAddress("glGetShaderPrecisionFormat") orelse return error.LoadError),
.glDepthRangef = @ptrCast(getProcAddress("glDepthRangef") orelse return error.LoadError),
.glClearDepthf = @ptrCast(getProcAddress("glClearDepthf") orelse return error.LoadError),
.glGetProgramBinary = @ptrCast(getProcAddress("glGetProgramBinary") orelse return error.LoadError),
.glProgramBinary = @ptrCast(getProcAddress("glProgramBinary") orelse return error.LoadError),
.glProgramParameteri = @ptrCast(getProcAddress("glProgramParameteri") orelse return error.LoadError),
.glUseProgramStages = @ptrCast(getProcAddress("glUseProgramStages") orelse return error.LoadError),
.glActiveShaderProgram = @ptrCast(getProcAddress("glActiveShaderProgram") orelse return error.LoadError),
.glCreateShaderProgramv = @ptrCast(getProcAddress("glCreateShaderProgramv") orelse return error.LoadError),
.glBindProgramPipeline = @ptrCast(getProcAddress("glBindProgramPipeline") orelse return error.LoadError),
.glDeleteProgramPipelines = @ptrCast(getProcAddress("glDeleteProgramPipelines") orelse return error.LoadError),
.glGenProgramPipelines = @ptrCast(getProcAddress("glGenProgramPipelines") orelse return error.LoadError),
.glIsProgramPipeline = @ptrCast(getProcAddress("glIsProgramPipeline") orelse return error.LoadError),
.glGetProgramPipelineiv = @ptrCast(getProcAddress("glGetProgramPipelineiv") orelse return error.LoadError),
.glProgramUniform1i = @ptrCast(getProcAddress("glProgramUniform1i") orelse return error.LoadError),
.glProgramUniform1iv = @ptrCast(getProcAddress("glProgramUniform1iv") orelse return error.LoadError),
.glProgramUniform1f = @ptrCast(getProcAddress("glProgramUniform1f") orelse return error.LoadError),
.glProgramUniform1fv = @ptrCast(getProcAddress("glProgramUniform1fv") orelse return error.LoadError),
.glProgramUniform1d = @ptrCast(getProcAddress("glProgramUniform1d") orelse return error.LoadError),
.glProgramUniform1dv = @ptrCast(getProcAddress("glProgramUniform1dv") orelse return error.LoadError),
.glProgramUniform1ui = @ptrCast(getProcAddress("glProgramUniform1ui") orelse return error.LoadError),
.glProgramUniform1uiv = @ptrCast(getProcAddress("glProgramUniform1uiv") orelse return error.LoadError),
.glProgramUniform2i = @ptrCast(getProcAddress("glProgramUniform2i") orelse return error.LoadError),
.glProgramUniform2iv = @ptrCast(getProcAddress("glProgramUniform2iv") orelse return error.LoadError),
.glProgramUniform2f = @ptrCast(getProcAddress("glProgramUniform2f") orelse return error.LoadError),
.glProgramUniform2fv = @ptrCast(getProcAddress("glProgramUniform2fv") orelse return error.LoadError),
.glProgramUniform2d = @ptrCast(getProcAddress("glProgramUniform2d") orelse return error.LoadError),
.glProgramUniform2dv = @ptrCast(getProcAddress("glProgramUniform2dv") orelse return error.LoadError),
.glProgramUniform2ui = @ptrCast(getProcAddress("glProgramUniform2ui") orelse return error.LoadError),
.glProgramUniform2uiv = @ptrCast(getProcAddress("glProgramUniform2uiv") orelse return error.LoadError),
.glProgramUniform3i = @ptrCast(getProcAddress("glProgramUniform3i") orelse return error.LoadError),
.glProgramUniform3iv = @ptrCast(getProcAddress("glProgramUniform3iv") orelse return error.LoadError),
.glProgramUniform3f = @ptrCast(getProcAddress("glProgramUniform3f") orelse return error.LoadError),
.glProgramUniform3fv = @ptrCast(getProcAddress("glProgramUniform3fv") orelse return error.LoadError),
.glProgramUniform3d = @ptrCast(getProcAddress("glProgramUniform3d") orelse return error.LoadError),
.glProgramUniform3dv = @ptrCast(getProcAddress("glProgramUniform3dv") orelse return error.LoadError),
.glProgramUniform3ui = @ptrCast(getProcAddress("glProgramUniform3ui") orelse return error.LoadError),
.glProgramUniform3uiv = @ptrCast(getProcAddress("glProgramUniform3uiv") orelse return error.LoadError),
.glProgramUniform4i = @ptrCast(getProcAddress("glProgramUniform4i") orelse return error.LoadError),
.glProgramUniform4iv = @ptrCast(getProcAddress("glProgramUniform4iv") orelse return error.LoadError),
.glProgramUniform4f = @ptrCast(getProcAddress("glProgramUniform4f") orelse return error.LoadError),
.glProgramUniform4fv = @ptrCast(getProcAddress("glProgramUniform4fv") orelse return error.LoadError),
.glProgramUniform4d = @ptrCast(getProcAddress("glProgramUniform4d") orelse return error.LoadError),
.glProgramUniform4dv = @ptrCast(getProcAddress("glProgramUniform4dv") orelse return error.LoadError),
.glProgramUniform4ui = @ptrCast(getProcAddress("glProgramUniform4ui") orelse return error.LoadError),
.glProgramUniform4uiv = @ptrCast(getProcAddress("glProgramUniform4uiv") orelse return error.LoadError),
.glProgramUniformMatrix2fv = @ptrCast(getProcAddress("glProgramUniformMatrix2fv") orelse return error.LoadError),
.glProgramUniformMatrix3fv = @ptrCast(getProcAddress("glProgramUniformMatrix3fv") orelse return error.LoadError),
.glProgramUniformMatrix4fv = @ptrCast(getProcAddress("glProgramUniformMatrix4fv") orelse return error.LoadError),
.glProgramUniformMatrix2dv = @ptrCast(getProcAddress("glProgramUniformMatrix2dv") orelse return error.LoadError),
.glProgramUniformMatrix3dv = @ptrCast(getProcAddress("glProgramUniformMatrix3dv") orelse return error.LoadError),
.glProgramUniformMatrix4dv = @ptrCast(getProcAddress("glProgramUniformMatrix4dv") orelse return error.LoadError),
.glProgramUniformMatrix2x3fv = @ptrCast(getProcAddress("glProgramUniformMatrix2x3fv") orelse return error.LoadError),
.glProgramUniformMatrix3x2fv = @ptrCast(getProcAddress("glProgramUniformMatrix3x2fv") orelse return error.LoadError),
.glProgramUniformMatrix2x4fv = @ptrCast(getProcAddress("glProgramUniformMatrix2x4fv") orelse return error.LoadError),
.glProgramUniformMatrix4x2fv = @ptrCast(getProcAddress("glProgramUniformMatrix4x2fv") orelse return error.LoadError),
.glProgramUniformMatrix3x4fv = @ptrCast(getProcAddress("glProgramUniformMatrix3x4fv") orelse return error.LoadError),
.glProgramUniformMatrix4x3fv = @ptrCast(getProcAddress("glProgramUniformMatrix4x3fv") orelse return error.LoadError),
.glProgramUniformMatrix2x3dv = @ptrCast(getProcAddress("glProgramUniformMatrix2x3dv") orelse return error.LoadError),
.glProgramUniformMatrix3x2dv = @ptrCast(getProcAddress("glProgramUniformMatrix3x2dv") orelse return error.LoadError),
.glProgramUniformMatrix2x4dv = @ptrCast(getProcAddress("glProgramUniformMatrix2x4dv") orelse return error.LoadError),
.glProgramUniformMatrix4x2dv = @ptrCast(getProcAddress("glProgramUniformMatrix4x2dv") orelse return error.LoadError),
.glProgramUniformMatrix3x4dv = @ptrCast(getProcAddress("glProgramUniformMatrix3x4dv") orelse return error.LoadError),
.glProgramUniformMatrix4x3dv = @ptrCast(getProcAddress("glProgramUniformMatrix4x3dv") orelse return error.LoadError),
.glValidateProgramPipeline = @ptrCast(getProcAddress("glValidateProgramPipeline") orelse return error.LoadError),
.glGetProgramPipelineInfoLog = @ptrCast(getProcAddress("glGetProgramPipelineInfoLog") orelse return error.LoadError),
.glVertexAttribL1d = @ptrCast(getProcAddress("glVertexAttribL1d") orelse return error.LoadError),
.glVertexAttribL2d = @ptrCast(getProcAddress("glVertexAttribL2d") orelse return error.LoadError),
.glVertexAttribL3d = @ptrCast(getProcAddress("glVertexAttribL3d") orelse return error.LoadError),
.glVertexAttribL4d = @ptrCast(getProcAddress("glVertexAttribL4d") orelse return error.LoadError),
.glVertexAttribL1dv = @ptrCast(getProcAddress("glVertexAttribL1dv") orelse return error.LoadError),
.glVertexAttribL2dv = @ptrCast(getProcAddress("glVertexAttribL2dv") orelse return error.LoadError),
.glVertexAttribL3dv = @ptrCast(getProcAddress("glVertexAttribL3dv") orelse return error.LoadError),
.glVertexAttribL4dv = @ptrCast(getProcAddress("glVertexAttribL4dv") orelse return error.LoadError),
.glVertexAttribLPointer = @ptrCast(getProcAddress("glVertexAttribLPointer") orelse return error.LoadError),
.glGetVertexAttribLdv = @ptrCast(getProcAddress("glGetVertexAttribLdv") orelse return error.LoadError),
.glViewportArrayv = @ptrCast(getProcAddress("glViewportArrayv") orelse return error.LoadError),
.glViewportIndexedf = @ptrCast(getProcAddress("glViewportIndexedf") orelse return error.LoadError),
.glViewportIndexedfv = @ptrCast(getProcAddress("glViewportIndexedfv") orelse return error.LoadError),
.glScissorArrayv = @ptrCast(getProcAddress("glScissorArrayv") orelse return error.LoadError),
.glScissorIndexed = @ptrCast(getProcAddress("glScissorIndexed") orelse return error.LoadError),
.glScissorIndexedv = @ptrCast(getProcAddress("glScissorIndexedv") orelse return error.LoadError),
.glDepthRangeArrayv = @ptrCast(getProcAddress("glDepthRangeArrayv") orelse return error.LoadError),
.glDepthRangeIndexed = @ptrCast(getProcAddress("glDepthRangeIndexed") orelse return error.LoadError),
.glGetFloati_v = @ptrCast(getProcAddress("glGetFloati_v") orelse return error.LoadError),
.glGetDoublei_v = @ptrCast(getProcAddress("glGetDoublei_v") orelse return error.LoadError),
.glDrawArraysInstancedBaseInstance = @ptrCast(getProcAddress("glDrawArraysInstancedBaseInstance") orelse return error.LoadError),
.glDrawElementsInstancedBaseInstance = @ptrCast(getProcAddress("glDrawElementsInstancedBaseInstance") orelse return error.LoadError),
.glDrawElementsInstancedBaseVertexBaseInstance = @ptrCast(getProcAddress("glDrawElementsInstancedBaseVertexBaseInstance") orelse return error.LoadError),
.glGetInternalformativ = @ptrCast(getProcAddress("glGetInternalformativ") orelse return error.LoadError),
.glGetActiveAtomicCounterBufferiv = @ptrCast(getProcAddress("glGetActiveAtomicCounterBufferiv") orelse return error.LoadError),
.glBindImageTexture = @ptrCast(getProcAddress("glBindImageTexture") orelse return error.LoadError),
.glMemoryBarrier = @ptrCast(getProcAddress("glMemoryBarrier") orelse return error.LoadError),
.glTexStorage1D = @ptrCast(getProcAddress("glTexStorage1D") orelse return error.LoadError),
.glTexStorage2D = @ptrCast(getProcAddress("glTexStorage2D") orelse return error.LoadError),
.glTexStorage3D = @ptrCast(getProcAddress("glTexStorage3D") orelse return error.LoadError),
.glDrawTransformFeedbackInstanced = @ptrCast(getProcAddress("glDrawTransformFeedbackInstanced") orelse return error.LoadError),
.glDrawTransformFeedbackStreamInstanced = @ptrCast(getProcAddress("glDrawTransformFeedbackStreamInstanced") orelse return error.LoadError),
.glClearBufferData = @ptrCast(getProcAddress("glClearBufferData") orelse return error.LoadError),
.glClearBufferSubData = @ptrCast(getProcAddress("glClearBufferSubData") orelse return error.LoadError),
.glDispatchCompute = @ptrCast(getProcAddress("glDispatchCompute") orelse return error.LoadError),
.glDispatchComputeIndirect = @ptrCast(getProcAddress("glDispatchComputeIndirect") orelse return error.LoadError),
.glCopyImageSubData = @ptrCast(getProcAddress("glCopyImageSubData") orelse return error.LoadError),
.glFramebufferParameteri = @ptrCast(getProcAddress("glFramebufferParameteri") orelse return error.LoadError),
.glGetFramebufferParameteriv = @ptrCast(getProcAddress("glGetFramebufferParameteriv") orelse return error.LoadError),
.glGetInternalformati64v = @ptrCast(getProcAddress("glGetInternalformati64v") orelse return error.LoadError),
.glInvalidateTexSubImage = @ptrCast(getProcAddress("glInvalidateTexSubImage") orelse return error.LoadError),
.glInvalidateTexImage = @ptrCast(getProcAddress("glInvalidateTexImage") orelse return error.LoadError),
.glInvalidateBufferSubData = @ptrCast(getProcAddress("glInvalidateBufferSubData") orelse return error.LoadError),
.glInvalidateBufferData = @ptrCast(getProcAddress("glInvalidateBufferData") orelse return error.LoadError),
.glInvalidateFramebuffer = @ptrCast(getProcAddress("glInvalidateFramebuffer") orelse return error.LoadError),
.glInvalidateSubFramebuffer = @ptrCast(getProcAddress("glInvalidateSubFramebuffer") orelse return error.LoadError),
.glMultiDrawArraysIndirect = @ptrCast(getProcAddress("glMultiDrawArraysIndirect") orelse return error.LoadError),
.glMultiDrawElementsIndirect = @ptrCast(getProcAddress("glMultiDrawElementsIndirect") orelse return error.LoadError),
.glGetProgramInterfaceiv = @ptrCast(getProcAddress("glGetProgramInterfaceiv") orelse return error.LoadError),
.glGetProgramResourceIndex = @ptrCast(getProcAddress("glGetProgramResourceIndex") orelse return error.LoadError),
.glGetProgramResourceName = @ptrCast(getProcAddress("glGetProgramResourceName") orelse return error.LoadError),
.glGetProgramResourceiv = @ptrCast(getProcAddress("glGetProgramResourceiv") orelse return error.LoadError),
.glGetProgramResourceLocation = @ptrCast(getProcAddress("glGetProgramResourceLocation") orelse return error.LoadError),
.glGetProgramResourceLocationIndex = @ptrCast(getProcAddress("glGetProgramResourceLocationIndex") orelse return error.LoadError),
.glShaderStorageBlockBinding = @ptrCast(getProcAddress("glShaderStorageBlockBinding") orelse return error.LoadError),
.glTexBufferRange = @ptrCast(getProcAddress("glTexBufferRange") orelse return error.LoadError),
.glTexStorage2DMultisample = @ptrCast(getProcAddress("glTexStorage2DMultisample") orelse return error.LoadError),
.glTexStorage3DMultisample = @ptrCast(getProcAddress("glTexStorage3DMultisample") orelse return error.LoadError),
.glTextureView = @ptrCast(getProcAddress("glTextureView") orelse return error.LoadError),
.glBindVertexBuffer = @ptrCast(getProcAddress("glBindVertexBuffer") orelse return error.LoadError),
.glVertexAttribFormat = @ptrCast(getProcAddress("glVertexAttribFormat") orelse return error.LoadError),
.glVertexAttribIFormat = @ptrCast(getProcAddress("glVertexAttribIFormat") orelse return error.LoadError),
.glVertexAttribLFormat = @ptrCast(getProcAddress("glVertexAttribLFormat") orelse return error.LoadError),
.glVertexAttribBinding = @ptrCast(getProcAddress("glVertexAttribBinding") orelse return error.LoadError),
.glVertexBindingDivisor = @ptrCast(getProcAddress("glVertexBindingDivisor") orelse return error.LoadError),
.glDebugMessageControl = @ptrCast(getProcAddress("glDebugMessageControl") orelse return error.LoadError),
.glDebugMessageInsert = @ptrCast(getProcAddress("glDebugMessageInsert") orelse return error.LoadError),
.glDebugMessageCallback = @ptrCast(getProcAddress("glDebugMessageCallback") orelse return error.LoadError),
.glGetDebugMessageLog = @ptrCast(getProcAddress("glGetDebugMessageLog") orelse return error.LoadError),
.glPushDebugGroup = @ptrCast(getProcAddress("glPushDebugGroup") orelse return error.LoadError),
.glPopDebugGroup = @ptrCast(getProcAddress("glPopDebugGroup") orelse return error.LoadError),
.glObjectLabel = @ptrCast(getProcAddress("glObjectLabel") orelse return error.LoadError),
.glGetObjectLabel = @ptrCast(getProcAddress("glGetObjectLabel") orelse return error.LoadError),
.glObjectPtrLabel = @ptrCast(getProcAddress("glObjectPtrLabel") orelse return error.LoadError),
.glGetObjectPtrLabel = @ptrCast(getProcAddress("glGetObjectPtrLabel") orelse return error.LoadError),
.glBufferStorage = @ptrCast(getProcAddress("glBufferStorage") orelse return error.LoadError),
.glClearTexImage = @ptrCast(getProcAddress("glClearTexImage") orelse return error.LoadError),
.glClearTexSubImage = @ptrCast(getProcAddress("glClearTexSubImage") orelse return error.LoadError),
.glBindBuffersBase = @ptrCast(getProcAddress("glBindBuffersBase") orelse return error.LoadError),
.glBindBuffersRange = @ptrCast(getProcAddress("glBindBuffersRange") orelse return error.LoadError),
.glBindTextures = @ptrCast(getProcAddress("glBindTextures") orelse return error.LoadError),
.glBindSamplers = @ptrCast(getProcAddress("glBindSamplers") orelse return error.LoadError),
.glBindImageTextures = @ptrCast(getProcAddress("glBindImageTextures") orelse return error.LoadError),
.glBindVertexBuffers = @ptrCast(getProcAddress("glBindVertexBuffers") orelse return error.LoadError),
.glClipControl = @ptrCast(getProcAddress("glClipControl") orelse return error.LoadError),
.glCreateTransformFeedbacks = @ptrCast(getProcAddress("glCreateTransformFeedbacks") orelse return error.LoadError),
.glTransformFeedbackBufferBase = @ptrCast(getProcAddress("glTransformFeedbackBufferBase") orelse return error.LoadError),
.glTransformFeedbackBufferRange = @ptrCast(getProcAddress("glTransformFeedbackBufferRange") orelse return error.LoadError),
.glGetTransformFeedbackiv = @ptrCast(getProcAddress("glGetTransformFeedbackiv") orelse return error.LoadError),
.glGetTransformFeedbacki_v = @ptrCast(getProcAddress("glGetTransformFeedbacki_v") orelse return error.LoadError),
.glGetTransformFeedbacki64_v = @ptrCast(getProcAddress("glGetTransformFeedbacki64_v") orelse return error.LoadError),
.glCreateBuffers = @ptrCast(getProcAddress("glCreateBuffers") orelse return error.LoadError),
.glNamedBufferStorage = @ptrCast(getProcAddress("glNamedBufferStorage") orelse return error.LoadError),
.glNamedBufferData = @ptrCast(getProcAddress("glNamedBufferData") orelse return error.LoadError),
.glNamedBufferSubData = @ptrCast(getProcAddress("glNamedBufferSubData") orelse return error.LoadError),
.glCopyNamedBufferSubData = @ptrCast(getProcAddress("glCopyNamedBufferSubData") orelse return error.LoadError),
.glClearNamedBufferData = @ptrCast(getProcAddress("glClearNamedBufferData") orelse return error.LoadError),
.glClearNamedBufferSubData = @ptrCast(getProcAddress("glClearNamedBufferSubData") orelse return error.LoadError),
.glMapNamedBuffer = @ptrCast(getProcAddress("glMapNamedBuffer") orelse return error.LoadError),
.glMapNamedBufferRange = @ptrCast(getProcAddress("glMapNamedBufferRange") orelse return error.LoadError),
.glUnmapNamedBuffer = @ptrCast(getProcAddress("glUnmapNamedBuffer") orelse return error.LoadError),
.glFlushMappedNamedBufferRange = @ptrCast(getProcAddress("glFlushMappedNamedBufferRange") orelse return error.LoadError),
.glGetNamedBufferParameteriv = @ptrCast(getProcAddress("glGetNamedBufferParameteriv") orelse return error.LoadError),
.glGetNamedBufferParameteri64v = @ptrCast(getProcAddress("glGetNamedBufferParameteri64v") orelse return error.LoadError),
.glGetNamedBufferPointerv = @ptrCast(getProcAddress("glGetNamedBufferPointerv") orelse return error.LoadError),
.glGetNamedBufferSubData = @ptrCast(getProcAddress("glGetNamedBufferSubData") orelse return error.LoadError),
.glCreateFramebuffers = @ptrCast(getProcAddress("glCreateFramebuffers") orelse return error.LoadError),
.glNamedFramebufferRenderbuffer = @ptrCast(getProcAddress("glNamedFramebufferRenderbuffer") orelse return error.LoadError),
.glNamedFramebufferParameteri = @ptrCast(getProcAddress("glNamedFramebufferParameteri") orelse return error.LoadError),
.glNamedFramebufferTexture = @ptrCast(getProcAddress("glNamedFramebufferTexture") orelse return error.LoadError),
.glNamedFramebufferTextureLayer = @ptrCast(getProcAddress("glNamedFramebufferTextureLayer") orelse return error.LoadError),
.glNamedFramebufferDrawBuffer = @ptrCast(getProcAddress("glNamedFramebufferDrawBuffer") orelse return error.LoadError),
.glNamedFramebufferDrawBuffers = @ptrCast(getProcAddress("glNamedFramebufferDrawBuffers") orelse return error.LoadError),
.glNamedFramebufferReadBuffer = @ptrCast(getProcAddress("glNamedFramebufferReadBuffer") orelse return error.LoadError),
.glInvalidateNamedFramebufferData = @ptrCast(getProcAddress("glInvalidateNamedFramebufferData") orelse return error.LoadError),
.glInvalidateNamedFramebufferSubData = @ptrCast(getProcAddress("glInvalidateNamedFramebufferSubData") orelse return error.LoadError),
.glClearNamedFramebufferiv = @ptrCast(getProcAddress("glClearNamedFramebufferiv") orelse return error.LoadError),
.glClearNamedFramebufferuiv = @ptrCast(getProcAddress("glClearNamedFramebufferuiv") orelse return error.LoadError),
.glClearNamedFramebufferfv = @ptrCast(getProcAddress("glClearNamedFramebufferfv") orelse return error.LoadError),
.glClearNamedFramebufferfi = @ptrCast(getProcAddress("glClearNamedFramebufferfi") orelse return error.LoadError),
.glBlitNamedFramebuffer = @ptrCast(getProcAddress("glBlitNamedFramebuffer") orelse return error.LoadError),
.glCheckNamedFramebufferStatus = @ptrCast(getProcAddress("glCheckNamedFramebufferStatus") orelse return error.LoadError),
.glGetNamedFramebufferParameteriv = @ptrCast(getProcAddress("glGetNamedFramebufferParameteriv") orelse return error.LoadError),
.glGetNamedFramebufferAttachmentParameteriv = @ptrCast(getProcAddress("glGetNamedFramebufferAttachmentParameteriv") orelse return error.LoadError),
.glCreateRenderbuffers = @ptrCast(getProcAddress("glCreateRenderbuffers") orelse return error.LoadError),
.glNamedRenderbufferStorage = @ptrCast(getProcAddress("glNamedRenderbufferStorage") orelse return error.LoadError),
.glNamedRenderbufferStorageMultisample = @ptrCast(getProcAddress("glNamedRenderbufferStorageMultisample") orelse return error.LoadError),
.glGetNamedRenderbufferParameteriv = @ptrCast(getProcAddress("glGetNamedRenderbufferParameteriv") orelse return error.LoadError),
.glCreateTextures = @ptrCast(getProcAddress("glCreateTextures") orelse return error.LoadError),
.glTextureBuffer = @ptrCast(getProcAddress("glTextureBuffer") orelse return error.LoadError),
.glTextureBufferRange = @ptrCast(getProcAddress("glTextureBufferRange") orelse return error.LoadError),
.glTextureStorage1D = @ptrCast(getProcAddress("glTextureStorage1D") orelse return error.LoadError),
.glTextureStorage2D = @ptrCast(getProcAddress("glTextureStorage2D") orelse return error.LoadError),
.glTextureStorage3D = @ptrCast(getProcAddress("glTextureStorage3D") orelse return error.LoadError),
.glTextureStorage2DMultisample = @ptrCast(getProcAddress("glTextureStorage2DMultisample") orelse return error.LoadError),
.glTextureStorage3DMultisample = @ptrCast(getProcAddress("glTextureStorage3DMultisample") orelse return error.LoadError),
.glTextureSubImage1D = @ptrCast(getProcAddress("glTextureSubImage1D") orelse return error.LoadError),
.glTextureSubImage2D = @ptrCast(getProcAddress("glTextureSubImage2D") orelse return error.LoadError),
.glTextureSubImage3D = @ptrCast(getProcAddress("glTextureSubImage3D") orelse return error.LoadError),
.glCompressedTextureSubImage1D = @ptrCast(getProcAddress("glCompressedTextureSubImage1D") orelse return error.LoadError),
.glCompressedTextureSubImage2D = @ptrCast(getProcAddress("glCompressedTextureSubImage2D") orelse return error.LoadError),
.glCompressedTextureSubImage3D = @ptrCast(getProcAddress("glCompressedTextureSubImage3D") orelse return error.LoadError),
.glCopyTextureSubImage1D = @ptrCast(getProcAddress("glCopyTextureSubImage1D") orelse return error.LoadError),
.glCopyTextureSubImage2D = @ptrCast(getProcAddress("glCopyTextureSubImage2D") orelse return error.LoadError),
.glCopyTextureSubImage3D = @ptrCast(getProcAddress("glCopyTextureSubImage3D") orelse return error.LoadError),
.glTextureParameterf = @ptrCast(getProcAddress("glTextureParameterf") orelse return error.LoadError),
.glTextureParameterfv = @ptrCast(getProcAddress("glTextureParameterfv") orelse return error.LoadError),
.glTextureParameteri = @ptrCast(getProcAddress("glTextureParameteri") orelse return error.LoadError),
.glTextureParameterIiv = @ptrCast(getProcAddress("glTextureParameterIiv") orelse return error.LoadError),
.glTextureParameterIuiv = @ptrCast(getProcAddress("glTextureParameterIuiv") orelse return error.LoadError),
.glTextureParameteriv = @ptrCast(getProcAddress("glTextureParameteriv") orelse return error.LoadError),
.glGenerateTextureMipmap = @ptrCast(getProcAddress("glGenerateTextureMipmap") orelse return error.LoadError),
.glBindTextureUnit = @ptrCast(getProcAddress("glBindTextureUnit") orelse return error.LoadError),
.glGetTextureImage = @ptrCast(getProcAddress("glGetTextureImage") orelse return error.LoadError),
.glGetCompressedTextureImage = @ptrCast(getProcAddress("glGetCompressedTextureImage") orelse return error.LoadError),
.glGetTextureLevelParameterfv = @ptrCast(getProcAddress("glGetTextureLevelParameterfv") orelse return error.LoadError),
.glGetTextureLevelParameteriv = @ptrCast(getProcAddress("glGetTextureLevelParameteriv") orelse return error.LoadError),
.glGetTextureParameterfv = @ptrCast(getProcAddress("glGetTextureParameterfv") orelse return error.LoadError),
.glGetTextureParameterIiv = @ptrCast(getProcAddress("glGetTextureParameterIiv") orelse return error.LoadError),
.glGetTextureParameterIuiv = @ptrCast(getProcAddress("glGetTextureParameterIuiv") orelse return error.LoadError),
.glGetTextureParameteriv = @ptrCast(getProcAddress("glGetTextureParameteriv") orelse return error.LoadError),
.glCreateVertexArrays = @ptrCast(getProcAddress("glCreateVertexArrays") orelse return error.LoadError),
.glDisableVertexArrayAttrib = @ptrCast(getProcAddress("glDisableVertexArrayAttrib") orelse return error.LoadError),
.glEnableVertexArrayAttrib = @ptrCast(getProcAddress("glEnableVertexArrayAttrib") orelse return error.LoadError),
.glVertexArrayElementBuffer = @ptrCast(getProcAddress("glVertexArrayElementBuffer") orelse return error.LoadError),
.glVertexArrayVertexBuffer = @ptrCast(getProcAddress("glVertexArrayVertexBuffer") orelse return error.LoadError),
.glVertexArrayVertexBuffers = @ptrCast(getProcAddress("glVertexArrayVertexBuffers") orelse return error.LoadError),
.glVertexArrayAttribBinding = @ptrCast(getProcAddress("glVertexArrayAttribBinding") orelse return error.LoadError),
.glVertexArrayAttribFormat = @ptrCast(getProcAddress("glVertexArrayAttribFormat") orelse return error.LoadError),
.glVertexArrayAttribIFormat = @ptrCast(getProcAddress("glVertexArrayAttribIFormat") orelse return error.LoadError),
.glVertexArrayAttribLFormat = @ptrCast(getProcAddress("glVertexArrayAttribLFormat") orelse return error.LoadError),
.glVertexArrayBindingDivisor = @ptrCast(getProcAddress("glVertexArrayBindingDivisor") orelse return error.LoadError),
.glGetVertexArrayiv = @ptrCast(getProcAddress("glGetVertexArrayiv") orelse return error.LoadError),
.glGetVertexArrayIndexediv = @ptrCast(getProcAddress("glGetVertexArrayIndexediv") orelse return error.LoadError),
.glGetVertexArrayIndexed64iv = @ptrCast(getProcAddress("glGetVertexArrayIndexed64iv") orelse return error.LoadError),
.glCreateSamplers = @ptrCast(getProcAddress("glCreateSamplers") orelse return error.LoadError),
.glCreateProgramPipelines = @ptrCast(getProcAddress("glCreateProgramPipelines") orelse return error.LoadError),
.glCreateQueries = @ptrCast(getProcAddress("glCreateQueries") orelse return error.LoadError),
.glGetQueryBufferObjecti64v = @ptrCast(getProcAddress("glGetQueryBufferObjecti64v") orelse return error.LoadError),
.glGetQueryBufferObjectiv = @ptrCast(getProcAddress("glGetQueryBufferObjectiv") orelse return error.LoadError),
.glGetQueryBufferObjectui64v = @ptrCast(getProcAddress("glGetQueryBufferObjectui64v") orelse return error.LoadError),
.glGetQueryBufferObjectuiv = @ptrCast(getProcAddress("glGetQueryBufferObjectuiv") orelse return error.LoadError),
.glMemoryBarrierByRegion = @ptrCast(getProcAddress("glMemoryBarrierByRegion") orelse return error.LoadError),
.glGetTextureSubImage = @ptrCast(getProcAddress("glGetTextureSubImage") orelse return error.LoadError),
.glGetCompressedTextureSubImage = @ptrCast(getProcAddress("glGetCompressedTextureSubImage") orelse return error.LoadError),
.glGetGraphicsResetStatus = @ptrCast(getProcAddress("glGetGraphicsResetStatus") orelse return error.LoadError),
.glGetnCompressedTexImage = @ptrCast(getProcAddress("glGetnCompressedTexImage") orelse return error.LoadError),
.glGetnTexImage = @ptrCast(getProcAddress("glGetnTexImage") orelse return error.LoadError),
.glGetnUniformdv = @ptrCast(getProcAddress("glGetnUniformdv") orelse return error.LoadError),
.glGetnUniformfv = @ptrCast(getProcAddress("glGetnUniformfv") orelse return error.LoadError),
.glGetnUniformiv = @ptrCast(getProcAddress("glGetnUniformiv") orelse return error.LoadError),
.glGetnUniformuiv = @ptrCast(getProcAddress("glGetnUniformuiv") orelse return error.LoadError),
.glReadnPixels = @ptrCast(getProcAddress("glReadnPixels") orelse return error.LoadError),
.glGetnMapdv = @ptrCast(getProcAddress("glGetnMapdv") orelse return error.LoadError),
.glGetnMapfv = @ptrCast(getProcAddress("glGetnMapfv") orelse return error.LoadError),
.glGetnMapiv = @ptrCast(getProcAddress("glGetnMapiv") orelse return error.LoadError),
.glGetnPixelMapfv = @ptrCast(getProcAddress("glGetnPixelMapfv") orelse return error.LoadError),
.glGetnPixelMapuiv = @ptrCast(getProcAddress("glGetnPixelMapuiv") orelse return error.LoadError),
.glGetnPixelMapusv = @ptrCast(getProcAddress("glGetnPixelMapusv") orelse return error.LoadError),
.glGetnPolygonStipple = @ptrCast(getProcAddress("glGetnPolygonStipple") orelse return error.LoadError),
.glGetnColorTable = @ptrCast(getProcAddress("glGetnColorTable") orelse return error.LoadError),
.glGetnConvolutionFilter = @ptrCast(getProcAddress("glGetnConvolutionFilter") orelse return error.LoadError),
.glGetnSeparableFilter = @ptrCast(getProcAddress("glGetnSeparableFilter") orelse return error.LoadError),
.glGetnHistogram = @ptrCast(getProcAddress("glGetnHistogram") orelse return error.LoadError),
.glGetnMinmax = @ptrCast(getProcAddress("glGetnMinmax") orelse return error.LoadError),
.glTextureBarrier = @ptrCast(getProcAddress("glTextureBarrier") orelse return error.LoadError),
.glSpecializeShader = @ptrCast(getProcAddress("glSpecializeShader") orelse return error.LoadError),
.glMultiDrawArraysIndirectCount = @ptrCast(getProcAddress("glMultiDrawArraysIndirectCount") orelse return error.LoadError),
.glMultiDrawElementsIndirectCount = @ptrCast(getProcAddress("glMultiDrawElementsIndirectCount") orelse return error.LoadError),
.glPolygonOffsetClamp = @ptrCast(getProcAddress("glPolygonOffsetClamp") orelse return error.LoadError),
  };
}pub fn makeProcTableCurrent(proc_table: ProcTable) void {
      current_proc_table = proc_table;
}
pub fn getProcTablePtr() ?*ProcTable {
      return &(current_proc_table orelse return null);
}