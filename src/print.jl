"""
    show(io::IO, timestamp::Timestamp)

Print a `Timestamp64` to the given `IO` stream as an ISO 8601 string.
See function `iso8601` for implementation details.
"""
Base.show(io::IO, timestamp::Timestamp64) = print(io, iso8601(timestamp))
