const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const zglgen_dep = b.dependency("zglgen", .{ .target = target, .optimize = .ReleaseSafe });
    const zglgen = zglgen_dep.artifact("zglgen");

    const freetype_dep = b.dependency("freetype", .{ .target = target, .optimize = .ReleaseSafe });

    const zglgen_cmd = b.addRunArtifact(zglgen);
    zglgen_cmd.addArgs(&[_][]const u8{
        // zig fmt off
        "--api",        "gl:3.3",
        "GL_KHR_debug",
        "-o",
        // zig fmt on
    });
    const gl_33_mod_path = zglgen_cmd.addOutputFileArg("gl_33.zig");

    const gl_33_mod = b.createModule(
        .{ .root_source_file = gl_33_mod_path },
    );

    const exe = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkSystemLibrary("glfw");
    exe.linkLibC();
    exe.root_module.addImport("glb", gl_33_mod);
    exe.root_module.addImport("freetype", freetype_dep.module("mach-freetype"));
    exe.root_module.addImport("harfbuzz", freetype_dep.module("mach-harfbuzz"));

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");

    {
        const unit_tests = b.addTest(.{
            .root_source_file = .{ .path = exe.root_module.root_source_file.?.path },
            .target = target,
            .optimize = optimize,
        });
        const test_run = b.addRunArtifact(unit_tests);
        test_step.dependOn(&test_run.step);
    }
}
