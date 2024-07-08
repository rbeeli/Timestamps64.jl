import Dates
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
    i - 1
end

@inline function (:)(start::Timestamp64, step::T, stop::Timestamp64) where T
    StepRange{Timestamp64,T}(start, step, stop)
end
