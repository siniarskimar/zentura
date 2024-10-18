const std = @import("std");
const zvk = @import("zig-vulkan");
const vk = @import("../vk.zig");
const GraphicsContext = @import("./GraphicsContext.zig");

const log = std.log.scoped(.vk_swapchain);

context: *const GraphicsContext,

handle: zvk.SwapchainKHR,
extent: zvk.Extent2D,
surface_format: zvk.SurfaceFormatKHR,
present_mode: zvk.PresentModeKHR,

render_pass: zvk.RenderPass,
swap_images: []SwapImage,

pub fn create(
    allocator: std.mem.Allocator,
    context: *const GraphicsContext,
    extent: zvk.Extent2D,
) !@This() {
    return try recycle(allocator, context, extent, .null_handle);
}

pub fn recreate(self: *@This(), allocator: std.mem.Allocator, extent: zvk.Extent2D) !void {
    const context = self.context;

    try self.context.dev.deviceWaitIdle();
    self.destroyWithoutHandle(allocator);
    self.* = try recycle(allocator, context, extent, self.handle);
}

fn recycle(
    allocator: std.mem.Allocator,
    context: *const GraphicsContext,
    extent: zvk.Extent2D,
    old_swapchain: zvk.SwapchainKHR,
) !@This() {
    const instance = context.instance;
    const caps = try instance.getPhysicalDeviceSurfaceCapabilitiesKHR(context.pdev, context.surface);
    const actual_extent = clampExtentToSurfaceCaps(caps, extent);

    if (actual_extent.width == 0 or actual_extent.height == 0) return error.InvalidSurfaceDimentions;

    const surface_format = try findSurfaceFormat(allocator, context);
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
    self.context.dev.destroyRenderPass(self.render_pass, null);
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

fn createRenderPass(dev: vk.Device, color_format: zvk.Format) !zvk.RenderPass {
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
    dev: vk.Device,
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
    context: *const GraphicsContext,
) !zvk.SurfaceFormatKHR {
    const instance = context.instance;
    const surface_formats = try instance.getPhysicalDeviceSurfaceFormatsAllocKHR(
        context.pdev,
        context.surface,
        allocator,
    );
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
