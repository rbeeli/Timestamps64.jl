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
@inline function _to_date_ns(ts::TimeSpec)
    date_sec = (ts.tv_sec ÷ 86400) * 86400
    1_000_000_000 * date_sec
end

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
