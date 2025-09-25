using TestItemRunner

@testitem "Accessors: Dates.year" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test year(ts) == year(dt)
    end
end

@testitem "Accessors: Dates.month" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test month(ts) == month(dt)
    end
end

@testitem "Accessors: Dates.day" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test day(ts) == day(dt)
    end
end

@testitem "Accessors: Dates.days" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test Dates.days(ts) == Dates.days(dt)
    end
end

@testitem "Accessors: Dates.yearmonth" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test yearmonth(ts) == yearmonth(dt)
    end
end

@testitem "Accessors: Dates.yearmonthday" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test yearmonthday(ts) == yearmonthday(dt)
    end
end

@testitem "Accessors: Dates.monthday" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test monthday(ts) == monthday(dt)
    end
end

@testitem "Accessors: Dates.isleapyear" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test isleapyear(ts) == isleapyear(dt)
    end
end

@testitem "Accessors: Dates.dayofweek" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(dt)
        @test dayofweek(ts) == dayofweek(dt)
    end
end

@testitem "Accessors: Dates.hour" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 12, 0, 0)
    @test hour(ts) == 12
end

@testitem "Accessors: Dates.minute" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 34, 0)
    @test minute(ts) == 34
end

@testitem "Accessors: Dates.second" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 56)
    @test second(ts) == 56
end

@testitem "Accessors: Dates.millisecond" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=Dates.value(Nanosecond(Millisecond(789))))
    @test millisecond(ts) == 789
end

@testitem "Accessors: Dates.microsecond" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=Dates.value(Nanosecond(Microsecond(789))))
    @test microsecond(ts) == 789
end

@testitem "Accessors: Dates.nanosecond" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test nanosecond(ts) == 789
end

@testitem "Accessors: unix_nanos" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix_nanos(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^3) + 789
end

@testitem "Accessors: unix_micros" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix_micros(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^2)
end

@testitem "Accessors: unix_millis" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix_millis(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000)
end

@testitem "Accessors: unix_secs" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix_secs(ts) == trunc(Int64, datetime2unix(DateTime(ts)))
end

@testitem "Accessors: unix(Dates.Nanosecond, ts)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix(Dates.Nanosecond, ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^3) + 789
end

@testitem "Accessors: unix(Dates.Microsecond, ts)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix(Dates.Microsecond, ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^2)
end

@testitem "Accessors: unix(Dates.Millisecond, ts)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix(Dates.Millisecond, ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000)
end

@testitem "Accessors: unix(Dates.Second, ts)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=789)
    @test unix(Dates.Second, ts) == trunc(Int64, datetime2unix(DateTime(ts)))
end
