using Test
using Dates
using Timestamps64

@testset verbose = true "Operations" begin
    @testset "+ FixedPeriod" begin
        periods = [
            Week(1),
            Day(1),
            Hour(1),
            Minute(1),
            Second(1),
            Millisecond(1),
            Microsecond(1),
            Nanosecond(1),
        ]

        for period in periods
            ts = Timestamp64(2020, 1, 1) + period
            @test ts ==
                Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=Dates.value(Nanosecond(period)))
            if period ∉ [Microsecond(1), Nanosecond(1)]
                @test DateTime(ts) == DateTime(2020, 1, 1) + period
            end
        end
    end

    @testset "+ Month, Quarter, Year" begin
        periods = [Month(1), Quarter(1), Year(1)]

        for period in periods
            ts = Timestamp64(2020, 1, 1) + period
            @test DateTime(ts) == DateTime(2020, 1, 1) + period
        end
    end

    @testset "- FixedPeriod" begin
        periods = [
            Week(1),
            Day(1),
            Hour(1),
            Minute(1),
            Second(1),
            Millisecond(1),
            Microsecond(1),
            Nanosecond(1),
        ]

        for period in periods
            ts = Timestamp64(2020, 1, 1) - period
            @test ts ==
                Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=-Dates.value(Nanosecond(period)))
            if period ∉ [Microsecond(1), Nanosecond(1)]
                @test DateTime(ts) == DateTime(2020, 1, 1) - period
            end
        end
    end

    @testset "- Month, Quarter, Year" begin
        periods = [Month(1), Quarter(1), Year(1)]

        for period in periods
            ts = Timestamp64(2020, 1, 1) - period
            @test DateTime(ts) == DateTime(2020, 1, 1) - period
        end
    end

    @testset "Difference type == Dates.Nanosecond" begin
        ts1 = Timestamp64(2020, 1, 1)
        ts2 = Timestamp64(2020, 1, 2)
        @test typeof(ts2 - ts1) == Nanosecond
    end

    @testset "Difference [days]" begin
        ts1 = Timestamp64(2020, 1, 1)
        ts2 = Timestamp64(2020, 1, 2)
        @test Dates.Day(ts2 - ts1) == Day(1)
    end

    @testset "Difference [ns]" begin
        ts1 = Timestamp64(2020, 1, 1)
        ts2 = Timestamp64(2020, 1, 2)
        @test ts2 - ts1 == Nanosecond(Day(1))
    end
end
