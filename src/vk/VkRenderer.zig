const std = @import("std");
const zvk = @import("zig-vulkan");
const glfw = @import("../bindings/glfw.zig");
const vk = @import("../vk.zig");
const vma = @import("../vma.zig");
const math = @import("../math.zig");

const GraphicsContext = @import("./GraphicsContext.zig");
const Swapchain = @import("./Swapchain.zig");
const TextRenderpass = @import("./TextRenderpass.zig");
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

window: *glfw.Window,
allocator: std.mem.Allocator,

ctx: GraphicsContext,
swapchain: Swapchain,
vma_allocator: vma.Allocator,

cmdpool: zvk.CommandPool,
frames: []FrameData,
current_frame: usize = 0,

should_resize: bool = false,

const shaders = @import("shaders");
const MAX_FRAMES_IN_FLIGHT: usize = 2;

pub const FrameData = struct {
    allocator: std.mem.Allocator,
    cmdpool: zvk.CommandPool,
    cmdbuf: zvk.CommandBuffer,

    image_acquired_semaphore: zvk.Semaphore,
    acquired_idx: u32 = 0,
    render_semaphore: zvk.Semaphore,
    render_fence: zvk.Fence,

    text_renderpass: TextRenderpass,

    fn init(
        allocator: std.mem.Allocator,
        dev: Device,
        surface_format: zvk.Format,
        surface_renderpass: zvk.RenderPass,
        cmdpool: zvk.CommandPool,
        vma_alloc: vma.Allocator,
    ) !@This() {
        var cmdbufs = [1]zvk.CommandBuffer{.null_handle};
        try dev.allocateCommandBuffers(&zvk.CommandBufferAllocateInfo{
            .command_pool = cmdpool,
            .command_buffer_count = 1,
            .level = .primary,
        }, &cmdbufs);
        errdefer dev.freeCommandBuffers(cmdpool, 1, &cmdbufs);

        const image_acquired = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(image_acquired, null);

        const render_semaphore = try dev.createSemaphore(&.{}, null);
        errdefer dev.destroySemaphore(render_semaphore, null);

        const render_fence = try dev.createFence(&zvk.FenceCreateInfo{
            .flags = .{ .signaled_bit = true },
        }, null);
        errdefer dev.destroyFence(render_fence, null);

        return FrameData{
            .allocator = allocator,
            .cmdpool = cmdpool,
            .cmdbuf = cmdbufs[0],
            .image_acquired_semaphore = image_acquired,
            .render_semaphore = render_semaphore,
            .render_fence = render_fence,
            .text_renderpass = try TextRenderpass.init(allocator, dev, surface_format, vma_alloc, surface_renderpass),
        };
    }

    fn deinit(self: *@This(), dev: Device, vma_alloc: vma.Allocator) void {
        dev.freeCommandBuffers(self.cmdpool, 1, &[1]zvk.CommandBuffer{self.cmdbuf});
        dev.destroySemaphore(self.image_acquired_semaphore, null);
        dev.destroySemaphore(self.render_semaphore, null);
        dev.destroyFence(self.render_fence, null);
        self.text_renderpass.deinit(dev, vma_alloc);
    }

    fn record(self: *@This(), dev: Device) !void {
        try self.text_renderpass.pushGlyph(0, 0);
        self.text_renderpass.record(dev, self.cmdbuf);
    }

    fn clear(self: *@This()) void {
        self.text_renderpass.clear();
    }
};

pub fn init(allocator: std.mem.Allocator, window: *glfw.Window) !@This() {
    var ctx = try GraphicsContext.init(allocator, window);
    errdefer ctx.deinit(allocator);

    const vma_allocator = try initVmaAllocator(
        ctx.instance,
        ctx.base_dispatch,
        ctx.pdev,
        ctx.dev.handle,
    );
    errdefer vma.destroyAllocator(vma_allocator);

    var window_width: c_int = undefined;
    var window_height: c_int = undefined;
    window.getFramebufferSize(&window_width, &window_height);

    var swapchain = try Swapchain.create(
        allocator,
        &ctx,
        .{ .width = @intCast(window_width), .height = @intCast(window_height) },
    );
    errdefer swapchain.destroy(allocator);

    const cmdpool = try ctx.dev.createCommandPool(
        &zvk.CommandPoolCreateInfo{
            .queue_family_index = ctx.graphics_queue.family,
            .flags = .{ .reset_command_buffer_bit = true },
        },
        null,
    );
    errdefer ctx.dev.destroyCommandPool(cmdpool, null);

    const frames = try allocator.alloc(FrameData, MAX_FRAMES_IN_FLIGHT);
    errdefer allocator.free(frames);
    {
        var idx: usize = 0;
        errdefer for (0..idx) |k| frames[k].deinit(ctx.dev, vma_allocator);

        while (idx < frames.len) : (idx += 1) {
            frames[idx] = try FrameData.init(allocator, ctx.dev, swapchain.surface_format.format, swapchain.render_pass, cmdpool, vma_allocator);
        }
    }

    return .{
        .window = window,
        .allocator = allocator,
        .ctx = ctx,
        .swapchain = swapchain,
        .vma_allocator = vma_allocator,

        .cmdpool = cmdpool,
        .frames = frames,
    };
}

