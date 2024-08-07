const std = @import("std");
const builtin = @import("builtin");

const vulkan_zig = @import("vulkan_zig");
const zig_wayland = @import("zig_wayland");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const scanner = zig_wayland.Scanner.create(b, .{});
    scanner.addSystemProtocol("stable/xdg-shell/xdg-shell.xml");

    scanner.generate("xdg_wm_base", 3);
    scanner.generate("wl_compositor", 6);
    scanner.generate("wl_seat", 8);
    scanner.generate("wl_output", 4);

    const vk_registry = b.dependency("vulkan_headers", .{}).path("registry/vk.xml");
    const dep_vkzig = b.dependency("vulkan_zig", .{
        .optimize = std.builtin.OptimizeMode.ReleaseSafe,
    });
    const vk_gen = dep_vkzig.artifact("vulkan-zig-generator");
    const run_vk_gen = b.addRunArtifact(vk_gen);
    run_vk_gen.addFileArg(vk_registry);

    const mod_vulkan = b.createModule(.{ .root_source_file = run_vk_gen.addOutputFileArg("vk.zig") });
    const mod_wayland = b.createModule(.{ .root_source_file = scanner.result });

    const shaders = vulkan_zig.ShaderCompileStep.create(
        b,
        &.{ "glslc", "--target-env=vulkan1.0" },
        "-o",
    );
    shaders.add("triangle_vert", "src/shader/triangle.vert", .{});
    shaders.add("triangle_frag", "src/shader/triangle.frag", .{});

    const exe_zentura = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_zentura.root_module.addImport("wayland", mod_wayland);
    exe_zentura.root_module.addImport("vulkan", mod_vulkan);
    exe_zentura.root_module.addImport("shaders", shaders.getModule());
    exe_zentura.linkLibC();
    exe_zentura.linkSystemLibrary("wayland-client");
    exe_zentura.linkSystemLibrary("X11");
    exe_zentura.linkSystemLibrary("X11-xcb");
    exe_zentura.linkSystemLibrary("xcb");
    exe_zentura.linkSystemLibrary("xkbcommon");
    scanner.addCSource(exe_zentura);
    b.installArtifact(exe_zentura);

    const run_zentura = b.addRunArtifact(exe_zentura);
    if (b.args) |args| {
        run_zentura.addArgs(args);
    }

    const step_run = b.step("run", "Run zentura");
    step_run.dependOn(&run_zentura.step);

    const step_check = b.step("check", "Check if the project compiles");
    step_check.dependOn(&exe_zentura.step);
}
