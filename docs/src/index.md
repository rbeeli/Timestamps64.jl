# Timestamps64.jl

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/rbeeli/Timestamps64.jl/blob/main/LICENSE)
![Maintenance](https://img.shields.io/maintenance/yes/2025)
[![Stable Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://rbeeli.github.io/Timestamps64.jl/stable/)
[![Dev Documentation](https://img.shields.io/badge/docs-dev-blue.svg)](https://rbeeli.github.io/Timestamps64.jl/dev/)

This package provides an efficient `Timestamp64` datetime type with nanosecond precision.
It is a wrapper around a single `Int64` value (8 bytes) that represents the number of nanoseconds since the UNIX epoch. Benchmarks show that common date/time operations are as fast as Julia's built-in `DateTime` type, or even significantly faster in some cases (see below).

`Timestamp64` can store values ranging from `1970-01-01T00:00:00.000000000` to `2262-04-11 23:47:16.854775807`, which should be sufficient for most applications.

This package works with Julia's built-in `Dates` module, providing methods to convert between `Timestamp64` and `DateTime`, `Date`, and `Time` types.
Furthermore, the common accessor functions for year, month, day, hour, minute, second, millisecond, microsecond, and nanosecond, among others, are provided.

Every function is unit-tested to ensure correctness, usually against the corresponding `Dates` function.

!!! note "Timestamps64 precision vs. Dates.DateTime"

    The default precision/unit of the difference of two `Timestamp64` objects is `Nanosecond`, while the default precision/unit of the difference of two `DateTime` objects is `Millisecond`.

!!! note "Timestamps64 time rounding vs. Dates.DateTime"

    Due to a different origin epoch (`1970-01-01T00:00:00.000000000` in `Timestamp64` vs. `0000-01-01T00:00:00` in `DateTime`), the rounding of `Timestamp64` with time periods smaller than `Day(1)` is not identical to the rounding of `DateTime`. This implementation corresponds to C++'s `chrono` rounding behavior.

## Supported platforms

This package is supported on the following platforms (64-bit only):

-   Linux
-   macOS Sierra 10.12 and later (needs `clock_gettime` support)

Examples of not supported platforms:

-   Any 32-bit system
-   Windows operating systems
-   Older macOS versions before 10.12

## Background

The reason this package was created is that the built-in `Dates.DateTime` type in Julia is not able to represent nanosecond precision.
The `Dates.DateTime` type has millisecond precision, which is insufficient for some specialized applications.

## API documentation

```julia
using Timestamps64
using Dates

# Create a timestamp
ts = Timestamp64(2021, 12, 31, 23, 58, 59, 123456789) # last parameter is nanoseconds

# Current timestamp in local time zone with nanosecond precision
now(Timestamp64)

# Current timestamp in UTC with nanosecond precision
now(Timestamp64, UTC)

# Today's timestamp in local time zone (at midnight)
today(Timestamp64)

# Today's timestamp in UTC (at midnight)
today(Timestamp64, UTC)

# Convert from various ISO 8601 string formats
Timestamp64("2021-01-01T00:00:01")
Timestamp64("2021-01-01T00:00:01Z")
Timestamp64("2021-01-01T00:00:00.001") # 1 millisecond
Timestamp64("2021-01-01T00:00:00.001Z") # 1 millisecond
Timestamp64("2021-01-01T00:00:00.000001") # 1 microsecond
Timestamp64("2021-01-01T00:00:00.000001Z") # 1 microsecond
Timestamp64("2021-01-01T00:00:00.000000001") # 1 nanosecond
Timestamp64("2021-01-01T00:00:00.000000001Z") # 1 nanosecond

# Base.parse is also supported (only ISO 8601 format with up to nanosecond precision)
parse(Timestamp64, "2021-01-01T00:00:00.000000001Z", Dates.ISODateTimeFormat)
parse(Timestamp64, "2021-01-01T00:00:00")
parse(Timestamp64, "2021-01-01T00:00:00.001")
parse(Timestamp64, "2021-01-01T00:00:00.000000001Z", ISOTimestamp64Format)


## Dates conversion

# Convert to DateTime, which only has millisecond precision
DateTime(ts)
convert(DateTime, ts)

# Convert to Date
Date(ts)
convert(Date, ts)

# Convert to Time
Time(ts)
convert(Time, ts)

# Create from DateTime (only with millisecond precision)
dt = now()
Timestamp64(dt)

# Create from Date and Time (nanosecond precision)
Timestamp64(Date(2021, 12, 31), Time(23, 58, 59, 123, 456, 789))


## Accessor functions
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


## Numeric operations

# Type constants
eps(Timestamp64)
zero(Timestamp64)
iszero(Timestamp64(0))
typemin(Timestamp64)
typemax(Timestamp64)

# Compare timestamps
ts1 < ts2
ts1 > ts2
ts1 == ts2

# Automatic type promotion
Timestamp64(2020, 1, 1) < DateTime(2020, 1, 2)
Timestamp64(2020, 1, 1) < Date(2020, 1, 2)


## Rounding

# Floor to nearest period value
floor(ts, Nanosecond(5))
floor(ts, Microsecond(5))
floor(ts, Millisecond(5))
floor(ts, Second(5))
floor(ts, Minute(5))
floor(ts, Hour(5))
floor(ts, Day(5))
floor(ts, Month(5))
floor(ts, Quarter(5))
floor(ts, Year(5))

# Ceil to nearest period
ceil(ts, Nanosecond(5))
ceil(ts, Microsecond(5))
ceil(ts, Millisecond(5))
ceil(ts, Second(5))
ceil(ts, Minute(5))
ceil(ts, Hour(5))
ceil(ts, Day(5))
ceil(ts, Month(5))
ceil(ts, Quarter(5))
ceil(ts, Year(5))

# Round to nearest period
round(ts, Nanosecond(5))
round(ts, Microsecond(5))
round(ts, Millisecond(5))
round(ts, Second(5))
round(ts, Minute(5))
round(ts, Hour(5))
round(ts, Day(5))
round(ts, Month(5))
round(ts, Quarter(5))
round(ts, Year(5))


## Ranges

# Create a range of timestamps using arbitrary periods
collect(Timestamp64(2020, 1, 1):Day(1):Timestamp64(2020, 1, 10))
collect(Timestamp64(2020, 1, 1):Week(1):Timestamp64(2020, 1, 31))
collect(Timestamp64(2020, 1, 1):Month(1):Timestamp64(2020, 12, 31))
collect(Timestamp64(2020, 1, 1):Quarter(1):Timestamp64(2020, 12, 31))
collect(Timestamp64(2020, 1, 1):Year(1):Timestamp64(2022, 1, 1))


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
```

## Performance

The `Timestamp64` implementation is very efficient and has a small memory footprint with only 8 bytes.
Common operations such as creating, parsing, converting, and formatting timestamps have been optimized and are as fast as Julia's built-in `DateTime` implementation, or even faster.

The following benchmark results have been obtained on an Intel(R) Core(TM) i9-12900K CPU on Ubuntu 22.04 using Julia 1.10.4.

### Get object with current date/time in UTC

```julia
using BenchmarkTools
using Timestamps64
using Dates

@btime now(Timestamp64, UTC);
@btime now(UTC);
```

#### Result

```console
julia> @btime now(Timestamp64, UTC);
  11.392 ns (0 allocations: 0 bytes)

julia> @btime now(UTC);
  22.015 ns (0 allocations: 0 bytes)
```

The `Timestamp64` type is almost **2 times faster** at getting the current UTC time compared to Julia's built-in `DateTime` type!

### Construction from date parts

```julia
using BenchmarkTools
using Timestamps64
using Dates

const year = 2021;

@btime Timestamp64($year, 1, 1, 0, 0, 1, 123*1_000_000); # last parameter in nanoseconds!
@btime DateTime($year, 1, 1, 0, 0, 1, 123);
```

#### Result

The `Timestamp64` type is **1.7 times faster** at constructing a datetime object from its parts compared to Julia's built-in `DateTime` type!

```console
julia> @btime Timestamp64($year, 1, 1, 0, 0, 1, 123);
  3.364 ns (0 allocations: 0 bytes)

julia> @btime DateTime($year, 1, 1, 0, 0, 1, 123);
  5.644 ns (0 allocations: 0 bytes)
```

### Parsing ISO 8601 strings

```julia
using BenchmarkTools
using Timestamps64
using Dates

@btime Timestamp64("2021-01-01T00:00:01");
@btime DateTime("2021-01-01T00:00:01");

@btime Timestamp64("2021-01-01T00:00:01.001");
@btime DateTime("2021-01-01T00:00:01.001");
```

#### Result

The `Timestamp64` type is almost **1.5 times faster** at parsing ISO 8601 strings compared to Julia's built-in `DateTime` type!

```console
julia> @btime Timestamp64("2021-01-01T00:00:01");
  16.175 ns (0 allocations: 0 bytes)

julia> @btime DateTime("2021-01-01T00:00:01");
  23.312 ns (0 allocations: 0 bytes)

julia> @btime Timestamp64("2021-01-01T00:00:01.001");
  19.271 ns (0 allocations: 0 bytes)

julia> @btime DateTime("2021-01-01T00:00:01.001");
  27.942 ns (0 allocations: 0 bytes)
```

### Format to ISO 8601 strings

```julia
using BenchmarkTools
using Timestamps64
using Dates

ts = Timestamp64(2021, 1, 1, 0, 0, 1) + Millisecond(123)
dt = DateTime(2021, 1, 1, 0, 0, 1) + Millisecond(123)

# ISO 8601 string formatting
@btime Dates.format($ts, ISOTimestamp64Format);
@btime Dates.format($dt, Dates.ISODateTimeFormat);
```

#### Result

The `Timestamp64` type is more than **6 times faster** at formatting to a ISO 8601 string compared to Julia's built-in `DateTime` type, and with fewer allocations!

```console
julia> @btime Dates.format($ts, ISOTimestamp64Format);
  46.626 ns (4 allocations: 200 bytes)

julia> @btime Dates.format($dt, Dates.ISODateTimeFormat);
  286.392 ns (19 allocations: 928 bytes)
```

### Calculate difference

Note that the `Timestamp64` type has nanosecond precision, while the `DateTime` type has millisecond precision, so the return type is correspondingly `Nanosecond` for `Timestamp64` and `Millisecond` for `DateTime`.

```julia
using BenchmarkTools
using Timestamps64
using Dates

ts1 = Timestamp64(2021, 1, 1, 0, 0, 1);
ts2 = Timestamp64(2021, 1, 1, 0, 0, 2);

dt1 = DateTime(2021, 1, 1, 0, 0, 1);
dt2 = DateTime(2021, 1, 1, 0, 0, 2);

@btime $ts2 - $ts1;
@btime $dt2 - $dt1;
```

#### Result

Identical performance for both `Timestamp64` and `DateTime` types.

```console
julia> @btime $ts2 - $ts1;
  1.356 ns (0 allocations: 0 bytes)

julia> @btime $dt2 - $dt1;
  1.358 ns (0 allocations: 0 bytes)
```

### Access UNIX timestamp in seconds

```julia
using BenchmarkTools
using Timestamps64
using Dates

ts = Timestamp64(2021, 1, 1, 0, 0, 1) + Millisecond(123);
dt = DateTime(2021, 1, 1, 0, 0, 1) + Millisecond(123);

@btime unix_secs($ts);
@btime trunc(Int64, datetime2unix($dt));
```

#### Result

Due to the internal representation of the `Timestamp64` value as UNIX timestamp in nanoseconds, the conversion to a UNIX timestamp in seconds is trivial and therefore **2.3 times faster** compared to Julia's built-in `DateTime` type using the `datetime2unix` function.

```console
julia> @btime unix_secs($ts);
  1.571 ns (0 allocations: 0 bytes)

julia> @btime trunc(Int64, datetime2unix($dt));
  3.654 ns (0 allocations: 0 bytes)
```

### Access UNIX timestamp in milliseconds

```julia
using BenchmarkTools
using Timestamps64
using Dates

ts = Timestamp64(2021, 1, 1, 0, 0, 1) + Millisecond(123);
dt = DateTime(2021, 1, 1, 0, 0, 1) + Millisecond(123);

@btime unix_millis($ts);
@btime trunc(Int64, datetime2unix($dt)*1000);
```

#### Result

Due to the internal representation of the `Timestamp64` value as UNIX timestamp in nanoseconds, the conversion to a UNIX timestamp in seconds is trivial and therefore **2.6 times faster** compared to Julia's built-in `DateTime` type using the `datetime2unix` function.

```console
julia> @btime unix_millis($ts);
  1.729 ns (0 allocations: 0 bytes)

julia> @btime trunc(Int64, datetime2unix($dt)*1000);
  4.420 ns (0 allocations: 0 bytes)
```

### Create object from UNIX timestamp in milliseconds

```julia
using BenchmarkTools
using Timestamps64
using Dates

unix_millis = 1609459201000; # 2021-01-01T00:00:01.000000000

@btime Timestamp64($unix_millis * 1_000_000);
@btime unix2datetime($unix_millis / 1000);
```

#### Result

The `Timestamp64` type is **3.3 times faster** at creating a timestamp from a UNIX timestamp in milliseconds compared to Julia's built-in `DateTime` type! This is partly due to the additional division operation required for the `DateTime` type.

```console
julia> @btime Timestamp64($unix_millis * 1_000_000);
  1.378 ns (0 allocations: 0 bytes)

julia> @btime unix2datetime($unix_millis / 1000);
  4.507 ns (0 allocations: 0 bytes)
```

### Create object from UNIX timestamp in seconds

```julia
using BenchmarkTools
using Timestamps64
using Dates

unix_secs = 1609459201; # 2021-01-01T00:00:01.000000000

@btime Timestamp64($unix_secs * 1_000_000_000);
@btime unix2datetime($unix_secs);
```

#### Result

Almost identical performance for both `Timestamp64` and `DateTime` types.

```console
julia> @btime Timestamp64($unix_secs * 1_000_000_000);
  1.539 ns (0 allocations: 0 bytes)

julia> @btime unix2datetime($unix_secs);
  1.570 ns (0 allocations: 0 bytes)
```

## Bug reports and feature requests

Please report any issues via the [GitHub issue tracker](https://github.com/rbeeli/Timestamps64.jl/issues).
