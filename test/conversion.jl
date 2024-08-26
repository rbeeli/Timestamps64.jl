using Test
using Dates
using Timestamps64

@testset verbose = true "Conversion" begin

    @testset "DateTime(Timestamp64(1970, 1, 1))" begin
        dt = DateTime(Timestamp64(1970, 1, 1))
        @test dt == DateTime(1970, 1, 1)
    end

    @testset "DateTime(Timestamp64(2020, 1, 1, 2, 3, 4))" begin
        dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4))
        @test dt == DateTime(2020, 1, 1, 2, 3, 4)
    end

    @testset "DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, 987)) (987=ns)" begin
        # only keeps millisecond precision
        dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, 987))
        @test dt == DateTime(2020, 1, 1, 2, 3, 4, 0)
    end

    @testset "DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))" begin
        # only keeps millisecond precision
        dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))
        @test dt == DateTime(2020, 1, 1, 2, 3, 4, 987)
    end

    @testset "Date(Timestamp64(2020, 1, 1, 0, 0, 0, 1))" begin
        # truncates to Date part only
        dt = Date(Timestamp64(2020, 1, 1, 0, 0, 0, 1))
        @test dt == Date(2020, 1, 1)
    end

    @testset "Date(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))" begin
        # truncates to Date part only
        dt = Date(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))
        @test dt == Date(2020, 1, 1)
    end

    @testset "Time(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))" begin
        # truncates to Time part only
        dt = Time(Timestamp64(2020, 1, 1, 2, 3, 4, 987000000))
        @test dt == Time(2, 3, 4, 987)
    end

end
