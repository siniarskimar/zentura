// TODO: Improve error handling, currently there is none
// and we let X11 crash the application.
//
// But this is near impossible to accomplish since there is no way
// to know if a request has been flushed or not. Flushing right after making
// a request will hurt performance over network connections.

const std = @import("std");
const nswindow = @import("./window.zig");
const Callback = nswindow.Callback;
pub const c = @cImport({
    @cInclude("X11/Xlib.h");
    @cInclude("X11/Xresource.h");
    @cInclude("X11/Xlib-xcb.h");
    @cInclude("xcb/xcb.h");
    @cInclude("X11/Xutil.h");
});

pub const log = std.log.scoped(.x11);

pub const Platform = struct {
    display: *c.Display,
    xcb_connection: *c.xcb_connection_t,
    default_screen: c_int,
    xcb_screen: *c.xcb_screen_t,
    xcontext: c.XContext,
    root: c.Window,

    /// Support for WM protocols
    WM_PROTOCOLS: c.Atom,

    /// WM closed a window
    WM_DELETE_WINDOW: c.Atom,

    /// WM alive ping
    NET_WM_PING: c.Atom,

    pub fn vtable() nswindow.Platform.VTable {
        const S = struct {
            pub fn deinit(ptr: *anyopaque, _: std.mem.Allocator) void {
                const self: *Platform = @alignCast(@ptrCast(ptr));
                self.deinit();
            }
            pub fn pollEvents(ptr: *anyopaque) nswindow.Platform.PollEventsError!void {
                const self: *Platform = @alignCast(@ptrCast(ptr));
                self.pollEvents();
            }
            pub fn tag() nswindow.Platform.Tag {
                return .x11;
            }
        };
        return .{
            .deinit = S.deinit,
            .pollEvents = S.pollEvents,
            .tag = S.tag,
            .createWindow = createWindow,
        };
    }

    pub fn init() !@This() {
        const display = c.XOpenDisplay(null) orelse {
            log.err("XOpenDisplay({s}) failed", .{std.mem.span(c.XDisplayName(null))});
            return error.OpenDisplayFailed;
        };

        errdefer _ = c.XCloseDisplay(display);

        const default_screen = c.XDefaultScreen(display);
        const root = c.XRootWindow(display, default_screen);
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
        const xcontext = c.XUniqueContext();

        return .{
            .display = display,
            .xcb_connection = xcb_connection,
            .default_screen = default_screen,
            .xcb_screen = screen.?,
            .xcontext = xcontext,
            .root = root,

            .WM_PROTOCOLS = c.XInternAtom(display, "WM_PROTOCOLS", c.False),
            .WM_DELETE_WINDOW = c.XInternAtom(display, "WM_DELETE_WINDOW", c.False),
            .NET_WM_PING = c.XInternAtom(display, "NET_WM_PING", c.False),
        };
    }

    pub fn deinit(self: @This()) void {
        _ = c.XCloseDisplay(self.display);
    }

    pub fn createWindow(
        ptr: *anyopaque,
        allocator: std.mem.Allocator,
        options: nswindow.WindowCreationOptions,
    ) nswindow.Platform.WindowCreationError!nswindow.Window {
        const self: *const @This() = @alignCast(@ptrCast(ptr));
        const window = Window.init(self.*, options.width, options.height);
        errdefer window.deinit();

        const heap = try allocator.create(Window);
        heap.* = window;

        return .{ .ptr = heap, .vtable = Window.vtable() };
    }

    pub fn pollEvents(self: @This()) void {
        _ = c.XPending(self.display);
        while (c.QLength(self.display) != 0) {
            var event: c.XEvent = undefined;
            _ = c.XNextEvent(self.display, &event);
            self.handleEvent(&event);
        }
        _ = c.XFlush(self.display);
    }

    fn handleEvent(self: @This(), event: *c.XEvent) void {
        const filtered = c.XFilterEvent(event, c.None) == c.True;

        switch (event.type) {
            c.SelectionRequest => {},
            c.GenericEvent => {},
            else => {
                var window: *Window = undefined;
                if (c.XFindContext(
                    self.display,
                    event.xany.window,
                    self.xcontext,
                    @ptrCast(window),
                ) != 0) {
                    return;
                }

                window.handleEvent(event, filtered);
            },
        }
    }
};

