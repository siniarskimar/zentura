const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {

    // Zig version check
    comptime {
        const zig_version = builtin.zig_version;
        const min_ver = std.SemanticVersion.parse("0.11.0") catch unreachable;
        if (zig_version.order(min_ver) != .eq) {
            std.debug.print(std.fmt.comptimePrint(
                \\ WARN: This project is tested against Zig {} but you have {}.
            , .{ min_ver, zig_version }));
        }
    }

    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const clap_dep = b.dependency("zig_clap", .{});
    const zglgen_dep = b.dependency("zglgen", .{ .optimize = .ReleaseSafe });
    const zglgen = zglgen_dep.artifact("zglgen");

    const zglgen_cmd = b.addRunArtifact(zglgen);
    zglgen_cmd.addArgs(&[_][]const u8{
        // zig fmt off
        "--api",        "gl:3.2",
        "GL_KHR_debug",
        "-o",
        // zig fmt on
    });
    const gl_33_mod_path = zglgen_cmd.addOutputFileArg("gl_33.zig");

    const gl_33_mod = b.createModule(.{
        .source_file = gl_33_mod_path,
    });

    const exe = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkSystemLibrary("glfw");
    exe.linkLibC();
    exe.addModule("clap", clap_dep.module("clap"));
    exe.addModule("gl", gl_33_mod);

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
            .root_source_file = .{ .path = exe.root_src.?.path },
            .target = target,
            .optimize = optimize,
        });
        const test_run = b.addRunArtifact(unit_tests);
        test_step.dependOn(&test_run.step);
    }
}
