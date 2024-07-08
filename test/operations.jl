using Test
using Dates
using Timestamp64

@testset verbose = true "Operations" begin

    @testset "Add Julia Period" begin
        periods = [Dates.Week(1), Dates.Day(1), Dates.Hour(1),
        Dates.Minute(1), Dates.Second(1), Dates.Millisecond(1), Dates.Microsecond(1), Dates.Nanosecond(1)]
        
        for period in periods
            ts = Timestamp(2020, 1, 1) + period
            @test ts == Timestamp(2020, 1, 1, 0, 0, 0, Dates.value(Nanosecond(period)))
            if period ∉ [Dates.Microsecond(1), Dates.Nanosecond(1)]
                @test DateTime(ts) == DateTime(2020, 1, 1) + period
            end
        end
    end

    @testset "Subtract Julia Period" begin
        periods = [Dates.Week(1), Dates.Day(1), Dates.Hour(1),
        Dates.Minute(1), Dates.Second(1), Dates.Millisecond(1), Dates.Microsecond(1), Dates.Nanosecond(1)]
        
        for period in periods
            ts = Timestamp(2020, 1, 1) - period
            @test ts == Timestamp(2020, 1, 1, 0, 0, 0, -Dates.value(Nanosecond(period)))
            if period ∉ [Dates.Microsecond(1), Dates.Nanosecond(1)]
                @test DateTime(ts) == DateTime(2020, 1, 1) - period
            end
        end
    end

    @testset "Difference type == Dates.Nanosecond" begin
        ts1 = Timestamp(2020, 1, 1)
        ts2 = Timestamp(2020, 1, 2)
        @test typeof(ts2 - ts1) == Nanosecond
    end

    @testset "Difference [days]" begin
        ts1 = Timestamp(2020, 1, 1)
        ts2 = Timestamp(2020, 1, 2)
        @test Dates.Day(ts2 - ts1) == Day(1)
    end

    @testset "Difference [ns]" begin
        ts1 = Timestamp(2020, 1, 1)
        ts2 = Timestamp(2020, 1, 2)
        @test ts2 - ts1 == Nanosecond(Day(1))
    end

    @testset "isless" begin
        ts1 = Timestamp(2020, 1, 1)
        ts2 = Timestamp(2020, 1, 2)
        @test isless(ts1, ts2)
        @test ts1 < ts2
    end

end
