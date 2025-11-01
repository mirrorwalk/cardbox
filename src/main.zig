const std = @import("std");
const back_utils = @import("back/back_utils.zig");
const front = @import("front/front.zig");
const front_utils = @import("front/front_utils.zig");

pub fn main() !void {
    std.debug.print("Batman\n", .{});

    var game_status = back_utils.getGameStatus();

    var front_config = try front_utils.init();
    defer front_utils.deinit(&front_config);

    while (game_status.running) {
        game_status.running = front.render(&front_config.render);
    }
}
