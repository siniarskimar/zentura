const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("../vk.zig");
const vma = @import("../vma.zig");
const math = @import("../math.zig");
const shaders = @import("vk-shaders");

const FrameData = @import("./VkRenderer.zig").FrameData;

vma_alloc: vma.Allocator,
pipeline: zvk.Pipeline,
pipeline_layout: zvk.PipelineLayout,
vert_module: zvk.ShaderModule,
frag_module: zvk.ShaderModule,

buffers: StagingBuffers,

const GlyphVert = extern struct {
    pos: math.Vec(3, f32),
    color: math.Vec(3, f32),

    const binding_description = zvk.VertexInputBindingDescription{
        .binding = 0,
        .stride = @sizeOf(GlyphVert),
        .input_rate = .vertex,
    };
    const attribute_descriptions = [_]zvk.VertexInputAttributeDescription{
        .{
            .binding = 0,
            .location = 0,
            .format = zvk.Format.r32g32b32_sfloat,
            .offset = @offsetOf(GlyphVert, "pos"),
        },
        .{
            .binding = 0,
            .location = 1,
            .format = zvk.Format.r32g32b32_sfloat,
            .offset = @offsetOf(GlyphVert, "color"),
        },
    };
};

const default_vertex_input_state: zvk.PipelineVertexInputStateCreateInfo = .{
    .vertex_binding_description_count = 1,
    .p_vertex_binding_descriptions = @ptrCast(&GlyphVert.binding_description),
    .vertex_attribute_description_count = 2,
    .p_vertex_attribute_descriptions = &GlyphVert.attribute_descriptions,
};
const default_input_assembly_state: zvk.PipelineInputAssemblyStateCreateInfo = .{
    .topology = .triangle_list,
    .primitive_restart_enable = 0,
};
const default_dynamic_state: zvk.PipelineDynamicStateCreateInfo = .{
    .dynamic_state_count = 2,
    .p_dynamic_states = &[_]zvk.DynamicState{ .viewport, .scissor },
};
const default_color_blend_state: zvk.PipelineColorBlendStateCreateInfo = .{
    .logic_op_enable = zvk.FALSE,
    .logic_op = .copy,
    .attachment_count = 1,
    .p_attachments = &.{
        zvk.PipelineColorBlendAttachmentState{
            .blend_enable = zvk.FALSE,
            .src_color_blend_factor = .one,
            .dst_color_blend_factor = .zero,
            .color_blend_op = .add,
            .src_alpha_blend_factor = .one,
            .dst_alpha_blend_factor = .zero,
            .alpha_blend_op = .add,
            .color_write_mask = .{ .r_bit = true, .g_bit = true, .b_bit = true, .a_bit = false },
        },
    },
    .blend_constants = .{ 0, 0, 0, 0 },
};

const default_viewport_state: zvk.PipelineViewportStateCreateInfo = .{
    .viewport_count = 1,
    .p_viewports = null, // dynamic
    .scissor_count = 1,
    .p_scissors = null, // dynamic
};

const renderpass_attachments = [_]zvk.AttachmentDescription{
    .{
        .format = undefined, // set in `init`
        .samples = .{ .@"1_bit" = true },
        .load_op = .load,
        .store_op = .store,
        .stencil_load_op = .dont_care,
        .stencil_store_op = .dont_care,
        .initial_layout = .color_attachment_optimal,
        .final_layout = .color_attachment_optimal,
    },
};
const renderpass_subpasses = [_]zvk.SubpassDescription{
    .{
        .pipeline_bind_point = .graphics,
        .color_attachment_count = 1,
        .p_color_attachments = &[_]zvk.AttachmentReference{
            .{
                .attachment = 0,
                .layout = .color_attachment_optimal,
            },
        },
    },
};

