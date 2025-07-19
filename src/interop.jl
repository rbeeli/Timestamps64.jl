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
@inline function _to_date_ns(ts::TimeSpec)
	date_sec = (ts.tv_sec ÷ 86400) * 86400
	1_000_000_000 * date_sec
end

"""
Calls clock_gettime from time.h using the CLOCK_REALTIME clock.

https://pubs.opengroup.org/onlinepubs/9699919799/functions/clock_gettime.html
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

"""
Returns the local time zone offset of a UNIX timestamp in seconds.

https://pubs.opengroup.org/onlinepubs/7908799/xsh/wcsftime.html
"""
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
	n == 0 && return 0 # unknown / not implemented time zone
	@assert n == 5 "Local time zone UTC offset string expected to be 5 characters, got $n"

	# convert e.g. "+0100" to 3600
	sign  = zstr[1] == Int32('+') ? 1 : -1
	hours = (zstr[2]-0x30)*10 + (zstr[3]-0x30)
	mins  = (zstr[4]-0x30)*10 + (zstr[5]-0x30)
	sign * (hours*3600 + mins*60)
end
