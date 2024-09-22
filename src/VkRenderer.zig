const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("./vk.zig");
const vma = @import("./vma.zig");
const math = @import("./math.zig");
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

window: *c.SDL_Window,
allocator: std.mem.Allocator,

ctx: InstanceContext,
rctx: *RenderContext,
swapchain: Swapchain,
vma_allocator: vma.Allocator,

text_renderpass: TextRenderpass,
cmdpool: zvk.CommandPool,
frames: []FrameData,
current_frame: usize = 0,

should_resize: bool = false,
ft_library: ft.FT_Library,
ft_face: ft.FT_Face = null,

const shaders = @import("shaders");
const MAX_FRAMES_IN_FLIGHT: usize = 3;

const FrameData = struct {
    allocator: std.mem.Allocator,
    cmdpool: zvk.CommandPool,
    cmdbuf: zvk.CommandBuffer,

    image_acquired_semaphore: zvk.Semaphore,
    acquired_idx: u32 = 0,
    render_semaphore: zvk.Semaphore,
    render_fence: zvk.Fence,

    gpu_vbo: zvk.Buffer,
    gpu_vbo_memalloc: vma.Allocation,
    gpu_vbo_info: vma.AllocationInfo,
    gpu_vbo_offset: zvk.DeviceSize,

    gpu_ibo: zvk.Buffer,
    gpu_ibo_memalloc: vma.Allocation,
    gpu_ibo_info: vma.AllocationInfo,
    gpu_ibo_offset: zvk.DeviceSize,

    transfer_cmdbuf: zvk.CommandBuffer,
    transfer_semaphore: zvk.Semaphore,
    text_transfer_info: std.ArrayListUnmanaged(TextRenderpass.FlushInfo) = .{},
    text_transfer_count: usize = 0,

    fn init(
        allocator: std.mem.Allocator,
        dev: Device,
        cmdpool: zvk.CommandPool,
        vma_alloc: vma.Allocator,
    ) !@This() {
        var cmdbufs = [1]zvk.CommandBuffer{.null_handle} ** 2;
        try dev.allocateCommandBuffers(&zvk.CommandBufferAllocateInfo{
            .command_pool = cmdpool,
            .command_buffer_count = 2,
            .level = .primary,
        }, &cmdbufs);
        errdefer dev.freeCommandBuffers(cmdpool, 2, &cmdbufs);

        const image_acquired = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(image_acquired, null);

        const render_semaphore = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(render_semaphore, null);

        const render_fence = try dev.createFence(&zvk.FenceCreateInfo{
            .flags = .{ .signaled_bit = true },
        }, null);
        errdefer dev.destroyFence(render_fence, null);

        var gpu_vbo_info: vma.AllocationInfo = undefined;
        var gpu_vbo_memalloc: vma.Allocation = undefined;
        const gpu_vbo = try vma.createBuffer(
            vma_alloc,
            zvk.BufferCreateInfo{
                // 1 MiB
                .size = 1 * 1024 * 1024,
                .usage = .{ .transfer_dst_bit = true, .vertex_buffer_bit = true },
                .sharing_mode = .exclusive,
            },
            .{
                .flags = .{},
                // Prefer for this buffer to be allocated on GPU
                .preferred_flags = @bitCast(zvk.MemoryPropertyFlags{ .device_local_bit = true }),
                .usage = .gpu_only,
            },
            &gpu_vbo_memalloc,
            &gpu_vbo_info,
        );

        var gpu_ibo_info: vma.AllocationInfo = undefined;
        var gpu_ibo_memalloc: vma.Allocation = undefined;
        const gpu_ibo = try vma.createBuffer(
            vma_alloc,
            zvk.BufferCreateInfo{
                .size = 1 * 1024 * 1024,
                .usage = .{ .transfer_dst_bit = true, .index_buffer_bit = true },
                .sharing_mode = .exclusive,
            },
            .{
                .flags = .{},
                // Prefer for this buffer to be allocated on GPU
                .preferred_flags = @bitCast(zvk.MemoryPropertyFlags{ .device_local_bit = true }),
                .usage = .gpu_only,
            },
            &gpu_ibo_memalloc,
            &gpu_ibo_info,
        );

        const transfer_semaphore = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(transfer_semaphore, null);

        return FrameData{
            .allocator = allocator,
            .cmdpool = cmdpool,
            .cmdbuf = cmdbufs[0],
            .image_acquired_semaphore = image_acquired,
            .render_semaphore = render_semaphore,
            .render_fence = render_fence,

            .gpu_vbo = gpu_vbo,
            .gpu_vbo_memalloc = gpu_vbo_memalloc,
            .gpu_vbo_info = gpu_vbo_info,
            .gpu_vbo_offset = 0,

            .gpu_ibo = gpu_ibo,
            .gpu_ibo_memalloc = gpu_ibo_memalloc,
            .gpu_ibo_info = gpu_ibo_info,
            .gpu_ibo_offset = 0,

            .transfer_cmdbuf = cmdbufs[1],
            .transfer_semaphore = transfer_semaphore,
        };
    }

    fn deinit(self: *@This(), dev: Device, vma_alloc: vma.Allocator) void {
        vma.destroyBuffer(vma_alloc, self.gpu_vbo, self.gpu_vbo_memalloc);
        vma.destroyBuffer(vma_alloc, self.gpu_ibo, self.gpu_ibo_memalloc);
        dev.freeCommandBuffers(self.cmdpool, 2, &[2]zvk.CommandBuffer{ self.cmdbuf, self.transfer_cmdbuf });
        dev.destroySemaphore(self.transfer_semaphore, null);
        dev.destroySemaphore(self.image_acquired_semaphore, null);
        dev.destroySemaphore(self.render_semaphore, null);
        dev.destroyFence(self.render_fence, null);
        self.text_transfer_info.deinit(self.allocator);
    }

    fn clearFlushes(self: *@This(), vma_alloc: vma.Allocator) void {
        const text_flushes: []TextRenderpass.FlushInfo = self.text_transfer_info.items[0..self.text_transfer_count];
        for (text_flushes, 0..) |flush_info, idx| {
            vma.destroyBuffer(vma_alloc, flush_info.buffers.vbo, flush_info.buffers.vbo_allocation);
            vma.destroyBuffer(vma_alloc, flush_info.buffers.ibo, flush_info.buffers.ibo_allocation);
            _ = self.text_transfer_info.swapRemove(idx);
        }
        self.text_transfer_count = 0;
        self.gpu_vbo_offset = 0;
        self.gpu_ibo_offset = 0;
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

    const vma_allocator = try initVmaAllocator(&ctx, rctx);
    errdefer vma.destroyAllocator(vma_allocator);

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

    const cmdpool = try rctx.dev.createCommandPool(
        &zvk.CommandPoolCreateInfo{
            .queue_family_index = rctx.graphics_queue.family,
            .flags = .{ .reset_command_buffer_bit = true },
        },
        null,
    );
    errdefer rctx.dev.destroyCommandPool(cmdpool, null);

    const frames = try allocator.alloc(FrameData, MAX_FRAMES_IN_FLIGHT);
    errdefer allocator.free(frames);
    {
        var idx: usize = 0;
        errdefer for (0..idx) |k| frames[k].deinit(rctx.dev, vma_allocator);

        while (idx < frames.len) : (idx += 1) {
            frames[idx] = try FrameData.init(allocator, rctx.dev, cmdpool, vma_allocator);
        }
    }

    const text_renderpass = try TextRenderpass.init(
        rctx.dev,
        swapchain.surface_format.format,
        vma_allocator,
        swapchain.render_pass,
    );
    errdefer text_renderpass.deinit(rctx.dev);

    return .{
        .window = window,
        .allocator = allocator,
        .ctx = ctx,
        .rctx = rctx,
        .ft_library = ft_library,
        .swapchain = swapchain,
        .vma_allocator = vma_allocator,

        .cmdpool = cmdpool,
        .frames = frames,

        .text_renderpass = text_renderpass,
    };
}

pub fn deinit(self: *@This()) void {
    const allocator = self.allocator;
    self.rctx.dev.deviceWaitIdle() catch std.time.sleep(std.time.ns_per_ms * 20);

    for (self.frames) |*frame| {
        frame.text_transfer_count = frame.text_transfer_info.items.len;
        frame.clearFlushes(self.vma_allocator);
        frame.deinit(self.rctx.dev, self.vma_allocator);
    }
    self.allocator.free(self.frames);
    self.rctx.dev.destroyCommandPool(self.cmdpool, null);

    self.text_renderpass.deinit(self.rctx.dev, self.vma_allocator);

    self.swapchain.destroy(allocator);
    vma.destroyAllocator(self.vma_allocator);
    self.rctx.deinit(allocator);
    allocator.destroy(self.rctx);
    self.ctx.deinit(allocator);
}

fn initVmaAllocator(instancectx: *const InstanceContext, renderctx: *const RenderContext) !vma.Allocator {
    var alloc: vma.Allocator = undefined;
    const result: zvk.Result = @enumFromInt(vma.createAllocator(&vma.AllocatorCreateInfo{
        .vulkanApiVersion = vma.VK_API_VERSION_1_1,
        .physicalDevice = @ptrFromInt(@intFromEnum(renderctx.pdev)),
        .device = @ptrFromInt(@intFromEnum(renderctx.dev.handle)),
        .instance = @ptrFromInt(@intFromEnum(instancectx.instance.handle)),
        .pVulkanFunctions = &vma.VulkanFunctions{
            .vkGetInstanceProcAddr = @ptrCast(instancectx.base_dispatch.dispatch.vkGetInstanceProcAddr),
            .vkGetDeviceProcAddr = @ptrCast(instancectx.instance.wrapper.dispatch.vkGetDeviceProcAddr),
        },
    }, &alloc));
    if (result != .success) {
        log.err("failed to create vulkan memory allocator", .{});
        return error.InitVulkanMemoryAllocator;
    }
    return alloc;
}

fn getCurrentFrame(self: *@This()) *FrameData {
    return &self.frames[self.current_frame];
}

pub fn present(self: *@This()) !void {
    const dev = self.rctx.dev;
    const frame = self.getCurrentFrame();
    const extent = self.swapchain.extent;

    // switch (try dev.waitForFences(
    //     1,
    //     &.{frame.secondary_fence},
    //     zvk.TRUE,
    //     std.time.ns_per_s,
    // )) {
    //     zvk.Result.success => {},
    //     zvk.Result.timeout => return error.Timeout,
    //     else => return error.Unknown,
    // }
    // try dev.resetFences(1, &.{frame.secondary_fence});
    try dev.resetCommandBuffer(frame.cmdbuf, .{});
    try dev.resetCommandBuffer(frame.transfer_cmdbuf, .{});
    frame.clearFlushes(self.vma_allocator);

    self.text_renderpass.pushGlyph(0, 0);
    self.text_renderpass.pushGlyph(0.5, 0.5);
    try frame.text_transfer_info.append(self.allocator, try self.text_renderpass.flush(false));
    frame.text_transfer_count += 1;

    const clear = zvk.ClearValue{ .color = .{
        .float_32 = .{ 0, 0, 0, 1 },
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
    try dev.beginCommandBuffer(frame.cmdbuf, &zvk.CommandBufferBeginInfo{
        .flags = .{ .one_time_submit_bit = true },
    });
    try dev.beginCommandBuffer(frame.transfer_cmdbuf, &zvk.CommandBufferBeginInfo{
        .flags = .{ .one_time_submit_bit = true },
    });

    dev.cmdSetViewport(frame.cmdbuf, 0, 1, @ptrCast(&viewport));
    dev.cmdSetScissor(frame.cmdbuf, 0, 1, @ptrCast(&scissor));

    const render_area = zvk.Rect2D{
        .offset = .{ .x = 0, .y = 0 },
        .extent = extent,
    };

    dev.cmdBeginRenderPass(frame.cmdbuf, &.{
        .render_pass = self.swapchain.render_pass,
        .framebuffer = self.swapchain.swap_images[frame.acquired_idx].framebuffer,
        .render_area = render_area,
        .clear_value_count = 1,
        .p_clear_values = @ptrCast(&clear),
    }, .@"inline");

    // dev.cmdPipelineBarrier(
    //     frame.cmdbuf,
    //     .{ .all_graphics_bit = true },
    //     .{ .all_graphics_bit = true },
    //     .{ .by_region_bit = true },
    //     0,
    //     null,
    //     0,
    //     null,
    //     1,
    //     &[_]zvk.ImageMemoryBarrier{
    //         zvk.ImageMemoryBarrier{
    //             .image = self.swapchain.swap_images[frame.acquired_idx].color_image,
    //             .src_access_mask = .{ .memory_write_bit = true },
    //             .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
    //             .old_layout = .undefined,
    //             .new_layout = .color_attachment_optimal,
    //             .src_queue_family_index = self.rctx.graphics_queue.family,
    //             .dst_queue_family_index = self.rctx.graphics_queue.family,
    //             .subresource_range = zvk.ImageSubresourceRange{
    //                 .aspect_mask = .{ .color_bit = true },
    //                 .base_mip_level = 0,
    //                 .level_count = zvk.REMAINING_MIP_LEVELS,
    //                 .base_array_layer = 0,
    //                 .layer_count = zvk.REMAINING_ARRAY_LAYERS,
    //             },
    //         },
    //     },
    // );

    for (frame.text_transfer_info.items[0..frame.text_transfer_count]) |flush_info| {
        flush_info.recordCommandBuffers(dev, frame);
    }

    // dev.cmdPipelineBarrier(
    //     frame.cmdbuf,
    //     .{ .all_graphics_bit = true },
    //     .{ .all_graphics_bit = true },
    //     .{ .by_region_bit = true },
    //     0,
    //     null,
    //     0,
    //     null,
    //     1,
    //     &[_]zvk.ImageMemoryBarrier{
    //         zvk.ImageMemoryBarrier{
    //             .image = self.swapchain.swap_images[frame.acquired_idx].color_image,
    //             .src_access_mask = .{ .memory_write_bit = true },
    //             .dst_access_mask = .{ .memory_write_bit = true, .memory_read_bit = true },
    //             .old_layout = .color_attachment_optimal,
    //             .new_layout = .present_src_khr,
    //             .src_queue_family_index = self.rctx.graphics_queue.family,
    //             .dst_queue_family_index = self.rctx.graphics_queue.family,
    //             .subresource_range = zvk.ImageSubresourceRange{
    //                 .aspect_mask = .{ .color_bit = true },
    //                 .base_mip_level = 0,
    //                 .level_count = zvk.REMAINING_MIP_LEVELS,
    //                 .base_array_layer = 0,
    //                 .layer_count = zvk.REMAINING_ARRAY_LAYERS,
    //             },
    //         },
    //     },
    // );
    try dev.endCommandBuffer(frame.transfer_cmdbuf);
    dev.cmdEndRenderPass(frame.cmdbuf);
    try dev.endCommandBuffer(frame.cmdbuf);

    try dev.queueSubmit(self.rctx.graphics_queue.handle, 2, &.{
        zvk.SubmitInfo{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = &.{frame.image_acquired_semaphore},
            .p_wait_dst_stage_mask = &.{.{ .top_of_pipe_bit = true }},
            .command_buffer_count = 1,
            .p_command_buffers = @ptrCast(&frame.transfer_cmdbuf),
            .signal_semaphore_count = 1,
            .p_signal_semaphores = &.{frame.transfer_semaphore},
        },
        zvk.SubmitInfo{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = &.{frame.transfer_semaphore},
            .p_wait_dst_stage_mask = &.{.{ .top_of_pipe_bit = true }},
            .command_buffer_count = 1,
            .p_command_buffers = &.{frame.cmdbuf},
            .signal_semaphore_count = 1,
            .p_signal_semaphores = &.{frame.render_semaphore},
        },
    }, frame.render_fence);

    _ = try self.rctx.dev.queuePresentKHR(self.rctx.present_queue.handle, &.{
        .wait_semaphore_count = 1,
        .p_wait_semaphores = @ptrCast(&frame.render_semaphore),
        .swapchain_count = 1,
        .p_swapchains = @ptrCast(&self.swapchain.handle),
        .p_image_indices = @ptrCast(&frame.acquired_idx),
    });

    self.current_frame = (self.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;

    if (self.should_resize) {
        try self.doResize();
    }
}

pub fn beginFrame(self: *@This()) !void {
    const dev = self.rctx.dev;
    const frame = self.getCurrentFrame();

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
    try dev.resetFences(1, &.{frame.render_fence});
    try dev.resetCommandBuffer(frame.cmdbuf, .{});
    try dev.resetCommandBuffer(frame.transfer_cmdbuf, .{});

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
    frame.acquired_idx = acquired.image_index;

    // RESEARCH: Does recreating the swapchain invalidate acquired images?
    if (acquired.result == .suboptimal_khr) {
        self.should_resize = true;
    }
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

pub const Swapchain = struct {
    instance: Instance,
    context: *const RenderContext,

    handle: zvk.SwapchainKHR,
    extent: zvk.Extent2D,
    surface_format: zvk.SurfaceFormatKHR,
    present_mode: zvk.PresentModeKHR,

    render_pass: zvk.RenderPass,
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
        const presentation_mode: zvk.PresentModeKHR = .fifo_khr;

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

        const render_pass = try createRenderPass(context.dev, surface_format.format);
        const swap_images = try initSwapchainImages(allocator, context.dev, swapchain, surface_format.format, render_pass, extent);
        errdefer {
            for (swap_images) |*image| {
                image.deinit();
            }
            allocator.free(swap_images);
        }

        return .{
            .instance = instance,
            .render_pass = render_pass,
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
            swapimage.deinit(self.context.dev);
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
        self.context.dev.destroyRenderPass(self.render_pass, null);
        self.context.dev.destroySwapchainKHR(self.handle, null);
    }

    fn createRenderPass(dev: Device, color_format: zvk.Format) !zvk.RenderPass {
        return try dev.createRenderPass(&zvk.RenderPassCreateInfo{
            .attachment_count = 1,
            .p_attachments = &.{
                zvk.AttachmentDescription{
                    .format = color_format,
                    .samples = .{ .@"1_bit" = true },
                    .load_op = .clear,
                    .store_op = .store,
                    .stencil_load_op = .load,
                    .stencil_store_op = .store,
                    .initial_layout = .undefined,
                    .final_layout = .present_src_khr,
                },
            },
            .subpass_count = 1,
            .p_subpasses = &.{
                zvk.SubpassDescription{
                    .pipeline_bind_point = .graphics,
                    .color_attachment_count = 1,
                    .p_color_attachments = &.{
                        zvk.AttachmentReference{ .attachment = 0, .layout = .color_attachment_optimal },
                    },
                },
            },
        }, null);
    }

    fn initSwapchainImages(
        allocator: std.mem.Allocator,
        dev: Device,
        swapchain: zvk.SwapchainKHR,
        format: zvk.Format,
        render_pass: zvk.RenderPass,
        extent: zvk.Extent2D,
    ) ![]SwapImage {
        const images = try dev.getSwapchainImagesAllocKHR(swapchain, allocator);
        defer allocator.free(images);

        const swap_images = try allocator.alloc(SwapImage, images.len);
        errdefer allocator.free(swap_images);

        var last_idx: usize = 0;
        errdefer for (0..last_idx) |i| swap_images[i].deinit(dev);

        while (last_idx < images.len) : (last_idx += 1) {
            swap_images[last_idx] = try SwapImage.init(dev, render_pass, images[last_idx], format, extent);
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
        color_image: zvk.Image, // non-owning handle
        color_view: zvk.ImageView,
        framebuffer: zvk.Framebuffer,

        pub fn init(
            dev: vk.Device,
            render_pass: zvk.RenderPass,
            color_image: zvk.Image,
            color_format: zvk.Format,
            extent: zvk.Extent2D,
        ) !@This() {
            const color_view = try dev.createImageView(&zvk.ImageViewCreateInfo{
                .image = color_image,
                .view_type = .@"2d",
                .format = color_format,
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
            errdefer dev.destroyImageView(color_view, null);

            const framebuffer = try dev.createFramebuffer(&zvk.FramebufferCreateInfo{
                .render_pass = render_pass,
                .attachment_count = 1,
                .p_attachments = &.{color_view},
                .width = extent.width,
                .height = extent.height,
                .layers = 1,
            }, null);
            errdefer dev.destroyFramebuffer(framebuffer, null);

            return .{
                .color_image = color_image,
                .color_view = color_view,
                .framebuffer = framebuffer,
            };
        }

        pub fn deinit(self: *@This(), dev: vk.Device) void {
            dev.destroyImageView(self.color_view, null);
            dev.destroyFramebuffer(self.framebuffer, null);
        }
    };
};

const TextRenderpass = struct {
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

    fn init(
        dev: Device,
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

    fn deinit(self: *@This(), dev: Device, vma_alloc: vma.Allocator) void {
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

    const FlushInfo = struct {
        pipeline: zvk.Pipeline,
        buffers: StagingBuffers,

        completion_sem: zvk.Semaphore = .null_handle,

        fn recordCommandBuffers(self: @This(), dev: Device, frame: *FrameData) void {
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

    fn flush(self: *@This(), reason_full: bool) !FlushInfo {
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

    fn buffersFull(self: *const @This()) bool {
        const vbo = (self.buffers.vertex_count + 4) * @sizeOf(GlyphVert) >= self.buffers.vbo_info.size;
        const ibo = (self.buffers.indices_count + 6) * @sizeOf(u32) >= self.buffers.ibo_info.size;

        return vbo or ibo;
    }

    fn pushGlyph(self: *@This(), x: f32, y: f32) void {
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
};
