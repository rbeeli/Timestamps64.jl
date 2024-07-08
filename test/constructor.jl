using Test
using Dates
using Timestamp64

@testset verbose = true "Constructor" begin

    @testset "zero(Timestamp)" begin
        @test zero(Timestamp) == Timestamp(0)
    end

    @testset "DateTime(1970, 1, 1, 0, 0, 0)" begin
        dt = DateTime(1970, 1, 1, 0, 0, 0)
        ts = Timestamp(dt)
        @test ts.ts == 0
        @test DateTime(ts) == dt
    end

    @testset "Date(1970, 1, 1)" begin
        dt = Date(1970, 1, 1)
        ts = Timestamp(dt)
        @test ts.ts == 0
        @test Date(ts) == dt
    end

    @testset "Date(2021, 12, 31)" begin
        dt = Date(2021, 12, 31)
        ts = Timestamp(dt)
        @test Date(ts) == dt
    end

    @testset "DateTime(2020, 1, 1, 0, 0, 0)" begin
        dt = DateTime(2020, 1, 1, 0, 0, 0)
        ts = Timestamp(dt)
        @test ts.ts == 1577836800000000000
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        @test DateTime(ts) == dt
    end

    @testset "DateTime(2020, 1, 1, 0, 0, 0)" begin
        dt = DateTime(2020, 1, 1, 0, 0, 0)
        ts = Timestamp(dt)
        @test ts.ts == 1577836800000000000
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        @test DateTime(ts) == dt
    end

    @testset "Timestamp(0)" begin
        ts = Timestamp(0)
        @test DateTime(ts) == DateTime(1970, 1, 1, 0, 0, 0)
        @test ts.ts == 0
    end

    @testset "Timestamp(typemax(Int64))" begin
        ts = Timestamp(typemax(Int64))
        @test DateTime(ts) == DateTime(2262, 4, 11, 23, 47, 16, 854)
        @test ts.ts == typemax(Int64)
    end

    @testset "Timestamp(1577836800000000000)" begin
        ts = Timestamp(1577836800000000000)
        @test DateTime(ts) == DateTime(2020, 1, 1, 0, 0, 0)
        @test ts.ts == 1577836800000000000
    end

    @testset "Timestamp([yr], [mth], [d])" begin
        for dt in DateTime(1970,1,1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp(year(dt), month(dt), day(dt))
            @test DateTime(ts) == dt
            @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        end
    end

    @testset "Timestamp([yr], [mth], [d], [hr], [min], [sec])" begin
        for dt in DateTime(1970,1,1):Day(1):DateTime(2262, 4, 11)
            dt += Hour(12) + Minute(34) + Second(56)
            ts = Timestamp(year(dt), month(dt), day(dt), 12, 34, 56)
            @test DateTime(ts) == dt
            @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
            @test year(ts) == year(dt)
            @test month(ts) == month(dt)
            @test day(ts) == day(dt)
            @test hour(ts) == 12
            @test minute(ts) == 34
            @test second(ts) == 56
        end
    end

    @testset "Timestamp(\"2021-01-01T00:00:01\")" begin
        ts = Timestamp("2021-01-01T00:00:01")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 1)
    end

    @testset "Timestamp(\"2021-01-01T00:00:01Z\")" begin
        ts = Timestamp("2021-01-01T00:00:01Z")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 1)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.001\")" begin
        ts = Timestamp("2021-01-01T00:00:00.001")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1_000_000)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.001Z\")" begin
        ts = Timestamp("2021-01-01T00:00:00.001Z")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1_000_000)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.000001\")" begin
        ts = Timestamp("2021-01-01T00:00:00.000001")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1_000)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.000001Z\")" begin
        ts = Timestamp("2021-01-01T00:00:00.000001Z")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1_000)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.000000001\")" begin
        ts = Timestamp("2021-01-01T00:00:00.000000001")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1)
    end

    @testset "Timestamp(\"2021-01-01T00:00:00.000000001Z\")" begin
        ts = Timestamp("2021-01-01T00:00:00.000000001Z")
        @test ts == Timestamp(2021, 1, 1, 0, 0, 0, 1)
    end

    @testset "Timestamp(\"2021-02-03T04:05:06.789123456\")" begin
        ts = Timestamp("2021-02-03T04:05:06.789123456")
        @test DateTime(ts) == DateTime(2021, 2, 3, 4, 5, 6, 789)
        @test ts == Timestamp(2021, 2, 3, 4, 5, 6, 789123456)
    end

    @testset "Timestamp(\"2021-02-03T04:05:06.789123456Z\")" begin
        ts = Timestamp("2021-02-03T04:05:06.789123456Z")
        @test DateTime(ts) == DateTime(2021, 2, 3, 4, 5, 6, 789)
        @test ts == Timestamp(2021, 2, 3, 4, 5, 6, 789123456)
    end

    @testset "timestamp_now()" begin
        ts = timestamp_now()
        dt = Dates.now()
        @test dt - DateTime(ts) < Millisecond(10)
    end

    @testset "timestamp_today()" begin
        ts = timestamp_today()
        dt = Dates.today()
        @test DateTime(ts) == dt
    end

end
