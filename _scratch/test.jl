using Dates: Dates
import Base.Libc: TmStruct

"""
    Dates.today(Timestamp64)  → midnight UTC, nanosecond granularity
"""
struct TimeSpec
    tv_sec::Int64   # seconds
    tv_nsec::Int64  # nanoseconds
end

"""
Converts the time.h timespec struct to a UNIX timestamp value in nanoseconds.
"""
@inline _to_unix_ns(ts::TimeSpec) = 1_000_000_000 * ts.tv_sec + ts.tv_nsec

"""
Calls clock_gettime from time.h using the CLOCK_REALTIME clock.
"""
function _clock_gettime()::TimeSpec
    ts = Ref(TimeSpec(0, 0))
    CLOCK_REALTIME = 0
    ret = ccall(:clock_gettime, Cint, (Cint, Ptr{TimeSpec}), CLOCK_REALTIME, ts)
    if ret != 0
        error("clock_gettime failed")
    end
    ts[]
end

# ---

"""
Accurate local wall-clock nanoseconds using libc (Julia >= 1.9)
"""
@inline function _local_offset_sec(utc_sec::Int64)::Int64
    tm = TmStruct(utc_sec) # broken‑down LOCAL time for that instant

    # mktime interprets `tm` as local and returns the corresponding epoch seconds (UTC)
    loc_sec = ccall(:mktime, Int64, (Ref{TmStruct},), tm)

    loc_sec - utc_sec                   # signed offset (includes DST)
end

"""
    Dates.now(Timestamp64)  → UTC, nanosecond precision
"""
@inline function now2()
    ns_utc = _to_unix_ns(_clock_gettime())                # raw UTC nanoseconds
    ns_off = _local_offset_sec(ns_utc ÷ 1_000_000_000) * 1_000_000_000
    ns_utc + ns_off
end

"""
	Dates.now(Timestamp64, UTC)  → nanoseconds UTC  (unchanged)
"""
@inline Dates.now(::Type{Timestamp64}, ::Type{Dates.UTC}) =
    Timestamp64(_to_unix_ns(_clock_gettime()))

"""
    Dates.today(Timestamp64)  → midnight UTC, nanosecond granularity
"""
@inline function Dates.today(::Type{Timestamp64})
    ns_local = Dates.now(Timestamp64).ts
    Timestamp64((ns_local ÷ 86_400_000_000_000) * 86_400_000_000_000)
end

import Base.Libc: TmStruct, strftime

@inline function _local_offset_sec2(utc_sec::Int64)::Int64
    tm = TmStruct(utc_sec)                 # local broken‑down time for that instant
    z = strftime("%z", tm)                # "+0200", "-0700", etc.

    sign = z[1] == '+' ? 1 : -1
    hours = parse(Int, z[2:3])
    mins = parse(Int, z[4:5])

    sign * (hours * 3600 + mins * 60)          # seconds east of UTC
end

function _local_tz_offset_sec(utc_sec::Int64)::Int64
    tm = TmStruct(utc_sec)

    fmt = "%z"
    zstr = Vector{Cwchar_t}(undef, 6)
    n = ccall(
        :wcsftime,
        Csize_t,
        (Ptr{Cwchar_t}, Csize_t, Cwstring, Ref{TmStruct}),
        zstr,
        length(zstr),
        fmt,
        tm,
    )
    n == 0 && return 0 # unknown / not implemented
    @assert n == 5 "Local time zone UTC offset string expected to be 5 characters, got $n"

    # convert e.g. "+0100" to 3600
    sign = zstr[1] == Int32('+') ? 1 : -1
    hours = (zstr[2] - 0x30) * 10 + (zstr[3] - 0x30)
    mins = (zstr[4] - 0x30) * 10 + (zstr[5] - 0x30)
    sign * (hours * 3600 + mins * 60)
end

using BenchmarkTools

@benchmark _local_offset_sec(10000000000)

@benchmark _local_offset_sec2(10000000000)

import Base.Libc: TmStruct

utc_sec = 10000000000
tm = TmStruct(utc_sec)
tm.isdst = -1
ccall(:mktime, Int, (Ref{TmStruct},), tm)

ccall(:gmtime_r, Ptr{TmStruct}, (Ref{Int}, Ref{TmStruct}), utc_sec, tm)

