import Dates

"""
    Dates.DateTime(t::Timestamp)

Convert a `Timestamp` to a `DateTime`.
Note that `DateTime` only has millisecond precision.
"""
function Dates.DateTime(timestamp::Timestamp)
    seconds, nanoseconds = divrem(timestamp.ts, 1_000_000_000)
    Dates.unix2datetime(seconds) + Dates.Nanosecond(nanoseconds)
end

"""
    Dates.Date(t::Timestamp)

Convert a `Timestamp` to a `Date`, discarding the time part.
"""
function Dates.Date(timestamp::Timestamp)
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
    Dates.Time(t::Timestamp)

Convert a `Timestamp` to a `Time`, discarding the date part.
"""
function Dates.Time(timestamp::Timestamp)
    time = timestamp.ts
    nss = 1_000_000_000
    hour = (time ÷ (3_600 * nss)) % 24
    mins = (time ÷ (60 * nss)) % 60
    secs = (time ÷ nss) % 60
    ns = time % nss
    Dates.Time(hour, mins, secs) + Dates.Nanosecond(ns)
end
