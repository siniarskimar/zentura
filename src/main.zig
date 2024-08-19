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

const TextBuffer = struct {
    allocator: std.mem.Allocator,
    buffer: std.ArrayListUnmanaged(u8) = .{},
    lines: std.ArrayListUnmanaged([]const u8) = .{},

    pub fn init(allocator: std.mem.Allocator) @This() {
        return .{ .allocator = allocator };
    }

    pub fn deinit(self: *@This()) void {
        self.buffer.deinit(self.allocator);
        self.lines.deinit(self.allocator);
    }

    pub fn computeLines(self: *@This()) !void {
        self.lines.clearRetainingCapacity();
        var start: usize = 0;
        for (self.buffer.items, 0..) |ch, idx| {
            if (ch != '\n') continue;
            try self.lines.append(self.allocator, self.buffer.items[start..idx]);
            start = idx + 1;
        }
        if (start != self.buffer.items.len) {
            try self.lines.append(self.allocator, self.buffer.items[start..]);
        }
    }

    pub fn getLineIndex(self: *const @This(), x: u64, y: u64) usize {
        if (self.lines.items.len == 0) {
            return 0;
        }
        const line = if (self.lines.items.len <= y)
            self.lines.getLast()
        else
            self.lines.items[y];

        const line_idx = @intFromPtr(self.buffer.items.ptr) - @intFromPtr(line.ptr);
        return line_idx + @min(x, line.len - 1);
    }

    pub fn insert(self: *@This(), x: u64, y: u64, slice: []const u8) !void {
        if (self.lines.items.len < y) {
            try self.buffer.appendSlice(self.allocator, slice);
        } else {
            try self.buffer.insertSlice(self.allocator, self.getLineIndex(x, y), slice);
        }
        try self.computeLines();
    }
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
    var text_buffer = TextBuffer.init(gpa.allocator());
    defer text_buffer.deinit();

    var cursor_x: u64 = 0;
    var cursor_y: u64 = 0;

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
                    if (kev.keysym.sym == c.SDLK_KP_ENTER) {
                        try text_buffer.insert(cursor_x, cursor_y, &[1]u8{'\n'});
                        cursor_x = 0;
                        cursor_y += 1;
                    }
                    // if (kev.keysym.sym == c.SDLK_KP_BACKSPACE) {
                    //     _ = text_buffer.popOrNull();
                    // }
                },
                c.SDL_TEXTINPUT => {
                    if (std.unicode.utf8ByteSequenceLength(event.text.text[0])) |len| {
                        try text_buffer.insert(cursor_x, cursor_y, event.text.text[0..len]);
                    } else |_| {
                        const len = std.mem.sliceTo(&event.text.text, 0).len;

                        try text_buffer.insert(cursor_x, cursor_y, event.text.text[0..len]);
                    }
                },
                else => {},
            }
        }
        // var text_y: u32 = 10;
        // var newline_it = std.mem.splitScalar(u8, text_buffer.items, '\n');
        // while (newline_it.next()) |line| {
        //     try vkrenderer.drawText(line, 30, text_y);
        //     text_y += 10;
        // }
        try vkrenderer.present();
    }
}
