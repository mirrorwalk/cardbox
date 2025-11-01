const std = @import("std");
pub const SDL = @cImport({
    @cInclude("SDL3/SDL.h");
    @cInclude("SDL3_ttf/SDL_ttf.h");
});

pub const Window = SDL.SDL_Window;
pub const Renderer = SDL.SDL_Renderer;
pub const Font = SDL.TTF_Font;
pub const Color = SDL.SDL_Color;
pub const Event = SDL.SDL_Event;
pub const FRect = SDL.SDL_FRect;

pub const EventTypes = enum {
    quit,
    mouse_moution,
    mouse_up,
    unknown,
};

pub fn sdlInit() !void {
    if (!SDL.SDL_Init(SDL.SDL_INIT_VIDEO)) {
        return error.SDLInitFailed;
    }
}

pub fn sdlQuit() void {
    SDL.SDL_Quit();
}

pub fn createWindow(title: []const u8, width: u16, height: u16) !*SDL.SDL_Window {
    const window = SDL.SDL_CreateWindow(@ptrCast(title), width, height, 0) orelse {
        return error.WindowCreationFailed;
    };
    return window;
}

pub fn destroyWindow(window: *SDL.SDL_Window) void {
    SDL.SDL_DestroyWindow(window);
}

pub fn createRenderer(window: *SDL.SDL_Window) !*SDL.SDL_Renderer {
    const renderer = SDL.SDL_CreateRenderer(window, null) orelse {
        return error.RendererCreationFailed;
    };
    return renderer;
}

pub fn delay(ms: u32) void {
    SDL.SDL_Delay(ms);
}

pub fn destroyRenderer(renderer: *SDL.SDL_Renderer) void {
    SDL.SDL_DestroyRenderer(renderer);
}

pub fn setRenderDrawColor(renderer: *SDL.SDL_Renderer, color: SDL.SDL_Color) void {
    _ = SDL.SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
}

pub fn renderClear(renderer: *SDL.SDL_Renderer) void {
    _ = SDL.SDL_RenderClear(renderer);
}

pub fn renderPresent(renderer: *SDL.SDL_Renderer) void {
    _ = SDL.SDL_RenderPresent(renderer);
}

pub fn pollEvent(event: *SDL.SDL_Event) bool {
    return SDL.SDL_PollEvent(event);
}

// pub fn createEvent() SDL.SDL_Event {
//     const event: SDL.SDL_Event = undefined;
//     return event;
// }

pub fn getEventType(event: *SDL.SDL_Event) EventTypes {
    switch (event.type) {
        SDL.SDL_EVENT_QUIT => return EventTypes.quit,
        SDL.SDL_EVENT_MOUSE_MOTION => return EventTypes.mouse_moution,
        SDL.SDL_EVENT_MOUSE_BUTTON_UP => return EventTypes.mouse_up,
        else => return EventTypes.unknown,
    }
}

pub fn ttfInit() !void {
    if (!SDL.TTF_Init()) {
        return error.TTFInitFailed;
    }
}

pub fn ttfQuit() void {
    SDL.TTF_Quit();
}

pub fn openFont(path: []const u8, size: f32) !*SDL.TTF_Font {
    const font = SDL.TTF_OpenFont(@ptrCast(path), size) orelse {
        return error.FontLoadFailed;
    };
    return font;
}

pub fn closeFont(font: *SDL.TTF_Font) void {
    SDL.TTF_CloseFont(font);
}

pub fn renderText(renderer: *SDL.SDL_Renderer, font: *SDL.TTF_Font, text: []const u8, x: f32, y: f32, red: u8, green: u8, blue: u8, alpha: u8) !void {
    const color = SDL.SDL_Color{ .r = red, .g = green, .b = blue, .a = alpha };
    const surface = SDL.TTF_RenderText_Solid(font, @ptrCast(text), text.len, color) orelse {
        return error.TextRenderFailed;
    };
    defer SDL.SDL_DestroySurface(surface);

    const texture = SDL.SDL_CreateTextureFromSurface(renderer, surface) orelse {
        return error.TextureCreationFailed;
    };
    defer SDL.SDL_DestroyTexture(texture);

    const dest_rect = SDL.SDL_FRect{ .x = x, .y = y, .w = @floatFromInt(surface.*.w), .h = @floatFromInt(surface.*.h) };
    _ = SDL.SDL_RenderTexture(renderer, texture, null, &dest_rect);
}

pub fn destroyAll(window: *SDL.SDL_Window, renderer: *SDL.SDL_Renderer) void {
    defer sdlQuit();
    defer ttfQuit();
    defer destroyWindow(window);
    defer destroyRenderer(renderer);
}

pub fn getStringSize(font: *SDL.TTF_Font, text: []const u8, width: *i32, height: *i32) void {
    var c_width: c_int = 0;
    var c_height: c_int = 0;

    _ = SDL.TTF_GetStringSize(font, @ptrCast(text), 0, &c_width, &c_height);

    width.* = @intCast(c_width);
    height.* = @intCast(c_height);
}

test "sdl" {
    try sdlInit();
    sdlQuit();
}

test "window" {
    try sdlInit();
    sdlQuit();

    const window = try createWindow("Window", 1920, 1080);
    destroyWindow(window);
}

test "renderer" {
    try sdlInit();
    sdlQuit();

    const window = try createWindow("Window", 1920, 1080);
    defer destroyWindow(window);

    const renderer = try createRenderer(window);
    defer destroyRenderer(renderer);
}

test "ttf" {
    try ttfInit();
    ttfQuit();
}

test "font" {
    try sdlInit();
    sdlQuit();

    try ttfInit();
    defer ttfQuit();

    const font = try openFont("/home/brog/projects/zig/cardbox/src/ttf/FiraSans-Regular.ttf", 12);
    defer closeFont(font);
}

test "render" {
    try sdlInit();
    defer sdlQuit();

    try ttfInit();
    defer ttfQuit();

    const font = try openFont("/home/brog/projects/zig/cardbox/src/ttf/FiraSans-Regular.ttf", 12);
    defer closeFont(font);

    const window = try createWindow("Window", 1920, 1080);
    defer destroyWindow(window);

    const renderer = try createRenderer(window);
    defer destroyRenderer(renderer);

    setRenderDrawColor(renderer, Color{ .r = 30, .g = 144, .b = 255, .a = 255 });
    renderClear(renderer);

    try renderText(renderer, font, "BIG TITLE", 400, 100, 255, 255, 255);

    renderPresent(renderer);

    delay(16);
}
