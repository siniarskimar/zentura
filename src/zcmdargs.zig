const std = @import("std");
const builtin = @import("builtin");
const Allocator = std.mem.Allocator;
const Type = std.builtin.Type;
const ArgIterator = std.process.ArgIterator;

pub fn SliceIterator(comptime T: type) type {
    return struct {
        const Self = @This();

        slice: []const T,
        index: usize,

        pub fn next(self: *Self) ?T {
            if (self.index >= self.slice.len)
                return null;
            self.index += 1;
            return self.slice[self.index - 1];
        }
    };
}

pub fn ParseResult(comptime Spec: type) type {
    if (@typeInfo(Spec) != .Struct) {
        @compileError("Option specification has to be a struct!");
    }

    const spec_info = @typeInfo(Spec).Struct;
    if (spec_info.is_tuple) {
        @compileError("Option specification cannot be a tuple!");
    }

    const OptionContainer = blk: {
        var fields: [spec_info.fields.len]Type.StructField = undefined;

        for (spec_info.fields, 0..) |field, idx| {
            if (@typeInfo(field.type) == .Optional)
                @compileError("optional types are disallowed");

            // void -> bool
            // []void -> i32
            // T -> ?T
            const FinalType = if (field.default_value) |_| field.type else switch (field.type) {
                void => bool,
                []void => i32,
                else => @Type(.{ .Optional = .{ .child = field.type } }),
            };

            const default: ?*const anyopaque = if (field.default_value) |_|
                field.default_value
            else switch (field.type) {
                void => &false,
                []void => &@as(FinalType, 0),
                else => |T| &@as(?T, null),
            };

            // @compileLog(field.type, FinalType, default);
            fields[idx] = .{
                .name = field.name,
                .type = FinalType,
                .default_value = default,
                .is_comptime = false,
                .alignment = 0,
            };
        }

        break :blk @Type(.{
            .Struct = .{
                .layout = .Auto,
                .fields = &fields,
                .decls = &[_]Type.Declaration{},
                .is_tuple = false,
            },
        });
    };

    return struct {
        options: OptionContainer,
        allocator: Allocator,
        unknown: std.ArrayList([]const u8),

        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return .{
                .allocator = allocator,
                .options = OptionContainer{},
                .unknown = std.ArrayList([]const u8).init(allocator),
            };
        }

        pub fn appendUnknown(self: *Self, arg: []const u8) !void {
            try self.unknown.append(self.allocator.dupe(u8, arg));
        }

        pub fn deinit(self: *Self) void {
            for (self.unknown.items) |unknown| {
                self.allocator.free(unknown);
            }
            self.unknown.deinit();
        }
    };
}

pub fn parseProcessArgs(comptime Spec: type, allocator: Allocator) !ParseResult(Spec) {
    var iterator = try std.process.argsWithAllocator(allocator);
    defer iterator.deinit();
    return try parseInternal(Spec, allocator, &iterator);
}

/// Parse command line arguments from a slice
/// Expects arguments without program name
pub fn parseSliceArgs(comptime Spec: type, allocator: Allocator, args: []const []const u8) !ParseResult(Spec) {
    var iter = SliceIterator([]const u8){ .slice = args, .index = 0 };
    return try parseInternal(Spec, allocator, &iter);
}

pub fn parseInternal(comptime Spec: type, allocator: Allocator, arg_iterator: anytype) !ParseResult(Spec) {
    validateOptionSpecification(Spec);
    validateArgIterator(arg_iterator.*);

    var parse_result = ParseResult(Spec).init(allocator);
    errdefer parse_result.deinit();

    argument_loop: while (arg_iterator.next()) |arg| {
        if (arg.len == 0) {
            unreachable; // arg.len == 0, this should not happen - no known OS does this
        }

        if (std.mem.startsWith(u8, arg, "--")) {
            if (arg.len == 2) {
                unreachable; // TODO: implement double dash
            }
            const maybe_eql = std.mem.indexOf(u8, arg, "=");
            const optname = arg[2 .. maybe_eql orelse arg.len];

            inline for (std.meta.fields(Spec)) |option| {
                if (std.mem.eql(u8, option.name, optname)) {
                    try parseOption(Spec, option, arg, arg_iterator, &parse_result);
                    continue :argument_loop;
                }
            }
            return error.UnknownArgument;
        } else if (std.mem.startsWith(u8, arg, "-")) {
            if (arg.len == 1) {
                unreachable; // TODO: implement single dash
            }
            if (!@hasDecl(Spec, "shorthands")) {
                return error.NoShorthandsDeclared;
            }
            group_loop: for (arg[1..]) |arg_shorthand| {
                inline for (std.meta.fields(@TypeOf(Spec.shorthands))) |shorthand| {
                    if (arg_shorthand == shorthand.name[0]) {
                        const linked_option = std.meta.fieldInfo(Spec, @field(Spec.shorthands, shorthand.name));
                        try parseOption(Spec, linked_option, arg, arg_iterator, &parse_result);
                        continue :group_loop;
                    }
                }
                return error.UnknownArgument;
            }
        }
    }
    return parse_result;
}

