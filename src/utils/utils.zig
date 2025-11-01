const std = @import("std");

pub fn getExeFolder(allocator: std.mem.Allocator) ![]u8 {
    const exe_dir_path = try std.fs.selfExeDirPathAlloc(allocator);
    return exe_dir_path;
}

pub fn joinPath(allocator: std.mem.Allocator, paths: []const []const u8) ![]u8 {
    const font_path = try std.fs.path.join(allocator, paths);
    return font_path;
}
