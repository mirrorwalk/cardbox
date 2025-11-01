const std = @import("std");
const back_utils = @import("back/back_utils.zig");
const front = @import("front/front.zig");
const front_utils = @import("front/front_utils.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var game_status = back_utils.getGameStatus();

    var front_config = try front_utils.init(allocator);
    defer front_config.deinit(allocator);

    while (game_status.running) {
        game_status.running = front.handleEvents();
        front.render(&front_config.render, &front_config.render_scene);
    }
}
