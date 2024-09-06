const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("./vk.zig");
const InstanceContext = vk.InstanceContext;
const RenderContext = vk.RenderContext;
const Instance = vk.Instance;
const Device = vk.Device;
const log = vk.log;

const c = @import("c");

// ---
// TODO(ziglang/zig/#20630): move this to `src/c.h`
pub const ft = @cImport({
    @cInclude("ft2build.h");
    @cInclude("freetype/freetype.h");
});

const vma = @cImport({
    @cInclude("vk_mem_alloc.h");
});

window: *c.SDL_Window,
allocator: std.mem.Allocator,

ctx: InstanceContext,
rctx: *RenderContext,
swapchain: Swapchain,
vma_allocator: vma.VmaAllocator,

render_pass: zvk.RenderPass,
pipeline_layout: zvk.PipelineLayout,
pipeline: zvk.Pipeline,
cmdpool: zvk.CommandPool,
framebuffers: []zvk.Framebuffer,
cmdbufs: []zvk.CommandBuffer,
frames: []FrameData,
current_frame: usize = 0,

should_resize: bool = false,
ft_library: ft.FT_Library,
ft_face: ft.FT_Face = null,

const shaders = @import("shaders");
const MAX_FRAMES_IN_FLIGHT: usize = 3;

const FrameData = struct {
    cmdpool: zvk.CommandPool,
    cmdbuf: zvk.CommandBuffer,
    image_acquired_semaphore: zvk.Semaphore,
    render_semaphore: zvk.Semaphore,
    render_fence: zvk.Fence,

    fn init(dev: Device, cmdpool: zvk.CommandPool) !@This() {
        var cmdbuf: zvk.CommandBuffer = .null_handle;
        try dev.allocateCommandBuffers(&zvk.CommandBufferAllocateInfo{
            .command_pool = cmdpool,
            .command_buffer_count = 1,
            .level = .primary,
        }, @ptrCast(&cmdbuf));
        errdefer dev.freeCommandBuffers(cmdpool, 1, @ptrCast(&cmdbuf));

        const image_acquired = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(image_acquired, null);

        const render_semaphore = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(render_semaphore, null);

        const render_fence = try dev.createFence(&zvk.FenceCreateInfo{
            .flags = .{ .signaled_bit = true },
        }, null);
        errdefer dev.destroyFence(render_fence, null);

        return .{
            .cmdpool = cmdpool,
            .cmdbuf = cmdbuf,
            .image_acquired_semaphore = image_acquired,
            .render_semaphore = render_semaphore,
            .render_fence = render_fence,
        };
    }

    fn deinit(self: *@This(), dev: Device) void {
        dev.freeCommandBuffers(self.cmdpool, 1, @ptrCast(&self.cmdbuf));
        dev.destroySemaphore(self.image_acquired_semaphore, null);
        dev.destroySemaphore(self.render_semaphore, null);
        dev.destroyFence(self.render_fence, null);
    }
};

extern fn SDL_Vulkan_CreateSurface(
    window: *c.SDL_Window,
    instance: zvk.Instance,
    surface: *zvk.SurfaceKHR,
) c.SDL_bool;

