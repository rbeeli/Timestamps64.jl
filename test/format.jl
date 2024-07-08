using Test
using Dates
using Timestamps64

@testset verbose = true "Format" begin

    @testset "Dates.format([ts], Dates.ISODateTimeFormat)" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6, 789456123)
        @test Dates.format(ts, Dates.ISODateTimeFormat) == "2021-02-03T04:05:06.789456123"
    end

    @testset "Dates.format([ts], ISOTimestamp64Format)" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6, 789456123)
        @test Dates.format(ts, ISOTimestamp64Format) == "2021-02-03T04:05:06.789456123"
    end

    @testset "iso8601([ts])" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6, 789456123)
        @test iso8601(ts) == "2021-02-03T04:05:06.789456123"
    end

    @testset "string([ts])" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6, 789456123)
        @test string(ts) == "2021-02-03T04:05:06.789456123"
        @test string(ts) == iso8601(ts)
    end

end
