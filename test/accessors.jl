using Test
using Dates
using Timestamp64

@testset verbose = true "Dates accessors" begin

    @testset "Dates.year" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0)
        @test Dates.year(ts) == 2020
    end

    @testset "Dates.month" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0)
        @test Dates.month(ts) == 1
    end

    @testset "Dates.day" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0)
        @test Dates.day(ts) == 1
    end

    @testset "Dates.hour" begin
        ts = Timestamp(2020, 1, 1, 12, 0, 0)
        @test Dates.hour(ts) == 12
    end

    @testset "Dates.minute" begin
        ts = Timestamp(2020, 1, 1, 0, 34, 0)
        @test Dates.minute(ts) == 34
    end

    @testset "Dates.second" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 56)
        @test Dates.second(ts) == 56
    end

    @testset "Dates.millisecond" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, Dates.value(Nanosecond(Millisecond(789))))
        @test Dates.millisecond(ts) == 789
    end

    @testset "Dates.microsecond" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, Dates.value(Nanosecond(Microsecond(789))))
        @test Dates.microsecond(ts) == 789
    end

    @testset "Dates.nanosecond" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, 789)
        @test Dates.nanosecond(ts) == 789
    end

    @testset "unix_nanos" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, 789)
        @test unix_nanos(ts) == Dates.value(ts)
    end

    @testset "unix_micros" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, 789)
        @test unix_micros(ts) == Dates.value(ts) ÷ 1_000
    end

    @testset "unix_millis" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, 789)
        @test unix_millis(ts) == Dates.value(ts) ÷ 1_000_000
    end

    @testset "unix_secs" begin
        ts = Timestamp(2020, 1, 1, 0, 0, 0, 789)
        @test unix_secs(ts) == Dates.value(ts) ÷ 1_000_000_000
    end

end
