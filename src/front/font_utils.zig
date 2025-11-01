const std = @import("std");
const utils = @import("../utils/utils.zig");
const sdl = @import("../utils/sdl.zig");

pub const FontConfig = struct {
    name: Fonts,
    size: f32,
};

pub const Fonts = enum {
    fira_sans,
};

pub const FontPaths = struct {
    fira_sans: []const u8 = "FiraSans-Regular.ttf",
};

pub fn openFont(
    font: Fonts,
    size: f32,
    open_fonts: *std.ArrayList(*sdl.Font),
    font_paths: *const FontPaths,
    allocator: std.mem.Allocator,
) !*sdl.Font {
    const font_path = try getFontPath(font, font_paths, allocator);
    defer allocator.free(font_path);

    const open_font = try sdl.openFont(font_path, size);

    try open_fonts.append(allocator, open_font);

    return open_font;
}

pub fn getFontPath(what_font: Fonts, font_paths: *const FontPaths, allocator: std.mem.Allocator) ![]const u8 {
    const exe_folder = try utils.getExeFolder(allocator);
    defer allocator.free(exe_folder);
    switch (what_font) {
        Fonts.fira_sans => {
            return try utils.joinPath(allocator, &.{ exe_folder, "ttf", font_paths.fira_sans });
        },
    }
}
