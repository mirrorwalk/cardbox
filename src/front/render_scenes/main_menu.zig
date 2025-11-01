const render_scenes_utils = @import("render_scenes_utils.zig");

const RenderScene = render_scenes_utils.RenderScene;
const Color = @import("../../utils/sdl.zig").Color;

pub fn getMainMenu(render_scene: *RenderScene) void {
    render_scene.background_color = Color{.r = 255, .g = 255, .b = 255, .a = 255};
}
