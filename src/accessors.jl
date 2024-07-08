import Dates

@inline Dates.value(timestamp::Timestamp) = timestamp.ts

@inline function Dates.days(timestamp::Timestamp)
    timestamp.ts ÷ (86_400 * 1_000_000_000)
end

@inline function Dates.year(timestamp::Timestamp)
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

@inline function Dates.month(timestamp::Timestamp)
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

@inline function Dates.day(timestamp::Timestamp)
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

@inline function Dates.hour(timestamp::Timestamp)
    (timestamp.ts ÷ (3_600 * 1_000_000_000)) % 24
end

@inline function Dates.minute(timestamp::Timestamp)
    (timestamp.ts ÷ (60 * 1_000_000_000)) % 60
end

@inline function Dates.second(timestamp::Timestamp)
    (timestamp.ts ÷ 1_000_000_000) % 60
end

@inline function Dates.millisecond(timestamp::Timestamp)
    (timestamp.ts % 1_000_000_000) ÷ 1_000_000
end

@inline function Dates.microsecond(timestamp::Timestamp)
    (timestamp.ts % 1_000_000_000) ÷ 1_000
end

@inline function Dates.nanosecond(timestamp::Timestamp)
    (timestamp.ts % 1_000_000_000)
end

@inline unix_nanos(timestamp::Timestamp) = timestamp.ts
@inline unix_micros(timestamp::Timestamp) = timestamp.ts ÷ 1_000
@inline unix_millis(timestamp::Timestamp) = timestamp.ts ÷ 1_000_000
@inline unix_secs(timestamp::Timestamp) = timestamp.ts ÷ 1_000_000_000

@inline unix(::Type{Dates.Nanosecond}, timestamp::Timestamp) = unix_nanos(timestamp)
@inline unix(::Type{Dates.Microsecond}, timestamp::Timestamp) = unix_micros(timestamp)
@inline unix(::Type{Dates.Millisecond}, timestamp::Timestamp) = unix_millis(timestamp)
@inline unix(::Type{Dates.Second}, timestamp::Timestamp) = unix_secs(timestamp)
