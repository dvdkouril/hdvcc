const std = @import("std");

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn origin() Vec3 {
        return Vec3{ .x = 0.0, .y = 0.0, .z = 0.0 };
    }

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3.init(self.x + other.x, self.y + other.y, self.z + other.z);
    }

    pub fn inverse(self: Vec3) Vec3 {
        return Vec3.init(-self.x, -self.y, -self.z);
    }

    pub fn scaled(self: Vec3, s: f32) Vec3 {
        return Vec3.init(self.x * s, self.y * s, self.z * s);
    }

    pub fn length(self: Vec3) f32 {
        return std.math.sqrt(self.lengthSquared());
    }

    pub fn lengthSquared(self: Vec3) f32 {
        return Vec3.dot(self, self);
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3(
            self.y * other.z - self.z * other.y,
            self.z * other.x - self.x * other.z,
            self.x * other.y - self.y * other.x,
        );
    }

    pub fn normalized(self: Vec3) Vec3 {
        return Vec3.scaled(self, 1 / self.length());
    }

    pub fn format(
        self: Vec3,
        comptime _: []const u8,
        _: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        try writer.print("Vec3({}, {}, {})\n", .{ self.x, self.y, self.z });
    }
};

test "Vec3.add" {
    const a = Vec3.init(3.0, 2.0, 1.0);
    const b = Vec3.init(1.0, 2.0, 3.0);
    const result = a.add(b);

    try std.testing.expect(@as(usize, @intFromFloat(result.x)) == 4);
    try std.testing.expect(@as(usize, @intFromFloat(result.y)) == 4);
    try std.testing.expect(@as(usize, @intFromFloat(result.z)) == 4);
}

test "Vec3.normalized" {
    const vec = Vec3.init(5000, 42, 123);
    const nlength = @round(vec.normalized().length());
    try std.testing.expectEqual(1, @as(usize, @intFromFloat(nlength)));
}
