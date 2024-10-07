const std = @import("std");
const builtin = @import("builtin");

const vulkan_zig = @import("vulkan_zig");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const exe_zentura = b.addExecutable(.{
        .name = "zentura",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_zentura.linkLibC();
    if (b.systemIntegrationOption("freetype2", .{})) {
        exe_zentura.linkSystemLibrary("freetype2");
    } else {
        const dep_freetype = b.dependency("freetype2", .{
            .optimize = .ReleaseSafe,
            .enable_brotli = false,
        });
        const lib_freetype = dep_freetype.artifact("freetype");
        exe_zentura.linkLibrary(lib_freetype);
    }
    exe_zentura.linkSystemLibrary("sdl2");
    b.installArtifact(exe_zentura);

    const c_headers = b.addTranslateC(.{
        .root_source_file = b.path("./src/c.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    exe_zentura.root_module.addImport("c", c_headers.createModule());

    const vk_registry = b.dependency("vulkan_headers", .{}).path("registry/vk.xml");

    const dep_vkzig = b.dependency("vulkan_zig", .{ .optimize = .ReleaseSafe });
    const vk_gen = dep_vkzig.artifact("vulkan-zig-generator");
    const run_vk_gen = b.addRunArtifact(vk_gen);
    run_vk_gen.addFileArg(vk_registry);
    exe_zentura.root_module.addImport("zig-vulkan", b.createModule(.{
        .root_source_file = run_vk_gen.addOutputFileArg("vk.zig"),
    }));

    const vk_vma = b.dependency("vulkan_memory_allocator", .{});
    exe_zentura.addIncludePath(vk_vma.path("include"));
    exe_zentura.addCSourceFile(.{
        .file = b.path("src/vma.cpp"),
    });
    exe_zentura.linkLibCpp();

    const shaders = vulkan_zig.ShaderCompileStep.create(
        b,
        &.{ "glslang", "--target-env=vulkan1.0" },
        "-o",
    );
    shaders.add("triangle_vert", "src/shader/triangle.vert", .{});
    shaders.add("triangle_frag", "src/shader/triangle.frag", .{});
    exe_zentura.root_module.addImport("shaders", shaders.getModule());

    const run_zentura = b.addRunArtifact(exe_zentura);
    if (b.args) |args| {
        run_zentura.addArgs(args);
    }

    const step_run = b.step("run", "Run zentura");
    step_run.dependOn(&run_zentura.step);

    const step_check = b.step("check", "Check if the project compiles");
    step_check.dependOn(&exe_zentura.step);
}
