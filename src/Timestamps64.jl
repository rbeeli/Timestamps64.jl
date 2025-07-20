module Timestamps64

@static if Sys.WORD_SIZE != 64
    error("Timestamps64.jl only supports 64-bit systems")
end

@static if Sys.iswindows()
    error("Timestamps64.jl is currently not supporting Windows systems")
end

export Timestamp64,
    ISOTimestamp64Format,
    RFC3339Timestamp64Format,
    iso8601,
    rfc3339,
    unix_nanos,
    unix_micros,
    unix_millis,
    unix_secs,
    unix

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

end # module Timestamps64
