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

    const exe = b.addExecutable(.{
        .name = "zen",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkSystemLibrary("glfw");
    exe.linkLibC();

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const glgen = b.addExecutable(.{
        .name = "glgen",
        .root_source_file = .{ .path = "tools/glgen/glgen.zig" },
        .target = target,
        .optimize = optimize,
    });

    const glgen_cmd = b.addRunArtifact(glgen);
    if (b.args) |args| {
        glgen_cmd.addArgs(args);
    }

    const glgen_step = b.step("glgen", "Generate OpenGL bindings");
    glgen_step.dependOn(&glgen_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&unit_tests.step);
}
