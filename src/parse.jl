using Dates: Dates

@inline function _tryparse_base10_positive(str::AbstractString, i::Int, len::Int)::Int
    i > len && return -1
    d::Int = 0
    @inbounds while i <= len
        c, ii = iterate(str, i)::Tuple{Char,Int}
        if '0' <= c <= '9'
            d = d * 10 + (c - '0')
        else
            break
        end
        i = ii
    end
    if i <= len
        return -1
    else
        return d
    end
end

"""
    Timestamp64(iso8601::AbstractString)

Create a `Timestamp64` object from an ISO 8601 string with nanoseconds precision.

# Examples

```julia
julia> Timestamp64("2021-01-01T00:00:01")
"2021-01-01T00:00:01.000000000"

julia> Timestamp64("2021-01-01T00:00:01Z")
"2021-01-01T00:00:01.000000000"

julia> Timestamp64("2021-01-01T00:00:00.001")
"2021-01-01T00:00:00.001000000"

julia> Timestamp64("2021-01-01T00:00:00.001Z")
"2021-01-01T00:00:00.001000000"

julia> Timestamp64("2021-01-01T00:00:00.000001")
"2021-01-01T00:00:00.000001000"

julia> Timestamp64("2021-01-01T00:00:00.000001Z")
"2021-01-01T00:00:00.000001000"

julia> Timestamp64("2021-01-01T00:00:00.000000001")
"2021-01-01T00:00:00.000000001"

julia> Timestamp64("2021-01-01T00:00:00.000000001Z")
"2021-01-01T00:00:00.000000001"
```
# """
function Timestamp64(s::T) where {T<:AbstractString}
    i, end_pos = firstindex(s), lastindex(s)
    i > end_pos && throw(ArgumentError("Cannot parse an empty string as a Timestamp64"))

    # discard 'Z' if it is the last character
    if s[end_pos] == 'Z'
        end_pos -= 1
    end

    # check min length
    (end_pos - i + 1 < 19) && @goto error

    # parse year
    dy = _tryparse_base10_positive(s, i, i + 3)
    dy == -1 && @goto error
    i += 4

    # '-' separator
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != '-' && @goto error

    # parse month
    dm = _tryparse_base10_positive(s, i, i + 1)
    dm == -1 && @goto error
    i += 2

    # '-' separator
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != '-' && @goto error

    # parse day
    dd = _tryparse_base10_positive(s, i, i + 1)
    dd == -1 && @goto error
    i += 2

    # 'T' separator
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != 'T' && @goto error

    # parse hour
    th = _tryparse_base10_positive(s, i, i + 1)
    th == -1 && @goto error
    i += 2

    # ':' separator
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != ':' && @goto error

    # parse minute
    tm = _tryparse_base10_positive(s, i, i + 1)
    tm == -1 && @goto error
    i += 2

    # ':' separator
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != ':' && @goto error

    # parse second
    ts = _tryparse_base10_positive(s, i, i + 1)
    ts == -1 && @goto error
    i += 2

    tns = 0

    # fractional seconds (if any)
    i > end_pos && @goto done
    c, i = iterate(s, i)::Tuple{Char,Int}
    c != '.' && @goto error

    frac_len = end_pos - i + 1

    if frac_len == 3
        # milliseconds
        tms = _tryparse_base10_positive(s, i, i + frac_len - 1)
        tms == -1 && @goto error
        tns = tms * 1_000_000
    elseif frac_len == 6
        # microseconds
        tus = _tryparse_base10_positive(s, i, i + frac_len - 1)
        tus == -1 && @goto error
        tns = tus * 1_000
    elseif frac_len == 9
        # nanoseconds
        tns = _tryparse_base10_positive(s, i, i + frac_len - 1)
        tns == -1 && @goto error
    else
        @goto error
    end

    @label done
    return Timestamp64(dy, dm, dd, th, tm, ts, tns)

    @label error
    throw(ArgumentError("Invalid Timestamp64 string"))
end

