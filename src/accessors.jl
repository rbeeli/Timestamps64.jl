import Dates

"""
Returns the number of nanoseconds since the UNIX epoch.
This is the raw value stored in the `Timestamp64` struct.
"""
@inline Dates.value(timestamp::Timestamp64) = timestamp.ts

"""
Returns the year as an integer.
"""
@inline function Dates.year(timestamp::Timestamp64)
    time = timestamp.ts
    nss = 1_000_000_000
    z = time ÷ (86_400 * nss) + 719468
    era = div(z >= 0 ? z : z - 146096, 146097)
    doe = z - era * 146097
    yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
    year = yoe + era * 400
    doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
    mp = div(5 * doy + 2, 153)
    month = mp + (mp < 10 ? 3 : -9)
    year += (month <= 2)
    year
end

"""
Returns the month of the year as an integer.
"""
@inline function Dates.month(timestamp::Timestamp64)
    time = timestamp.ts
    nss = 1_000_000_000
    z = time ÷ (86_400 * nss) + 719468
    era = div(z >= 0 ? z : z - 146096, 146097)
    doe = z - era * 146097
    yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
    doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
    mp = div(5 * doy + 2, 153)
    month = mp + (mp < 10 ? 3 : -9)
    month
end

"""
Returns the day of the month as an integer.
"""
@inline function Dates.day(timestamp::Timestamp64)
    time = timestamp.ts
    nss = 1_000_000_000
    z = time ÷ (86_400 * nss) + 719468
    era = div(z >= 0 ? z : z - 146096, 146097)
    doe = z - era * 146097
    yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
    doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
    mp = div(5 * doy + 2, 153)
    day = doy - div(153 * mp + 2, 5) + 1
    day
end

"""
Returns the number of days since the beginning of the
current era (January 1, year 0) as an integer.
"""
@inline function Dates.days(timestamp::Timestamp64)
    # Number of days between Jan 1, year 0 and Unix epoch (Jan 1, 1970)
    days_before_unix_epoch = 719_163
    
    # Convert nanoseconds to days since Unix epoch
    days_since_unix = timestamp.ts ÷ (1_000_000_000 * 60 * 60 * 24)
    
    # Return the number of days since the beginning of the current era
    days_before_unix_epoch + days_since_unix
end

"""
Returns the hour of the day as an integer.
"""
@inline function Dates.hour(timestamp::Timestamp64)
    (timestamp.ts ÷ (3_600 * 1_000_000_000)) % 24
end

"""
Returns the minute of the hour as an integer.
"""
@inline function Dates.minute(timestamp::Timestamp64)
    (timestamp.ts ÷ (60 * 1_000_000_000)) % 60
end

"""
Returns the second of the minute as an integer.
"""
@inline function Dates.second(timestamp::Timestamp64)
    (timestamp.ts ÷ 1_000_000_000) % 60
end

"""
Returns the millisecond part of the `Timestamp64` as an integer.
Microseconds and nanoseconds are truncated.
"""
@inline function Dates.millisecond(timestamp::Timestamp64)
    (timestamp.ts % 1_000_000_000) ÷ 1_000_000
end

"""
Returns the microsecond part of the `Timestamp64` as an integer.
Nanoseconds are truncated.
"""
@inline function Dates.microsecond(timestamp::Timestamp64)
    (timestamp.ts % 1_000_000_000) ÷ 1_000
end

"""
Returns the nanosecond part of the `Timestamp64` as an integer.
"""
@inline function Dates.nanosecond(timestamp::Timestamp64)
    (timestamp.ts % 1_000_000_000)
end

"""
Returns the UNIX timestamp in nanoseconds.
This is an efficient operation since it uses the raw value stored in the `Timestamp64` struct.
"""
@inline unix_nanos(timestamp::Timestamp64) = timestamp.ts

"""
Returns the UNIX timestamp in microseconds.
"""
@inline unix_micros(timestamp::Timestamp64) = timestamp.ts ÷ 1_000

"""
Returns the UNIX timestamp in milliseconds.
"""
@inline unix_millis(timestamp::Timestamp64) = timestamp.ts ÷ 1_000_000

"""
Returns the UNIX timestamp in seconds.
"""
@inline unix_secs(timestamp::Timestamp64) = timestamp.ts ÷ 1_000_000_000

"""
Returns the UNIX timestamp in nanoseconds.
This is an efficient operation since it uses the raw value stored in the `Timestamp64` struct.
"""
@inline unix(::Type{Dates.Nanosecond}, timestamp::Timestamp64) = unix_nanos(timestamp)

"""
Returns the UNIX timestamp in microseconds.
"""
@inline unix(::Type{Dates.Microsecond}, timestamp::Timestamp64) = unix_micros(timestamp)

"""
Returns the UNIX timestamp in milliseconds.
"""
@inline unix(::Type{Dates.Millisecond}, timestamp::Timestamp64) = unix_millis(timestamp)

"""
Returns the UNIX timestamp in seconds.
"""
@inline unix(::Type{Dates.Second}, timestamp::Timestamp64) = unix_secs(timestamp)
