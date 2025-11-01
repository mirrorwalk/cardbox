const sdl = @import("../utils/sdl.zig");
const front_utils = @import("front_utils.zig");

pub fn render(render_config: *const front_utils.RenderConfig) bool {
    var event: sdl.Event = undefined;
    while (sdl.pollEvent(&event)) {
        const evnt = sdl.getEventType(&event);
        if (evnt == sdl.EventTypes.quit) {
            return false;
        }
    }

    sdl.setRenderDrawColor(render_config.renderer, render_config.background_color);
    sdl.renderClear(render_config.renderer);

    sdl.renderPresent(render_config.renderer);

    sdl.delay(16);

    return true;
}
