using Dates: Dates

"""
    Dates.DateTime(timestamp::Timestamp)

Convert a `Timestamp64` to a `DateTime`.
Note that `DateTime` only has millisecond precision.
"""
function Dates.DateTime(timestamp::Timestamp64)
    seconds, nanoseconds = divrem(timestamp.ts, 1_000_000_000)
    Dates.unix2datetime(seconds) + Dates.Nanosecond(nanoseconds)
end

"""
    Dates.Date(timestamp::Timestamp)

Convert a `Timestamp64` to a `Date`, discarding the time part.
"""
function Dates.Date(timestamp::Timestamp64)
    time = timestamp.ts
    nss = 1_000_000_000
    z = time ÷ (86_400 * nss) + 719468
    era = div(z >= 0 ? z : z - 146096, 146097)
    doe = z - era * 146097
    yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
    year = yoe + era * 400
    doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
    mp = div(5 * doy + 2, 153)
    day = doy - div(153 * mp + 2, 5) + 1
    month = mp + (mp < 10 ? 3 : -9)
    year += (month <= 2)
    Dates.Date(year, month, day)
end

"""
    Dates.Time(timestamp::Timestamp)

Convert a `Timestamp64` to a `Time`, discarding the date part.
"""
function Dates.Time(timestamp::Timestamp64)
    time = timestamp.ts
    nss = 1_000_000_000
    hour = (time ÷ (3_600 * nss)) % 24
    mins = (time ÷ (60 * nss)) % 60
    secs = (time ÷ nss) % 60
    ns = time % nss
    Dates.Time(hour, mins, secs) + Dates.Nanosecond(ns)
end

"""
Timestamp64(dt::Dates.DateTime)

Create a `Timestamp64` object from a `Dates.DateTime`.
"""
@inline function Timestamp64(dt::Dates.DateTime)
    # Dates.value(dt) returns the number of milliseconds since 0001-01-01T00:00:00
    Timestamp64((Dates.value(dt) - Dates.UNIXEPOCH) * 1_000_000)
end

"""
Timestamp64(dt::Dates.DateTime)

Create a `Timestamp64` object from a `Dates.Date`.
"""
@inline function Timestamp64(dt::Dates.Date)
    Timestamp64(Dates.year(dt), Dates.month(dt), Dates.day(dt))
end

"""
Timestamp64(date::Dates.Date, time::Dates.Time)

Create a `Timestamp64` object from a `Dates.Date` and a `Dates.Time`.
"""
@inline function Timestamp64(date::Dates.Date, time::Dates.Time)
    Timestamp64(
        Dates.year(date), #
        Dates.month(date),
        Dates.day(date),
        0,
        0,
        0;
        nanoseconds=Dates.value(time),
    )
end

# Date, Time, DateTime <-> Timestamp64 conversions
Base.convert(::Type{Timestamp64}, dt::Dates.DateTime) = Timestamp64(dt)
Base.convert(::Type{Timestamp64}, dt::Dates.Date) = Timestamp64(dt)
Base.convert(::Type{Dates.Date}, ts::Timestamp64) = Dates.Date(ts)
Base.convert(::Type{Dates.Time}, ts::Timestamp64) = Dates.Time(ts)
Base.convert(::Type{Dates.DateTime}, ts::Timestamp64) = Dates.DateTime(ts)

# Date-Timestamp64 promotion
Base.promote_rule(::Type{Dates.Date}, x::Type{Timestamp64}) = Timestamp64

# DateTime-Timestamp64 promotion
Base.promote_rule(::Type{Dates.DateTime}, x::Type{Timestamp64}) = Timestamp64
