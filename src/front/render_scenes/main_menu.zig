const std = @import("std");
const render_scenes_utils = @import("render_scenes_utils.zig");
const font_utils = @import("../font_utils.zig");

const RenderScene = render_scenes_utils.RenderScene;
const Color = @import("../../utils/sdl.zig").Color;

pub fn getMainMenu(render_scene: *RenderScene, allocator: std.mem.Allocator) !void {
    render_scene.background_color = Color{ .r = 255, .g = 255, .b = 255, .a = 255 };

    const title_text = render_scenes_utils.Text{
        .color = Color{ .r = 0, .g = 0, .b = 0, .a = 255 },
        .text = "Hey",
        .x = 100,
        .y = 100,
        .font = .{ .name = font_utils.Fonts.fira_sans, .size = 72},
    };

    var renderable = render_scenes_utils.Renderable{
        .item = .{ .text = title_text },
        .z_index = 0,
    };

    try render_scene.renders.append(allocator, &renderable);
}
