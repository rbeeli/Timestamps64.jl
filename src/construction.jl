using Dates: Dates
using Base.Libc: TmStruct

"""
	Timestamp64(year::Int, month::Int, day::Int)

Construct a `Timestamp64` from individual calendar components.

# Arguments
- `year`: Calendar year (e.g. `2025`).
- `month`: Month of the year `1-12`.
- `day`: Day of the month `1-31`.
"""
function Timestamp64(year::Int, month::Int, day::Int)
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

    Timestamp64(time)
end

"""
	Timestamp64(year::Integer, month::Integer, day::Integer)

Construct a `Timestamp64` from individual calendar components.

# Arguments
- `year`: Calendar year (e.g. `2025`).
- `month`: Month of the year `1-12`.
- `day`: Day of the month `1-31`.
"""
@inline Timestamp64(year::T, month::T, day::T) where {T<:Integer} =
    Timestamp64(Int(year), Int(month), Int(day))

"""
    Timestamp64(year::Int, month::Int, day::Int, hours::Int;
                minutes::Int = 0, seconds::Int = 0, nanoseconds::Int = 0)

Construct a `Timestamp64` from individual calendar and clock components.

# Arguments
- `year`: Calendar year (e.g. `2025`).
- `month`: Month of the year `1-12`.
- `day`: Day of the month `1-31`.
- `hours`: Hour of the day `0-23`.
- `minutes`: Minute of the hour `0-59` (default `0`).
- `seconds`: Second of the minute `0-59` (default `0`).

# Keyword Arguments
- `nanoseconds`: Additional nanoseconds `0-999_999_999` (default `0`).

# Examples
```julia
julia> Timestamp64(2025, 7, 20, 14, 30, 15, nanoseconds=1_000)
2025-07-20T14:30:15.000001000
"""
function Timestamp64(
    year::Int, #
    month::Int,
    day::Int,
    hours::Int,
    minutes::Int=0,
    seconds::Int=0;
    nanoseconds::Int=0, # kwarg to be explicit - Dates.DateTime takes milliseconds!
)
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
    time =
        (z - 719468) * 86_400 * nss +
        hours * 3_600 * nss +
        minutes * 60 * nss +
        seconds * nss +
        nanoseconds

    Timestamp64(time)
end

"""
Returns the current time as a `Timestamp64` object with nanosecond precision
in **UTC** time zone.
Equivalent to `now(Timestamp64, UTC)`.
"""
@inline Dates.now(::Type{Timestamp64}) = Dates.now(Timestamp64, Dates.UTC)

"""
Returns the current time as a `Timestamp64` object with nanosecond precision
in **UTC** time zone.
"""
@inline Dates.now(::Type{Timestamp64}, ::Type{Dates.UTC}) =
    Timestamp64(_to_unix_ns(_clock_gettime()))

"""
Returns the current date as a `Timestamp64` object with nanosecond precision
in **UTC** time zone. The time part is set to `00:00:00.000000`.
Equivalent to `today(Timestamp64, UTC)`.
"""
@inline Dates.today(::Type{Timestamp64}) = Dates.today(Timestamp64, Dates.UTC)

"""
Returns the current date as a `Timestamp64` object with nanosecond precision
in **UTC** time zone. The time part is set to `00:00:00.000000`.
"""
@inline Dates.today(::Type{Timestamp64}, ::Type{Dates.UTC}) =
    Timestamp64(_to_date_ns(_clock_gettime()))
