const std = @import("std");
const builtin = @import("builtin");
const xml = @import("./xml.zig");

fn downloadGLSpecification(allocator: std.mem.Allocator) ![]u8 {
    var httpclient = std.http.Client{ .allocator = allocator };
    const url = "https://github.com/KhronosGroup/OpenGL-Registry/raw/main/xml/gl.xml";
    const uri = try std.Uri.parse(url);
    var headers = std.http.Headers{ .allocator = allocator };
    defer headers.deinit();

    try headers.append("accept", "text/plain;application/xml");
    try headers.append("accept-encoding", "gzip, deflate");

    std.log.info("Downloading GL specification from {s}", .{url});

    var req = try httpclient.request(.GET, uri, headers, .{});
    defer req.deinit();
    try req.start();
    try req.wait();

    const body = try req.reader().readAllAlloc(allocator, 1 * 1024 * 1024 * 10);
    return body;
}

fn getTempDirPath() ![]const u8 {
    switch (builtin.os.tag) {
        .windows => {
            if (std.os.getenv("TMP")) |tmp| {
                return tmp;
            }
            if (std.os.getenv("TEMP")) |tmp| {
                return tmp;
            }
            if (std.os.getenv("USERPOFILE")) |tmp| {
                return tmp;
            }
        },
        .linux => {
            return "/tmp";
        },
        .macos => {
            if (std.os.getenv("TMPDIR")) |tmp| {
                return tmp;
            }
        },
        else => {
            return error.UnsupportedOS;
        },
    }
    return error.NoValidTmpDir;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const gl_spec = blk: {
        const tmp_dir = try getTempDirPath();
        const spec_filepath = try std.fs.path.join(allocator, &[_][]const u8{ tmp_dir, "zen-glgen.xml" });
        defer allocator.free(spec_filepath);

        var file = std.fs.openFileAbsolute(spec_filepath, .{}) catch |err| switch (err) {
            error.FileNotFound => {
                var result = try downloadGLSpecification(allocator);
                var cache = try std.fs.createFileAbsolute(spec_filepath, .{});
                defer cache.close();

                try cache.writeAll(result);
                break :blk result;
            },
            else => return err,
        };

        defer file.close();
        break :blk try file.readToEndAlloc(allocator, 10 * 1024 * 1024);
    };
    defer allocator.free(gl_spec);

    var parserctx = xml.ParserContext.init(gl_spec, 0);
    var document = xml.parse(&parserctx, allocator) catch |err| {
        std.log.err("An error occoured during parsing of GL XML specification (line {}, column {}):\n\t{s}\n", .{
            parserctx.linenr,
            parserctx.colnr,
            parserctx.formatNearBytes(),
        });
        return err;
    };
    defer document.deinit();
}
