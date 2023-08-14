const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {

    // Minimal Zig version check
    comptime {
        const zig_version = builtin.zig_version;
        const min_ver = std.SemanticVersion.parse("0.11.0-dev.3892+0a6cd257b") catch unreachable;
        if (zig_version.order(min_ver) == .lt) {
            @compileError(std.fmt.comptimePrint(
                \\ This project requires at least version {} of Zig but you have v{}
                \\ https://github.com/ziglang/zig (commit 0a6cd257b should work)
            , .{ min_ver, zig_version }));
        }
    }

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const zcmdargs = b.createModule(.{
        .source_file = .{ .path = "src/zcmdargs.zig" },
    });

    const zen = b.addExecutable(.{
        .name = "zen",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    zen.linkSystemLibrary("glfw");
    zen.linkLibC();

    b.installArtifact(zen);

    const run_cmd = b.addRunArtifact(zen);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const glgen = b.addExecutable(.{
        .name = "glgen",
        .root_source_file = .{ .path = "src/glgen/glgen.zig" },
        .target = target,
        .optimize = optimize,
    });
    glgen.addModule("zcmdargs", zcmdargs);

    const glgen_cmd = b.addRunArtifact(glgen);
    if (b.args) |args| {
        glgen_cmd.addArgs(args);
    }

    const glgen_step = b.step("glgen", "Generate OpenGL bindings");
    glgen_step.dependOn(&glgen_cmd.step);

    const test_step = b.step("test", "Run unit tests");

    {
        const unit_tests = b.addTest(.{
            .root_source_file = .{ .path = zen.root_src.?.path },
            .target = target,
            .optimize = optimize,
        });
        const test_run = b.addRunArtifact(unit_tests);
        test_step.dependOn(&test_run.step);
    }
    {
        const zcmdargs_tests = b.addTest(.{
            .root_source_file = .{ .path = zcmdargs.source_file.path },
            .target = target,
            .optimize = optimize,
        });
        const test_run = b.addRunArtifact(zcmdargs_tests);
        test_step.dependOn(&test_run.step);
    }
    {
        const glgen_tests = b.addTest(.{
            .root_source_file = .{ .path = glgen.root_src.?.path },
            .target = target,
            .optimize = optimize,
        });
        const test_run = b.addRunArtifact(glgen_tests);
        test_step.dependOn(&test_run.step);
    }
}
