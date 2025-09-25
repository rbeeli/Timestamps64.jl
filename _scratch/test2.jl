using Dates
using Timestamps64

@inline function year_month_day(timestamp::Timestamp64)
    nss = 1_000_000_000
    z = timestamp.ts ÷ (86_400 * nss) + 719468
    era = div(z >= 0 ? z : z - 146096, 146097)
    doe = z - era * 146097
    yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
    year = yoe + era * 400
    doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
    mp = div(5 * doy + 2, 153)
    day = doy - div(153 * mp + 2, 5) + 1
    month = mp + (mp < 10 ? 3 : -9)
    year += (month <= 2)
    (year, month, day)
end

using BenchmarkTools

@benchmark year_month_day($Timestamp64(2020, 1, 2))

@benchmark yearmonthday($Timestamp64(2020, 1, 2))

@benchmark iso8601($now(Timestamp64))
