const std = @import("std");
const linux = std.os.linux;

const Profile = enum {
    PowerSaver,
    Performance,
    Balanced,
    Unknown,

    fn parse(value: []const u8) @This() {
        return if (std.mem.eql(u8, value, "performance"))
            @This().Performance
        else if (std.mem.eql(u8, value, "power-saver"))
            @This().PowerSaver
        else if (std.mem.eql(u8, value, "balanced"))
            @This().Balanced
        else
            @This().Unknown;
    }

    fn print(profile: @This()) ?[:0]const u8 {
        return switch (profile) {
            @This().Performance => "performance",
            @This().PowerSaver => "power-saver",
            @This().Balanced => "balanced",
            @This().Unknown => null,
        };
    }

    fn repr(profile: @This()) [:0]const u8 {
        return switch (profile) {
            @This().Performance => "performance",
            @This().PowerSaver => "power-saver",
            @This().Balanced => "balanced",
            @This().Unknown => "unknown",
        };
    }

    const MAX_LEN = len: {
        var max = 0;
        for (@typeInfo(@This()).@"enum".fields) |field| {
            const name = @This().repr(@enumFromInt(field.value));
            max = @max(max, name.len);
        }
        break :len max;
    };
};

var ppc: [:0]const u8 = undefined;
var envp: [*:null]const ?[*:0]const u8 = undefined;
var battery: linux.fd_t = undefined;
var socket: linux.fd_t = undefined;
var state: ?Profile = null;
var stop: bool = false;

pub fn main(init: std.process.Init.Minimal) u8 {
    const ret = entrypoint(
        init.args.vector,
        init.environ.block.slice,
    ) catch |err| exit(fromError(err));
    return ret;
}

pub fn entrypoint(
    args: []const [*:0]const u8,
    environ: [*:null]const ?[*:0]const u8,
) !u8 {
    envp = environ;

    if (args.len != 4) {
        try writeAll(
            2,
            "usage: auto-ppd [ppc-path] [battery-path] [socket-path]\n",
        );
        return 1;
    }

    // signals
    {
        const StopHandler = struct {
            fn handler(sig: linux.SIG) callconv(.c) void {
                _ = sig;
                stop = true;
            }
        };
        const action: linux.Sigaction = .{
            .handler = .{.handler = StopHandler.handler},
            .mask = std.os.linux.sigemptyset(),
            .flags = 0,
        };
        _ = try errno(linux.sigaction(linux.SIG.INT, &action, null));
        _ = try errno(linux.sigaction(linux.SIG.TERM, &action, null));
    }

    ppc = std.mem.span(args[1]);

    battery = battery: {
        const path = args[2];
        const bat = try errno(
            linux.open(path, .{ .CLOEXEC = true }, 0),
        );
        errdefer _ = errno(linux.close(bat)) catch {};
        break :battery @intCast(bat);
    };
    defer _ = errno(linux.close(battery)) catch {};

    const sock_path, socket = socket: {
        const sock: linux.fd_t = @intCast(
            try errno(linux.socket(linux.AF.UNIX, linux.SOCK.STREAM, 0)),
        );
        errdefer _ = errno(linux.close(sock)) catch {};

        const path = args[3];
        var addr = linux.sockaddr.un{ .path = undefined };
        @memcpy(&addr.path, path);
        const len = @sizeOf(@TypeOf(addr.family)) + std.mem.len(path);
        _ = try errno(linux.bind(sock, @ptrCast(&addr), @intCast(len)));
        errdefer _ = errno(linux.unlink(path)) catch {};

        _ = try errno(linux.chmod(path, 0o777));
        const flags = linux.O{ .CLOEXEC = true, .NONBLOCK = true };
        _ = try errno(
            linux.fcntl(sock, linux.F.SETFL, @as(u32, @bitCast(flags))),
        );
        _ = try errno(linux.listen(sock, 1));

        break :socket .{ path, sock };
    };
    defer _ = errno(linux.unlink(sock_path)) catch {};
    defer _ = errno(linux.close(socket)) catch {};

    try loop();
    return 0;
}

