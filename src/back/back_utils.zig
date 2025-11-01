const GameStatus = struct {
    running: bool = true,
    active_scene: Scenes,
};

pub const Scenes = enum { main_menu };

pub fn getGameStatus() GameStatus {
    return GameStatus{
        .active_scene = Scenes.main_menu,
    };
}
