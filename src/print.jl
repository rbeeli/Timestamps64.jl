"""
    show(io::IO, t::Timestamp)

Print a `Timestamp` to the given `IO` stream as an ISO 8601 string.
See function `iso8601` for implementation details.
"""
function Base.show(io::IO, t::Timestamp)
    print(io, iso8601(t))
end