fn loop() !void {
    var poll_fds: [1]linux.pollfd = .{.{
        .fd = socket,
        .events = linux.POLL.IN | linux.POLL.PRI,
        .revents = 0,
    }};
    var polled: usize = 0;

    while (!stop) {
        const ppc_info = getProfilePre() catch ppc_info: {
            _ = writeAll(
                2,
                "starting powerprofilesctl failed\n",
            ) catch {};
            break :ppc_info null;
        };

        if (polled > 0) {
            handleConnection() catch {
                _ = writeAll(
                    2,
                    "connection failed\n",
                ) catch {};
            };
        }

        const new_profile = state orelse autoState() catch new_profile: {
            _ = writeAll(
                2,
                "reading battery failed\n",
            ) catch {};
            break :new_profile .Unknown;
        };

        const cur_profile = if (ppc_info) |info|
            getProfile(info) catch cur_profile: {
                _ = writeAll(
                    2,
                    "getting powerprofilesctl output failed\n",
                ) catch {};
                break :cur_profile .Unknown;
            }
        else
            .Unknown;

        setProfile(new_profile, cur_profile) catch {
            _ = writeAll(
                2,
                "failed to set new profile\n",
            ) catch {};
        };

        polled = errno(
            linux.poll(&poll_fds, poll_fds.len, 1000 * 60),
        ) catch polled: {
            _ = writeAll(
                2,
                "poll failed\n",
            ) catch {};
            break :polled 0;
        };
    }
}

fn handleConnection() !void {
    while (true) {
        const fd: linux.fd_t = @intCast(errno(
            linux.accept(socket, null, null),
        ) catch |err| switch (fromError(err)) {
            .AGAIN => return, // EAGAIN == EWOULDBLOCK
            else => |e| return toError(e),
        });
        defer _ = errno(linux.close(fd)) catch {};

        var buf: [Profile.MAX_LEN + 1]u8 = undefined;
        const data = data: {
            var iovec: [1]std.posix.iovec = .{
                .{ .base = &buf, .len = buf.len },
            };
            var msg: linux.msghdr = .{
                .name = null,
                .namelen = 0,
                .iov = &iovec,
                .iovlen = iovec.len,
                .control = null,
                .controllen = 0,
                .flags = 0,
            };
            const len = try errno(linux.recvmsg(fd, &msg, linux.MSG.WAITALL));
            const data = trimTrailingNewline(buf[0..len]) orelse {
                _ = writeAll(
                    2,
                    "invalid data from client\n",
                ) catch {};
                continue;
            };
            break :data data;
        };

        const profile = if (std.mem.eql(u8, data, "auto"))
            null
        else
            Profile.parse(data);
        if (profile == .Unknown) {
            _ = writeAll(
                2,
                "invalid profile from client\n",
            ) catch {};
            continue;
        }

        if (profile == state) {
            _ = writeAll(
                2,
                "default profile unchanged\n",
            ) catch {};
            continue;
        }

        state = profile;
        _ = writeAll(
            2,
            "default profile changed\n",
        ) catch {};
    }
}

fn autoState() !Profile {
    var buf: [4]u8 = undefined;
    _ = try errno(linux.lseek(battery, 0, linux.SEEK.SET));
    const data = trimTrailingNewline(try readAll(battery, &buf)) orelse {
        _ = writeAll(
            2,
            "invalid data from battery\n",
        ) catch {};
        return .Unknown;
    };

    const bat = std.fmt.parseUnsigned(u8, data, 10) catch {
        _ = writeAll(
            2,
            "failed to parse battery\n",
        ) catch {};
        return .Unknown;
    };

    return if (bat > 50) .Balanced else .PowerSaver;
}

const PPCInfo = struct {
    pid: linux.pid_t,
    fd: linux.fd_t,
};

fn getProfilePre() !PPCInfo {
    const read, const write = fds: {
        var fds: [2]i32 = undefined;
        _ = try errno(linux.pipe(&fds));
        break :fds fds;
    };
    defer _ = errno(linux.close(write)) catch {};
    errdefer _ = errno(linux.close(read)) catch {};

    const pid = try fork();
    if (pid == 0) {
        _ = try errno(linux.dup2(write, 1));
        const args: [2:null]?[*:0]const u8 = .{ "powerprofilesctl", "get" };
        try exec(ppc, &args);
        comptime unreachable;
    }

    return .{ .pid = pid, .fd = read };
}

