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
};

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
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
