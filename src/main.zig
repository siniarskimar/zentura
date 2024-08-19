const std = @import("std");
const builtin = @import("builtin");

const log = std.log;
const vk = @import("./vk.zig");
const shaders = @import("shaders");
const c = @import("c");

const ft = vk.ft;

const std_options = std.Options{
    .log_level = if (builtin.mode == .Debug) .debug else .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    if (c.SDL_InitSubSystem(c.SDL_INIT_VIDEO) != 0) {
        log.err("failed to initialize SDL video: {s}", .{c.SDL_GetError()});
        return error.SDLInitFailed;
    }
    defer c.SDL_Quit();

    var ft_library: ft.FT_Library = null;
    if (ft.FT_Init_FreeType(&ft_library) != 0) {
        log.err("failed to initialize Freetype", .{});
        return error.FTInitFailed;
    }
    defer _ = ft.FT_Done_FreeType(ft_library);

    const window = c.SDL_CreateWindow(
        "zentura",
        c.SDL_WINDOWPOS_UNDEFINED,
        c.SDL_WINDOWPOS_UNDEFINED,
        800,
        600,
        c.SDL_WINDOW_RESIZABLE | c.SDL_WINDOW_VULKAN,
    );
    if (window == null) {
        log.err("failed to create SDL window: {s}", .{c.SDL_GetError()});
        return error.CreateWindowFailed;
    }
    defer c.SDL_DestroyWindow(window);

    var vkrenderer = try vk.Renderer.init(gpa.allocator(), window.?, ft_library);
    defer vkrenderer.deinit();

    var should_close: bool = false;
    var text_buffer = std.ArrayList(u8).init(gpa.allocator());
    defer text_buffer.deinit();

    while (!should_close) {
        var event: c.SDL_Event = undefined;
        while (c.SDL_PollEvent(&event) == 1) {
            switch (event.type) {
                c.SDL_QUIT => {
                    should_close = true;
                },
                c.SDL_WINDOWEVENT => switch (event.window.event) {
                    c.SDL_WINDOWEVENT_SIZE_CHANGED,
                    c.SDL_WINDOWEVENT_RESIZED,
                    => {
                        vkrenderer.should_resize = true;
                    },
                    else => {},
                },
                c.SDL_KEYDOWN => {
                    const kev = event.key;
                    if (kev.keysym.sym == c.SDLK_RETURN or kev.keysym.sym == c.SDLK_KP_ENTER) {
                        try text_buffer.appendSlice("\\n");
                    }
                },
                c.SDL_TEXTINPUT => {
                    if (std.unicode.utf8ByteSequenceLength(event.text.text[0])) |len| {
                        try text_buffer.appendSlice(event.text.text[0..len]);
                    } else |_| {
                        const len = std.mem.sliceTo(&event.text.text, 0).len;

                        try text_buffer.appendSlice(event.text.text[0..len]);
                    }
                },
                else => {},
            }
        }
        try vkrenderer.present();
    }
}