fn getNextOptionValue(argument: []const u8, arg_iterator: anytype) ![]const u8 {
    const maybe_eql = std.mem.indexOf(u8, argument, "=");

    const valuebuffer = if (maybe_eql) |eql|
        argument[eql + 1 ..]
    else
        (arg_iterator.next() orelse return error.ExpectedValue);

    if (valuebuffer.len == 0) {
        return error.ExpectedValue;
    }

    return valuebuffer;
}

fn parseOption(comptime Spec: type, comptime option_info: Type.StructField, argument: []const u8, arg_iterator: anytype, parse_result: *ParseResult(Spec)) !void {
    if (@typeInfo(@TypeOf(arg_iterator)) != .Pointer) {
        @compileError("arg_iterator has to be a pointer");
    }
    var result_option_field = &@field(parse_result.options, option_info.name);

    switch (option_info.type) {
        void => result_option_field.* = true,
        []void => result_option_field.* += 1,
        bool => {
            const valuebuffer = try getNextOptionValue(argument, arg_iterator);
            const truthy = std.mem.eql(u8, valuebuffer, "true");

            if (truthy) {
                result_option_field.* = true;
                return;
            }

            const falsy = std.mem.eql(u8, valuebuffer, "false");
            if (falsy) {
                result_option_field.* = false;
                return;
            }
            return error.BadValue;
        },
        []const u8 => result_option_field.* = try getNextOptionValue(argument, arg_iterator),
        else => |T| switch (@typeInfo(T)) {
            .Int => {
                const valuebuffer = try getNextOptionValue(argument, arg_iterator);
                result_option_field.* = std.fmt.parseInt(T, valuebuffer, 0) catch return error.BadValue;
            },
            .Float => {
                const valuebuffer = try getNextOptionValue(argument, arg_iterator);
                result_option_field.* = std.fmt.parseFloat(T, valuebuffer) catch return error.BadValue;
            },
            else => @compileError("no parser defined for " ++ @typeName(T)),
        },
        // else => unreachable,
    }
}

fn validateArgIterator(candidate: anytype) void {
    const T = @TypeOf(candidate);

    if (@typeInfo(T) != .Struct)
        @compileError("validation of arg_iterator failed: must be a struct");

    if (!@hasDecl(T, "next") or @typeInfo(@TypeOf(T.next)) != .Fn)
        @compileError("validation of arg_iterator failed: must have a function named 'next'");

    const Next = @TypeOf(T.next);
    if (@typeInfo(Next).Fn.return_type.? != ?[]const u8)
        @compileError("validation of arg_iterator failed: function named 'next' must return ?[]const u8");

    if (@typeInfo(Next).Fn.params.len != 1)
        @compileError("validation of arg_iterator failed: function named 'next' must accept single parameter");
}

fn validateOptionSpecification(comptime Spec: type) void {
    if (@hasDecl(Spec, "shorthands")) {
        if (@typeInfo(@TypeOf(Spec.shorthands)) != .Struct) @compileError("shorthand container must be a struct");

        inline for (std.meta.fields(@TypeOf(Spec.shorthands)), 0..) |shorthand, idx| {
            _ = idx;
            if (@typeInfo(shorthand.type) != .EnumLiteral) {
                @compileError("the assigned value of shorthand must be an enum literal (" ++ shorthand.name ++ ")");
            }
            if (shorthand.name.len > 1) {
                @compileError("shorthand must be one letter long (" ++ shorthand.name ++ ")");
            }
            const linked_option_name = @tagName(@field(Spec.shorthands, shorthand.name));
            if (!@hasField(Spec, linked_option_name)) {
                @compileError("shorthand " ++ shorthand.name ++ " links to non existant option " ++ linked_option_name);
            }
        }
    }
}

test "valueless options" {
    const TestOptions = struct {
        foo: void,
        bar: void,
        verbose: []void,

        const shorthands = .{
            .f = .foo,
            .b = .bar,
            .v = .verbose,
        };

        const docs = .{};
    };
    const argument_lines = [_][]const []const u8{
        &[_][]const u8{
            "--foo",
            "--bar",
            "--verbose",
            "--verbose",
        },
        &[_][]const u8{ "-f", "-b", "-v", "-v" },
        &[_][]const u8{"-fbvv"},
    };
    for (argument_lines) |argument_line| {
        const result = try parseSliceArgs(TestOptions, std.testing.allocator, argument_line);
        try std.testing.expect(result.options.foo == true);
        try std.testing.expect(result.options.bar == true);
        try std.testing.expect(result.options.verbose == 2);
    }
}

