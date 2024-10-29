module Timestamps64

@static if Base.Sys.WORD_SIZE != 64
    error("Timestamps64.jl only supports 64-bit systems")
end

include("types.jl")
include("interop.jl")
include("construction.jl")
include("accessors.jl")
include("operations.jl")
include("conversion.jl")
include("rounding.jl")
include("ranges.jl")
include("format.jl")
include("parse.jl")
include("print.jl")

# export all
for n in names(@__MODULE__; all=true)
    if Base.isidentifier(n) && n ∉ (Symbol(@__MODULE__), :eval, :include) && !startswith(string(n), "_")
        @eval export $n
    end
end

end # module Timestamp
