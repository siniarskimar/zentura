const std = @import("std");
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
        const filtered = c.XFilterEvent(event, c.None);

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
                switch (event.type) {
                    c.ReparentNotify => {},
                    c.ConfigureNotify => {
                        const eventw = event.xconfigure.width;
                        const eventh = event.xconfigure.height;
                        if (eventw != window.width or eventh != window.height) {
                            window.width = @intCast(eventw);
                            window.height = @intCast(eventh);
                        }
                    },
                    c.ClientMessage => {
                        if (filtered == c.True) return;
                        if (event.xclient.message_type == self.WM_PROTOCOLS) {
                            const protocol = event.xclient.data.l[0];
                            if (protocol == self.WM_DELETE_WINDOW) {
                                window.flag_closed = true;
                            } else if (protocol == self.NET_WM_PING) {
                                var reply = event.*;
                                reply.xclient.window = self.root;
                                _ = c.XSendEvent(
                                    self.display,
                                    self.root,
                                    c.False,
                                    c.SubstructureNotifyMask | c.SubstructureRedirectMask,
                                    &reply,
                                );
                            }
                        }
                    },
                    c.Expose => {
                        std.debug.print("{p} Expose!", .{window});
                    },
                    else => {},
                }
            },
        }
    }
};

pub const Window = struct {
    context: Platform,
    window_handle: c.XID,

    width: u32,
    height: u32,

    flag_closed: bool = false,

    pub fn init(context: Platform, width: u32, height: u32) !@This() {
        // const visual = c.XDefaultVisual(context.display, context.default_screen);

        const window = c.XCreateSimpleWindow(context.display, context.xcb_screen.root, 0, 0, width, height, 0, c.CopyFromParent, c.InputOutput);

        return .{
            .context = context,
            .window_handle = window,
            .width = width,
            .height = height,
        };
    }

    pub fn deinit(self: @This()) void {
        _ = c.XDestroyWindow(self.context.display, self.window_handle);
    }

        }
    }

        }
    }

    }
};
