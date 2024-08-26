import Dates

"""
Timestamp object which stores nanoseconds since UNIX epoch.

The underlying integer is a 64-bit signed integer which can store nanoseconds
from `1970-01-01T00:00:00.000000000` to `2262-04-11 23:47:16.854775807`.
"""
struct Timestamp64 <: Dates.AbstractDateTime
    ts::Int64
    Timestamp64(ts::UInt64) = new(Int64(ts))
    Timestamp64(ts::Int64) = new(ts)

    # ts::Dates.UTInstant{Dates.Nanosecond}
    # Timestamp64(ts::UInt64) = new(Dates.UTInstant{Dates.Nanosecond}(Dates.Nanosecond(ts)))
    # Timestamp64(ts::Int64) = new(Dates.UTInstant{Dates.Nanosecond}(Dates.Nanosecond(ts)))
end


"""
Return the smallest unit value supported by `Timestamp64`,
which is 1 nanosecond.
"""
@inline Base.eps(::Type{Timestamp64}) = Dates.Nanosecond(1)

@inline Base.zero(::Type{Timestamp64}) = Timestamp64(0)

@inline Base.typemin(::Union{Timestamp64, Type{Timestamp64}}) = Timestamp64(0)
@inline Base.typemax(::Union{Timestamp64, Type{Timestamp64}}) = Timestamp64(typemax(Int64))

"""
Compare two `Timestamp64`s whether the first is less than the second (earlier in time).
"""
@inline Base.isless(t1::Timestamp64, t2::Timestamp64) = t1.ts < t2.ts
