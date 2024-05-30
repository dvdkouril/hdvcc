const std = @import("std");

const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn origin() Vec3 {
        return Vec3{ 0.0, 0.0, 0.0 };
    }

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
       return Vec3.init(self.x + other.x,
                        self.y + other.y,
                        self.z + other.z);
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

    // inline vec3 cross(const vec3& u, const vec3& v) {
    //     return vec3(u.e[1] * v.e[2] - u.e[2] * v.e[1],
    //                 u.e[2] * v.e[0] - u.e[0] * v.e[2],
    //                 u.e[0] * v.e[1] - u.e[1] * v.e[0]);
    // }

    // inline vec3 unit_vector(const vec3& v) {
    //     return v / v.length();
    // }

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
        try writer.print("Vec3({}, {}, {})\n", .{self.x, self.y, self.z });
    }

};

const Point3 = Vec3;

pub fn main() !void {
    const image_width = 256;
    const image_height = 256;

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("P3\n{d} {d}\n255\n", .{ image_width, image_height });

    for (0..image_height) |j| {
        std.debug.print("\rScanlines remaining: {d}", .{image_height - j});

        for (0..image_width) |i| {
            const r = @as(f32, @floatFromInt(i)) / (image_width - 1);
            const g = @as(f32, @floatFromInt(j)) / (image_height - 1);
            const b: f32 = 0.0;

            const ir = @as(usize, @intFromFloat(255.999 * r));
            const ig = @as(usize, @intFromFloat(255.999 * g));
            const ib = @as(usize, @intFromFloat(255.999 * b));

            try stdout.print("{d} {d} {d}\n", .{ ir, ig, ib });
        }
    }

    std.debug.print("\rDone.    \n", .{});


    try bw.flush(); // don't forget to flush!

    const posA = Point3.init(3, 2, 1);
    const posB = Point3.init(1, 2, 3);
    const res = posA.add(posB);
    std.debug.print("res = {}", .{ res });
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

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
    // std.debug.print("{}\n {}", .{ vec, nlength });
    try std.testing.expectEqual(1, @as(usize, @intFromFloat(nlength)));
}
