using Dates
using Timestamps64
using BenchmarkTools

@inline function _write2!(p::Ptr{UInt8}, x::UInt)  # 00 - 99
    unsafe_store!(p, 0x30 + (x ÷ 10))      # ‐‐> ‘0’ + tens
    unsafe_store!(p + 1, 0x30 + (x % 10))  # ‐‐> ‘0’ + ones
end

@inline function _write4!(p::Ptr{UInt8}, x::UInt)  # 0000 - 9999
    unsafe_store!(p, 0x30 + (x ÷ 1000))
    unsafe_store!(p + 1, 0x30 + (x ÷ 100 % 10))
    unsafe_store!(p + 2, 0x30 + (x ÷ 10 % 10))
    unsafe_store!(p + 3, 0x30 + x % 10)
end

@inline function _write9!(p::Ptr{UInt8}, x::UInt)  # 000_000_000 - 999_999_999
    @inbounds for k in 8:-1:0
        d = x % 10
        unsafe_store!(p + k, 0x30 + d)
        x ÷= 10
    end
    nothing
end

"""
    iso8601(ts::Timestamp64) -> ::String

Formats the timestamp as valid ISO 8601 nano string.
Note that no trailing 'Z' character is returned.
"""
function iso86012(ts::Timestamp64)
    base = "0000-00-00T00:00:00.000000000" # 29 chars

    GC.@preserve base begin
        ptr = pointer(base)

        # write date
        y, m, d = Dates.yearmonthday(ts)
        _write4!(ptr, UInt(y))
        _write2!(ptr + 5, UInt(m))
        _write2!(ptr + 8, UInt(d))

        # write time
        _write2!(ptr + 11, UInt(Dates.hour(ts)))
        _write2!(ptr + 14, UInt(Dates.minute(ts)))
        _write2!(ptr + 17, UInt(Dates.second(ts)))
        _write9!(ptr + 20, UInt(Dates.nanosecond(ts)))
    end

    base
end

const ts = now(Timestamp64)

@time iso8601(ts)
@time iso86012(ts)

@benchmark iso8601($ts)
@benchmark iso86012($ts)
