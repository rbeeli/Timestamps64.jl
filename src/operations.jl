import Base: +, -, isless
import Dates: hour, minute, second, nanosecond, yearmonthday, daysinmonth, yearwrap, monthwrap

"""
Add a `Period` to a `Timestamp64`.
"""
@inline function +(timestamp::Timestamp64, period::Dates.FixedPeriod)
    Timestamp64(timestamp.ts + Dates.Nanosecond(period).value)
end

"""
Subtract a `Period` from a `Timestamp64`.
"""
@inline function -(timestamp::Timestamp64, period::Dates.FixedPeriod)
    Timestamp64(timestamp.ts - Dates.Nanosecond(period).value)
end

function (+)(ts::Timestamp64, y::Dates.Year)
    oy, m, d = yearmonthday(ts)
    ny = oy + Dates.value(y)
    ld = daysinmonth(ny, m)
    Timestamp64(ny, m, d <= ld ? d : ld, hour(ts), minute(ts), second(ts), nanosecond(ts))
end
function (-)(ts::Timestamp64, y::Dates.Year)
    oy, m, d = yearmonthday(ts)
    ny = oy - Dates.value(y)
    ld = daysinmonth(ny, m)
    Timestamp64(ny, m, d <= ld ? d : ld, hour(ts), minute(ts), second(ts), nanosecond(ts))
end
function (+)(ts::Timestamp64, z::Dates.Month)
    y, m, d = yearmonthday(ts)
    ny = yearwrap(y, m, Dates.value(z))
    mm = monthwrap(m, Dates.value(z))
    ld = daysinmonth(ny, mm)
    Timestamp64(ny, mm, d <= ld ? d : ld, hour(ts), minute(ts), second(ts), nanosecond(ts))
end
function (-)(ts::Timestamp64, z::Dates.Month)
    y, m, d = yearmonthday(ts)
    ny = yearwrap(y, m, -Dates.value(z))
    mm = monthwrap(m, -Dates.value(z))
    ld = daysinmonth(ny, mm)
    Timestamp64(ny, mm, d <= ld ? d : ld, hour(ts), minute(ts), second(ts), nanosecond(ts))
end
@inline (+)(ts::Timestamp64, y::Dates.Quarter) = ts + Dates.Month(y)
@inline (-)(ts::Timestamp64, y::Dates.Quarter) = ts - Dates.Month(y)

"""
Subtract two `Timestamp64`s to get a `Period`.
"""
@inline -(t1::Timestamp64, t2::Timestamp64) = Dates.Nanosecond(t1.ts - t2.ts)

"""
Compare two `Timestamp64`s whether the first is less than the second (earlier in time).
"""
@inline isless(t1::Timestamp64, t2::Timestamp64) = t1.ts < t2.ts
