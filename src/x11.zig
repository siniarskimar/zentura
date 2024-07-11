const std = @import("std");
const vulkan = @import("./vulkan.zig");
pub const c = @cImport({
    @cInclude("X11/Xlib.h");
    @cInclude("X11/Xlib-xcb.h");
    @cInclude("xcb/xcb.h");
});

pub const Context = struct {
    display: *c.Display,
    xcb_connection: *c.xcb_connection_t,
    default_screen: c_int,
    xcb_screen: *c.xcb_screen_t,

    pub fn init() !@This() {
        // OpenGL doesn't play nicely with xcb
        // so this is necessary
        const display = c.XOpenDisplay(null) orelse
            return error.OpenDisplayFailed;

        errdefer _ = c.XCloseDisplay(display);

        const default_screen = c.XDefaultScreen(display);
        const xcb_connection = c.XGetXCBConnection(display) orelse
            return error.GetXcbConnFailed;

        // Get xcb_screen from default_screen int
        // xcb_setup_roots_iterator starts at screen 0
        var screen: ?*c.xcb_screen_t = null;
        var screen_iter = c.xcb_setup_roots_iterator(c.xcb_get_setup(xcb_connection));
        for (0..@as(usize, @intCast(default_screen))) |_| {
            c.xcb_screen_next(&screen_iter);
        }
        screen = screen_iter.data;

        return .{
            .display = display,
            .xcb_connection = xcb_connection,
            .default_screen = default_screen,
            .xcb_screen = screen.?,
        };
    }

    pub fn deinit(self: @This()) void {
        _ = c.XCloseDisplay(self.display);
    }
};

pub const Window = struct {
    context: Context,
    window_handle: c.XID,

    width: u32,
    height: u32,

    pub fn init(context: Context, width: u32, height: u32) !@This() {
        // const visual = c.XDefaultVisual(context.display, context.default_screen);

        const window = c.XCreateSimpleWindow(context.display, context.xcb_screen.root, 0, 0, width, height, 0, c.CopyFromParent, c.InputOutput);

        return .{
            .context = context,
            .window_handle = window,
            .width = width,
            .height = height,
        };
    }

    pub fn deinit(self: *@This()) void {
        _ = c.XDestroyWindow(self.context.display, self.window_handle);
    }

    // pub fn handleEvents(self: *@This()) void {

    //     // c.XNextEvent(, )
    // }
};

pub const VulkanContext = struct {
    context: vulkan.Context,
    devcontext: *vulkan.DeviceContext,
    swapchain: vulkan.Swapchain,

    const vk = vulkan.vk;

    const instance_extensions = [_][*:0]const u8{
        vulkan.vk.extensions.khr_xlib_surface.name,
        vulkan.vk.extensions.khr_xcb_surface.name,
    };
    const device_extensions = [_][*:0]const u8{};

    pub fn init(allocator: std.mem.Allocator, window: Window) !@This() {
        std.log.debug("Creating Vulkan instance context", .{});
        var vkcontext = try vulkan.Context.init(
            &(instance_extensions ++ vulkan.required_instance_extensions),
            allocator,
        );
        errdefer vkcontext.deinit(allocator);

        // const vkCreateXlibSurfacePtr = vkcontext.getInstanceProcAddress(
        //     vkcontext.instance.handle,
        //     "vkCreateXlibSurfaceKHR",
        // ) orelse {
        //     std.log.err("Command loading failed for 'vkCreateXlibSurfaceKHR'", .{});
        //     return error.CommandLoadFailure;
        // };

        // const vkCreateXlibSurface: vk.PfnCreateXlibSurfaceKHR = @ptrCast(vkCreateXlibSurfacePtr);

        const vkCreateXcbSurfacePtr = vkcontext.getInstanceProcAddress(
            vkcontext.instance.handle,
            "vkCreateXcbSurfaceKHR",
        ) orelse {
            std.log.err("Command loading failed for 'vkCreateXcbSurfaceKHR'", .{});
            return error.CommandLoadFailure;
        };

        const vkCreateXcbSurface: vk.PfnCreateXcbSurfaceKHR = @ptrCast(vkCreateXcbSurfacePtr);

        std.log.debug("Creating Vulkan-Wayland surface", .{});
        const surface = try createXcbSurface(vkCreateXcbSurface, vkcontext.instance.handle, &vk.XcbSurfaceCreateInfoKHR{
            .connection = @ptrCast(window.context.xcb_connection),
            .window = @intCast(window.window_handle),
        });
        errdefer vkcontext.instance.destroySurfaceKHR(surface, null);

        const devcontext = try allocator.create(vulkan.DeviceContext);
        errdefer allocator.destroy(devcontext);

        std.log.debug("Creating Vulkan device context", .{});
        devcontext.* = try vulkan.DeviceContext.init(
            &(device_extensions ++ vulkan.required_device_extensions),
            allocator,
            vkcontext.instance,
            surface,
        );
        errdefer devcontext.deinit(allocator);

        std.log.debug("Creating Vulkan swapchain", .{});
        const swapchain = try vulkan.Swapchain.create(
            allocator,
            vkcontext.instance,
            devcontext,
            .{ .width = window.width, .height = window.height },
        );
        errdefer swapchain.destroy(allocator);

        return .{
            .context = vkcontext,
            .devcontext = devcontext,
            .swapchain = swapchain,
        };
    }

    pub fn deinit(self: *@This(), allocator: std.mem.Allocator) void {
        self.swapchain.destroy(allocator);
        self.devcontext.deinit(allocator);
        allocator.destroy(self.devcontext);
        self.context.deinit(allocator);
    }

    fn createXlibSurface(
        vkCreateXlibSurface: vk.PfnCreateXlibSurfaceKHR,
        instance_handle: vk.Instance,
        create_info: *const vk.XlibSurfaceCreateInfoKHR,
    ) !vk.SurfaceKHR {
        var surface: vk.SurfaceKHR = .null_handle;
        switch (vkCreateXlibSurface(
            instance_handle,
            create_info,
            null,
            &surface,
        )) {
            vk.Result.success => {},
            vk.Result.error_out_of_host_memory => return error.OutOfHostMemory,
            vk.Result.error_out_of_device_memory => return error.OutOfDeviceMemory,
            else => return error.Unknown,
        }
        return surface;
    }

    fn createXcbSurface(
        vkCreateXcbSurface: vk.PfnCreateXcbSurfaceKHR,
        instance_handle: vk.Instance,
        create_info: *const vk.XcbSurfaceCreateInfoKHR,
    ) !vk.SurfaceKHR {
        var surface: vk.SurfaceKHR = .null_handle;
        switch (vkCreateXcbSurface(
            instance_handle,
            create_info,
            null,
            &surface,
        )) {
            vk.Result.success => {},
            vk.Result.error_out_of_host_memory => return error.OutOfHostMemory,
            vk.Result.error_out_of_device_memory => return error.OutOfDeviceMemory,
            else => return error.Unknown,
        }
        return surface;
    }

    pub fn getDeviceName(self: *const @This()) []const u8 {
        return std.mem.sliceTo(&self.devcontext.pdevprops.device_name, 0);
    }
};
