const std = @import("std");
const c = @import("c");
const zvk = @import("zig-vulkan");

pub const Monitor = c.GLFWmonitor;

pub fn init() !void {
    if (c.glfwInit() != c.GLFW_TRUE) return error.InitFailed;
}

pub fn terminate() void {
    c.glfwTerminate();
}

const Error = struct {
    code: c_int = 0,
    description: ?[*:0]const u8 = null,
};

pub fn getError() Error {
    var result: Error = .{};
    result.code = c.glfwGetError(@ptrCast(&result.description));
    return result;
}

pub fn vulkanSupported() bool {
    return c.glfwVulkanSupported() > 0;
}

pub const getInstanceProcAddress = c.glfwGetInstanceProcAddress;

pub fn getInstanceExtensions() [][*c]const u8 {
    var count: u32 = 0;
    const exts = @as([*][*c]const u8, c.glfwGetRequiredInstanceExtensions(&count));
    return exts[0..count];
}

pub const createWindowSurface = c.glfwCreateWindowSurface;

pub const pollEvents = c.glfwPollEvents;

pub const WindowHints = struct {
    context_version_major: ?c_int = null,
    context_version_minor: ?c_int = null,
    client_api: ?ClientApi = null,
    context_creation_api: ?c_int = null,
    doublebuffer: ?bool = null,
    opengl_profile: ?c_int = null,
    opengl_forward_compat: ?c_int = null,

    pub const ClientApi = enum(c_int) {
        no_api = c.GLFW_NO_API,
        opengl_api = c.GLFW_OPENGL_API,
        opengl_es_api = c.GLFW_OPENGL_ES_API,
    };

    pub fn set(self: *const @This()) void {
        inline for (std.meta.fields(@This())) |field| {
            const field_value = @field(self, field.name);
            if (field_value != null) {
                const glfw_constant_name = comptime blk: {
                    const prefixed = "GLFW_" ++ field.name;
                    var uppercased: [prefixed.len]u8 = undefined;
                    _ = std.ascii.upperString(&uppercased, prefixed);
                    break :blk uppercased;
                };
                const hint_enum = @field(c, &glfw_constant_name);
                const hint_value = field_value.?;

                switch (@typeInfo(@TypeOf(hint_value))) {
                    .int => c.glfwWindowHint(hint_enum, hint_value),
                    .bool => c.glfwWindowHint(hint_enum, if (hint_value) c.GLFW_TRUE else c.GLFW_FALSE),
                    .@"enum" => c.glfwWindowHint(hint_enum, @intCast(@intFromEnum(hint_value))),
                    else => @compileError("Unsupported window hint type " ++ @typeName(field.type)),
                }
            }
        }
    }
};

pub const GLFWWindow = c.GLFWwindow;

pub const Window = opaque {
    pub fn create(width: c_uint, height: c_uint, title: [*:0]const u8, monitor: ?*Monitor, hints: WindowHints) !*@This() {
        hints.set();
        const window = c.glfwCreateWindow(@intCast(width), @intCast(height), title, monitor, null);
        if (window == null) return error.CreationFailed;
        return @ptrCast(window.?);
    }

    pub fn destroy(self: *@This()) void {
        c.glfwDestroyWindow(@ptrCast(self));
    }

    pub fn getFramebufferSize(self: *const @This(), width: ?*c_int, height: ?*c_int) void {
        c.glfwGetFramebufferSize(@ptrCast(@constCast(self)), width, height);
    }

    pub fn shouldClose(self: *const @This()) bool {
        return c.glfwWindowShouldClose(@ptrCast(@constCast(self))) != 0;
    }

    pub fn setUserPointer(self: *@This(), userdata: ?*anyopaque) void {
        c.glfwSetWindowUserPointer(@ptrCast(self), userdata);
    }

    pub fn getUserPointer(self: *const @This()) ?*anyopaque {
        return c.glfwGetWindowUserPointer(@ptrCast(@constCast(self)));
    }

    pub fn setSizeCallback(self: *@This(), cb_fn: c.GLFWwindowsizefun) void {
        c.glfwSetWindowSizeCallback(@ptrCast(self), cb_fn);
    }

    pub fn setCharCallback(self: *@This(), cb_fn: c.GLFWcharfun) void {
        _ = c.glfwSetCharCallback(@ptrCast(self), cb_fn);
    }
};
