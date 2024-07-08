import Dates

"""
    ISOTimestamp64Format

Describes the ISO 8601 formatting for a `Timestamp64`.
This is the default value for `Dates.format` of a `Timestamp64`.

# Example
```jldoctest
julia> Dates.format(Timestamp64(2018, 8, 8, 12, 0, 43, 1), ISOTimestamp64Format)
"2018-08-08T12:00:43.000000001"
```
"""
const ISOTimestamp64Format = Dates.DateFormat("yyyy-mm-dd\\THH:MM:SS.fffffffff")
Dates.default_format(::Type{Timestamp64}) = ISOTimestamp64Format

"""
    Dates.format(t::Timestamp, ::typeof(ISOTimestamp64Format)

Return a string representing the timestamp in ISO 8601 format
with nanosecond precision.
"""
function Dates.format(timestamp::Timestamp64, ::typeof(ISOTimestamp64Format))
    iso8601(timestamp)
end

"""
    Dates.format(t::Timestamp, ::typeof(Dates.ISODateTimeFormat)

Return a string representing the timestamp in ISO 8601 format
with nanosecond precision.
"""
function Dates.format(timestamp::Timestamp64, ::typeof(Dates.ISODateTimeFormat))
    iso8601(timestamp)
end

"""
    iso8601(timestamp::Timestamp64)

Return a string representing the timestamp in ISO 8601 format.

Note that the timestamp is always in UTC and the precision is nanoseconds (9 digits).

# Examples

```jldoctest
julia> using Timestamps

```
"""
function iso8601(timestamp::Timestamp64)
    time = timestamp.ts
    out = "0000-00-00T00:00:00.000000000"
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

## Does the same, but is slower
# function iso8601(timestamp::Timestamp64)
#     time = timestamp.ts
#     nss = 1_000_000_000
#     # mn = 1_000_000

#     z = time ÷ (86_400 * nss) + 719468
#     era = div(z >= 0 ? z : z - 146096, 146097)
#     doe = z - era * 146097
#     yoe = div(doe - div(doe, 1460) + div(doe, 36524) - div(doe, 146096), 365)
#     year = yoe + era * 400
#     doy = doe - (365 * yoe + div(yoe, 4) - div(yoe, 100))
#     mp = div(5 * doy + 2, 153)
#     day = doy - div(153 * mp + 2, 5) + 1
#     month = mp + (mp < 10 ? 3 : -9)
#     year += (month <= 2)

#     year_str = string(year)
#     month_str = lpad(month, 2, '0')
#     day_str = lpad(day, 2, '0')
    
#     hour = (time ÷ (3_600 * nss)) % 24
#     mins = (time ÷ (60 * nss)) % 60
#     secs = (time ÷ nss) % 60
#     ns = (time % nss)

#     hour_str = lpad(hour, 2, '0')
#     mins_str = lpad(mins, 2, '0')
#     secs_str = lpad(secs, 2, '0')
#     ns_str = lpad(ns, 9, '0')

#     "$(year_str)-$(month_str)-$(day_str)T$(hour_str):$(mins_str):$(secs_str).$(ns_str)Z"
# end
