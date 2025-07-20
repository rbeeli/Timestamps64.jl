using Dates: Dates

# fast number to string helpers
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
    ISOTimestamp64Format

Describes the ISO 8601 nano formatting for a `Timestamp64`.
This is the default value for `Dates.format` of a `Timestamp64`.
Note that it does not contain a trailing `Z` character.

# Example
```jldoctest
julia> Dates.format(Timestamp64(2018, 8, 8, 12, 0, 43, nanoseconds=1), ISOTimestamp64Format)
"2018-08-08T12:00:43.000000001"
```
"""
const ISOTimestamp64Format = Dates.DateFormat("yyyy-mm-dd\\THH:MM:SS.fffffffff")
Dates.default_format(::Type{Timestamp64}) = ISOTimestamp64Format

"""
    RFC3339Timestamp64Format

Describes the RFC 3339 nano formatting for a `Timestamp64`.
This is the default value for `Dates.format` of a `Timestamp64`.
Note that it does not contain a trailing `Z` character.

# Example
```jldoctest
julia> Dates.format(Timestamp64(2018, 8, 8, 12, 0, 43, nanoseconds=1), ISOTimestamp64Format)
"2018-08-08T12:00:43.000000001"
```
"""
const RFC3339Timestamp64Format = Dates.DateFormat("yyyy-mm-dd\\THH:MM:SS.fffffffffZ")

"""
    Dates.format(t::Timestamp, ::typeof(ISOTimestamp64Format)

Return a string representing the timestamp in ISO 8601 format
with nanosecond precision.
"""
Dates.format(timestamp::Timestamp64, ::typeof(ISOTimestamp64Format)) = iso8601(timestamp)

"""
    Dates.format(t::Timestamp, ::typeof(Dates.ISODateTimeFormat)

Return a string representing the timestamp in ISO 8601 format
with nanosecond precision.
"""
Dates.format(timestamp::Timestamp64, ::typeof(Dates.ISODateTimeFormat)) = iso8601(timestamp)

"""
    Dates.format(t::Timestamp, ::typeof(RFC3339Timestamp64Format)

Return a string representing the timestamp in RFC 3339 format
with nanosecond precision.
"""
Dates.format(timestamp::Timestamp64, ::typeof(RFC3339Timestamp64Format)) = rfc3339(timestamp)

"""
    iso8601(timestamp::Timestamp64)

Return a string representing the timestamp in ISO 8601 nano format.

Note that the timestamp is always in UTC,
the precision is nanoseconds (9 digits),
and **no** trailing 'Z' character is returned.

# Examples

```jldoctest
julia> iso8601(Timestamp64(2018, 8, 8, 12, 0, 43, nanoseconds=1))
"2018-08-08T12:00:43.000000001"
```
"""
function iso8601(ts::Timestamp64)
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

"""
    rfc3339(timestamp::Timestamp64)

Return a string representing the timestamp in RFC 3339 nano format.

Note that the timestamp is always in UTC,
the precision is nanoseconds (9 digits),
and a trailing 'Z' character is returned.

# Examples

```jldoctest
julia> rfc3339(Timestamp64(2018, 8, 8, 12, 0, 43, nanoseconds=1))
"2018-08-08T12:00:43.000000001Z"
```
"""
function rfc3339(ts::Timestamp64)
    base = "0000-00-00T00:00:00.000000000Z" # 30 chars

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
