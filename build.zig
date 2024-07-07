const std = @import("std");
const builtin = @import("builtin");
const zig_wayland = @import("zig_wayland");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const scanner = zig_wayland.Scanner.create(b, .{});

    const mod_wayland = b.createModule(.{ .root_source_file = scanner.result });
    scanner.addSystemProtocol("stable/xdg-shell/xdg-shell.xml");

    scanner.generate("xdg_wm_base", 3);

    const exe_zentura = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_zentura.root_module.addImport("wayland", mod_wayland);
    exe_zentura.linkLibC();
    exe_zentura.linkSystemLibrary("wayland-client");
    scanner.addCSource(exe_zentura);
    b.installArtifact(exe_zentura);

    const run_zentura = b.addRunArtifact(exe_zentura);
    if (b.args) |args| {
        run_zentura.addArgs(args);
    }

    const step_run = b.step("run", "Run zentura");
    step_run.dependOn(&run_zentura.step);
}