test "options with values" {
    const Options = struct {
        rboolean: bool,
        rinteger: i32,
        rfloat: f32,
        rstr: []const u8,
        boolean: bool = true,
        integer: i32 = 420,
        float: f32 = 6.9,
        str: []const u8 = "Ya like jazzz?",

        flag: void, // for testing groups

        const shorthands = .{
            .b = .rboolean,
            .i = .rinteger,
            .f = .rfloat,
            .s = .rstr,
            .B = .boolean,
            .I = .integer,
            .F = .float,
            .S = .str,
            .L = .flag,
        };
    };

    const required_values = [_][]const []const u8{
        &[_][]const u8{ "--rboolean", "true", "--rinteger", "200", "--rfloat", "0.1", "--rstr", "Yea i do!", "--flag" },
        &[_][]const u8{ "--rboolean=true", "--rinteger=200", "--rfloat=0.1", "--rstr=Yea i do!", "--flag" },
        &[_][]const u8{ "-L", "-b", "true", "-i", "200", "-f", "0.1", "-s", "Yea i do!", "-L" },
        &[_][]const u8{ "-Lb", "true", "-Li", "200", "-Lf", "0.1", "-Ls", "Yea i do!" },
    };

    const changing_optionals = [_][]const []const u8{
        &[_][]const u8{ "--boolean", "false", "--integer", "100", "--float", "0.5", "--str", "Who would listen to that?", "--flag" },
        &[_][]const u8{ "--boolean=false", "--integer=100", "--float=0.5", "--str=Who would listen to that?", "--flag" },
        &[_][]const u8{ "-L", "-B", "false", "-I", "100", "-F", "0.5", "-S", "Who would listen to that?", "-L" },
        &[_][]const u8{ "-LB", "false", "-LI", "100", "-LF", "0.5", "-LS", "Who would listen to that?" },
    };
    for (required_values) |argument_line| {
        const result = try parseSliceArgs(Options, std.testing.allocator, argument_line);
        try std.testing.expectEqual(true, result.options.flag);
        try std.testing.expectEqual(true, result.options.rboolean.?);
        try std.testing.expectEqual(@as(i32, 200), result.options.rinteger.?);
        try std.testing.expectEqual(@as(f32, 0.1), result.options.rfloat.?);
        try std.testing.expectEqualSlices(u8, "Yea i do!", result.options.rstr.?);

        try std.testing.expectEqual(true, result.options.boolean);
        try std.testing.expectEqual(@as(i32, 420), result.options.integer);
        try std.testing.expectEqual(@as(f32, 6.9), result.options.float);
        try std.testing.expectEqualSlices(u8, "Ya like jazzz?", result.options.str);
    }

    for (changing_optionals) |argument_line| {
        const result = try parseSliceArgs(Options, std.testing.allocator, argument_line);

        try std.testing.expectEqual(true, result.options.flag);
        try std.testing.expectEqual(false, result.options.boolean);
        try std.testing.expectEqual(@as(i32, 100), result.options.integer);
        try std.testing.expectEqual(@as(f32, 0.5), result.options.float);
        try std.testing.expectEqualSlices(u8, "Who would listen to that?", result.options.str);
    }
}

test "error.BadValue" {
    const Options = struct {
        boolean: bool,
        integer: i32,
        float: f32,
        str: []const u8,

        const shorthands = .{
            .b = .boolean,
            .i = .integer,
            .f = .float,
            .s = .str,
        };
    };

    const argument_lines = [_][]const []const u8{
        &[_][]const u8{ "--boolean", "treu" },
        &[_][]const u8{ "-b", "treu" },
        &[_][]const u8{"--boolean=treu"},
        &[_][]const u8{"-b=treu"},

        &[_][]const u8{ "--integer", "0.6" },
        &[_][]const u8{ "-i", "0.6" },
        &[_][]const u8{"--integer=0.6"},
        &[_][]const u8{"-i=0.6"},

        &[_][]const u8{ "--float", "value" },
        &[_][]const u8{ "-f", "value" },
        &[_][]const u8{"--float=value"},
        &[_][]const u8{"-f=value"},

        // []const u8 can't have a bad value
    };
    for (argument_lines) |argument_line| {
        try std.testing.expectError(error.BadValue, parseSliceArgs(Options, std.testing.allocator, argument_line));
    }
}

test "error.ExpectedValue" {
    const Options = struct {
        ping: void,
        pong: u32,

        const shorthands = .{
            .p = .ping,
            .P = .pong,
        };
    };

    const argument_lines = [_][]const []const u8{
        &[_][]const u8{ "--ping", "--pong" },
        &[_][]const u8{ "-p", "-P" },
        &[_][]const u8{"-pP="},
        &[_][]const u8{"-P"},

        // []const u8 can't have a bad value
    };
    for (argument_lines) |argument_line| {
        try std.testing.expectError(error.ExpectedValue, parseSliceArgs(Options, std.testing.allocator, argument_line));
    }
}
