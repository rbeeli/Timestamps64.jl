module Timestamps64

@static if Base.Sys.WORD_SIZE != 64
    error("Timestamps64.jl only supports 64-bit systems")
end

export Timestamp64,
       ISOTimestamp64Format,
       iso8601,
       unix_nanos,
       unix_micros,
       unix_millis,
       unix_secs

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

end # module Timestamp
