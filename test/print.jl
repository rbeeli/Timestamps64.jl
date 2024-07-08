using Test
using Dates
using Timestamp64

@testset verbose = true "Base.show" begin

    @testset "Timestamp(DateTime(1970, 1, 1))" begin
        ts = Timestamp(DateTime(1970, 1, 1))
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "1970-01-01T00:00:00.000000000"
    end

    @testset "Timestamp(DateTime(2262, 4, 11))" begin
        ts = Timestamp(DateTime(2262, 4, 11))
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2262-04-11T00:00:00.000000000"
    end

    @testset "Timestamp(DateTime(2020, 1, 1))" begin
        ts = Timestamp(DateTime(2020, 1, 1))
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2020-01-01T00:00:00.000000000"
    end

    @testset "Timestamp(DateTime(2020, 1, 1, 12, 34, 56, 789))" begin
        ts = Timestamp(DateTime(2020, 1, 1, 12, 34, 56, 789))
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2020-01-01T12:34:56.789000000"
    end

    @testset "Timestamp(2020, 1, 1)" begin
        ts = Timestamp(2020, 1, 1)
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2020-01-01T00:00:00.000000000"
    end

    @testset "Timestamp(2020, 1, 1, 12, 34, 56)" begin
        ts = Timestamp(2020, 1, 1, 12, 34, 56)
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2020-01-01T12:34:56.000000000"
    end

    @testset "Timestamp(2020, 1, 1, 12, 34, 56, 123456789)" begin
        ts = Timestamp(2020, 1, 1, 12, 34, 56, 123456789)
        io = IOBuffer()
        show(io, ts)
        @test String(take!(io)) == "2020-01-01T12:34:56.123456789"
    end

end
