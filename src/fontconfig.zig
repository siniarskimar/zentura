//! Fontconfig wrapper

const std = @import("std");
const c = @import("c");

pub const FcMatchKind = enum(c.FcMatchKind) {
    pattern = c.FcMatchPattern,
    font = c.FcMatchFont,
    scan = c.FcMatchScan,
};

pub const FcResult = enum(c.FcResult) {
    match = c.FcResultMatch,
    no_match = c.FcResultNoMatch,
    type_mismatch = c.FcResultTypeMismatch,
    out_of_memory = c.FcResultOutOfMemory,
};

pub const FcConfig = opaque {
    pub fn destroy(self: *@This()) void {
        c.FcConfigDestroy(@ptrCast(self));
    }
};

/// Represents a search pattern including:
///  - font name
///  - font style
///  - font weight
///  - etc
pub const FcPattern = opaque {
    pub fn create() !*@This() {
        const pat: ?*@This() = @ptrCast(c.FcPatternCreate());
        return pat orelse return error.Unknown;
    }

    /// String representation to pattern object
    pub fn deserialize(pattern: []const u8) !*@This() {
        const pat: ?*@This() = @ptrCast(c.FcNameParse(pattern.ptr));
        return pat orelse return error.Unknown;
    }

    pub fn destroy(self: *@This()) void {
        c.FcPatternDestroy(@ptrCast(self));
    }

    /// Pretty print pattern object.
    /// Purely for debugging purposes
    pub fn debugPrint(self: *const @This()) void {
        const pat: *const c.FcPattern = @ptrCast(self);
        c.FcPatternPrint(pat);
    }

    /// Perform font substitution according to the config
    /// ```
    /// Font substitution is the process of using one typeface in place of another
    /// when the intended typeface either is not available or does not contain glyphs
    /// for the required characters.
    /// https://en.wikipedia.org/wiki/Font_substitution
    /// ```
    /// The return value indicates whenever this operation failed or succeded and
    /// it may be safetly ignored.
    pub fn configSubstitute(self: *@This(), config: *FcConfig, kind: FcMatchKind) bool {
        return c.FcConfigSubstitute(@ptrCast(config), @ptrCast(self), @intFromEnum(kind)) != 0;
    }

    /// Apply sensible defaults to empty properties
    pub fn defaultSubstitute(self: *@This()) void {
        c.FcDefaultSubstitute(@ptrCast(self));
    }
};

/// Initialize Fontconfig library
pub fn init() !void {
    // Fontconfig prints errors to stderr
    if (c.FcInit() == 0) return error.Unknown;
}

/// Free all data structures allocated previously and deinitalizes Fontconfig
pub fn deinit() void {
    c.FcFini();
}

/// Load default and user configuration, fonts referenced in them and returns FcConfig object
pub fn loadConfigAndFonts() !*FcConfig {
    const config: ?*FcConfig = @ptrCast(c.FcInitLoadConfigAndFonts());
    return config orelse return error.Unknown;
}

pub const MatchResult = struct {
    info: FcResult,
    match: ?*FcPattern,
};

pub fn bestMatch(config: *FcConfig, pattern: *FcPattern) MatchResult {
    var result: c.FcResult = c.FcResultNoMatch;
    const match: ?*FcPattern = @ptrCast(c.FcFontMatch(@ptrCast(config), @ptrCast(pattern), &result));
    return .{
        .info = @enumFromInt(result),
        .match = match,
    };
}
