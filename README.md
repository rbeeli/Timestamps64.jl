# Timestamps64.jl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2024)

This package provides an efficient `Timestamp64` type with nanosecond precision.
It is a wrapper around a single `Int64` value (8 bytes) that represents the number of nanoseconds since the UNIX epoch.

`Timestamp64` can store values ranging from `1970-01-01T00:00:00.000000000` to `2262-04-11 23:47:16.854775807`, which should be sufficient for most applications.

The reason this packages was created is that the built-in `Dates.DateTime` type in Julia is not able to represent nanosecond precision.
The `Dates.DateTime` type has millisecond precision, which is insufficient for some specialized applications.

This package works with Julia's built-in `Dates` module with methods to convert between `Timestamp64` and `DateTime`, `Date` and `Time` types.
Furthermore, the common accessor functions for year, month, day, hour, minute, second, millisecond, microsecond, and nanosecond, among others, are provided.

## Examples

```julia
using Timestamps64
using Dates

# Create a timestamp
ts = Timestamp64(2021, 12, 31, 23, 58, 59, 123456789) # last parameter is nanoseconds

# Current timestamp (microsecond precision)
now(Timestamp64)

# Today's timestamp (at midnight)
today(Timestamp64)

# Convert to DateTime (only with millisecond precision)
dt = DateTime(ts)

# Convert to Date
Date(ts)

# Convert to Time
Time(ts)

# Convert DateTime back to Timestamp64 (only with millisecond precision)
Timestamp64(dt)

# Convert from various ISO 8601 string formats
Timestamp64("2021-01-01T00:00:01")
Timestamp64("2021-01-01T00:00:01Z")
Timestamp64("2021-01-01T00:00:00.001")
Timestamp64("2021-01-01T00:00:00.001Z")
Timestamp64("2021-01-01T00:00:00.000001")
Timestamp64("2021-01-01T00:00:00.000001Z")
Timestamp64("2021-01-01T00:00:00.000000001")
Timestamp64("2021-01-01T00:00:00.000000001Z")

# Base.parse is also supported (only ISO 8601 format with up to nanosecond precision)
parse(Timestamp64, "2021-01-01T00:00:00.000000001Z", Dates.ISODateTimeFormat)
parse(Timestamp64, "2021-01-01T00:00:00")
parse(Timestamp64, "2021-01-01T00:00:00.001")
parse(Timestamp64, "2021-01-01T00:00:00.000000001Z", ISOTimestamp64Format)

# Accessor functions
year(ts)
month(ts)
day(ts)
hour(ts)
minute(ts)
second(ts)
nanosecond(ts)
millisecond(ts)
microsecond(ts)
nanosecond(ts)
yearmonth(ts)
yearmonthday(ts)
monthday(ts)
monthname(ts)
isleapyear(ts)
dayofweek(ts)

## String conversions

# Convert to string (ISO 8601 default)
string(ts)

# Convert to ISO 8601 string explicitly
iso8601(ts)

# Print string (ISO 8601 default)
println(ts)

# Dates.format is also supported
Dates.format(ts, Dates.ISODateTimeFormat)
Dates.format(ts, ISOTimestamp64Format)


## UNIX timestamp conversions

# create from UNIX timestamp in nanoseconds
Timestamp64(1704412800000000000)

# get UNIX timestamp in nanoseconds
Dates.value(ts)
unix_nanos(ts)
unix(Nanosecond, ts)

# get UNIX timestamp in microseconds
unix_micros(ts)
unix(Microsecond, ts)

# get UNIX timestamp in milliseconds
unix_millis(ts)
unix(Millisecond, ts)

# get UNIX timestamp in seconds
unix_secs(ts)
unix(Second, ts)


## Arithmetics

# Add period
ts2 = ts + Millisecond(100)
ts2 - ts

# Subtract period
ts2 = ts - Microsecond(1)
ts2 - ts

# Difference of two timestamps
ts1 = Timestamp64(2022, 12, 31, 23, 58, 59)
ts2 = Timestamp64(2023, 1, 1, 23, 58, 59)
ts2 - ts1
Day(ts2 - ts1)

# Compare timestamps
ts1 < ts2
ts1 > ts2
ts1 == ts2

## Ranges
# Note that `Month` and `Year` are not supported in ranges due to their variable length

# Create a range of timestamps using arbitrary periods
Timestamp64(2020, 1, 1):Day(1):Timestamp64(2020, 1, 10) # 10 days

collect(Timestamp64(2020, 1, 1):Day(1):Timestamp64(2020, 1, 10))
```
