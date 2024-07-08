# Timestamp64.jl

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2024)

This package provides an efficient `Timestamp` type with nanosecond precision.
It is a wrapper around a single `Int64` value (8 bytes) that represents the number of nanoseconds since the UNIX epoch.

`Timestamp` can store values ranging from `1970-01-01T00:00:00.000000000` to `2262-04-11 23:47:16.854775807`, which should be sufficient for most applications.

The reason this packages was created is that the built-in `Dates.DateTime` type in Julia is not able to represent nanosecond precision.
The `Dates.DateTime` type has millisecond precision, which is insufficient for some specialized applications.

This package works with Julia's built-in `Dates` module with methods to convert between `Timestamp` and `DateTime`, `Date` and `Time` types.
Furthermore, the common accessor functions for year, month, day, hour, minute, second, millisecond, microsecond, and nanosecond, among others, are provided.

## Examples

```julia
using Timestamp64
using Dates

# Create a timestamp
ts = Timestamp(2021, 12, 31, 23, 58, 59, 123456789) # last parameter is nanoseconds

# Current timestamp (microsecond precision)
timestamp_now()

# Today's timestamp (at midnight)
timestamp_today()

# Convert to DateTime (only with millisecond precision)
dt = DateTime(ts)

# Convert to Date
Date(ts)

# Convert to Time
Time(ts)

# Convert DateTime back to Timestamp (only with millisecond precision)
Timestamp(dt)

# Convert to string (ISO 8601 by default)
string(ts)

# Print string (ISO 8601 by default)
println(ts)

# Convert to ISO 8601 string
println(iso8601(ts))

# Convert from various ISO 8601 string formats
Timestamp("2021-01-01T00:00:01")
Timestamp("2021-01-01T00:00:01Z")
Timestamp("2021-01-01T00:00:00.001")
Timestamp("2021-01-01T00:00:00.001Z")
Timestamp("2021-01-01T00:00:00.000001")
Timestamp("2021-01-01T00:00:00.000001Z")
Timestamp("2021-01-01T00:00:00.000000001")
Timestamp("2021-01-01T00:00:00.000000001Z")

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

# UNIX epoch in nanoseconds
Dates.value(ts)
unix_nanos(ts)
unix(Nanosecond, ts)

# UNIX epoch in microseconds
unix_micros(ts)
unix(Microsecond, ts)

# UNIX epoch in milliseconds
unix_millis(ts)
unix(Millisecond, ts)

# UNIX epoch in seconds
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
ts1 = Timestamp(2022, 12, 31, 23, 58, 59)
ts2 = Timestamp(2023, 1, 1, 23, 58, 59)
ts2 - ts1
Day(ts2 - ts1)

# Compare timestamps
ts1 < ts2
ts1 > ts2
ts1 == ts2
```
