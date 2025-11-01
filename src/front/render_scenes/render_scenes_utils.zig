const std = @import("std");
const main_menu = @import("main_menu.zig");
const sdl = @import("../../utils/sdl.zig");
const font_config = @import("../font_utils.zig");

const Color = sdl.Color;
const Scenes = @import("../../back/back_utils.zig").Scenes;

pub const RenderScene = struct {
    renders: std.ArrayList(*Renderable) = std.ArrayList(*Renderable).empty,
    background_color: Color = Color{ .r = 0, .g = 0, .b = 0, .a = 255 },
    open_fonts: std.ArrayList(*sdl.Font) = std.ArrayList(*sdl.Font).empty,

    pub fn deinit(self: *RenderScene, allocator: std.mem.Allocator) void {
        self.renders.deinit(allocator);
        self.open_fonts.deinit(allocator);
    }

    pub fn clear(self: *RenderScene, allocator: std.mem.Allocator) void {
        self.renders.clearAndFree(allocator);
        self.open_fonts.clearAndFree(allocator);
    }
};

pub const Renderable = struct {
    item: RenderableItem,
    z_index: u8 = 0,
};

pub const Text = struct {
    text: []const u8,
    // font: *sdl.Font,
    font: font_config.FontConfig,
    x: f32,
    y: f32,
    color: Color,
};

pub const RenderableItem = union(enum) {
    text: Text,
};

pub fn getRenderScene() RenderScene {
    return RenderScene{};
}

pub fn changeScene(render_scene: *RenderScene, scene: Scenes, allocator: std.mem.Allocator) !void {
    render_scene.clear(allocator);

    switch (scene) {
        .main_menu => {
            try main_menu.getMainMenu(render_scene, allocator);
        },
    }
}
