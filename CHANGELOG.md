# Changelog

## [0.5.0] – 2025‑07‑20

### Added

-   New `rfc3339` formatting function (adds trailing `Z`, `iso8601` doesn't)
-   New `Dates.DateFormat` template `RFC3339Timestamp64Format`
-   Compile-time check for Windows platforms (not supported)

### Changed

-   Optimized implementation of `iso8601`

## [0.4.0] – 2025‑07‑20

### Breaking ⚠️

-   Last constructor argument of `Timestamp64` now a keyword argument to avoid ambiguity with `DateTime` last argument being milliseconds.

    ```julia
    Timestamp64(year::Int, month::Int, day::Int)
    Timestamp64(year::T, month::T, day::T) where {T<:Integer}
    Timestamp64(year::Int, month::Int, day::Int, hours::Int, minutes::Int=0, seconds::Int=0; nanoseconds::Int=0)
    ```

### Added

-   Export `unix` function
-   Unit tests for `unix` function

### Changed

-   Removed internal function `_local_tz_offset_sec` and replaced with `Base.Libc.TmStruct` call

## [0.3.0] – 2025‑07‑19

### Breaking ⚠️

-   `Dates.now(::Type{Timestamp64})` and `Dates.today(::Type{Timestamp64})` return local time zone timestamps (before UTC) to be consistent with `Dates.now()` and `Dates.today()`

### Added

-   Functions `today(Timestamp64, UTC)`
-   Set minimum required Julia version restriction to 1.9

### Changed

-   Replaced dynamic package symbols export with fixed list for better IDE integration and static analysis
