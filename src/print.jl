"""
    show(io::IO, timestamp::Timestamp)

Print a `Timestamp64` to the given `IO` stream as an ISO 8601 string.
See function `iso8601` for implementation details.

# Examples

    "2025-07-20T12:34:56.123456789"
"""
Base.show(io::IO, timestamp::Timestamp64) = print(io, iso8601(timestamp))

"""
    Base.show(io::IO, ::MIME"text/plain", ts::Timestamp64)

Print a `Timestamp64` to the given `IO` stream as an ISO 8601 string.
See function `iso8601` for implementation details.

# Examples

    "2025-07-20T12:34:56.123456789"
"""
Base.show(io::IO, ::MIME"text/plain", timestamp::Timestamp64) = print(io, iso8601(timestamp))
