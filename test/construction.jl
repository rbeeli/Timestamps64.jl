using Test
using Dates
using Timestamps64

@testset verbose = true "Construction" begin

    @testset "DateTime(1970, 1, 1, 0, 0, 0)" begin
        dt = DateTime(1970, 1, 1, 0, 0, 0)
        ts = Timestamp64(dt)
        @test ts.ts == 0
        @test DateTime(ts) == dt
    end

    @testset "Date(1970, 1, 1)" begin
        dt = Date(1970, 1, 1)
        ts = Timestamp64(dt)
        @test ts.ts == 0
        @test Date(ts) == dt
    end

    @testset "Date(2021, 12, 31)" begin
        dt = Date(2021, 12, 31)
        ts = Timestamp64(dt)
        @test Date(ts) == dt
    end

    @testset "DateTime(2020, 1, 1, 0, 0, 0)" begin
        dt = DateTime(2020, 1, 1, 0, 0, 0)
        ts = Timestamp64(dt)
        @test ts.ts == 1577836800000000000
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        @test DateTime(ts) == dt
    end

    @testset "DateTime(2020, 1, 1, 0, 0, 0)" begin
        dt = DateTime(2020, 1, 1, 0, 0, 0)
        ts = Timestamp64(dt)
        @test ts.ts == 1577836800000000000
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        @test DateTime(ts) == dt
    end

    @testset "from Date and Time" begin
        date = Date(2020, 1, 1)
        time = Time(23, 24, 35) + Nanosecond(123456789)
        @test Timestamp64(date, time) == Timestamp64(2020, 1, 1, 23, 24, 35, 123456789)
    end

    @testset "Timestamp64(0)" begin
        ts = Timestamp64(0)
        @test DateTime(ts) == DateTime(1970, 1, 1, 0, 0, 0)
        @test ts.ts == 0
    end

    @testset "Timestamp64(typemax(Int64))" begin
        ts = Timestamp64(typemax(Int64))
        @test DateTime(ts) == DateTime(2262, 4, 11, 23, 47, 16, 854)
        @test ts.ts == typemax(Int64)
    end

    @testset "Timestamp64(1577836800000000000)" begin
        ts = Timestamp64(1577836800000000000)
        @test DateTime(ts) == DateTime(2020, 1, 1, 0, 0, 0)
        @test ts.ts == 1577836800000000000
    end

    @testset "Timestamp64([yr], [mth], [d])" begin
        for dt in DateTime(1970,1,1):Day(1):DateTime(2262, 4, 11)
            ts = Timestamp64(year(dt), month(dt), day(dt))
            @test DateTime(ts) == dt
            @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        end
    end

    @testset "Timestamp64([yr], [mth], [d], [hr], [min], [sec])" begin
        for dt in DateTime(1970,1,1):Day(1):DateTime(2262, 4, 11)
            dt += Hour(12) + Minute(34) + Second(56)
            ts = Timestamp64(year(dt), month(dt), day(dt), 12, 34, 56)
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

    @testset "now(Timestamp64)" begin
        ts = now(Timestamp64)
        dt = Dates.now()
        @test dt - DateTime(ts) < Millisecond(5)
    end

    @testset "now(Timestamp64, UTC)" begin
        ts = now(Timestamp64, UTC)
        dt = Dates.now(UTC)
        @test dt - DateTime(ts) < Millisecond(5)
    end

    @testset "today(Timestamp64)" begin
        ts = today(Timestamp64)
        dt = Dates.today()
        @test DateTime(ts) == dt
    end

end