pub fn init(
    dev: vk.Device,
    surface_format: zvk.Format,
    vma_alloc: vma.Allocator,
    render_pass: zvk.RenderPass,
) !@This() {
    var attachments = renderpass_attachments;
    attachments[0].format = surface_format;

    const layout = try dev.createPipelineLayout(&.{}, null);
    errdefer dev.destroyPipelineLayout(layout, null);

    const vert_module = try dev.createShaderModule(&.{
        .code_size = shaders.triangle_vert.len,
        .p_code = @ptrCast(&shaders.triangle_vert),
    }, null);
    errdefer dev.destroyShaderModule(vert_module, null);

    const frag_module = try dev.createShaderModule(&.{
        .code_size = shaders.triangle_frag.len,
        .p_code = @ptrCast(&shaders.triangle_frag),
    }, null);
    errdefer dev.destroyShaderModule(frag_module, null);

    var pipeline: zvk.Pipeline = .null_handle;
    _ = try dev.createGraphicsPipelines(
        .null_handle,
        1,
        &[_]zvk.GraphicsPipelineCreateInfo{
            zvk.GraphicsPipelineCreateInfo{
                .layout = layout,
                .render_pass = render_pass,
                .subpass = 0,
                .base_pipeline_index = -1,
                .stage_count = 2,
                .p_stages = &[_]zvk.PipelineShaderStageCreateInfo{
                    .{
                        .flags = .{},
                        .stage = .{ .vertex_bit = true },
                        .module = vert_module,
                        .p_name = "main",
                    },
                    .{
                        .flags = .{},
                        .stage = .{ .fragment_bit = true },
                        .module = frag_module,
                        .p_name = "main",
                    },
                },
                .p_vertex_input_state = &default_vertex_input_state,
                .p_input_assembly_state = &default_input_assembly_state,
                .p_tessellation_state = null,
                .p_viewport_state = &default_viewport_state,
                .p_rasterization_state = &zvk.PipelineRasterizationStateCreateInfo{
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
                },
                .p_multisample_state = &zvk.PipelineMultisampleStateCreateInfo{
                    .rasterization_samples = .{ .@"1_bit" = true },
                    .min_sample_shading = 1,
                    .alpha_to_coverage_enable = zvk.FALSE,
                    .alpha_to_one_enable = zvk.FALSE,
                    .sample_shading_enable = zvk.FALSE,
                },
                .p_depth_stencil_state = null,
                .p_color_blend_state = &default_color_blend_state,
                .p_dynamic_state = &default_dynamic_state,
            },
        },
        null,
        @ptrCast(&pipeline),
    );

    return .{
        .vma_alloc = vma_alloc,
        .pipeline = pipeline,
        .pipeline_layout = layout,
        .vert_module = vert_module,
        .frag_module = frag_module,

        .buffers = try allocateStagingBuffers(vma_alloc, 1),
    };
}

pub fn deinit(self: *@This(), dev: vk.Device, vma_alloc: vma.Allocator) void {
    dev.destroyPipelineLayout(self.pipeline_layout, null);
    dev.destroyPipeline(self.pipeline, null);
    dev.destroyShaderModule(self.vert_module, null);
    dev.destroyShaderModule(self.frag_module, null);

    vma.destroyBuffer(vma_alloc, self.buffers.vbo, self.buffers.vbo_allocation);
    vma.destroyBuffer(vma_alloc, self.buffers.ibo, self.buffers.ibo_allocation);
}

const StagingBuffers = struct {
    size_factor: u32 = 1,

    vbo: zvk.Buffer,
    vbo_allocation: vma.Allocation,
    vbo_info: vma.AllocationInfo,
    vertex_count: u32 = 0,

    ibo: zvk.Buffer,
    ibo_allocation: vma.Allocation,
    ibo_info: vma.AllocationInfo,
    indices_count: u32 = 0,
};

fn allocateStagingBuffers(vma_alloc: vma.Allocator, size_factor: u32) !StagingBuffers {
    std.debug.assert(size_factor != 0);

    var vbo_info: vma.AllocationInfo = undefined;
    var vbo_allocation: vma.Allocation = undefined;
    const vbo_buffer = try vma.createBuffer(vma_alloc, .{
        .size = 16 * 1024 * size_factor,
        .usage = .{ .transfer_src_bit = true },
        .sharing_mode = .exclusive,
    }, .{
        .flags = .{ .mapped_bit = true, .host_access_sequential_bit = true },
        .usage = .cpu_to_gpu,
        .required_flags = .{ .host_visible_bit = true, .host_coherent_bit = true },
    }, &vbo_allocation, &vbo_info);

    var ibo_info: vma.AllocationInfo = undefined;
    var ibo_allocation: vma.Allocation = undefined;
    const ibo_buffer = try vma.createBuffer(vma_alloc, .{
        .size = 1000 * 6 * @sizeOf(u32) * size_factor,
        .usage = .{ .transfer_src_bit = true },
        .sharing_mode = .exclusive,
    }, .{
        .flags = .{ .mapped_bit = true, .host_access_sequential_bit = true },
        .usage = .cpu_to_gpu,
        .required_flags = .{ .host_visible_bit = true, .host_coherent_bit = true },
    }, &ibo_allocation, &ibo_info);

    return StagingBuffers{
        .vbo = vbo_buffer,
        .vbo_allocation = vbo_allocation,
        .vbo_info = vbo_info,

        .ibo = ibo_buffer,
        .ibo_allocation = ibo_allocation,
        .ibo_info = ibo_info,
    };
}