pub fn init(allocator: std.mem.Allocator, window: *c.SDL_Window, ft_library: ft.FT_Library) !@This() {
    var ctx = try InstanceContext.init(allocator, window);
    errdefer ctx.deinit(allocator);

    var surface: zvk.SurfaceKHR = .null_handle;
    if (SDL_Vulkan_CreateSurface(window, ctx.instance.handle, &surface) == c.SDL_FALSE) {
        log.err("failed to create Vulkan surface: {s}", .{c.SDL_GetError()});
        return error.CreateSurfaceFailed;
    }
    errdefer ctx.instance.destroySurfaceKHR(surface, null);

    const rctx = try allocator.create(RenderContext);
    errdefer allocator.destroy(rctx);

    rctx.* = try RenderContext.init(allocator, ctx.instance, surface);
    errdefer rctx.deinit(allocator);

    const vma_allocator = blk: {
        const func_pointers: vma.VmaVulkanFunctions = .{
            .vkGetInstanceProcAddr = @ptrCast(ctx.base_dispatch.dispatch.vkGetInstanceProcAddr),
            .vkGetDeviceProcAddr = @ptrCast(ctx.instance.wrapper.dispatch.vkGetDeviceProcAddr),
        };

        const create_info: vma.VmaAllocatorCreateInfo = .{
            .vulkanApiVersion = vma.VK_API_VERSION_1_1,
            .physicalDevice = @ptrFromInt(@intFromEnum(rctx.pdev)),
            .device = @ptrFromInt(@intFromEnum(rctx.dev.handle)),
            .instance = @ptrFromInt(@intFromEnum(ctx.instance.handle)),
            .pVulkanFunctions = &func_pointers,
        };

        var alloc: vma.VmaAllocator = undefined;
        const result: zvk.Result = @enumFromInt(vma.vmaCreateAllocator(&create_info, &alloc));
        if (result != .success) {
            log.err("failed to create vulkan memory allocator", .{});
            return error.InitVulkanMemoryAllocator;
        }
        break :blk alloc;
    };
    errdefer vma.vmaDestroyAllocator(vma_allocator);

    var window_width: c_int = undefined;
    var window_height: c_int = undefined;
    c.SDL_Vulkan_GetDrawableSize(window, &window_width, &window_height);

    var swapchain = try Swapchain.create(
        allocator,
        ctx.instance,
        rctx,
        .{ .width = @intCast(window_width), .height = @intCast(window_height) },
    );
    errdefer swapchain.destroy(allocator);

    const render_pass = try createRenderPass(rctx.dev, swapchain);
    errdefer rctx.dev.destroyRenderPass(render_pass, null);

    const layout = try rctx.dev.createPipelineLayout(&zvk.PipelineLayoutCreateInfo{}, null);
    errdefer rctx.dev.destroyPipelineLayout(layout, null);

    const pipeline = try createVulkanPipeline(rctx.dev, layout, render_pass);
    errdefer rctx.dev.destroyPipeline(pipeline, null);

    const cmdpool = try rctx.dev.createCommandPool(
        &zvk.CommandPoolCreateInfo{
            .queue_family_index = rctx.graphics_queue.family,
            .flags = .{ .reset_command_buffer_bit = true },
        },
        null,
    );
    errdefer rctx.dev.destroyCommandPool(cmdpool, null);

    const framebuffers = try createFramebuffers(allocator, rctx.dev, render_pass, swapchain);
    errdefer destroyFramebuffers(allocator, rctx.dev, framebuffers);

    const cmdbufs = try allocateCommandBuffers(
        allocator,
        rctx.dev,
        cmdpool,
        framebuffers,
    );
    errdefer destroyCommandBuffers(allocator, rctx.dev, cmdpool, cmdbufs);

    const frames = try allocator.alloc(FrameData, MAX_FRAMES_IN_FLIGHT);
    errdefer allocator.free(frames);
    {
        var idx: usize = 0;
        errdefer for (0..idx) |k| frames[k].deinit(rctx.dev);

        while (idx < frames.len) : (idx += 1) {
            frames[idx] = try FrameData.init(rctx.dev, cmdpool);
        }
    }

    return .{
        .window = window,
        .allocator = allocator,
        .ctx = ctx,
        .rctx = rctx,
        .ft_library = ft_library,
        .swapchain = swapchain,
        .vma_allocator = vma_allocator,

        .render_pass = render_pass,
        .pipeline_layout = layout,
        .pipeline = pipeline,
        .cmdpool = cmdpool,
        .cmdbufs = cmdbufs,
        .framebuffers = framebuffers,

        .frames = frames,
    };
}

pub fn deinit(self: *@This()) void {
    const allocator = self.allocator;
    self.rctx.dev.deviceWaitIdle() catch std.time.sleep(std.time.ns_per_ms * 20);

    for (self.frames) |*frame| {
        frame.deinit(self.rctx.dev);
    }
    self.allocator.free(self.frames);
    destroyFramebuffers(allocator, self.rctx.dev, self.framebuffers);
    destroyCommandBuffers(allocator, self.rctx.dev, self.cmdpool, self.cmdbufs);
    self.rctx.dev.destroyCommandPool(self.cmdpool, null);

    self.rctx.dev.destroyPipeline(self.pipeline, null);
    self.rctx.dev.destroyPipelineLayout(self.pipeline_layout, null);
    self.rctx.dev.destroyRenderPass(self.render_pass, null);

    self.swapchain.destroy(allocator);
    vma.vmaDestroyAllocator(self.vma_allocator);
    self.rctx.deinit(allocator);
    allocator.destroy(self.rctx);
    self.ctx.deinit(allocator);
}

