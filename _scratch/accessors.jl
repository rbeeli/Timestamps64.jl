function generate_utc_timestamp(time::UInt64)
    nss = 1_000_000_000
    # mn = 1_000_000

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

    year_str = string(year)
    month_str = lpad(month, 2, '0')
    day_str = lpad(day, 2, '0')
    
    hour = (time ÷ (3_600 * nss)) % 24
    mins = (time ÷ (60 * nss)) % 60
    secs = (time ÷ nss) % 60
    ns = (time % nss)

    hour_str = lpad(hour, 2, '0')
    mins_str = lpad(mins, 2, '0')
    secs_str = lpad(secs, 2, '0')
    ns_str = lpad(ns, 9, '0')

    "$(year_str)-$(month_str)-$(day_str)T$(hour_str):$(mins_str):$(secs_str).$(ns_str)Z"
end

function generate_utc_timestamp_fast(time::UInt64)
    out = "0000-00-00T00:00:00.000000000Z"
    ptr = pointer(out)
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

    # TODO: Optimize
    date_str = string(1_000_000 * year + 1000 * month + day)
    unsafe_copyto!(ptr, pointer(date_str), 10)

    hour = (time ÷ (3_600 * nss)) % 24
    mins = (time ÷ (60 * nss)) % 60
    secs = (time ÷ nss) % 60
    ns = (time % nss)

    t = (100_000_000 * nss + hour * 10_000_000 * nss + mins * 10_000 * nss + secs * 10 * nss + ns)
    # TODO: Optimize
    t_str = string(t)
    unsafe_copyto!(ptr + 11, pointer(t_str), 18)

    unsafe_store!(ptr, '-', 5)
    unsafe_store!(ptr, '-', 8)
    unsafe_store!(ptr, ':', 14)
    unsafe_store!(ptr, ':', 17)
    unsafe_store!(ptr, '.', 20)
    unsafe_store!(ptr, unsafe_load(ptr, 12) - 1, 12)

    out
end


using BenchmarkTools

@benchmark generate_utc_timestamp(UInt64(typemax(Int64)))
@benchmark generate_utc_timestamp_fast(UInt64(typemax(Int64)))