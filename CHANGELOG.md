# Changelog

## [0.3.0] – 2025‑07‑19

### Breaking ⚠️

- `Dates.now(::Type{Timestamp64})` and `Dates.today(::Type{Timestamp64})` return local time zone timestamps (before UTC) to be consistent with `Dates.now()` and `Dates.today()`

### Added

- Functions `today(Timestamp64, UTC)`
- Set minimum required Julia version restriction to 1.9

### Changed

- Replaced dynamic package symbols export with fixed list for better IDE integration and best practice
