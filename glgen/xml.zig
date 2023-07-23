/// xml.zig
/// Provides parsing of XML 1.0 (https://www.w3.org/TR/xml/)
const std = @import("std");
const Allocator = std.mem.Allocator;
const ascii = std.ascii;

pub const Entity = struct {
    allocator: Allocator,
    parent: ?*Entity,
    children: std.ArrayList(*Entity),
    tag: []const u8,
    textcontent: std.SegmentedList([]const u8, 0),

    const Self = @This();

    pub fn initAlloc(allocator: Allocator, tag: []const u8, parent: ?*Entity) !*Self {
        var self = try allocator.create(Self);

        self.tag = try allocator.dupe(u8, tag);
        self.allocator = allocator;
        self.parent = parent;
        self.children = std.ArrayList(*Entity).init(allocator);
        self.textcontent = std.SegmentedList([]const u8, 0){};
        return self;
    }

    // TODO: XPath querying
    // pub fn find(self: *const Self) *Self { }
    // pub fn findall(self: *const Self, allocator: Allocator) []*Self { }

    pub fn deinit(self: *Self) void {
        self.allocator.free(self.tag);
        for (self.children.items) |child| {
            child.deinit();
            self.allocator.destroy(child);
        }
        self.children.deinit();
        self.textcontent.deinit(self.allocator);
    }

    pub fn appendChild(self: *Self, child: *Entity) !void {
        if (child.allocator.ptr != self.allocator.ptr) {
            return error.MismatchedAllocators;
        }
        if (child.parent != null) {
            return error.ParentFieldNotNull;
        }
        child.parent = self;
        try self.children.append(child);
    }
};

