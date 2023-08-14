const std = @import("std");
const Allocator = std.mem.Allocator;
const Type = std.builtin.Type;
const builtin = @import("builtin");

pub fn SliceIter(comptime T: type) type {
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

pub const ParserDescription = struct {
    options: []const Option = &[_]Option{},
    positionals: []const Positional = &[_]Positional{},
    // argument_names: []const []const u8 = &[_][]const u8{},

    pub const Option = struct {
        name: []const u8,
        short_name: ?u8 = null,

        /// Expected value type,
        /// void indicates that option is valueless
        value_type: type = void,
        default_value: ?*const anyopaque = null,
    };

    pub const Positional = struct {
        name: []const u8,

        /// Expected value type
        /// cannot be void
        value_type: type,

        /// Replaces positional name on the help page
        /// <value_type> -> <docstring>
        docstring: ?[]const u8 = null,

        required: bool = true,
    };

    const Self = @This();

    pub fn addOption(comptime self: *Self, comptime argument: Option) void {
        self.options = self.options ++ [_]Option{argument};
    }

    pub fn addPositional(comptime self: *Self, comptime argument: Positional) void {
        self.positionals = self.positionals ++ [_]Positional{argument};
    }

    pub fn constructResultType(comptime self: *const Self) type {
        var fields: [self.positionals.len + self.options.len]Type.StructField = undefined;
        for (self.positionals, 0..) |positional, idx| {
            if (positional.value_type == void) {
                @compileError("A positional argument cannot have a value type of void");
            }
            const final_type = @Type(.{ .Optional = .{ .child = positional.value_type } });
            fields[idx] = .{
                .name = positional.name,
                .type = final_type,
                .default_value = &@as(final_type, null),
                .is_comptime = false,
                .alignment = 0,
            };
        }
        for (self.options, self.positionals.len..) |option, idx| {
            const final_type = switch (option.value_type) {
                void => bool,
                []void => u32,
                else => |T| @Type(.{ .Optional = .{ .child = T } }),
            };
            const default_value: ?*const anyopaque = blk: {
                if (option.default_value != null) {
                    break :blk option.default_value;
                }

                switch (option.value_type) {
                    void => break :blk &false,
                    []void => break :blk &@as(final_type, 0),
                    else => |T| break :blk &@as(?T, null),
                }
            };
            fields[idx] = .{
                .name = option.name,
                .type = final_type,
                .default_value = default_value,
                .is_comptime = false,
                .alignment = 0,
            };
        }
        // Duplicate fields will be caught by @Type
        const ArgumentContainer = @Type(.{ .Struct = .{
            .layout = .Auto,
            .fields = &fields,
            .decls = &[_]Type.Declaration{},
            .is_tuple = false,
        } });

        return struct {
            args: ArgumentContainer = ArgumentContainer{},
        };
    }
};

fn parseBoolean(buffer: []const u8) ?bool {
    // zig fmt: off
    return
        if (std.mem.eql(u8, buffer, "true")) true
        else if (std.mem.eql(u8, buffer, "false")) false
        else return null;
    // zig fmt: on
}

const ParseError = error{
    ExpectedValue,
    BadValue,
    InvalidOptionName,
    UnknownOption,
    NotAnOption,
} || std.fmt.ParseIntError || std.fmt.ParseFloatError;

const Diagnostics = struct {
    // TODO: Provide diagnostics for the end user
};

const ParseErrorWrapper = struct {
    err: ParseError,
    stacktrace: ?*std.builtin.StackTrace,

    fn init(err: ParseError, stacktrace: ?*std.builtin.StackTrace) ParseErrorWrapper {
        return .{ .err = err, .stacktrace = stacktrace };
    }
};

pub fn ArgumentParser(comptime comptime_parser: ParserDescription) type {
    return struct {
        const Self = @This();
        const Result = comptime_parser.constructResultType();

        /// A slightly modified std.ComptimeStringMap
        const ParserDispatcher = constructParserDispather();

        const ParseContext = struct {
            parse_result: *Result,
            argument_iterator: *SliceIter([]const u8),
            positional_idx: usize = 0,
            current_argument: ?[]const u8 = null,
            current_option_name: ?[]const u8 = null,
            argument_eql: ?usize = null,
            diagnostics: ?*Diagnostics = null,

            fn loadOption(self: *@This(), argument: []const u8) bool {
                if (argument.len < 2) {
                    return false;
                }
                const maybe_eql = std.mem.indexOf(u8, argument, "=");
                const optname_end = if (maybe_eql) |eql| eql else argument.len;
                const optname_start = switch (argument[0]) {
                    else => return false,
                    '-' => switch (argument[1]) {
                        else => @as(usize, 1),
                        '-' => @as(usize, 2),
                    },
                };

                self.argument_eql = maybe_eql;
                self.current_option_name = argument[optname_start..optname_end];
                self.current_argument = argument;
                return true;
            }
        };

        const ValueParserFn = fn (ctx: *ParseContext) ?ParseErrorWrapper;

        fn parseValue(
            comptime OptionValueType: type,
            comptime ResultType: type,
            currentvalue: *ResultType,
            valuebuffer: []const u8,
        ) ParseError!ResultType {
            return switch (OptionValueType) {
                void => true,
                []void => currentvalue.* + 1,
                []const u8 => valuebuffer,

                bool => parseBoolean(valuebuffer) orelse return ParseError.BadValue,

                else => switch (@typeInfo(OptionValueType)) {
                    .Int => try std.fmt.parseInt(OptionValueType, valuebuffer, 0),
                    .Float => try std.fmt.parseFloat(OptionValueType, valuebuffer, 0),
                    .Enum => std.meta.stringToEnum(OptionValueType, valuebuffer) orelse return ParseError.BadValue,
                    else => @compileError("No valid parser for type " ++ @typeName(OptionValueType)),
                },
            };
        }

        fn getValueStr(ctx: *ParseContext) ParseError![]const u8 {
            const currargument = ctx.current_argument.?;
            const maybe_eql = std.mem.indexOf(u8, currargument, "=");
            var valuebuffer: []const u8 = undefined;

            if (maybe_eql) |eql| {
                valuebuffer = currargument[eql + 1 ..];
            } else {
                valuebuffer = ctx.argument_iterator.next() orelse "";
            }

            if (valuebuffer.len == 0) {
                return ParseError.ExpectedValue;
            }
            return valuebuffer;
        }

        fn ValueParser(comptime option: ParserDescription.Option) *const ValueParserFn {
            // gotta love generating functions at comptime
            return &(struct {
                fn parse(ctx: *ParseContext) ?ParseErrorWrapper {
                    const currargument = ctx.current_argument.?;
                    if (currargument.len == 0) unreachable;

                    var field = &@field(ctx.parse_result.args, option.name);
                    var valuebuffer: []const u8 = undefined;

                    switch (option.value_type) {
                        void, []void => {},
                        else => {
                            valuebuffer = getValueStr(ctx) catch |err| {
                                return ParseErrorWrapper.init(err, @errorReturnTrace());
                            };
                        },
                    }

                    field.* = parseValue(
                        option.value_type,
                        @TypeOf(@field(ctx.parse_result.args, option.name)),
                        field,
                        valuebuffer,
                    ) catch |err| {
                        return ParseErrorWrapper.init(err, @errorReturnTrace());
                    };

                    return null;
                }
            }).parse;
        }

        pub fn constructParserDispather() type {
            @setEvalBranchQuota(2000);
            const computed = inner: {
                const KV = struct {
                    key: []const u8,
                    value: *const ValueParserFn,
                };

                var short_count = 0;
                for (comptime_parser.options) |opt| if (opt.short_name) |_| {
                    short_count += 1;
                };

                var short_idx = 0;
                var sorted_kvs: [comptime_parser.options.len + short_count]KV = undefined;

                for (comptime_parser.options, 0..) |opt, idx| {
                    sorted_kvs[idx] = .{ .key = opt.name, .value = ValueParser(opt) };
                    if (opt.short_name) |short| {
                        sorted_kvs[comptime_parser.options.len + short_idx] = .{ .key = &[_]u8{short}, .value = ValueParser(opt) };
                        short_idx += 1;
                    }
                }

                const SortContext = struct {
                    kvs: []KV,

                    pub fn lessThan(ctx: @This(), a: usize, b: usize) bool {
                        return ctx.kvs[a].key.len < ctx.kvs[b].key.len;
                    }

                    pub fn swap(ctx: @This(), a: usize, b: usize) void {
                        return std.mem.swap(KV, &ctx.kvs[a], &ctx.kvs[b]);
                    }
                };

                std.mem.sortUnstableContext(0, sorted_kvs.len, SortContext{ .kvs = &sorted_kvs });
                const kvs_len = sorted_kvs.len;
                const min_len = sorted_kvs[0].key.len;
                const max_len = sorted_kvs[kvs_len - 1].key.len;

                var len_indexes: [max_len + 1]usize = undefined;
                var len: usize = 0;
                var i: usize = 0;
                while (len <= max_len) : (len += 1) {
                    // find the first keyword len == len
                    while (len > sorted_kvs[i].key.len) {
                        i += 1;
                    }
                    len_indexes[len] = i;
                }
                break :inner .{
                    .min_len = min_len,
                    .max_len = max_len,
                    .sorted_kvs = sorted_kvs,
                    .len_indexes = len_indexes,
                };
            };

            return struct {
                const kvs = computed.sorted_kvs;

                fn get(key: []const u8) ?*const ValueParserFn {
                    if (key.len < computed.min_len or key.len > computed.max_len) {
                        return null;
                    }
                    var kvs_idx = computed.len_indexes[key.len];
                    while (true) {
                        const kv = computed.sorted_kvs[kvs_idx];

                        // This seems pointless, but std.ComptimeStringMap does it this way
                        if (kv.key.len != key.len) {
                            return null;
                        }

                        if (std.mem.eql(u8, key, kv.key)) {
                            return kv.value;
                        }
                        kvs_idx += 1;
                        if (kvs_idx >= computed.sorted_kvs.len) {
                            break;
                        }
                    }
                    return null;
                }
            };
        }

        /// Dispatches work to the correct option parser
        /// by directly manipulating the parse result
        fn parseOption(ctx: *ParseContext) !void {
            const optname = ctx.current_option_name.?;
            if (optname.len == 0) {
                return ParseError.NotAnOption;
            }

            const valueParser = ParserDispatcher.get(optname) orelse return ParseError.UnknownOption;
            if (valueParser(ctx)) |err_wrapper| {
                if (err_wrapper.stacktrace) |stacktrace| {
                    std.debug.dumpStackTrace(stacktrace.*);
                }
                return err_wrapper.err;
            }
        }

        fn parsePositional(ctx: *ParseContext) !void {
            _ = ctx;
        }

        pub fn parseArgSlice(slice: []const []const u8) !Result {
            var arg_iterator = SliceIter([]const u8){ .slice = slice, .index = 0 };
            var parse_result = Result{};
            var ctx = ParseContext{
                .parse_result = &parse_result,
                .argument_iterator = &arg_iterator,
                .current_argument = "",
                .diagnostics = null,
            };

            while (arg_iterator.next()) |arg| {
                ctx.current_argument = arg;
                switch (arg[0]) {
                    '-' => {
                        if (ctx.loadOption(arg) == false) unreachable;
                        if (arg.len >= 3 and arg[1] == '-') {
                            // long name
                            // --......
                            try parseOption(&ctx);
                        } else {
                            // short name
                            // could be a group
                            // -....
                            const option_group = ctx.current_option_name.?;

                            for (option_group) |option| {
                                ctx.current_option_name = &[1]u8{option};
                                try parseOption(&ctx);
                            }
                        }
                    },
                    else => {
                        // positional
                    },
                }
            }
            return parse_result;
        }
    };
}

const test_parser = blk: {
    var desc = ParserDescription{};
    desc.addOption(.{ .name = "foo", .short_name = 'f' });
    desc.addOption(.{ .name = "fool", .short_name = 'd', .value_type = bool });
    desc.addOption(.{ .name = "goal", .short_name = 'g', .value_type = bool });
    desc.addOption(.{ .name = "verbose", .short_name = 'v', .value_type = []void });
    desc.addOption(.{ .name = "integer", .short_name = 'i', .value_type = i32 });
    desc.addOption(.{ .name = "string", .value_type = []const u8 });
    desc.addOption(.{ .name = "enum", .value_type = enum { Abra, Cadabra } });
    // desc.addOption(.{ .name = "union", .value_type = union { a: i32 } });
    break :blk ArgumentParser(desc);
};

test "long options" {
    {
        // zig fmt: off
        const arguments = try test_parser.parseArgSlice(&[_][]const u8{
            "--fool", "false",
            "--goal", "true",
            "--foo",
            "--verbose", "--verbose",
            "--integer", "720",
            "--string=Never gonna give you up",
            "--enum=Abra"
        });
        // zig fmt: on

        try std.testing.expectEqual(false, arguments.args.fool.?);
        try std.testing.expectEqual(true, arguments.args.goal.?);
        try std.testing.expectEqual(true, arguments.args.foo);
        try std.testing.expect(arguments.args.verbose == 2);
        try std.testing.expect(arguments.args.integer.? == 720);
        try std.testing.expectEqualStrings("Never gonna give you up", arguments.args.string.?);
        try std.testing.expect(arguments.args.@"enum".? == .Abra);
    }
}

test "errors" {
    try std.testing.expectError(
        error.BadValue,
        test_parser.parseArgSlice(&[_][]const u8{
            "--fool",
            "treu",
        }),
    );
}
