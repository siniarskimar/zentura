const std = @import("std");
const testing = std.testing;

// Usefull from std
pub const rad_per_deg = std.math.rad_per_deg;
pub const deg_per_rad = std.math.deg_per_rad;
pub const degreesToRadians = std.math.degreesToRadians;

/// Comptime constraint of mathematical vector
pub fn Vec(N: comptime_int, T: type) type {
    const typeinfo = @typeInfo(T);
    if (typeinfo != .Float and typeinfo != .Int)
        @compileError("vector type must be either a float or integer");

    if (N < 1) @compileError("number of vector components cannot be smaller than 1");
    return [N]T;
}

/// Comptime constraint of mathematical matrix NxM
pub fn Mat(N: comptime_int, M: comptime_int, T: type) type {
    const typeinfo = @typeInfo(T);
    if (typeinfo != .Float and typeinfo != .Int)
        @compileError("matrix type must be either a float or integer");

    if (N < 1) @compileError("matrix dimention N must be bigger than 0");
    if (M < 1) @compileError("matrix dimention M must be bigger than 0");
    return [N][M]T;
}

/// Shorthand for Mat(N,N,T)
pub fn MatN(N: comptime_int, T: type) type {
    return Mat(N, N, T);
}

pub fn vecDot(
    N: comptime_int,
    T: type,
    a: Vec(N, T),
    b: Vec(N, T),
) T {
    if (@typeInfo(T) == .Float) {
        return @reduce(.Add, @as(@Vector(N, T), a) * @as(@Vector(N, T), b));
    }
    // TODO: change this to @Vector but check for overflow
    var result: T = 0;
    inline for (0..N) |comp| {
        result += a[comp] * b[comp];
    }
    return result;
}

pub fn vecCross(
    N: comptime_int,
    T: type,
    a: Vec(N, T),
    b: Vec(N, T),
) Vec(N, T) {
    switch (N) {
        1 => @compileError("cross product does not exist for 1D vectors"),
        2 => @compileError("cross product does not exist for 2D vectors"),
        3 => return Vec(N, T){
            a[1] * b[2] - a[2] * b[1], // x-hat
            a[2] * b[0] - a[0] * b[2], // y-hat
            a[0] * b[1] - a[1] * b[0], // z-hat
        },
        else => @compileError("TODO: implement cross product for 3+ vectors"),
    }
}

pub fn vecMulScalar(
    N: comptime_int,
    T: type,
    vec: Vec(N, T),
    scalar: T,
) Vec(N, T) {
    if (@typeInfo(T) == .Float) {
        return @as(@Vector(N, T), vec) * @as(@Vector(N, T), @splat(scalar));
    }
    var result: Vec(N, T) = undefined;
    inline for (0..N) |comp| {
        result[comp] = vec[comp] * scalar;
    }
    return result;
}

/// Component-wise multiplication
pub fn vecCompMul(
    N: comptime_int,
    T: type,
    a: Vec(N, T),
    b: Vec(N, T),
) Vec(N, T) {
    var result: Vec(N, T) = undefined;
    inline for (0..N) |comp| {
        result[comp] = a[comp] * b[comp];
    }
    return result;
}

test "test/vecDot" {
    try testing.expectEqual(
        14,
        vecDot(3, u32, .{ 1, 2, 3 }, .{ 1, 2, 3 }),
    );
}

test "test/vecCross" {
    try testing.expectEqual(
        Vec(3, f32){ 0, 0, 1 },
        vecCross(3, f32, .{ 1, 0, 0 }, .{ 0, 1, 0 }),
    );
    try testing.expectEqual(
        Vec(3, f32){ 0, 0, -1 },
        vecCross(3, f32, .{ 0, 1, 0 }, .{ 1, 0, 0 }),
    );
}

test "test/vecMul" {
    try testing.expectEqual(
        Vec(3, f32){ 3, 3, 3 },
        vecMulScalar(3, f32, .{ 1, 1, 1 }, 3),
    );
    try testing.expectEqual(
        Vec(3, f32){ 0.5, 0.5, 0.5 },
        vecMulScalar(3, f32, .{ 1, 1, 1 }, 0.5),
    );
    try testing.expectEqual(
        Vec(3, f32){ 3, 4, 3 },
        vecCompMul(3, f32, .{ 1, 2, 3 }, .{ 3, 2, 1 }),
    );
}

pub fn matNTranspose(
    N: comptime_int,
    T: type,
    mat: MatN(N, T),
) MatN(N, T) {
    var result: MatN(N, T) = undefined;

    inline for (0..N) |n| {
        inline for (0..N) |m| {
            result[n][m] = mat[m][n];
        }
    }
    return result;
}

