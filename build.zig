const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) !void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const mod_zentura = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
        .link_libcpp = true,
    });

    const c_headers = b.addTranslateC(.{
        .root_source_file = b.path("./src/c.h"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    c_headers.addIncludePath(b.dependency("vulkan_headers", .{}).path("include"));
    // TODO: Replace this with fetching fontconfig
    c_headers.addSystemIncludePath(.{ .cwd_relative = "/usr/include" });

    mod_zentura.addImport("c", c_headers.createModule());
    mod_zentura.addImport("zig-vulkan", generateVulkanBindings(b));
    try compileVulkanShaders(b, mod_zentura);

    try linkFreetype(b, mod_zentura);
    mod_zentura.linkSystemLibrary("glfw", .{});
    mod_zentura.linkSystemLibrary("fontconfig", .{});
    try compileVulkanMemoryAllocator(b, mod_zentura);

    const exe_zentura = b.addExecutable(.{
        .name = "zentura",
        .root_module = mod_zentura,
    });
    b.installArtifact(exe_zentura);

    const run_zentura = b.addRunArtifact(exe_zentura);
    if (b.args) |args| {
        run_zentura.addArgs(args);
    }

    const step_run = b.step("run", "Run zentura");
    step_run.dependOn(&run_zentura.step);

    const check_zentura = b.addExecutable(.{ .name = "zentura", .root_module = mod_zentura });
    const step_check = b.step("check", "Check if the project compiles");
    step_check.dependOn(&check_zentura.step);
}

fn compileVulkanShaders(b: *std.Build, module: *std.Build.Module) !void {
    const vk_shaders = [_]struct {
        import_name: []const u8,
        source_path: []const u8,
    }{
        .{
            .import_name = "shader_triangle_vert",
            .source_path = "src/vk/shader/triangle.vert",
        },
        .{
            .import_name = "shader_triangle_frag",
            .source_path = "src/vk/shader/triangle.frag",
        },
        .{
            .import_name = "shader_glyph_vert",
            .source_path = "src/vk/shader/glyph.vert.glsl",
        },
        .{
            .import_name = "shader_glyph_frag",
            .source_path = "src/vk/shader/glyph.frag.glsl",
        },
    };

    const glslang_exe = try b.findProgram(&.{"glslang"}, &.{});

    inline for (vk_shaders) |shader| {
        const compile_step = b.addSystemCommand(&.{
            glslang_exe,
            "--target-env",
            "vulkan1.1",
            "-o",
        });
        module.addAnonymousImport(shader.import_name, .{
            .root_source_file = compile_step.addOutputFileArg(shader.import_name),
        });
        compile_step.addFileArg(b.path(shader.source_path));
    }
}

fn generateVulkanBindings(b: *std.Build) *std.Build.Module {
    const vk_registry = b.dependency("vulkan_headers", .{}).path("registry/vk.xml");

    const dep_vkzig = b.dependency("vulkan_zig", .{ .optimize = .ReleaseSafe });
    const vk_gen = dep_vkzig.artifact("vulkan-zig-generator");
    const run_vk_gen = b.addRunArtifact(vk_gen);
    run_vk_gen.addFileArg(vk_registry);

    return b.createModule(.{
        .root_source_file = run_vk_gen.addOutputFileArg("vk.zig"),
    });
}

fn linkFreetype(b: *std.Build, module: *std.Build.Module) !void {
    if (b.systemIntegrationOption("freetype2", .{})) {
        module.linkSystemLibrary("freetype2", .{});
        return;
    }
    const dep_freetype = b.dependency("freetype2", .{
        .optimize = .ReleaseSafe,
        .enable_brotli = false,
    });
    const lib_freetype = dep_freetype.artifact("freetype");
    module.linkLibrary(lib_freetype);
}

fn compileVulkanMemoryAllocator(b: *std.Build, module: *std.Build.Module) !void {
    const vk_vma = b.dependency("vulkan_memory_allocator", .{});
    module.addIncludePath(vk_vma.path("include"));
    module.addCSourceFile(.{
        .file = b.path("src/vma.cpp"),
    });
}
