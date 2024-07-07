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

    const exe = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("wayland", mod_wayland);
    exe.linkLibC();
    exe.linkSystemLibrary("wayland-client");
    scanner.addCSource(exe);
    b.installArtifact(exe);
}