pub fn present(self: *@This()) !void {
    const dev = self.rctx.dev;
    const extent = self.swapchain.extent;
    const frame = self.frames[self.current_frame];

    switch (try dev.waitForFences(
        1,
        &.{frame.render_fence},
        zvk.TRUE,
        std.time.ns_per_s,
    )) {
        zvk.Result.success => {},
        zvk.Result.timeout => return error.Timeout,
        else => return error.Unknown,
    }
    const cmdbuf = frame.cmdbuf;
    try dev.resetFences(1, &.{frame.render_fence});
    try dev.resetCommandBuffer(cmdbuf, .{});

    const acquired = dev.acquireNextImageKHR(
        self.swapchain.handle,
        std.math.maxInt(u64),
        frame.image_acquired_semaphore,
        .null_handle,
    ) catch |err| switch (err) {
        error.OutOfDateKHR => {
            try self.doResize();
            return;
        },
        else => return err,
    };
    if (acquired.result != .success and acquired.result != .suboptimal_khr) {
        std.debug.panic("failed to acquire next image for rendering: {}", .{acquired.result});
    }

    const framebuffer = self.framebuffers[acquired.image_index];

    const clear = zvk.ClearValue{ .color = .{
        .float_32 = .{ 0, 1, 0, 1 },
    } };
    const viewport = zvk.Viewport{
        .x = 0,
        .y = 0,
        .width = @floatFromInt(self.swapchain.extent.width),
        .height = @floatFromInt(self.swapchain.extent.height),
        .min_depth = 0,
        .max_depth = 1,
    };
    const scissor = zvk.Rect2D{
        .offset = .{ .x = 0, .y = 0 },
        .extent = self.swapchain.extent,
    };
    try dev.beginCommandBuffer(cmdbuf, &zvk.CommandBufferBeginInfo{
        .flags = .{ .one_time_submit_bit = true },
    });
    dev.cmdPipelineBarrier(
        cmdbuf,
        .{ .all_graphics_bit = true },
        .{ .all_graphics_bit = true },
        .{ .by_region_bit = true },
        0,
        null,
        0,
        null,
        1,
        &[_]zvk.ImageMemoryBarrier{
            zvk.ImageMemoryBarrier{
                .image = self.swapchain.swap_images[acquired.image_index].handle,
                .src_access_mask = .{ .memory_write_bit = true },
                .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
                .old_layout = .undefined,
                .new_layout = .color_attachment_optimal,
                .src_queue_family_index = self.rctx.graphics_queue.family,
                .dst_queue_family_index = self.rctx.graphics_queue.family,
                .subresource_range = zvk.ImageSubresourceRange{
                    .aspect_mask = .{ .color_bit = true },
                    .base_mip_level = 0,
                    .level_count = zvk.REMAINING_MIP_LEVELS,
                    .base_array_layer = 0,
                    .layer_count = zvk.REMAINING_ARRAY_LAYERS,
                },
            },
        },
    );

    dev.cmdSetViewport(cmdbuf, 0, 1, @ptrCast(&viewport));
    dev.cmdSetScissor(cmdbuf, 0, 1, @ptrCast(&scissor));

    const render_area = zvk.Rect2D{
        .offset = .{ .x = 0, .y = 0 },
        .extent = extent,
    };

    dev.cmdBeginRenderPass(cmdbuf, &.{
        .render_pass = self.render_pass,
        .framebuffer = framebuffer,
        .render_area = render_area,
        .clear_value_count = 1,
        .p_clear_values = @ptrCast(&clear),
    }, .@"inline");

    dev.cmdBindPipeline(cmdbuf, .graphics, self.pipeline);
    dev.cmdDraw(cmdbuf, 3, 1, 0, 0);
    dev.cmdEndRenderPass(cmdbuf);

    dev.cmdPipelineBarrier(
        cmdbuf,
        .{ .all_graphics_bit = true },
        .{ .all_graphics_bit = true },
        .{ .by_region_bit = true },
        0,
        null,
        0,
        null,
        1,
        &[_]zvk.ImageMemoryBarrier{
            zvk.ImageMemoryBarrier{
                .image = self.swapchain.swap_images[acquired.image_index].handle,
                .src_access_mask = .{ .memory_write_bit = true },
                .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
                .old_layout = .color_attachment_optimal,
                .new_layout = .present_src_khr,
                .src_queue_family_index = self.rctx.graphics_queue.family,
                .dst_queue_family_index = self.rctx.graphics_queue.family,
                .subresource_range = zvk.ImageSubresourceRange{
                    .aspect_mask = .{ .color_bit = true },
                    .base_mip_level = 0,
                    .level_count = zvk.REMAINING_MIP_LEVELS,
                    .base_array_layer = 0,
                    .layer_count = zvk.REMAINING_ARRAY_LAYERS,
                },
            },
        },
    );
    try dev.endCommandBuffer(cmdbuf);

    try self.rctx.dev.queueSubmit(
        self.rctx.graphics_queue.handle,
        1,
        @ptrCast(&zvk.SubmitInfo{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = @ptrCast(&frame.image_acquired_semaphore),
            .p_wait_dst_stage_mask = @ptrCast(&zvk.PipelineStageFlags{ .top_of_pipe_bit = true }),

            .command_buffer_count = 1,
            .p_command_buffers = @ptrCast(&frame.cmdbuf),

            .signal_semaphore_count = 1,
            .p_signal_semaphores = @ptrCast(&frame.render_semaphore),
        }),
        frame.render_fence,
    );

    _ = try self.rctx.dev.queuePresentKHR(self.rctx.present_queue.handle, &.{
        .wait_semaphore_count = 1,
        .p_wait_semaphores = @ptrCast(&frame.render_semaphore),
        .swapchain_count = 1,
        .p_swapchains = @ptrCast(&self.swapchain.handle),
        .p_image_indices = @ptrCast(&acquired.image_index),
    });

    self.current_frame = (self.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
    if (acquired.result == .suboptimal_khr or self.should_resize) try self.doResize();
}

fn doResize(self: *@This()) !void {
    self.should_resize = false;
    var window_width: c_int = undefined;
    var window_height: c_int = undefined;
    c.SDL_Vulkan_GetDrawableSize(self.window, &window_width, &window_height);

    try self.swapchain.recreate(
        self.allocator,
        .{ .width = @intCast(window_width), .height = @intCast(window_height) },
    );

    destroyFramebuffers(self.allocator, self.rctx.dev, self.framebuffers);
    self.framebuffers = try createFramebuffers(
        self.allocator,
        self.rctx.dev,
        self.render_pass,
        self.swapchain,
    );
}

fn destroyCommandBuffers(
    allocator: std.mem.Allocator,
    dev: Device,
    cmdpool: zvk.CommandPool,
    cmdbufs: []zvk.CommandBuffer,
) void {
    dev.freeCommandBuffers(cmdpool, @intCast(cmdbufs.len), cmdbufs.ptr);
    allocator.free(cmdbufs);
}

fn destroyFramebuffers(allocator: std.mem.Allocator, dev: Device, framebuffers: []zvk.Framebuffer) void {
    for (framebuffers) |fb| dev.destroyFramebuffer(fb, null);
    allocator.free(framebuffers);
}

fn allocateCommandBuffers(
    allocator: std.mem.Allocator,
    dev: Device,
    cmdpool: zvk.CommandPool,
    framebuffers: []zvk.Framebuffer,
) ![]zvk.CommandBuffer {
    const cmdbufs = try allocator.alloc(zvk.CommandBuffer, framebuffers.len);
    errdefer allocator.free(cmdbufs);

    try dev.allocateCommandBuffers(&.{
        .command_pool = cmdpool,
        .level = .primary,
        .command_buffer_count = @intCast(cmdbufs.len),
    }, cmdbufs.ptr);

    return cmdbufs;
}

fn createFramebuffers(
    allocator: std.mem.Allocator,
    dev: Device,
    render_pass: zvk.RenderPass,
    swapchain: Swapchain,
) ![]zvk.Framebuffer {
    var framebuffers = try allocator.alloc(zvk.Framebuffer, swapchain.swap_images.len);
    errdefer allocator.free(framebuffers);

    var idx: usize = 0;
    errdefer for (framebuffers[0..idx]) |fb| dev.destroyFramebuffer(fb, null);

    while (idx < framebuffers.len) {
        framebuffers[idx] = try dev.createFramebuffer(&zvk.FramebufferCreateInfo{
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

fn createRenderPass(dev: Device, swapchain: Swapchain) !zvk.RenderPass {
    const color_attachment = zvk.AttachmentDescription{
        .format = swapchain.surface_format.format,
        .samples = .{ .@"1_bit" = true },
        .load_op = .clear,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .color_attachment_optimal,
        .final_layout = .color_attachment_optimal,
    };

    const color_attachment_ref = zvk.AttachmentReference{
        .attachment = 0,
        .layout = .color_attachment_optimal,
    };

    const subpass = zvk.SubpassDescription{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .p_color_attachments = @ptrCast(&color_attachment_ref),
    };

    return try dev.createRenderPass(&zvk.RenderPassCreateInfo{
        .attachment_count = 1,
        .p_attachments = @ptrCast(&color_attachment),
        .subpass_count = 1,
        .p_subpasses = @ptrCast(&subpass),
    }, null);
}

fn createVulkanPipeline(
    dev: Device,
    layout: zvk.PipelineLayout,
    render_pass: zvk.RenderPass,
) !zvk.Pipeline {
    const vert_module = try dev.createShaderModule(&zvk.ShaderModuleCreateInfo{
        .code_size = shaders.triangle_vert.len,
        .p_code = @ptrCast(&shaders.triangle_vert),
    }, null);
    defer dev.destroyShaderModule(vert_module, null);

    const frag_module = try dev.createShaderModule(&zvk.ShaderModuleCreateInfo{
        .code_size = shaders.triangle_frag.len,
        .p_code = @ptrCast(&shaders.triangle_frag),
    }, null);
    defer dev.destroyShaderModule(frag_module, null);

    const shader_stages = [_]zvk.PipelineShaderStageCreateInfo{
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

    const vertex_input_info = zvk.PipelineVertexInputStateCreateInfo{
        .vertex_binding_description_count = 0,
        .vertex_attribute_description_count = 0,
    };

    const input_assembly_info = zvk.PipelineInputAssemblyStateCreateInfo{
        .topology = .triangle_list,
        .primitive_restart_enable = zvk.FALSE,
    };

    const dynamic_state = [_]zvk.DynamicState{ .viewport, .scissor };
    const dynamic_state_info = zvk.PipelineDynamicStateCreateInfo{
        .dynamic_state_count = dynamic_state.len,
        .p_dynamic_states = &dynamic_state,
    };

    const viewport_state = zvk.PipelineViewportStateCreateInfo{
        .viewport_count = 1,
        .p_viewports = undefined,
        .scissor_count = 1,
        .p_scissors = undefined,
    };

    const rasterizer_info = zvk.PipelineRasterizationStateCreateInfo{
        .flags = .{},
        .depth_clamp_enable = zvk.FALSE,
        .rasterizer_discard_enable = zvk.FALSE,
        .polygon_mode = .fill,
        .cull_mode = .{ .back_bit = true },
        .front_face = .clockwise,
        .depth_bias_enable = zvk.FALSE,
        .depth_bias_constant_factor = 0,
        .depth_bias_clamp = 0,
        .depth_bias_slope_factor = 0,
        .line_width = 1,
    };
    const multisampling_info = zvk.PipelineMultisampleStateCreateInfo{
        .rasterization_samples = .{ .@"1_bit" = true },
        .min_sample_shading = 1,
        .alpha_to_coverage_enable = zvk.FALSE,
        .alpha_to_one_enable = zvk.FALSE,
        .sample_shading_enable = zvk.FALSE,
    };

    const colorblending_attach_info = zvk.PipelineColorBlendAttachmentState{
        .blend_enable = zvk.FALSE,
        .src_color_blend_factor = .one,
        .dst_color_blend_factor = .zero,
        .color_blend_op = .add,
        .src_alpha_blend_factor = .one,
        .dst_alpha_blend_factor = .zero,
        .alpha_blend_op = .add,
        .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = false },
    };

    const colorblending_info = zvk.PipelineColorBlendStateCreateInfo{
        .logic_op_enable = zvk.FALSE,
        .logic_op = .copy,
        .attachment_count = 1,
        .p_attachments = @ptrCast(&colorblending_attach_info),
        .blend_constants = .{ 0, 0, 0, 0 },
    };

    const pipeline_info = zvk.GraphicsPipelineCreateInfo{
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

    var pipeline: zvk.Pipeline = .null_handle;
    _ = try dev.createGraphicsPipelines(
        .null_handle,
        1,
        @ptrCast(&pipeline_info),
        null,
        @ptrCast(&pipeline),
    );
    return pipeline;
}

pub const Swapchain = struct {
    instance: Instance,
    context: *const RenderContext,

    handle: zvk.SwapchainKHR,
    extent: zvk.Extent2D,
    surface_format: zvk.SurfaceFormatKHR,
    present_mode: zvk.PresentModeKHR,

    swap_images: []SwapImage,

    pub fn create(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const RenderContext,
        extent: zvk.Extent2D,
    ) !@This() {
        return try recycle(allocator, instance, context, extent, .null_handle);
    }

    pub fn recreate(self: *@This(), allocator: std.mem.Allocator, extent: zvk.Extent2D) !void {
        const instance = self.instance;
        const context = self.context;

        try self.context.dev.deviceWaitIdle();
        self.destroyWithoutHandle(allocator);
        self.* = try recycle(allocator, instance, context, extent, self.handle);
    }

    fn recycle(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const RenderContext,
        extent: zvk.Extent2D,
        old_swapchain: zvk.SwapchainKHR,
    ) !@This() {
        const caps = try instance.getPhysicalDeviceSurfaceCapabilitiesKHR(context.pdev, context.surface);
        const actual_extent = clampExtentToSurfaceCaps(caps, extent);

        if (actual_extent.width == 0 or actual_extent.height == 0) return error.InvalidSurfaceDimentions;

        const surface_format = try findSurfaceFormat(allocator, instance, context);
        const presentation_mode = try findPresentationMode(allocator, instance, context);

        var image_count = caps.min_image_count + 1;
        if (caps.max_image_count > 0 and image_count > caps.max_image_count) {
            image_count = caps.max_image_count;
        }

        var create_info = zvk.SwapchainCreateInfoKHR{
            .surface = context.surface,
            .min_image_count = image_count,
            .image_format = surface_format.format,
            .image_color_space = surface_format.color_space,
            .image_extent = actual_extent,
            .image_array_layers = 1,
            .image_usage = .{ .color_attachment_bit = true },
            .image_sharing_mode = .exclusive,

            .present_mode = presentation_mode,
            .clipped = zvk.TRUE,
            .pre_transform = caps.current_transform,
            .composite_alpha = .{ .opaque_bit_khr = true },

            .old_swapchain = old_swapchain,
        };
        if (context.graphics_queue.family != context.present_queue.family) {
            create_info.image_sharing_mode = .concurrent;
            create_info.queue_family_index_count = 2;
            create_info.p_queue_family_indices = &[_]u32{ context.graphics_queue.family, context.present_queue.family };
        }

        const swapchain = try context.dev.createSwapchainKHR(&create_info, null);
        errdefer context.dev.destroySwapchainKHR(swapchain, null);

        if (old_swapchain != .null_handle) {
            context.dev.destroySwapchainKHR(old_swapchain, null);
        }

        const swap_images = try initSwapchainImages(allocator, context, swapchain, surface_format.format);
        errdefer {
            for (swap_images) |*image| {
                image.deinit();
            }
            allocator.free(swap_images);
        }

        return .{
            .instance = instance,
            .context = context,
            .handle = swapchain,
            .extent = actual_extent,
            .surface_format = surface_format,
            .present_mode = presentation_mode,
            .swap_images = swap_images,
        };
    }

    pub fn destroyWithoutHandle(self: *@This(), allocator: std.mem.Allocator) void {
        for (self.swap_images) |*swapimage| {
            swapimage.deinit();
        }
        allocator.free(self.swap_images);
    }

    pub fn destroy(self: *@This(), allocator: std.mem.Allocator) void {
        // If we fail to wait, just wait on the CPU and cross fingers the GPU
        // completed all jobs
        self.context.dev.deviceWaitIdle() catch |err| {
            log.warn("deviceWaitIdle failed: {s}", .{@errorName(err)});
            std.time.sleep(std.time.ns_per_ms * 20);
        };
        self.destroyWithoutHandle(allocator);
        self.context.dev.destroySwapchainKHR(self.handle, null);
    }

    fn initSwapchainImages(
        allocator: std.mem.Allocator,
        context: *const RenderContext,
        swapchain: zvk.SwapchainKHR,
        format: zvk.Format,
    ) ![]SwapImage {
        const images = try context.dev.getSwapchainImagesAllocKHR(swapchain, allocator);
        defer allocator.free(images);

        const swap_images = try allocator.alloc(SwapImage, images.len);
        errdefer allocator.free(swap_images);

        var last_idx: usize = 0;
        errdefer for (0..last_idx) |i| swap_images[i].deinit();

        while (last_idx < images.len) {
            swap_images[last_idx] = try SwapImage.init(context, images[last_idx], format);
            last_idx += 1;
        }
        return swap_images;
    }

    fn clampExtentToSurfaceCaps(caps: zvk.SurfaceCapabilitiesKHR, extent: zvk.Extent2D) zvk.Extent2D {
        if (caps.current_extent.width != std.math.maxInt(u32)) {
            return caps.current_extent;
        } else {
            return .{
                .width = std.math.clamp(extent.width, caps.min_image_extent.width, caps.max_image_extent.width),
                .height = std.math.clamp(extent.height, caps.min_image_extent.height, caps.max_image_extent.height),
            };
        }
    }

    /// Tries to find V-sync enabled mode `mailbox_khr`, else fallback to `fifo_khr`.
    ///
    /// `mailbox_khr` maintains a single-entry queue. Whenever a new image is pushed
    /// it gets replaced with new one.
    ///
    /// [p] - [1]
    ///
    /// `fifo_khr` maintains a mutiple-entry queue. Each entry is appened to the end of the queue
    ///
    /// [p] - [1] - [2] - ...
    // TODO: When using mailbox_khr, manually limit frame rate to display's refresh rate
    fn findPresentationMode(
        _: std.mem.Allocator,
        _: Instance,
        _: *const RenderContext,
    ) !zvk.PresentModeKHR {
        // const modes = try instance.getPhysicalDeviceSurfacePresentModesAllocKHR(context.pdev, context.surface, allocator);
        // defer allocator.free(modes);

        // for (modes) |mode| {
        //     if (mode == .mailbox_khr) return mode;
        // }

        return .fifo_khr;
    }

    /// Tries to find RGB8 srgb surface format.
    /// If the search fails, returns whatever the first format was reported
    fn findSurfaceFormat(
        allocator: std.mem.Allocator,
        instance: Instance,
        context: *const RenderContext,
    ) !zvk.SurfaceFormatKHR {
        const surface_formats = try instance.getPhysicalDeviceSurfaceFormatsAllocKHR(context.pdev, context.surface, allocator);
        defer allocator.free(surface_formats);

        const preffered = zvk.SurfaceFormatKHR{
            .format = .r8g8b8_srgb,
            .color_space = .srgb_nonlinear_khr,
        };

        for (surface_formats) |format| {
            if (std.meta.eql(format, preffered)) return format;
        }

        return surface_formats[0];
    }

    const SwapImage = struct {
        context: *const RenderContext,
        handle: zvk.Image,
        view: zvk.ImageView,

        pub fn init(context: *const RenderContext, handle: zvk.Image, format: zvk.Format) !@This() {
            const view = try context.dev.createImageView(&zvk.ImageViewCreateInfo{
                .image = handle,
                .view_type = .@"2d",
                .format = format,
                .components = .{
                    .r = .identity,
                    .g = .identity,
                    .b = .identity,
                    .a = .identity,
                },
                .subresource_range = .{
                    .aspect_mask = .{ .color_bit = true },
                    .base_mip_level = 0,
                    .level_count = 1,
                    .base_array_layer = 0,
                    .layer_count = 1,
                },
            }, null);
            errdefer context.dev.destroyImageView(view, null);

            return .{
                .context = context,
                .handle = handle,
                .view = view,
            };
        }

        pub fn deinit(self: *@This()) void {
            self.context.dev.destroyImageView(self.view, null);
        }
    };
};
