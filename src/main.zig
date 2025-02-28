pub fn main() !void {
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}

pub const SingleSuitTiles = struct {
    tiles: [9]u3,

    pub fn is_winning(hand: @This(), sets_left: usize) bool {
        if (sets_left == 0) {
            var pairs_found: usize = 0;
            for (hand.tiles) |num_tiles| {
                if (num_tiles == 2) pairs_found += 1;
            }
            return pairs_found == 1;
        }

        for (hand.tiles, 0..) |num_tiles, i| {
            if (num_tiles >= 3) {
                var new_hand = hand;
                new_hand.tiles[i] -= 3;
                if (new_hand.is_winning(sets_left - 1)) return true;
            }
            if (i <= hand.tiles.len - 3 and num_tiles >= 1 and hand.tiles[i + 1] >= 1 and hand.tiles[i + 2] >= 1) {
                var new_hand = hand;
                new_hand.tiles[i] -= 1;
                new_hand.tiles[i + 1] -= 1;
                new_hand.tiles[i + 2] -= 1;
                if (new_hand.is_winning(sets_left - 1)) return true;
            }
        }
        return false;
    }
};
test "single suit" {
    const hand1: SingleSuitTiles = .{
        .tiles = .{ 1, 1, 2, 1, 3, 1, 2, 2, 1 },
    };
    try std.testing.expect(hand1.is_winning(4));
    const hand2: SingleSuitTiles = .{
        .tiles = .{ 4, 4, 3, 0, 2, 0, 0, 0, 1 },
    };
    try std.testing.expect(!hand2.is_winning(4));
}

const std = @import("std");
