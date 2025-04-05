const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("../vk.zig");
const vma = @import("../vma.zig");
const math = @import("../math.zig");
const shader_glyph_vert align(@alignOf(u32)) = @embedFile("shader_glyph_vert").*;
const shader_glyph_frag align(@alignOf(u32)) = @embedFile("shader_glyph_frag").*;

const FrameData = @import("./VkRenderer.zig").FrameData;

vma_alloc: vma.Allocator,
pipeline: zvk.Pipeline,
pipeline_layout: zvk.PipelineLayout,
vert_module: zvk.ShaderModule,
frag_module: zvk.ShaderModule,

buffers: std.ArrayList(StagingBuffers),

const GlyphVert = extern struct {
    pos: math.Vec(3, f32),
    color: math.Vec(3, f32),
    size: math.Vec(2, f32),

    const binding_description = zvk.VertexInputBindingDescription{
        .binding = 0,
        .stride = @sizeOf(GlyphVert),
        .input_rate = .instance,
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
        .{
            .binding = 0,
            .location = 2,
            .format = zvk.Format.r32g32_sfloat,
            .offset = @offsetOf(GlyphVert, "size"),
        },
    };
};

const default_vertex_input_state: zvk.PipelineVertexInputStateCreateInfo = .{
    .vertex_binding_description_count = 1,
    .p_vertex_binding_descriptions = @ptrCast(&GlyphVert.binding_description),
    .vertex_attribute_description_count = 3,
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
    allocator: std.mem.Allocator,
    dev: vk.Device,
    _: zvk.Format,
    vma_alloc: vma.Allocator,
    render_pass: zvk.RenderPass,
) !@This() {
    const layout = try dev.createPipelineLayout(&.{}, null);
    errdefer dev.destroyPipelineLayout(layout, null);

    const vert_module = try dev.createShaderModule(&.{
        .code_size = shader_glyph_vert.len,
        .p_code = @ptrCast(&shader_glyph_vert),
    }, null);
    errdefer dev.destroyShaderModule(vert_module, null);

    const frag_module = try dev.createShaderModule(&.{
        .code_size = shader_glyph_frag.len,
        .p_code = @ptrCast(&shader_glyph_frag),
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

    var buffers = std.ArrayList(StagingBuffers).init(allocator);
    errdefer buffers.deinit();

    try buffers.append(try StagingBuffers.init(vma_alloc, 512));

    return .{
        .vma_alloc = vma_alloc,
        .pipeline = pipeline,
        .pipeline_layout = layout,
        .vert_module = vert_module,
        .frag_module = frag_module,

        .buffers = buffers,
    };
}

pub fn deinit(self: *@This(), dev: vk.Device, vma_alloc: vma.Allocator) void {
    dev.destroyPipelineLayout(self.pipeline_layout, null);
    dev.destroyPipeline(self.pipeline, null);
    dev.destroyShaderModule(self.vert_module, null);
    dev.destroyShaderModule(self.frag_module, null);

    for (self.buffers.items) |*buf| {
        buf.deinit(vma_alloc);
    }
    self.buffers.deinit();
}

const StagingBuffers = struct {
    glyph_count: u32 = 1,

    vbo: zvk.Buffer,
    vbo_allocation: vma.Allocation,
    vbo_info: vma.AllocationInfo,
    vertex_count: u32 = 0,

    ibo: zvk.Buffer,
    ibo_allocation: vma.Allocation,
    ibo_info: vma.AllocationInfo,
    indices_count: u32 = 0,

    fn init(vma_alloc: vma.Allocator, glyph_count: u32) !@This() {
        std.debug.assert(glyph_count != 0);

        var vbo_info: vma.AllocationInfo = undefined;
        var vbo_allocation: vma.Allocation = undefined;
        const vbo_buffer = try vma.createBuffer(vma_alloc, .{
            .size = 4 * @sizeOf(f32) * glyph_count,
            .usage = .{ .vertex_buffer_bit = true },
            .sharing_mode = .exclusive,
        }, .{
            .flags = .{ .mapped_bit = true, .host_access_sequential_bit = true },
            .usage = .cpu_to_gpu,
            .required_flags = .{ .host_visible_bit = true, .host_coherent_bit = true },
        }, &vbo_allocation, &vbo_info);
        errdefer vma.destroyBuffer(vma_alloc, vbo_buffer, vbo_allocation);

        var ibo_info: vma.AllocationInfo = undefined;
        var ibo_allocation: vma.Allocation = undefined;
        const ibo_buffer = try vma.createBuffer(vma_alloc, .{
            .size = 6 * @sizeOf(u32) * glyph_count,
            .usage = .{ .index_buffer_bit = true },
            .sharing_mode = .exclusive,
        }, .{
            .flags = .{ .mapped_bit = true, .host_access_sequential_bit = true },
            .usage = .cpu_to_gpu,
            .required_flags = .{ .host_visible_bit = true, .host_coherent_bit = true },
        }, &ibo_allocation, &ibo_info);

        return StagingBuffers{
            .glyph_count = glyph_count,

            .vbo = vbo_buffer,
            .vbo_allocation = vbo_allocation,
            .vbo_info = vbo_info,

            .ibo = ibo_buffer,
            .ibo_allocation = ibo_allocation,
            .ibo_info = ibo_info,
        };
    }

    fn deinit(self: *@This(), vma_alloc: vma.Allocator) void {
        vma.destroyBuffer(vma_alloc, self.vbo, self.vbo_allocation);
        vma.destroyBuffer(vma_alloc, self.ibo, self.ibo_allocation);
    }
};

pub fn pushGlyph(self: *@This(), x: f32, y: f32) !void {
    var buffers = &self.buffers.items[self.buffers.items.len - 1];
    if (buffers.glyph_count == buffers.vertex_count) {
        try self.buffers.append(try StagingBuffers.init(self.vma_alloc, buffers.glyph_count * 2));
        buffers = &self.buffers.items[self.buffers.items.len - 1];
    }

    const vbo_data: [*]GlyphVert = @alignCast(@ptrCast(buffers.vbo_info.pMappedData orelse
        std.debug.panic("vertex buffer not mapped", .{})));

    const ibo_data: [*]u32 = @alignCast(@ptrCast(buffers.ibo_info.pMappedData orelse
        std.debug.panic("index buffer not mapped", .{})));

    const vbo_slice = vbo_data[buffers.vertex_count .. buffers.vertex_count + 1];
    vbo_slice[0] = GlyphVert{ .pos = .{ x, y, 0 }, .color = .{ 1, 1, 1 }, .size = .{ 20, 20 } };

    const ibo_slice = ibo_data[buffers.indices_count .. buffers.indices_count + 6];
    ibo_slice[0] = buffers.vertex_count + 0;
    ibo_slice[1] = buffers.vertex_count + 1;
    ibo_slice[2] = buffers.vertex_count + 2;
    ibo_slice[3] = buffers.vertex_count + 2;
    ibo_slice[4] = buffers.vertex_count + 3;
    ibo_slice[5] = buffers.vertex_count + 0;

    buffers.vertex_count += @intCast(vbo_slice.len);
    buffers.indices_count += @intCast(ibo_slice.len);
}

pub fn record(self: *@This(), dev: vk.Device, cmdbuf: zvk.CommandBuffer) void {
    dev.cmdBindPipeline(cmdbuf, .graphics, self.pipeline);
    for (self.buffers.items) |buffer| {
        dev.cmdBindIndexBuffer(cmdbuf, buffer.ibo, 0, .uint32);
        dev.cmdBindVertexBuffers(cmdbuf, 0, 1, &.{buffer.vbo}, &.{0});
        dev.cmdDrawIndexed(cmdbuf, buffer.indices_count, buffer.glyph_count, 0, 0, 0);
    }
}

pub fn clear(self: *@This()) void {
    for (0..self.buffers.items.len - 1) |_| {
        const idx = self.buffers.items.len - 2;

        self.buffers.items[idx].deinit(self.vma_alloc);
        _ = self.buffers.swapRemove(idx);
    }
    var buffers = &self.buffers.items[0];
    buffers.vertex_count = 0;
    buffers.indices_count = 0;
}