test "test/matNTranspose" {
    const mat: MatN(3, f32) = .{
        .{ 1, 2, 3 },
        .{ 4, 5, 6 },
        .{ 7, 8, 9 },
    };
    const expected: MatN(3, f32) = .{
        .{ 1, 4, 7 },
        .{ 2, 5, 8 },
        .{ 3, 6, 9 },
    };
    const transposed = matNTranspose(3, f32, mat);
    try testing.expectEqualSlices(f32, &expected[0], &transposed[0]);
    try testing.expectEqualSlices(f32, &expected[1], &transposed[1]);
    try testing.expectEqualSlices(f32, &expected[2], &transposed[2]);
}

pub fn matNMul(
    N: comptime_int,
    T: type,
    a: MatN(N, T),
    b: MatN(N, T),
) MatN(N, T) {
    var result: MatN(N, T) = undefined;
    const transposed = matNTranspose(N, T, b);

    // TODO: measure the performance
    inline for (0..N) |a_row| {
        inline for (0..N) |b_col| {
            result[a_row][b_col] = vecDot(N, T, a[a_row], transposed[b_col]);
        }
    }

    return result;
}

pub fn matMulScalar(
    N: comptime_int,
    M: comptime_int,
    T: type,
    mat: Mat(N, M, T),
    scalar: T,
) Mat(N, M, T) {
    var result: Mat(N, M, T) = undefined;
    inline for (0..N) |row| {
        inline for (0..M) |col| {
            result[row][col] = mat[row][col] * scalar;
        }
    }
    return result;
}

pub fn matMulVec(
    N: comptime_int,
    M: comptime_int,
    T: type,
    mat: Mat(N, M, T),
    x: Vec(M, T),
) Vec(M, T) {
    var result: Vec(M, T) = undefined;
    inline for (0..M) |m| {
        result[m] = vecMulScalar(M, T, mat[m], x[m]);
    }
    return result;
}

test "test/matNMul/1" {
    const result = matNMul(3, f32, .{
        .{ 1, 2, 3 },
        .{ 4, 5, 6 },
        .{ 7, 8, 9 },
    }, .{
        .{ 1, 2, 3 },
        .{ 4, 5, 6 },
        .{ 7, 8, 9 },
    });
    const expected: MatN(3, f32) = .{
        .{ 30, 36, 42 },
        .{ 66, 81, 96 },
        .{ 102, 126, 150 },
    };
    try testing.expectEqualSlices(f32, &expected[0], &result[0]);
    try testing.expectEqualSlices(f32, &expected[1], &result[1]);
    try testing.expectEqualSlices(f32, &expected[2], &result[2]);
}

test "test/matNMul/2" {
    // Non-commutativity
    const result1 = matNMul(2, f32, .{
        .{ 0, 1 },
        .{ 0, 0 },
    }, .{
        .{ 0, 0 },
        .{ 1, 0 },
    });
    const expected1: MatN(2, f32) = .{
        .{ 1, 0 },
        .{ 0, 0 },
    };

    const result2 = matNMul(2, f32, .{
        .{ 0, 0 },
        .{ 1, 0 },
    }, .{
        .{ 0, 1 },
        .{ 0, 0 },
    });
    const expected2: MatN(2, f32) = .{
        .{ 0, 0 },
        .{ 0, 1 },
    };
    try testing.expectEqualSlices(f32, &expected1[0], &result1[0]);
    try testing.expectEqualSlices(f32, &expected1[1], &result1[1]);

    try testing.expectEqualSlices(f32, &expected2[0], &result2[0]);
    try testing.expectEqualSlices(f32, &expected2[1], &result2[1]);
}

/// Counter-clockwise rotation matrix
pub fn mat2Rot(T: type, radians: f32) MatN(2, T) {
    return MatN(2, T){
        .{ @cos(radians), -@sin(radians) },
        .{ @sin(radians), @cos(radians) },
    };
}

/// Counter-clockwise rotation matrix
pub fn mat3Rot(T: type, radians: f32) MatN(2, T) {
    return MatN(2, T){
        // zig fmt: off
        .{@cos(radians), -@sin(radians), 0},
        .{@sin(radians),  @cos(radians), 0},
        .{            0,              0, 1}
        // zig fmt: on
    };
}

pub fn matOrtho(
    left: f32,
    right: f32,
    top: f32,
    bottom: f32,
    far: f32,
    near: f32,
) MatN(4, f32) {
    const rl_diff = right - left;
    const tb_diff = top - bottom;
    const fn_diff = far - near;

    // zig fmt: off
    return .{
        .{ 2/rl_diff,         0,           0, -(right + left)/rl_diff },
        .{           0, 2/tb_diff,         0, -(top + bottom)/tb_diff },
        .{           0,         0, 2/fn_diff, -(far + near)/fn_diff   },
        .{           0,         0,         0,                       1 }
    };
    // zig fmt: on
}
