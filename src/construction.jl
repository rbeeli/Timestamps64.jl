using Dates: Dates
import Base.Libc

"""
	Timestamp64(year::Int, month::Int, day::Int)

Create a `Timestamp64` object from date components.
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
	Timestamp64(year::Int, month::Int, day::Int)

Create a `Timestamp64` object from date and time components.
"""
function Timestamp64(
    year::Int, month::Int, day::Int, hours::Int, minutes::Int=0, seconds::Int=0, nanoseconds::Int=0
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
Returns the current time as a `Timestamp64` object with nanoseconds precision
in local timezone.
"""
@inline function Dates.now(::Type{Timestamp64})
    ns_utc = _to_unix_ns(_clock_gettime()) # raw UTC nanoseconds
    ns_off = _local_tz_offset_sec(ns_utc ÷ 1_000_000_000) * 1_000_000_000
    Timestamp64(ns_utc + ns_off)
end

"""
Returns the current time as a `Timestamp64` object with nanoseconds precision
in UTC timezone.
"""
@inline function Dates.now(::Type{Timestamp64}, ::Type{Dates.UTC})
    Timestamp64(_to_unix_ns(_clock_gettime()))
end

"""
Returns the current date as a `Timestamp64` object with nanoseconds precision
in local timezone. The time part is set to `00:00:00.000000`.
"""
@inline function Dates.today(::Type{Timestamp64})
    ns_local = Dates.now(Timestamp64).ts
    Timestamp64((ns_local ÷ 86_400_000_000_000) * 86_400_000_000_000)
end

"""
Returns the current date as a `Timestamp64` object with nanoseconds precision
in UTC timezone. The time part is set to `00:00:00.000000`.
"""
@inline function Dates.today(::Type{Timestamp64}, ::Type{Dates.UTC})
    Timestamp64(_to_date_ns(_clock_gettime()))
end
