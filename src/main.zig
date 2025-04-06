const std = @import("std");
const builtin = @import("builtin");

const log = std.log;

const glfw = @import("./bindings/glfw.zig");
const vk = @import("./vk.zig");

const VkRenderer = @import("./vk/VkRenderer.zig");
const ft = VkRenderer.ft;

const std_options = std.Options{
    .log_level = if (builtin.mode == .Debug) .debug else .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    glfw.init() catch |err| {
        log.err("failed to initialize GLFW: {s}", .{glfw.getError().description.?});
        return err;
    };
    defer glfw.terminate();

    var ft_library: ft.FT_Library = null;
    if (ft.FT_Init_FreeType(&ft_library) != 0) {
        log.err("failed to initialize Freetype", .{});
        return error.FTInitFailed;
    }
    defer _ = ft.FT_Done_FreeType(ft_library);

    const window = glfw.Window.create(800, 600, "zentura", null, .{ .client_api = .no_api }) catch |err| {
        log.err("failed to create window: {s}", .{glfw.getError().description.?});
        return err;
    };
    defer window.destroy();

    var vkrenderer = try VkRenderer.init(gpa.allocator(), window, ft_library);
    defer vkrenderer.deinit();

    var window_userdata: WindowUserData = .{
        .vkrenderer = &vkrenderer,
    };
    window.setUserPointer(&window_userdata);
    window.setCharCallback(&WindowUserData.charCallback);

    var should_close: bool = false;
    var text_buffer = std.ArrayList(u8).init(gpa.allocator());
    defer text_buffer.deinit();

    while (!should_close) {
        glfw.pollEvents();

        if (window.shouldClose()) {
            should_close = true;
        }

        try vkrenderer.beginFrame();
        try vkrenderer.present();
    }
}

const WindowUserData = struct {
    vkrenderer: *VkRenderer,

    export fn sizeCallback(glfw_window: *glfw.GLFWWindow, _: c_int, _: c_int) void {
        const window: *glfw.Window = @ptrCast(glfw_window);
        const userdata: *@This() = @ptrCast(@alignCast(window.getUserPointer()));
        userdata.vkrenderer.should_resize = true;
    }

    export fn charCallback(_: ?*glfw.GLFWWindow, codepoint: u32) void {
        std.debug.print("{u}\n", .{@as(u21, @intCast(codepoint))});
    }
};