pub const FlushInfo = struct {
    pipeline: zvk.Pipeline,
    buffers: StagingBuffers,

    pub fn recordCommandBuffers(self: @This(), dev: vk.Device, frame: *FrameData) void {
        dev.cmdBindPipeline(frame.cmdbuf, .graphics, self.pipeline);
        dev.cmdBindVertexBuffers(frame.cmdbuf, 0, 1, &.{frame.gpu_vbo}, &.{frame.gpu_vbo_offset});
        dev.cmdBindIndexBuffer(frame.cmdbuf, frame.gpu_ibo, frame.gpu_ibo_offset, .uint32);
        dev.cmdDrawIndexed(frame.cmdbuf, self.buffers.indices_count, self.buffers.indices_count / 6, 0, 0, 0);

        const vbo_size = self.buffers.vertex_count * @sizeOf(GlyphVert);
        const ibo_size = self.buffers.indices_count * @sizeOf(u32);

        dev.cmdCopyBuffer(frame.transfer_cmdbuf, self.buffers.vbo, frame.gpu_vbo, 1, &.{
            zvk.BufferCopy{
                .src_offset = 0,
                .dst_offset = frame.gpu_vbo_offset,
                .size = vbo_size,
            },
        });
        dev.cmdCopyBuffer(frame.transfer_cmdbuf, self.buffers.ibo, frame.gpu_ibo, 1, &.{
            zvk.BufferCopy{
                .src_offset = 0,
                .dst_offset = frame.gpu_ibo_offset,
                .size = ibo_size,
            },
        });

        frame.gpu_vbo_offset += vbo_size;
        frame.gpu_ibo_offset += ibo_size;
    }
};

pub fn flush(self: *@This(), reason_full: bool) !FlushInfo {
    const flush_info = FlushInfo{
        .pipeline = self.pipeline,
        .buffers = self.buffers,
    };
    if (reason_full) {
        self.buffers.size_factor += 1;
    }

    self.buffers = try allocateStagingBuffers(self.vma_alloc, self.buffers.size_factor);
    return flush_info;
}

pub fn buffersFull(self: *const @This()) bool {
    const vbo = (self.buffers.vertex_count + 4) * @sizeOf(GlyphVert) >= self.buffers.vbo_info.size;
    const ibo = (self.buffers.indices_count + 6) * @sizeOf(u32) >= self.buffers.ibo_info.size;

    return vbo or ibo;
}

pub fn pushGlyph(self: *@This(), x: f32, y: f32) void {
    std.debug.assert(self.buffersFull() == false);
    std.debug.assert(self.buffers.vbo_info.pMappedData != null);

    const vbo_data: [*]GlyphVert = @alignCast(@ptrCast(self.buffers.vbo_info.pMappedData orelse
        std.debug.panic("vertex buffer not mapped", .{})));

    const ibo_data: [*]u32 = @alignCast(@ptrCast(self.buffers.ibo_info.pMappedData orelse
        std.debug.panic("index buffer not mapped", .{})));

    const vbo_slice = vbo_data[self.buffers.vertex_count .. self.buffers.vertex_count + 4];
    vbo_slice[0] = GlyphVert{ .pos = .{ x, y, 0 }, .color = .{ 1, 1, 1 } };
    vbo_slice[1] = GlyphVert{ .pos = .{ x + 0.1, y, 0 }, .color = .{ 1, 1, 1 } };
    vbo_slice[2] = GlyphVert{ .pos = .{ x + 0.1, y + 0.1, 0 }, .color = .{ 1, 1, 1 } };
    vbo_slice[3] = GlyphVert{ .pos = .{ x, y + 0.1, 0 }, .color = .{ 1, 1, 1 } };

    const ibo_slice = ibo_data[self.buffers.indices_count .. self.buffers.indices_count + 6];
    ibo_slice[0] = self.buffers.vertex_count + 0;
    ibo_slice[1] = self.buffers.vertex_count + 1;
    ibo_slice[2] = self.buffers.vertex_count + 2;
    ibo_slice[3] = self.buffers.vertex_count + 2;
    ibo_slice[4] = self.buffers.vertex_count + 3;
    ibo_slice[5] = self.buffers.vertex_count + 0;

    self.buffers.vertex_count += @intCast(vbo_slice.len);
    self.buffers.indices_count += @intCast(ibo_slice.len);
}
