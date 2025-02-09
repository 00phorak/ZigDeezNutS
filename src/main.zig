const std = @import("std");
const expect = std.testing.expect;
const net = std.net;
const posix = std.posix;
const buf = @import("buffer.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{
        .safety = true,
    }){};
    const allocator = gpa.allocator();
    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) expect(false) catch @panic("TEST FAIL");
    }

    const addr = try net.Address.parseIp("127.0.0.1", 2048);
    const socket = try posix.socket(posix.AF.INET, posix.SOCK.DGRAM, posix.IPPROTO.UDP);
    defer posix.close(socket);

    try posix.bind(socket, &addr.any, addr.getOsSockLen());

    var bytePacketBuffer: buf.BytePacketBuffer = buf.BytePacketBuffer.new(allocator);
    // TODO: [1] trim and compare
    const exit = "exit\r\n";

    while (true) {
        // recv calls recvfrom anyways..
        const len = try posix.recvfrom(socket, &bytePacketBuffer.buf, 0, null, null);
        const input = bytePacketBuffer.buf[0..len];
        // TODO: [1] trim and compare
        if (std.mem.eql(u8, input, exit)) {
            return;
        }
        std.debug.print("{s}\n", .{bytePacketBuffer.buf[0..len]});
    }
}

// Test everything
comptime {
    std.testing.refAllDecls(@This());
}
