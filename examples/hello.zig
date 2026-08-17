const std = @import("std");
const greeting = @import("greeting.zig");

pub fn main() !void {
    std.debug.print("{s}\n", .{greeting.message()});
}