# OLD and slower implementations
# function Timestamp64(iso8601::T) where {T<:AbstractString}
#     year = parse(Int, @view iso8601[1:4])
#     month = parse(Int, @view iso8601[6:7])
#     day = parse(Int, @view iso8601[9:10])
#     hours = parse(Int, @view iso8601[12:13])
#     minutes = parse(Int, @view iso8601[15:16])
#     seconds = parse(Int, @view iso8601[18:19])
#     nanoseconds = 0
#     if length(iso8601) > 20
#         endindex = length(iso8601)
#         if iso8601[endindex] == 'Z'
#             endindex -= 1
#         end
#         if endindex == 23 # milliseconds
#             nanoseconds = parse(Int, @view iso8601[21:endindex])*1_000_000
#         elseif endindex == 26#  microseconds
#             nanoseconds = parse(Int, @view iso8601[21:endindex])*1_000
#         else # nanoseconds
#             nanoseconds = parse(Int, @view iso8601[21:endindex])
#         end
#     end
#     Timestamp64(year, month, day, hours, minutes, seconds, nanoseconds)
# end
# function Timestamp64(s::T) where {T<:AbstractString}
#     i, end_pos = firstindex(s), lastindex(s)
#     i > end_pos && throw(ArgumentError("Cannot parse an empty string as a Timestamp64"))

#     # discard 'Z' if it is the last character
#     if s[end_pos] == 'Z'
#         end_pos -= 1
#     end

#     local dy
#     dm = dd = Int64(1)
#     th = tm = ts = tns = Int64(0)

#     # parse year
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1)
#         val === nothing && @goto error
#         dy, i = val
#         i > end_pos && @goto error
#     end

#     # '-' separator
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != '-' && @goto error
#     i > end_pos && @goto done

#     # parse month
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 2)
#         val === nothing && @goto error
#         dm, i = val
#         i > end_pos && @goto done
#     end

#     # '-' separator
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != '-' && @goto error
#     i > end_pos && @goto done

#     # parse day
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 2)
#         val === nothing && @goto error
#         dd, i = val
#         i > end_pos && @goto done
#     end

#     # 'T' separator
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != 'T' && @goto error
#     i > end_pos && @goto done

#     # parse hour
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 2)
#         val === nothing && @goto error
#         th, i = val
#         i > end_pos && @goto done
#     end

#     # ':' separator
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != ':' && @goto error
#     i > end_pos && @goto done

#     # parse minute
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 2)
#         val === nothing && @goto error
#         tm, i = val
#         i > end_pos && @goto done
#     end

#     # ':' separator
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != ':' && @goto error
#     i > end_pos && @goto done

#     # parse second
#     let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 2)
#         val === nothing && @goto error
#         ts, i = val
#         i > end_pos && @goto done
#     end

#     # fractional seconds (if any)
#     c, i = iterate(s, i)::Tuple{Char, Int}
#     c != '.' && @goto error
#     i > end_pos && @goto done

#     if end_pos - i + 1 == 3
#         # milliseconds
#         let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 3)
#             val === nothing && @goto error
#             tms, j = val
#             tms *= 10 ^ (3 - (j - i))
#             tns = tms * 1_000_000
#             j > end_pos || @goto error
#         end
#     elseif end_pos - i + 1 == 6
#         # microseconds
#         let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 6)
#             val === nothing && @goto error
#             tms, j = val
#             tms *= 10 ^ (6 - (j - i))
#             tns = tms * 1_000
#             j > end_pos || @goto error
#         end
#     elseif end_pos - i + 1 == 9
#         # nanoseconds
#         let val = Dates.tryparsenext_base10(s, i, end_pos, 1, 9)
#             val === nothing && @goto error
#             tns, j = val
#             tns *= 10 ^ (9 - (j - i))
#             j > end_pos || @goto error
#         end
#     end

#     @label done
#     return Timestamp64(dy, dm, dd, th, tm, ts, tns)

#     @label error
#     throw(ArgumentError("Invalid Timestamp64 string"))
# end

"""
Parses a datetime string `s` using the ISO 8601 format and returns a `Timestamp64` object
with microseconds precision.
"""
Base.parse(::Type{Timestamp64}, s::AbstractString, df::typeof(Dates.ISODateTimeFormat)) =
    Timestamp64(s)

"""
Parses a datetime string `s` using the ISO 8601 format and returns a `Timestamp64` object
with microseconds precision.
"""
function Base.parse(
    ::Type{Timestamp64}, s::AbstractString, df::Dates.DateFormat=Dates.default_format(Timestamp64)
)
    if df != Dates.ISODateTimeFormat && df != ISOTimestamp64Format
        throw(ArgumentError("Only ISODateTimeFormat and ISOTimestamp64Format are supported"))
    end
    Timestamp64(s)
end
