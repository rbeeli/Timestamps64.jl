import Dates
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
function Timestamp64(year::Int, month::Int, day::Int, hours::Int, minutes::Int=0, seconds::Int=0, nanoseconds::Int=0)
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

    Timestamp64(time)
end

"""
Returns the current time as a `Timestamp64` object with nanoseconds precision and UTC timezone.
"""
@inline function Dates.now(::Type{Timestamp64})
    Dates.now(Timestamp64, Dates.UTC)
end

"""
Returns the current time as a `Timestamp64` object with nanoseconds precision and UTC timezone.
"""
@inline function Dates.now(::Type{Timestamp64}, ::Type{Dates.UTC})
    timespec = _clock_gettime()
    ts = _to_unix_ns(timespec)
    Timestamp64(ts)
end

"""
Returns the current date as a `Timestamp64` object with nanoseconds precision.
The time part is set to `00:00:00.000000`.
"""
@inline function Dates.today(::Type{Timestamp64})
    timespec = _clock_gettime()
    ts = _to_date_ns(timespec)
    Timestamp64(ts)
end
