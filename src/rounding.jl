import Dates

@inline function Base.floor(timestamp::Timestamp64, p::Dates.TimePeriod)
    nanos = timestamp.ts
    period_nanos = Dates.value(Dates.Nanosecond(p))
    Timestamp64(nanos - mod(nanos, period_nanos))
end

@inline function Base.floor(timestamp::Timestamp64, p::Dates.DatePeriod)
    Timestamp64(floor(Dates.Date(timestamp), p))
end
