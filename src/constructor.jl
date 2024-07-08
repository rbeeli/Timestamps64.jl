import Dates
import Base.Libc

const Base.zero(::Type{Timestamp}) = Timestamp(0)

"""
Timestamp(dt::Dates.DateTime)

Create a `Timestamp` object from a `Dates.DateTime`.
"""
function Timestamp(dt::Dates.DateTime)
    # Dates.value(dt) returns the number of milliseconds since 0001-01-01T00:00:00
    Timestamp((Dates.value(dt) - Dates.UNIXEPOCH) * 1_000_000)
end

"""
Timestamp(dt::Dates.DateTime)

Create a `Timestamp` object from a `Dates.Date`.
"""
function Timestamp(dt::Dates.Date)
    Timestamp(Dates.year(dt), Dates.month(dt), Dates.day(dt))
end

"""
    Timestamp(year::Int, month::Int, day::Int)

Create a `Timestamp` object from date components.
"""
function Timestamp(year::Int, month::Int, day::Int)
    nss = 1_000_000_000

    # Adjust the year and month for the algorithm
    if month <= 2
        year -= 1
        month += 12
    end

    # Calculate the era, year of era, and day of year
    era = div(year, 400)
    yoe = year % 400
    mp = month - 3
    doy = div(153 * mp + 2, 5) + day - 1

    # Calculate the day of era
    doe = 365 * yoe + div(yoe, 4) - div(yoe, 100) + doy

    # Calculate z
    z = era * 146097 + doe

    # Calculate the time in nanoseconds
    time = (z - 719468) * 86_400 * nss

    Timestamp(time)
end

"""
    Timestamp(year::Int, month::Int, day::Int)

Create a `Timestamp` object from date and time components.
"""
function Timestamp(year::Int, month::Int, day::Int, hours::Int, minutes::Int=0, seconds::Int=0, nanoseconds::Int=0)
    nss = 1_000_000_000

    # Adjust the year and month for the algorithm
    if month <= 2
        year -= 1
        month += 12
    end

    # Calculate the era, year of era, and day of year
    era = div(year, 400)
    yoe = year % 400
    mp = month - 3
    doy = div(153 * mp + 2, 5) + day - 1

    # Calculate the day of era
    doe = 365 * yoe + div(yoe, 4) - div(yoe, 100) + doy

    # Calculate z
    z = era * 146097 + doe

    # Calculate the time in nanoseconds
    time = (z - 719468) * 86_400 * nss + hours * 3_600 * nss + minutes * 60 * nss + seconds * nss + nanoseconds

    Timestamp(time)
end

"""
    Timestamp(iso8601::AbstractString)

Create a `Timestamp` object from an ISO 8601 string with nanoseconds precision.

# Examples

```julia
julia> Timestamp("2021-01-01T00:00:01")
"2021-01-01T00:00:01.000000000"

julia> Timestamp("2021-01-01T00:00:01Z")
"2021-01-01T00:00:01.000000000"

julia> Timestamp("2021-01-01T00:00:00.001")
"2021-01-01T00:00:00.001000000"

julia> Timestamp("2021-01-01T00:00:00.001Z")
"2021-01-01T00:00:00.001000000"

julia> Timestamp("2021-01-01T00:00:00.000001")
"2021-01-01T00:00:00.000001000"

julia> Timestamp("2021-01-01T00:00:00.000001Z")
"2021-01-01T00:00:00.000001000"

julia> Timestamp("2021-01-01T00:00:00.000000001")
"2021-01-01T00:00:00.000000001"

julia> Timestamp("2021-01-01T00:00:00.000000001Z")
"2021-01-01T00:00:00.000000001"
```
"""
function Timestamp(iso8601::T) where {T<:AbstractString}
    year = parse(Int, iso8601[1:4])
    month = parse(Int, iso8601[6:7])
    day = parse(Int, iso8601[9:10])
    hours = parse(Int, iso8601[12:13])
    minutes = parse(Int, iso8601[15:16])
    seconds = parse(Int, iso8601[18:19])
    nanoseconds = 0
    if length(iso8601) > 20
        endindex = length(iso8601)
        if iso8601[endindex] == 'Z'
            endindex -= 1
        end
        if endindex == 23 # milliseconds
            nanoseconds = parse(Int, iso8601[21:endindex])*1_000_000
        elseif endindex == 26#  microseconds
            nanoseconds = parse(Int, iso8601[21:endindex])*1_000
        else # nanoseconds
            nanoseconds = parse(Int, iso8601[21:endindex])
        end
    end
    Timestamp(year, month, day, hours, minutes, seconds, nanoseconds)
end

"""
Returns the current time as a `Timestamp` object with microseconds precision.
"""
function timestamp_now()
    tv = Libc.TimeVal()
    tm = Libc.TmStruct(tv.sec)
    Timestamp(tm.year + 1900, tm.month + 1, Int(tm.mday), Int(tm.hour), Int(tm.min), Int(tm.sec), tv.usec * 1_000)
end

"""
Returns the current date as a `Timestamp` object with microseconds precision.
The time part is set to `00:00:00.000000`.
"""
function timestamp_today()
    tv = Libc.TimeVal()
    tm = Libc.TmStruct(tv.sec)
    Timestamp(tm.year + 1900, tm.month + 1, Int(tm.mday))
end