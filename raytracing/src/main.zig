const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    // std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

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

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
