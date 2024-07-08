import Base: +, -, isless
import Dates

"""
Add a `Period` to a `Timestamp`.
"""
@inline function +(timestamp::Timestamp, period::Dates.Period)
    Timestamp(timestamp.ts + Dates.Nanosecond(period).value)
end

"""
Subtract a `Period` from a `Timestamp`.
"""
@inline function -(timestamp::Timestamp, period::Dates.Period)
    Timestamp(timestamp.ts - Dates.Nanosecond(period).value)
end

"""
Subtract two `Timestamp`s to get a `Period`.
"""
@inline -(t1::Timestamp, t2::Timestamp) = Dates.Nanosecond(t1.ts - t2.ts)

"""
Compare two `Timestamp`s whether the first is less than the second (earlier in time).
"""
@inline isless(t1::Timestamp, t2::Timestamp) = t1.ts < t2.ts