pub const Window = struct {
    context: Platform,
    window_handle: c.XID,
    parent_handle: c.XID,

    width: u32,
    height: u32,

    state_closed: bool = false,

    cb_framebuffer_resize: ?Callback(nswindow.FramebufferResizeCb) = null,

    pub fn vtable() nswindow.Window.VTable {
        const S = struct {
            pub fn deinit(ptr: *anyopaque, _: std.mem.Allocator) void {
                const self: *Window = @alignCast(@ptrCast(ptr));
                self.deinit();
            }
            pub fn closed(ptr: *anyopaque) bool {
                const self: *const Window = @alignCast(@ptrCast(ptr));
                return self.state_closed;
            }
            pub fn dimensions(ptr: *anyopaque) nswindow.Window.Dimensions {
                const self: *const Window = @alignCast(@ptrCast(ptr));
                return .{ .width = self.width, .height = self.height };
            }
            pub fn tag() nswindow.Platform.Tag {
                return .x11;
            }
            pub fn setFramebufferResizeCallback(
                ptr: *anyopaque,
                cb: ?Callback(nswindow.FramebufferResizeCb),
            ) ?Callback(nswindow.FramebufferResizeCb) {
                const self: *Window = @alignCast(@ptrCast(ptr));
                return self.setFramebufferResizeCallback(cb);
            }
        };

        return .{
            .deinit = S.deinit,
            .closed = S.closed,
            .dimensions = S.dimensions,
            .tag = S.tag,
            .setFramebufferResizeCallback = S.setFramebufferResizeCallback,
        };
    }

    pub fn init(context: Platform, width: u32, height: u32) @This() {
        const window = c.XCreateSimpleWindow(
            context.display,
            context.xcb_screen.root,
            0,
            0,
            width,
            height,
            0,
            c.CopyFromParent,
            c.InputOutput,
        );

        // Can't be const because whoever designed XSetWMProtocols
        // could not be bothered to make it accept const
        var protocols = [_]c.Atom{ context.WM_DELETE_WINDOW, context.NET_WM_PING };
        _ = c.XSetWMProtocols(context.display, window, &protocols, @intCast(protocols.len));

        return .{
            .context = context,
            .window_handle = window,
            .parent_handle = context.root,
            .width = width,
            .height = height,
        };
    }

    pub fn deinit(self: @This()) void {
        _ = c.XDestroyWindow(self.context.display, self.window_handle);
    }

    fn handleEvent(self: *@This(), event: *c.XEvent, filtered: bool) void {
        switch (event.type) {
            c.ReparentNotify => {
                self.parent_handle = event.xreparent.parent;
            },
            c.ConfigureNotify => {
                const eventw = event.xconfigure.width;
                const eventh = event.xconfigure.height;
                if (eventw != self.width or eventh != self.height) {
                    self.width = @intCast(eventw);
                    self.height = @intCast(eventh);
                    if (self.cb_framebuffer_resize) |cb| {
                        cb.ptr(cb.ctx, self.width, self.height);
                    }
                }
            },
            c.ClientMessage => {
                if (filtered) return;
                self.handleClientMessage(event);
            },
            c.Expose => {
                std.debug.print("{any} Expose!", .{self});
            },
            else => {},
        }
    }

    fn handleClientMessage(self: *@This(), event: *c.XEvent) void {
        if (event.xclient.message_type == self.context.WM_PROTOCOLS) {
            const protocol = event.xclient.data.l[0];
            if (protocol == self.context.WM_DELETE_WINDOW) {
                self.state_closed = true;
            } else if (protocol == self.context.NET_WM_PING) {
                var reply = event.*;
                reply.xclient.window = self.context.root;
                _ = c.XSendEvent(
                    self.context.display,
                    self.context.root,
                    c.False,
                    c.SubstructureNotifyMask | c.SubstructureRedirectMask,
                    &reply,
                );
            }
        }
    }

    pub fn setFramebufferResizeCallback(
        self: *@This(),
        callback: ?Callback(nswindow.FramebufferResizeCb),
    ) ?Callback(nswindow.FramebufferResizeCb) {
        const old = self.cb_framebuffer_resize;
        self.cb_framebuffer_resize = callback;
        return old;
    }
};
