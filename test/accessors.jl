using Test
using Dates
using Timestamps64

@testset verbose = true "Accessors" begin

    @testset "Dates.year" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test year(ts) == year(dt)
        end
    end

    @testset "Dates.month" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test month(ts) == month(dt)
        end
    end

    @testset "Dates.day" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test day(ts) == day(dt)
        end
    end

    @testset "Dates.days" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test Dates.days(ts) == Dates.days(dt)
        end
    end

    @testset "Dates.yearmonth" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test yearmonth(ts) == yearmonth(dt)
        end
    end

    @testset "Dates.yearmonthday" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test yearmonthday(ts) == yearmonthday(dt)
        end
    end

    @testset "Dates.monthday" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test monthday(ts) == monthday(dt)
        end
    end

    @testset "Dates.isleapyear" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test isleapyear(ts) == isleapyear(dt)
        end
    end

    @testset "Dates.dayofweek" begin
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(dt)
            @test dayofweek(ts) == dayofweek(dt)
        end
    end

    @testset "Dates.hour" begin
        ts = Timestamp64(2020, 1, 1, 12, 0, 0)
        @test hour(ts) == 12
    end

    @testset "Dates.minute" begin
        ts = Timestamp64(2020, 1, 1, 0, 34, 0)
        @test minute(ts) == 34
    end

    @testset "Dates.second" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 56)
        @test second(ts) == 56
    end

    @testset "Dates.millisecond" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, Dates.value(Nanosecond(Millisecond(789))))
        @test millisecond(ts) == 789
    end

    @testset "Dates.microsecond" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, Dates.value(Nanosecond(Microsecond(789))))
        @test microsecond(ts) == 789
    end

    @testset "Dates.nanosecond" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, 789) # 789 nanoseconds
        @test nanosecond(ts) == 789
    end

    @testset "unix_nanos" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, 789) # 789 nanoseconds
        @test unix_nanos(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^3) + 789
    end

    @testset "unix_micros" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, 789) # 789 nanoseconds
        @test unix_micros(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000^2)
    end

    @testset "unix_millis" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, 789) # 789 nanoseconds
        @test unix_millis(ts) == trunc(Int64, datetime2unix(DateTime(ts)) * 1_000)
    end

    @testset "unix_secs" begin
        ts = Timestamp64(2020, 1, 1, 0, 0, 0, 789) # 789 nanoseconds
        @test unix_secs(ts) == trunc(Int64, datetime2unix(DateTime(ts)))
    end

end