pub const Document = struct {
    root: ?*Entity,
    allocator: Allocator,

    const Self = @This();

    pub fn init(allocator: Allocator, root: ?*Entity) Self {
        return .{
            .root = root,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: *Self) void {
        if (self.root) |root| {
            root.deinit();
            self.allocator.destroy(root);
        }
    }
};

pub const ParseError = error{
    InvalidAscii,
    UnexpectedEnd,
    InvalidEntity,
    ExpectedEntityName,
    UnenclosedEntity,
    InvalidEntityNameChar,
    MismatchedEntityCloseTag,
    MultipleDocumentRoots,
};

pub const ParserContext = struct {
    buffer: []const u8,
    idx: usize,
    linenr: u32,
    colnr: u32,

    const Self = @This();

    pub fn init(buffer: []const u8, pos: usize) Self {
        return .{
            .buffer = buffer,
            .idx = pos,
            .linenr = 0,
            .colnr = 0,
        };
    }

    /// Return current character and move forward
    fn next(self: *Self) ?u8 {
        if (self.idx == self.buffer.len) {
            return null;
        }
        const byte = self.buffer[self.idx];
        self.idx += 1;
        return byte;
    }

    /// Return current character without moving forward
    fn peek(self: *const Self) ?u8 {
        if (self.idx == self.buffer.len) {
            return null;
        }
        return self.buffer[self.idx];
    }

    // Return slice of `count` characters without moving forward
    fn peekSlice(self: *const Self, count: usize) ?[]const u8 {
        if (self.idx + count >= self.buffer.len) {
            return null;
        }
        return self.buffer[self.idx .. self.idx + count];
    }

    /// Skip at most `count` characters
    /// Returns true if succeded
    fn skip(self: *Self, count: usize) bool {
        if (self.idx == self.buffer.len) {
            return false;
        }
        self.idx += @min(count, self.buffer.len - self.idx);
        return true;
    }

    /// Rewind at most `count` characters back
    /// Returns true if succeded
    fn rewind(self: *Self, count: usize) bool {
        if (self.idx == 0) {
            return false;
        }
        self.idx -= @min(count, self.idx);
        return true;
    }

    /// Skip whitespace characters
    fn skipWhitespace(self: *Self) void {
        while (self.next()) |ch| {
            switch (ch) {
                0x20, 0x09, 0x0D, 0x0A => {},
                else => {
                    // We took one alphanumeric for the test
                    self.rewind(1);

                    return;
                },
            }
        }
    }

    fn isEof(self: *const Self) bool {
        return self.idx == self.buffer.len;
    }

    /// Returns slice of bytes near current position
    /// Used for error logging purposes
    pub fn formatNearBytes(self: *const Self) []const u8 {
        var start = self.idx;
        var end = self.idx;

        for (0..10) |_| {
            const sbyte = self.buffer[start];
            const ebyte = self.buffer[end];
            if (start != 0 or sbyte != '\n' or sbyte != '\r') {
                start -= 1;
            }
            if (end != self.buffer.len or ebyte != '\n' or ebyte != '\r') {
                end -= 1;
            }
        }
        return self.buffer[start..end];
    }
};

fn parseName(parserctx: *ParserContext) ParseError!?[]const u8 {
    const start = parserctx.idx;
    var len: usize = 0;

    if (parserctx.next()) |ch| {
        switch (ch) {
            '_', 'a'...'z', 'A'...'Z', ':' => {
                len += 1;
            },
            else => return error.InvalidEntityNameChar,
        }
    }

    while (parserctx.next()) |ch| {
        switch (ch) {
            '_', 'a'...'z', 'A'...'Z', ':', '.', '-', '0'...'9' => {
                len += 1;
            },
            else => {
                // whitespace or entity end or entity self close
                if (ascii.isWhitespace(ch) or ch == '>' or ch == '/') {
                    _ = parserctx.rewind(1);
                    break;
                }
                return error.InvalidEntityNameChar;
            },
        }
    }
    if (len == 0) {
        return null;
    }

    return parserctx.buffer[start .. start + len];
}

pub fn parse(parserctx: *ParserContext, allocator: Allocator) !Document {
    var result = Document.init(allocator, null);
    errdefer result.deinit();

    var entitystack = std.ArrayList(*Entity).init(allocator);
    defer entitystack.deinit();

    var contentstart: ?usize = null;
    var contentlen: usize = 0;

    while (parserctx.next()) |byte| {
        if (byte > 127) {
            return ParseError.InvalidAscii;
        }
        parserctx.colnr += 1;

        if (byte == '\n') {
            parserctx.linenr += 1;
            parserctx.colnr = 0;
        }

        switch (byte) {
            // Start entity
            '<' => {
                if (contentstart != null) {
                    var current: *Entity = entitystack.getLastOrNull() orelse {
                        std.log.err("reached unreachable code while parsing XML: line={}, col={}, eof={}, {s}\n", .{ parserctx.linenr, parserctx.colnr, parserctx.isEof(), parserctx.formatNearBytes() });
                        unreachable;
                    };
                    try current.textcontent.append(allocator, parserctx.buffer[contentstart.? .. contentstart.? + contentlen]);
                }
                switch (parserctx.next().?) {
                    // Closing tag
                    '/' => {
                        const name = try parseName(parserctx) orelse return ParseError.ExpectedEntityName;
                        const current = entitystack.getLastOrNull() orelse return ParseError.MismatchedEntityCloseTag;

                        if (!std.mem.eql(u8, current.tag, name)) {
                            return ParseError.MismatchedEntityCloseTag;
                        }
                        _ = entitystack.pop();

                        const end = ascii.indexOfIgnoreCasePos(parserctx.buffer, parserctx.idx, ">") orelse return ParseError.UnenclosedEntity;
                        parserctx.idx = end + 1;
                    },

                    // XMLDecl
                    '?' => {
                        const name = try parseName(parserctx) orelse return ParseError.ExpectedEntityName;

                        if (!std.mem.eql(u8, name, "xml")) {
                            return ParseError.InvalidEntity;
                        }

                        // TODO: Store XMLDecl data in Document

                        const end = ascii.indexOfIgnoreCasePos(parserctx.buffer, parserctx.idx, "?>") orelse return ParseError.UnenclosedEntity;
                        parserctx.idx = end + 2;
                    },

                    // Comment
                    '!' => {
                        // Let's just not care about DOCTYPE

                        if (parserctx.peekSlice(2)) |maybe_dashes| {
                            if (std.mem.eql(u8, maybe_dashes, "--")) {
                                _ = parserctx.skip(2);
                                const end = ascii.indexOfIgnoreCasePos(parserctx.buffer, parserctx.idx, "-->") orelse return ParseError.UnenclosedEntity;
                                parserctx.idx = end + 3;
                                continue;
                            }
                        }
                        if (parserctx.isEof()) {
                            return ParseError.UnexpectedEnd;
                        }
                        return ParseError.InvalidEntity;
                    },

                    // Opening tag
                    else => {
                        _ = parserctx.rewind(1);
                        const name = try parseName(parserctx) orelse return ParseError.UnexpectedEnd;
                        var entity = try Entity.initAlloc(allocator, name, null);

                        errdefer allocator.destroy(entity);
                        errdefer entity.deinit();

                        if (result.root == null) {
                            result.root = entity;
                            try entitystack.append(entity);
                        } else {
                            if (entitystack.items.len == 0) {
                                return ParseError.MultipleDocumentRoots;
                            }
                            var current = entitystack.getLastOrNull() orelse unreachable;
                            try current.appendChild(entity);
                            try entitystack.append(entity);
                        }

                        // TODO: Implement parsing of entity attributes

                        const end = ascii.indexOfIgnoreCasePos(parserctx.buffer, parserctx.idx, ">") orelse return ParseError.UnenclosedEntity;

                        // Entity with no content (self-closing)
                        if (parserctx.buffer[end - 1] == '/') {
                            _ = entitystack.pop();
                        }

                        parserctx.idx = end + 1;
                    },
                }
            },
            // Text content
            else => {
                if (byte == '\n' or byte == '\r') {
                    continue;
                }
                if (contentstart == null) {
                    // One character already consumed
                    contentstart = parserctx.idx - 1;
                    contentlen = 1;
                } else {
                    contentlen += 1;
                }
            },
        }
    }
    return result;
}

test "parse: single entity" {
    var parserctx = ParserContext.init("<hello></hello>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);
}

test "parse: multiple roots" {
    var parserctx = ParserContext.init("<hello></hello><world></world>", 0);
    var result = parse(&parserctx, std.testing.allocator);
    try std.testing.expectError(ParseError.MultipleDocumentRoots, result);
}

// Error case
test "parse: entity with invalid name characters" {
    var parsercontexes = std.ArrayList(ParserContext).init(std.testing.allocator);
    defer parsercontexes.deinit();
    try parsercontexes.append(ParserContext.init("< hello></hello>", 0));
    try parsercontexes.append(ParserContext.init("<hello></ hello>", 0));
    try parsercontexes.append(ParserContext.init("< hello/>", 0));
    try parsercontexes.append(ParserContext.init("<0hello/>", 0));

    for (0..parsercontexes.items.len) |i| {
        var parserctx = &parsercontexes.items[i];
        var result = parse(parserctx, std.testing.allocator);
        try std.testing.expectError(ParseError.InvalidEntityNameChar, result);
    }
}

test "parse: mismatched close" {
    var parserctx = ParserContext.init("</hello>", 0);
    var result = parse(&parserctx, std.testing.allocator);
    try std.testing.expectError(ParseError.MismatchedEntityCloseTag, result);
}

//  Comment case no. 1
test "parse: entity - comment before" {
    var parserctx = ParserContext.init("<!-- comment --><hello></hello>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);
}
//  Comment case no. 2
test "parse: entity - comment inside" {
    var parserctx = ParserContext.init("<hello><!-- comment --></hello>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);
}

test "parse: entity with content" {
    var parserctx = ParserContext.init("<hello>world</hello>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);
    try std.testing.expect(result.root.?.textcontent.len == 1);
    try std.testing.expectEqualSlices(u8, "world", result.root.?.textcontent.at(0).*);
}

test "parse: self closing entity" {
    var parserctx = ParserContext.init("<hello/>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);
}

test "parse: nested entities" {
    var parserctx = ParserContext.init("<hello><world></world></hello>", 0);
    var result = try parse(&parserctx, std.testing.allocator);
    defer result.deinit();

    try std.testing.expect(result.root != null);
    try std.testing.expect(result.root.?.children.items.len == 1);
    try std.testing.expectEqualSlices(u8, "hello", result.root.?.tag);

    try std.testing.expect(result.root.?.children.items[0].children.items.len == 0);
    try std.testing.expectEqualSlices(u8, "world", result.root.?.children.items[0].tag);
}

test "parse: nested entities - mismatched close" {
    var parserctx = ParserContext.init("<hello><world></hello></world>", 0);
    var result = parse(&parserctx, std.testing.allocator);
    try std.testing.expectError(ParseError.MismatchedEntityCloseTag, result);
}
