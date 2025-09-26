import Base.Libc: TmStruct

"""
https://www.gnu.org/software/libc/manual/html_node/Time-Types.html#index-struct-timespec
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
Converts the time.h timespec struct to a UNIX timestamp value in nanoseconds
with only the date component, the time component is set to 00:00:00.0
"""
@inline _to_date_ns(ts::TimeSpec) = 1_000_000_000 * (ts.tv_sec ÷ 86400) * 86400

"""
Cross-platform wrapper for getting current time with nanosecond precision.
Uses clock_gettime on Unix systems and Windows APIs on Windows.
"""
@inline function _clock_gettime()::TimeSpec
    @static if Sys.iswindows()
        return _clock_gettime_windows()
    else
        return _clock_gettime_unix()
    end
end

"""
Calls clock_gettime from time.h using the CLOCK_REALTIME clock.

https://pubs.opengroup.org/onlinepubs/9699919799/functions/clock_gettime.html
"""
@inline function _clock_gettime_unix()::TimeSpec
    ts = Ref(TimeSpec(0, 0))
    CLOCK_REALTIME = 0
    ret = ccall(:clock_gettime, Cint, (Cint, Ptr{TimeSpec}), CLOCK_REALTIME, ts)
    if ret != 0
        error("clock_gettime failed")
    end
    ts[]
end

"""
Windows implementation using GetSystemTimePreciseAsFileTime for high-precision UTC time.
Falls back to GetSystemTimeAsFileTime if the precise version is not available.

Returns time in the same TimeSpec format as the Unix version.
"""
@inline function _clock_gettime_windows()::TimeSpec
    # FILETIME structure: 64-bit value representing 100-nanosecond intervals since January 1, 1601 UTC
    filetime = Ref{UInt64}(0)

    # Try to use GetSystemTimePreciseAsFileTime (Windows 8+)
    # If it fails, fall back to GetSystemTimeAsFileTime
    try
        ccall((:GetSystemTimePreciseAsFileTime, "kernel32"), Cvoid, (Ptr{UInt64},), filetime)
    catch
        ccall((:GetSystemTimeAsFileTime, "kernel32"), Cvoid, (Ptr{UInt64},), filetime)
    end

    # Convert Windows FILETIME to Unix timestamp
    # FILETIME epoch: January 1, 1601 UTC
    # Unix epoch: January 1, 1970 UTC
    # Difference: 11644473600 seconds = 116444736000000000 * 100ns intervals
    windows_epoch_diff_100ns = 116444736000000000

    # Convert to Unix timestamp in 100-nanosecond intervals
    unix_100ns = filetime[] - windows_epoch_diff_100ns

    # Convert to seconds and nanoseconds
    tv_sec = unix_100ns ÷ 10_000_000  # 100ns intervals to seconds
    tv_nsec = (unix_100ns % 10_000_000) * 100  # remaining 100ns intervals to nanoseconds

    TimeSpec(tv_sec, tv_nsec)
end

# """
# Returns the local time zone offset of a UNIX timestamp in seconds.

# https://pubs.opengroup.org/onlinepubs/7908799/xsh/wcsftime.html
# """
# function _local_tz_offset_sec(utc_sec::Int64)::Int64
#     tm = TmStruct(utc_sec)

#     fmt = "%z"
#     zstr = Vector{Cwchar_t}(undef, 6)
#     # https://github.com/JuliaLang/julia/blob/9615af0f269df4d371b8010e9507ed5bae86103b/base/libc.jl#L231
#     n = ccall(
#         :wcsftime,
#         Csize_t,
#         (Ptr{Cwchar_t}, Csize_t, Cwstring, Ref{TmStruct}),
#         zstr,
#         length(zstr),
#         fmt,
#         tm,
#     )
#     n == 0 && return 0 # unknown / not implemented time zone
#     @assert n == 5 "Local time zone UTC offset string expected to be 5 characters, got $n"

#     # convert e.g. "+0100" to 3600
#     sign = zstr[1] == Int32('+') ? 1 : -1
#     hours = (zstr[2] - 0x30) * 10 + (zstr[3] - 0x30)
#     mins = (zstr[4] - 0x30) * 10 + (zstr[5] - 0x30)
#     sign * (hours * 3600 + mins * 60)
# end
