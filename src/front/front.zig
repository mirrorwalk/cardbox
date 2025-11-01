const sdl = @import("../utils/sdl.zig");
const front_utils = @import("front_utils.zig");
const render_scenes_utils = @import("render_scenes/render_scenes_utils.zig");

pub fn render(render_config: *const front_utils.RenderConfig, render_scene: *const render_scenes_utils.RenderScene) void {
    const renderer = render_config.renderer;
    const bg_color = render_scene.background_color;
    sdl.setRenderDrawColor(renderer, bg_color);
    sdl.renderClear(renderer);

    sdl.renderPresent(renderer);

    sdl.delay(16);
}

pub fn handleEvents() bool {
    var event: sdl.Event = undefined;
    while (sdl.pollEvent(&event)) {
        const evnt = sdl.getEventType(&event);
        if (evnt == sdl.EventTypes.quit) {
            return false;
        }
    }

    return true;
}