pub fn deinit(self: *@This()) void {
    const allocator = self.allocator;
    self.ctx.dev.deviceWaitIdle() catch std.time.sleep(std.time.ns_per_ms * 20);

    for (self.frames) |*frame| {
        frame.deinit(self.ctx.dev, self.vma_allocator);
    }
    self.allocator.free(self.frames);
    self.ctx.dev.destroyCommandPool(self.cmdpool, null);

    self.swapchain.destroy(allocator);
    vma.destroyAllocator(self.vma_allocator);
    self.ctx.deinit(allocator);
}

fn initVmaAllocator(
    instance: vk.Instance,
    base_dispatch: vk.BaseDispatch,
    pdev: zvk.PhysicalDevice,
    device: zvk.Device,
) !vma.Allocator {
    var alloc: vma.Allocator = undefined;
    const result: zvk.Result = @enumFromInt(vma.createAllocator(&vma.AllocatorCreateInfo{
        .vulkanApiVersion = vma.VK_API_VERSION_1_1,
        .physicalDevice = @ptrFromInt(@intFromEnum(pdev)),
        .device = @ptrFromInt(@intFromEnum(device)),
        .instance = @ptrFromInt(@intFromEnum(instance.handle)),
        .pVulkanFunctions = &vma.VulkanFunctions{
            .vkGetInstanceProcAddr = @ptrCast(base_dispatch.dispatch.vkGetInstanceProcAddr),
            .vkGetDeviceProcAddr = @ptrCast(instance.wrapper.dispatch.vkGetDeviceProcAddr),
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
    const dev = self.ctx.dev;
    const frame = self.getCurrentFrame();
    const extent = self.swapchain.extent;

    frame.clear();

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

    try frame.record(dev);

    dev.cmdEndRenderPass(frame.cmdbuf);
    try dev.endCommandBuffer(frame.cmdbuf);

    try dev.queueSubmit(self.ctx.graphics_queue.handle, 1, &.{
        zvk.SubmitInfo{
            .wait_semaphore_count = 1,
            .p_wait_semaphores = &.{frame.image_acquired_semaphore},
            .p_wait_dst_stage_mask = &.{.{ .top_of_pipe_bit = true }},
            .command_buffer_count = 1,
            .p_command_buffers = &.{frame.cmdbuf},
            .signal_semaphore_count = 1,
            .p_signal_semaphores = &.{frame.render_semaphore},
        },
    }, frame.render_fence);

    _ = try self.ctx.dev.queuePresentKHR(self.ctx.present_queue.handle, &.{
        .wait_semaphore_count = 1,
        .p_wait_semaphores = @ptrCast(&frame.render_semaphore),
        .swapchain_count = 1,
        .p_swapchains = @ptrCast(&self.swapchain.handle),
        .p_image_indices = @ptrCast(&frame.acquired_idx),
    });

    self.current_frame = (self.current_frame + 1) % MAX_FRAMES_IN_FLIGHT;
}

pub fn beginFrame(self: *@This()) !void {
    const dev = self.ctx.dev;
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
    if (self.should_resize) {
        try self.doResize();
    }
    try dev.resetFences(1, &.{frame.render_fence});
    try dev.resetCommandBuffer(frame.cmdbuf, .{});

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

    if (acquired.result == .suboptimal_khr) {
        self.should_resize = true;
    }
}

fn doResize(self: *@This()) !void {
    self.should_resize = false;
    var window_width: c_int = undefined;
    var window_height: c_int = undefined;
    self.window.getFramebufferSize(&window_width, &window_height);

    try self.swapchain.recreate(
        self.allocator,
        .{ .width = @intCast(window_width), .height = @intCast(window_height) },
    );
}
