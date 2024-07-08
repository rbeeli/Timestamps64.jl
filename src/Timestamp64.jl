module Timestamp64

import Dates

"""
Timestamp object which stores nanoseconds since UNIX epoch.

The underlying integer is a 64-bit signed integer which can store nanoseconds
from `1970-01-01T00:00:00.000000000` to `2262-04-11 23:47:16.854775807`.
"""
struct Timestamp <: Dates.AbstractDateTime
    ts::Int64
    Timestamp(ts::UInt64) = new(Int64(ts))
    Timestamp(ts::Int64) = new(ts)

    # ts::Dates.UTInstant{Dates.Nanosecond}
    # Timestamp(ts::UInt64) = new(Dates.UTInstant{Dates.Nanosecond}(Dates.Nanosecond(ts)))
    # Timestamp(ts::Int64) = new(Dates.UTInstant{Dates.Nanosecond}(Dates.Nanosecond(ts)))
end

include("constructor.jl")
include("accessors.jl")
include("operations.jl")
include("conversion.jl")
include("format.jl")
include("print.jl")

# export all
for n in names(@__MODULE__; all=true)
    if Base.isidentifier(n) && n ∉ (Symbol(@__MODULE__), :eval, :include)
        @eval export $n
    end
end

end # module Timestamp
