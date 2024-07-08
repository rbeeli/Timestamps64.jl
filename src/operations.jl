import Base: +, -, isless
import Dates

"""
Add a `Period` to a `Timestamp64`.
"""
@inline function +(timestamp::Timestamp64, period::Dates.Period)
    Timestamp64(timestamp.ts + Dates.Nanosecond(period).value)
end

"""
Subtract a `Period` from a `Timestamp64`.
"""
@inline function -(timestamp::Timestamp64, period::Dates.Period)
    Timestamp64(timestamp.ts - Dates.Nanosecond(period).value)
end

"""
Subtract two `Timestamp64`s to get a `Period`.
"""
@inline -(t1::Timestamp64, t2::Timestamp64) = Dates.Nanosecond(t1.ts - t2.ts)

"""
Compare two `Timestamp64`s whether the first is less than the second (earlier in time).
"""
@inline isless(t1::Timestamp64, t2::Timestamp64) = t1.ts < t2.ts