using Base.Libc: TmStruct

"""
    utc_offset(t::Integer) -> Int

Offset of the local civil time zone from UTC at Unix time `t`,
expressed in seconds **east** of UTC (e.g. `+3600` for UTC+1).

Only `gmtime_r` and `mktime` are used, so the result depends on
whatever time zone database your process is currently using
(`ENV["TZ"]` + `/etc/localtime` on Unix).
"""
function _local_tz_offset_sec(utc_sec::Integer)::Int
    # break the timestamp down *UTC*
    tm = TmStruct()
    ccall(
        :gmtime_r,
        Ptr{TmStruct},
        (Ref{Int}, Ref{TmStruct}),
        utc_sec, # time_t *
        tm,  # struct tm *
    )

    # tell mktime() to decide whether DST applies
    tm.isdst = -1
    local_tt = ccall(:mktime, Int, (Ref{TmStruct},), tm)
    local_tt == -1 && error("mktime failed (timestamp out of range)")

    # calc time zone offset (seconds east of UTC)
    Int(utc_sec - local_tt)
end

function _local_tz_offset_sec2(utc_sec::Int)::Int
    tm = TmStruct(utc_sec)

    fmt = "%z"
    zstr = Vector{Cchar}(undef, 6)
    n = ccall(
        :strftime,
        Csize_t,
        (Ptr{Cchar}, Csize_t, Cstring, Ref{TmStruct}),
        zstr,
        length(zstr),
        fmt,
        tm,
    )
    n == 0 && return 0 # unknown / not implemented
    @assert n == 5 "Local time zone UTC offset string expected to be 5 characters, got $n"

    # convert e.g. "+0100" to 3600
    sign = zstr[1] == Int32('+') ? 1 : -1
    hours = (zstr[2] - 0x30) * 10 + (zstr[3] - 0x30)
    mins = (zstr[4] - 0x30) * 10 + (zstr[5] - 0x30)
    sign * (hours * 3600 + mins * 60)
end

_local_tz_offset_sec(10000000000)

_local_tz_offset_sec2(10000000000)

using BenchmarkTools

@benchmark _local_tz_offset_sec($10000000000)

@benchmark _local_tz_offset_sec2($10000000000)

using Base.Libc: TmStruct

@inline function _timegm(tm::TmStruct)::Int
    # matches https://github.com/pts/minilibc686/blob/master/fyi/c_timegm.c
    y = tm.year - 100
    yday = tm.yday
    month = 0

    if yday < 0
        month = tm.month + 1
        if month <= 2
            y -= 1
            month += 12
        end
        yday = (153 * month + 3) ÷ 5 + tm.mday - 399
    else
        y -= 1
    end

    y4 = y >> 2
    y100 = y4 ÷ 25
    if rem(y4, 25) < 0
        y100 -= 1
    end

    days = 365 * y + y4 - y100 + (y100 >> 2) + (yday + 11_323)
    days * 86_400 + (tm.hour * 60 + tm.min) * 60 + tm.sec
end

"""
    _local_tz_offset_sec(ts::Integer) -> Int

Signed UTC offset (seconds east of UTC) for UNIX timestamp `ts`.
"""
function _local_tz_offset_sec(ts::Integer)::Int
    tm = TmStruct() # zero‑filled
    ccall(:localtime_r, Ptr{TmStruct}, (Ref{Int}, Ref{TmStruct}), ts, tm)
    _timegm(tm) - ts
end

using TimeZones, Dates

zdt_utc = ZonedDateTime(2014, 6, 1, tz"UTC")
zdt_loc = astimezone(zdt_utc, tz"Europe/Zurich")

Dates.value(zdt_utc.zone.offset) # 0
Dates.value(zdt_loc.zone.offset) # 7200

unix_sec = TimeZones.zdt2unix(Int64, zdt_utc) # 1401580800
_local_tz_offset_sec(unix_sec) # 7200

# ---

_local_tz_offset_sec(10000000000)

@benchmark _local_tz_offset_sec($unix_sec)

function unix2datetime_local(t::Real)
    s = floor(t)
    ms = (t - s) * 1000
    DateTime(Libc.TmStruct(s)) + Millisecond(round(Int, ms))
end

@benchmark unix2datetime_local($unix_sec)
