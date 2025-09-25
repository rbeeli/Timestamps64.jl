


# # Implement step function
# function step(start::Timestamp64, stop::Timestamp64, step::Period)
#     step_ns = Nanosecond(step).value
#     start:step_ns:stop
# end

# # Make Timestamp64 iterable
# function iterate(r::StepRange{Timestamp64, Int64}, i=r.start)
#     i > r.stop && return nothing
#     (Timestamp64(i), i + r.step)
# end

# # Define iterator size
# IteratorSize(::Type{<:StepRange{Timestamp64}}) = SizeUnknown()

using Timestamps64
using Dates
import Base: (:)

# Given a start and end date, how many steps/periods are in between (see Julia ranges.jl)
guess(a::Timestamp64, b::Timestamp64, c::T) where T = floor(Int64, (b.ts - a.ts) / Dates.tons(c))

function Dates.len(a::Timestamp64, b::Timestamp64, c)
    lo, hi, st = min(a, b), max(a, b), abs(c)
    i = guess(a, b, c)
    v = lo + st * i
    prev = v  # Ensure `v` does not overflow
    while v <= hi && prev <= v
        prev = v
        v += st
        i += 1
    end
    return i - 1
end

function (:)(start::Timestamp64, step::T, stop::Timestamp64) where T
    StepRange{Timestamp64,T}(start, step, stop)
end

collect(Timestamp64(0):Day(1):now(Timestamp64))
