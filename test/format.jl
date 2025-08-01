using Test
using Dates
using Timestamps64

@testset verbose = true "Format" begin
    @testset "Dates.format([ts], Dates.ISODateTimeFormat)" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test Dates.format(ts, Dates.ISODateTimeFormat) == "2021-02-03T04:05:06.789456123"
    end

    @testset "Dates.format([ts], ISOTimestamp64Format)" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test Dates.format(ts, ISOTimestamp64Format) == "2021-02-03T04:05:06.789456123"
    end

    @testset "Dates.format([ts], RFC3339Timestamp64Format)" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test Dates.format(ts, RFC3339Timestamp64Format) == "2021-02-03T04:05:06.789456123Z"
    end

    @testset "iso8601([ts])" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test iso8601(ts) == "2021-02-03T04:05:06.789456123"
    end

    @testset "rfc3339([ts])" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test rfc3339(ts) == "2021-02-03T04:05:06.789456123Z"
    end

    @testset "string([ts])" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789456123)
        @test string(ts) == "2021-02-03T04:05:06.789456123"
        @test string(ts) == iso8601(ts)
    end

    @testset "Base.show overloads" begin
        ts = Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789_456_123)
        expected = "2021-02-03T04:05:06.789456123"

        # two‑argument show(io, x)
        str2 = sprint(show, ts) # capture output → String
        @test str2 == expected

        # three‑argument show(io, MIME"text/plain"(), x)
        str3 = sprint(show, MIME"text/plain"(), ts)
        @test str3 == expected

        # string(x) is consistent
        @test string(ts) == expected  # string() calls show indirectly
    end
end
