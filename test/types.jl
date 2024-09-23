using Test
using Dates
using Timestamps64

@testset verbose = true "Types" begin

    @testset "zero(Timestamp64)" begin
        @test zero(Timestamp64) == Timestamp64(0)
    end

    @testset "iszero" begin
        @test iszero(zero(Timestamp64))
        @test iszero(Timestamp64(0))
        @test iszero(typemin(Timestamp64))
    end

    @testset "isless" begin
        ts1 = Timestamp64(2020, 1, 1)
        ts2 = Timestamp64(2020, 1, 2)
        @test isless(ts1, ts2)
        @test ts1 < ts2
    end

    @testset "eps(Timestamp64)" begin
        @test eps(Timestamp64) == Nanosecond(1)
    end

    @testset "typemin(Timestamp64)" begin
        @test typemin(Timestamp64) == Timestamp64(0)
        @test typemin(Timestamp64) == zero(Timestamp64)
        @test string(typemin(Timestamp64)) == "1970-01-01T00:00:00.000000000"
    end

    @testset "typemax(Timestamp64)" begin
        @test typemax(Timestamp64) == Timestamp64(typemax(Int64))
        @test string(typemax(Timestamp64)) == "2262-04-11T23:47:16.854775807"
    end

    @testset "type promotion for Date and DateTime" begin
        @test Date(2020, 1, 1) < Timestamp64(2020, 1, 2)
        @test Timestamp64(2020, 1, 1) < Date(2020, 1, 2)
        @test DateTime(2020, 1, 1, 0, 0, 0) < Timestamp64(2020, 1, 2)
        @test Timestamp64(2020, 1, 1) < DateTime(2020, 1, 2, 0, 0, 0)
    end

    @testset "convert support" begin
        @test convert(Timestamp64, DateTime(2020, 1, 1, 0, 0, 0)) == Timestamp64(2020, 1, 1)
        @test convert(Timestamp64, Date(2020, 1, 1)) == Timestamp64(2020, 1, 1)
        @test convert(Date, Timestamp64(2020, 1, 1)) == Date(2020, 1, 1)
        @test convert(DateTime, Timestamp64(2020, 1, 1)) == DateTime(2020, 1, 1, 0, 0, 0)
    end

end
