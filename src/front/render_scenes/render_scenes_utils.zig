const std = @import("std");
const main_menu = @import("main_menu.zig");

const Scenes = @import("../../back/back_utils.zig").Scenes;
const Color = @import("../../utils/sdl.zig").Color;

pub const RenderScene = struct {
    renders: std.ArrayList(Renderable) = std.ArrayList(Renderable).empty,
    background_color: Color,

    pub fn deinit(self: *RenderScene, allocator: std.mem.Allocator) void {
        self.renders.deinit(allocator);
    }
};

pub const Renderable = struct {
    item: RenderableItem,
    z_index: u8,
};

pub const RenderableItem = enum {
    Text,
};

pub fn getScene(scene: Scenes) RenderScene {
    var render_scene = RenderScene{
        .background_color = Color{ .r = 0, .g = 0, .b = 0, .a = 255 },
    };

    switch (scene) {
        .main_menu => {
            main_menu.getMainMenu(&render_scene);
        },
    }

    return render_scene;
}
