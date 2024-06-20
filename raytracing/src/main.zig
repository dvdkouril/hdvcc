const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

const Point3 = Vec3;
const Color = Vec3;

const Ray = struct {
    origin: Point3,
    direction: Vec3,

    pub fn init(origin: Point3, direction: Vec3) Ray {
        return Ray{ .origin = origin, .direction = direction };
    }

    pub fn at(self: Ray, t: f32) Point3 {
        return self.origin.add(self.direction.scaled(t));
    }
};

fn writeColor(writer: anytype, color: Color) !void {
    const r = color.x;
    const g = color.y;
    const b = color.z;

    const ir: usize = @intFromFloat(255.999 * r);
    const ig: usize = @intFromFloat(255.999 * g);
    const ib: usize = @intFromFloat(255.999 * b);

    try writer.print("{d} {d} {d}\n", .{ ir, ig, ib });
}

pub fn main() !void {

    // Image

    const aspect_ratio = 16.0 / 9.0;
    const image_width = 400;
    // // Calculate the image height, and ensure that it's at least 1.
    const image_height: comptime_int = comptime @intFromFloat(@as(f64, @floatFromInt(image_width)) / aspect_ratio);

    // Camera

    // Viewport widths less than one are ok since they are real valued.
    const viewport_height: f64 = 2.0;
    const viewport_width: f64 = viewport_height * (@as(f64, @floatFromInt(image_width)) / image_height);
    const camera_center = Point3.origin();

    // Calculate the vectors across the horizontal and down
    // the vertical viewport edges.

    // Calculate the vectors across the horizontal and down the vertical viewport edges.
    const viewport_u = Vec3.init(viewport_width, 0, 0);
    const viewport_v = Vec3.init(0, -viewport_height, 0);

    // Calculate the horizontal and vertical delta vectors from pixel to pixel.
    const pixel_delta_u = viewport_u.scaled(1.0 / image_width);
    const pixel_delta_v = viewport_v.scaled(1.0 / image_height);

    // Calculate the location of the upper left pixel.
    const viewport_upper_left = camera_center
        .sub(Vec3.init(0, 0, focal_length))
        .sub(viewport_u.scaled(1.0 / 2.0))
        .sub(viewport_v.scaled(1.0 / 2.0));

    const pixel00_loc = viewport_upper_left.add(Vec3.add(pixel_delta_u, pixel_delta_v).scaled(0.5));

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
            const ifloat = @as(f32, @floatFromInt(i));
            const jfloat = @as(f32, @floatFromInt(j));
            const r = ifloat / (image_width - 1);
            const g = ifloat / (image_height - 1);
            const b: f32 = 0.0;
            const pixel_color = Color.init(r, g, b);

            const pixel_center = pixel00_loc.add(
                Vec3.add(pixel_delta_u.scaled(ifloat),
                Vec3.add(pixel_delta_v.scaled(jfloat))
            );

            const ray_direction = pixel_center.sub(camera_center);
            const ray = Ray.init(camera_center, ray_direction);
            const pixel_color = ray_color(ray);

            try writeColor(stdout, pixel_color);
        }
    }

    std.debug.print("\rDone.    \n", .{});

    try bw.flush(); // don't forget to flush!

    const posA = Point3.init(3, 2, 1);
    const posB = Point3.init(1, 2, 3);
    const res = posA.add(posB);
    std.debug.print("res = {}", .{res});
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "Ray.at" {
    // 0, 0, 0 direciton is 1, 0, 0 t =  5, 5, 0, 0
    const ray = Ray.init(
        Vec3.origin(),
        Point3.init(1, 0, 0),
    );
    const point = ray.at(5);
    try std.testing.expectEqual(5, @as(usize, @intFromFloat(point.x)));
    try std.testing.expectEqual(0, @as(usize, @intFromFloat(point.y)));
    try std.testing.expectEqual(0, @as(usize, @intFromFloat(point.z)));
}