fn getProfile(info: PPCInfo) !Profile {
    defer _ = errno(linux.close(info.fd)) catch {};

    const status = try wait(info.pid);

    if (status.exit_status != 0) {
        _ = writeAll(
            2,
            "getting profile failed\n",
        ) catch {};
        return .Unknown;
    }

    var buf: [Profile.MAX_LEN + 1]u8 = undefined;
    const data = trimTrailingNewline(try readAll(info.fd, &buf)) orelse {
        _ = writeAll(
            2,
            "invalid data from ppc\n",
        ) catch {};
        return .Unknown;
    };

    return Profile.parse(data);
}

fn setProfile(new: Profile, cur: Profile) !void {
    const profile = if (new == .Unknown or cur == .Unknown or new == cur)
        null
    else
        new.print();

    if (profile) |p| {
        _ = writeAll(
            2,
            msg: {
                const pre: []const u8 = comptime "setting profile to: ";
                var buf: [pre.len + Profile.MAX_LEN + 1]u8 = undefined;
                @memmove(buf[0..pre.len], pre);
                @memmove(buf[pre.len .. pre.len + p.len], p);
                buf[pre.len + p.len] = '\n';
                break :msg buf[0 .. pre.len + p.len + 1];
            },
        ) catch {};

        const pid = try fork();
        if (pid == 0) {
            const args: [3:null]?[*:0]const u8 = .{ "powerprofilesctl", "set", p };
            try exec(ppc, &args);
            comptime unreachable;
        }

        const status = try wait(pid);

        if (status.exit_status != 0) {
            _ = writeAll(
                2,
                "setting profile failed\n",
            ) catch {};
            return;
        }
    }
}

inline fn errno(value: usize) !usize {
    const err = linux.errno(value);
    return switch (err) {
        .SUCCESS => value,
        else => |e| @errorFromInt(@intFromEnum(e)),
    };
}

inline fn fromError(err: anyerror) linux.E {
    return @enumFromInt(@intFromError(err));
}

inline fn toError(err: linux.E) anyerror {
    return @errorFromInt(@intFromEnum(err));
}

inline fn exit(err: linux.E) noreturn {
    linux.exit(-%@intFromEnum(err));
}

fn writeAll(fd: linux.fd_t, buf: []const u8) !void {
    var remaining = buf;
    while (remaining.len > 0) {
        const len = try errno(linux.write(fd, remaining.ptr, remaining.len));
        remaining = remaining[len..];
    }
}

fn readAll(fd: linux.fd_t, buf: []u8) ![]u8 {
    var read: usize = 0;
    while (read < buf.len) {
        const remaining = buf[read..];
        const len = try errno(linux.read(fd, remaining.ptr, remaining.len));
        if (len == 0) break;
        read += len;
    }
    return buf[0..read];
}

inline fn fork() !linux.pid_t {
    const pid = try errno(linux.fork());
    return @intCast(pid);
}

inline fn exec(
    path: [*:0]const u8,
    argv: [*:null]const ?[*:0]const u8,
) !noreturn {
    _ = try errno(linux.execve(path, argv, envp));
    unreachable;
}

fn wait(pid: linux.pid_t) !struct {
    exit_status: u8,
    if_exited: bool,
    if_signaled: bool,
    if_stopped: bool,
    stop_sig: linux.SIG,
    term_sig: linux.SIG,
} {
    var status: u32 = undefined;
    _ = try errno(linux.waitpid(pid, &status, 0));
    return .{
        .exit_status = linux.W.EXITSTATUS(status),
        .if_exited = linux.W.IFEXITED(status),
        .if_signaled = linux.W.IFSIGNALED(status),
        .if_stopped = linux.W.IFSTOPPED(status),
        .stop_sig = linux.W.STOPSIG(status),
        .term_sig = linux.W.TERMSIG(status),
    };
}

fn trimTrailingNewline(buf: []const u8) ?[]const u8 {
    if (buf.len == 0 or buf[buf.len - 1] != '\n')
        return null;
    return buf[0 .. buf.len - 1];
}
