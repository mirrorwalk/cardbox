const std = @import("std");
const sdl = @import("../utils/sdl.zig");
const render_scenes_utils = @import("render_scenes/render_scenes_utils.zig");

const Scenes = @import("../back/back_utils.zig").Scenes;

const FrontConfig = struct {
    window: WindowConfig,
    render: RenderConfig,
    render_scene: render_scenes_utils.RenderScene,

    pub fn deinit(self: *FrontConfig, allocator: std.mem.Allocator) void {
        defer sdl.sdlQuit();

        defer sdl.ttfQuit();

        defer sdl.destroyWindow(self.window.window);

        defer sdl.destroyRenderer(self.render.renderer);

        defer self.render_scene.deinit(allocator);
    }
};

const WindowConfig = struct {
    window: *sdl.Window,
    dimensions: WindowDimensions,
};

const WindowDimensions = struct {
    width: u16,
    height: u16,
};

pub const RenderConfig = struct {
    renderer: *sdl.Renderer,
    background_color: sdl.Color,
};

pub fn init() !FrontConfig {
    try sdl.sdlInit();

    try sdl.ttfInit();
    errdefer sdl.sdlQuit();

    const window_dimensions = WindowDimensions{
        .width = 960,
        .height = 540,
    };

    const window = try sdl.createWindow(
        "Window",
        window_dimensions.width,
        window_dimensions.height,
    );
    errdefer {
        sdl.ttfQuit();
        sdl.sdlQuit();
    }

    const renderer = try sdl.createRenderer(window);
    errdefer {
        sdl.destroyWindow(window);
        sdl.ttfQuit();
        sdl.sdlQuit();
    }

    const window_config = WindowConfig{
        .window = window,
        .dimensions = window_dimensions,
    };

    const render_config = RenderConfig{
        .background_color = sdl.Color{ .r = 0, .g = 0, .b = 0, .a = 255 },
        .renderer = renderer,
    };

    const scene = render_scenes_utils.getScene(Scenes.main_menu);

    const front_config = FrontConfig{
        .window = window_config,
        .render = render_config,
        .render_scene = scene,
    };

    return front_config;
}
