const std = @import("std");
const builtin = @import("builtin");

const wayland = @import("./wayland.zig");
const vulkan = @import("./vulkan.zig");
const vk = vulkan.vk;
const shaders = @import("shaders");

const WlContext = wayland.WlContext;
const WlWindow = wayland.WlWindow;

const std_options = std.Options{
    .log_level = if (builtin.mode == .Debug) .debug else .info,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var vksolib = try vulkan.loadSharedLibrary();
    defer vksolib.close();

    var wlcontext = try WlContext.init();
    defer wlcontext.deinit();

    wlcontext.wl_registry.setListener(*WlContext, WlContext.globalsListener, &wlcontext);
    if (wlcontext.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    var wlwindow = try WlWindow.init(&wlcontext);
    defer wlwindow.deinit();

    wlwindow.initListeners();
    wlwindow.width = 800;
    wlwindow.height = 600;
    wlwindow.xdg_toplevel.setTitle("zentura");
    wlwindow.xdg_toplevel.setAppId("siniarskimar.zentura");
    wlwindow.xdg_toplevel.setMinSize(100, 100);

    var vkcontext = try wayland.VulkanContext.init(gpa.allocator(), &wlwindow);
    defer vkcontext.deinit(gpa.allocator());

    const vkplayout = try vkcontext.devcontext.dev.createPipelineLayout(&vk.PipelineLayoutCreateInfo{}, null);
    defer vkcontext.devcontext.dev.destroyPipelineLayout(vkplayout, null);

    const vkrenderpass = try createRenderPass(vkcontext.devcontext.dev, vkcontext.swapchain);
    defer vkcontext.devcontext.dev.destroyRenderPass(vkrenderpass, null);

    const vkpipeline = try createVulkanPipeline(vkcontext.devcontext.dev, vkplayout, vkrenderpass);
    defer vkcontext.devcontext.dev.destroyPipeline(vkpipeline, null);

    var framebuffers = try createFramebuffers(gpa.allocator(), vkcontext.devcontext.dev, vkrenderpass, vkcontext.swapchain);
    defer destroyFramebuffers(gpa.allocator(), vkcontext.devcontext.dev, framebuffers);

    const cmdpool = try vkcontext.devcontext.dev.createCommandPool(&.{
        .queue_family_index = vkcontext.devcontext.graphics_queue.family,
    }, null);
    defer vkcontext.devcontext.dev.destroyCommandPool(cmdpool, null);

    var cmdbufs = try createCommandBuffers(
        gpa.allocator(),
        vkcontext.devcontext.dev,
        cmdpool,
        vkrenderpass,
        framebuffers,
        vkpipeline,
        vkcontext.swapchain.extent,
    );
    defer destroyCommandBuffers(gpa.allocator(), vkcontext.devcontext.dev, cmdpool, cmdbufs);

    wlwindow.wl_surface.commit();
    if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

    std.log.info("Using GPU: {s}", .{vkcontext.getDeviceName()});

    while (!wlwindow.is_closed) {
        wlwindow.wl_surface.damage(0, 0, @intCast(wlwindow.width), @intCast(wlwindow.height));
        wlwindow.wl_surface.commit();
        if (wlwindow.context.wl_display.roundtrip() != .SUCCESS) return error.RoundtripFailed;

        if (wlwindow.width == 0 or wlwindow.height == 0) {
            continue;
        }

        const cmdbuf = cmdbufs[vkcontext.swapchain.image_index];

        const state = vkcontext.swapchain.present(cmdbuf) catch |err| switch (err) {
            error.OutOfDateKHR => .suboptimal,
            else => return err,
        };

        if (state == .suboptimal or vkcontext.swapchain.extent.width != wlwindow.width or vkcontext.swapchain.extent.height != wlwindow.height) {
            // std.debug.print("recreate\n", .{});
            try vkcontext.swapchain.recreate(gpa.allocator(), .{ .width = wlwindow.width, .height = wlwindow.height });

            destroyFramebuffers(gpa.allocator(), vkcontext.devcontext.dev, framebuffers);
            framebuffers = try createFramebuffers(gpa.allocator(), vkcontext.devcontext.dev, vkrenderpass, vkcontext.swapchain);

            destroyCommandBuffers(gpa.allocator(), vkcontext.devcontext.dev, cmdpool, cmdbufs);
            cmdbufs = try createCommandBuffers(
                gpa.allocator(),
                vkcontext.devcontext.dev,
                cmdpool,
                vkrenderpass,
                framebuffers,
                vkpipeline,
                vkcontext.swapchain.extent,
            );
        }
    }
    try vkcontext.devcontext.dev.deviceWaitIdle();
}

fn destroyCommandBuffers(allocator: std.mem.Allocator, dev: vulkan.Device, cmdpool: vk.CommandPool, cmdbufs: []vk.CommandBuffer) void {
    dev.freeCommandBuffers(cmdpool, @intCast(cmdbufs.len), cmdbufs.ptr);
    allocator.free(cmdbufs);
}

fn destroyFramebuffers(allocator: std.mem.Allocator, dev: vulkan.Device, framebuffers: []vk.Framebuffer) void {
    for (framebuffers) |fb| dev.destroyFramebuffer(fb, null);
    allocator.free(framebuffers);
}

fn createCommandBuffers(
    allocator: std.mem.Allocator,
    dev: vulkan.Device,
    cmdpool: vk.CommandPool,
    render_pass: vk.RenderPass,
    framebuffers: []vk.Framebuffer,
    pipeline: vk.Pipeline,
    extent: vk.Extent2D,
) ![]vk.CommandBuffer {
    const cmdbufs = try allocator.alloc(vk.CommandBuffer, framebuffers.len);
    errdefer allocator.free(cmdbufs);

    try dev.allocateCommandBuffers(&.{
        .command_pool = cmdpool,
        .level = .primary,
        .command_buffer_count = @intCast(cmdbufs.len),
    }, cmdbufs.ptr);
    errdefer dev.freeCommandBuffers(cmdpool, @intCast(cmdbufs.len), cmdbufs.ptr);

    const clear = vk.ClearValue{ .color = .{ .float_32 = .{ 0, 0, 0, 1 } } };
    const viewport = vk.Viewport{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(extent.width),
        .height = @floatFromInt(extent.height),
        .min_depth = 0,
        .max_depth = 1,
    };
    const scissor = vk.Rect2D{
        .offset = .{ .x = 0, .y = 0 },
        .extent = extent,
    };

    for (cmdbufs, framebuffers) |cmdbuf, fb| {
        try dev.beginCommandBuffer(cmdbuf, &.{});

        dev.cmdSetViewport(cmdbuf, 0, 1, @ptrCast(&viewport));
        dev.cmdSetScissor(cmdbuf, 0, 1, @ptrCast(&scissor));

        const render_area = vk.Rect2D{
            .offset = .{ .x = 0, .y = 0 },
            .extent = extent,
        };

        dev.cmdBeginRenderPass(cmdbuf, &.{
            .render_pass = render_pass,
            .framebuffer = fb,
            .render_area = render_area,
            .clear_value_count = 1,
            .p_clear_values = @ptrCast(&clear),
        }, .@"inline");

        dev.cmdBindPipeline(cmdbuf, .graphics, pipeline);
        dev.cmdDraw(cmdbuf, 3, 1, 0, 0);
        dev.cmdEndRenderPass(cmdbuf);
        try dev.endCommandBuffer(cmdbuf);
    }

    return cmdbufs;
}

fn createFramebuffers(
    allocator: std.mem.Allocator,
    dev: vulkan.Device,
    render_pass: vk.RenderPass,
    swapchain: vulkan.Swapchain,
) ![]vk.Framebuffer {
    var framebuffers = try allocator.alloc(vk.Framebuffer, swapchain.swap_images.len);
    errdefer allocator.free(framebuffers);

    var idx: usize = 0;
    errdefer for (framebuffers[0..idx]) |fb| dev.destroyFramebuffer(fb, null);

    while (idx < framebuffers.len) {
        framebuffers[idx] = try dev.createFramebuffer(&vk.FramebufferCreateInfo{
            .render_pass = render_pass,
            .attachment_count = 1,
            .p_attachments = @ptrCast(&swapchain.swap_images[idx].view),
            .width = swapchain.extent.width,
            .height = swapchain.extent.height,
            .layers = 1,
        }, null);
        idx += 1;
    }

    return framebuffers;
}

fn createRenderPass(dev: vulkan.Device, swapchain: vulkan.Swapchain) !vk.RenderPass {
    const color_attachment = vk.AttachmentDescription{
        .format = swapchain.surface_format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .undefined,
        .final_layout = .present_src_khr,
    };

    const color_attachment_ref = vk.AttachmentReference{
        .attachment = 0,
        .layout = .color_attachment_optimal,
    };

    const subpass = vk.SubpassDescription{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .p_color_attachments = @ptrCast(&color_attachment_ref),
    };

    return try dev.createRenderPass(&vk.RenderPassCreateInfo{
        .attachment_count = 1,
        .p_attachments = @ptrCast(&color_attachment),
        .subpass_count = 1,
        .p_subpasses = @ptrCast(&subpass),
    }, null);
}

fn createVulkanPipeline(
    dev: vulkan.Device,
    layout: vk.PipelineLayout,
    render_pass: vk.RenderPass,
) !vk.Pipeline {
    const vert_module = try dev.createShaderModule(&vulkan.vk.ShaderModuleCreateInfo{
        .code_size = shaders.triangle_vert.len,
        .p_code = @ptrCast(&shaders.triangle_vert),
    }, null);
    defer dev.destroyShaderModule(vert_module, null);

    const frag_module = try dev.createShaderModule(&vulkan.vk.ShaderModuleCreateInfo{
        .code_size = shaders.triangle_frag.len,
        .p_code = @ptrCast(&shaders.triangle_frag),
    }, null);
    defer dev.destroyShaderModule(frag_module, null);

    const shader_stages = [_]vk.PipelineShaderStageCreateInfo{
        .{
            .module = vert_module,
            .p_name = "main",
            .stage = .{ .vertex_bit = true },
        },
        .{
            .module = frag_module,
            .p_name = "main",
            .stage = .{ .fragment_bit = true },
        },
    };

    const vertex_input_info = vk.PipelineVertexInputStateCreateInfo{
        .vertex_binding_description_count = 0,
        .vertex_attribute_description_count = 0,
    };

    const input_assembly_info = vk.PipelineInputAssemblyStateCreateInfo{
        .topology = .triangle_list,
        .primitive_restart_enable = vk.FALSE,
    };

    const dynamic_state = [_]vk.DynamicState{ .viewport, .scissor };
    const dynamic_state_info = vk.PipelineDynamicStateCreateInfo{
        .dynamic_state_count = dynamic_state.len,
        .p_dynamic_states = &dynamic_state,
    };

    const viewport_state = vk.PipelineViewportStateCreateInfo{
        .viewport_count = 1,
        .p_viewports = undefined,
        .scissor_count = 1,
        .p_scissors = undefined,
    };

    const rasterizer_info = vk.PipelineRasterizationStateCreateInfo{
        .depth_clamp_enable = vk.FALSE,
        .rasterizer_discard_enable = vk.FALSE,
        .polygon_mode = .fill,
        .line_width = 1.0,
        .cull_mode = .{ .back_bit = true },
        .front_face = .clockwise,
        .depth_bias_enable = vk.FALSE,
        .depth_bias_constant_factor = 0,
        .depth_bias_clamp = 0,
        .depth_bias_slope_factor = 0,
    };
    const multisampling_info = vk.PipelineMultisampleStateCreateInfo{
        .rasterization_samples = .{ .@"1_bit" = true },
        .min_sample_shading = 1,
        .alpha_to_coverage_enable = vk.FALSE,
        .alpha_to_one_enable = vk.FALSE,
        .sample_shading_enable = vk.FALSE,
    };

    const colorblending_attach_info = vk.PipelineColorBlendAttachmentState{
        .blend_enable = vk.FALSE,
        .src_color_blend_factor = .one,
        .dst_color_blend_factor = .zero,
        .color_blend_op = .add,
        .src_alpha_blend_factor = .one,
        .dst_alpha_blend_factor = .zero,
        .alpha_blend_op = .add,
    };

    const colorblending_info = vk.PipelineColorBlendStateCreateInfo{
        .logic_op_enable = vk.FALSE,
        .logic_op = .copy,
        .attachment_count = 1,
        .p_attachments = @ptrCast(&colorblending_attach_info),
        .blend_constants = .{ 0, 0, 0, 0 },
    };

    const pipeline_info = vk.GraphicsPipelineCreateInfo{
        .stage_count = 2,
        .p_stages = &shader_stages,
        .p_vertex_input_state = &vertex_input_info,
        .p_input_assembly_state = &input_assembly_info,
        .p_tessellation_state = null,
        .p_viewport_state = &viewport_state,
        .p_rasterization_state = &rasterizer_info,
        .p_multisample_state = &multisampling_info,
        .p_depth_stencil_state = null,
        .p_color_blend_state = &colorblending_info,
        .p_dynamic_state = &dynamic_state_info,
        .layout = layout,
        .render_pass = render_pass,
        .subpass = 0,
        .base_pipeline_handle = .null_handle,
        .base_pipeline_index = -1,
    };

    var pipeline: vk.Pipeline = .null_handle;
    _ = try dev.createGraphicsPipelines(
        .null_handle,
        1,
        @ptrCast(&pipeline_info),
        null,
        @ptrCast(&pipeline),
    );
    return pipeline;
}
