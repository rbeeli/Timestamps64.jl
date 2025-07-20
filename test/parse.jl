using Test
using Dates
using Timestamps64

@testset verbose = true "Parse" begin
    @testset "Timestamp64(\"2021-01-01T00:00:01\")" begin
        ts = Timestamp64("2021-01-01T00:00:01")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 1)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:01Z\")" begin
        ts = Timestamp64("2021-01-01T00:00:01Z")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 1)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.001\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.001")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1_000_000)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.001Z\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.001Z")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1_000_000)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.000001\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.000001")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1_000)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.000001Z\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.000001Z")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1_000)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.000000001\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.000000001")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1)
    end

    @testset "Timestamp64(\"2021-01-01T00:00:00.000000001Z\")" begin
        ts = Timestamp64("2021-01-01T00:00:00.000000001Z")
        @test ts == Timestamp64(2021, 1, 1, 0, 0, 0; nanoseconds=1)
    end

    @testset "Timestamp64(\"2021-02-03T04:05:06.789123456\")" begin
        ts = Timestamp64("2021-02-03T04:05:06.789123456")
        @test DateTime(ts) == DateTime(2021, 2, 3, 4, 5, 6, 789)
        @test ts == Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456)
    end

    @testset "Timestamp64(\"2021-02-03T04:05:06.789123456Z\")" begin
        ts = Timestamp64("2021-02-03T04:05:06.789123456Z")
        @test DateTime(ts) == DateTime(2021, 2, 3, 4, 5, 6, 789)
        @test ts == Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456)
    end

    @testset "Base.parse(Timestamp64, [iso 8601 strings])" begin
        cases = [
            (
                "2021-02-03T04:05:06.789123456",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            (
                "2021-02-03T04:05:06.789123456Z",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            ("2021-02-03T04:05:06.789123", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000)),
            (
                "2021-02-03T04:05:06.789123Z",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000),
            ),
            ("2021-02-03T04:05:06.789", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000)),
            ("2021-02-03T04:05:06.789Z", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000)),
            ("2021-02-03T04:05:06", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=0)),
            ("2021-02-03T04:05:06Z", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=0)),
        ]
        for (iso8601, expected) in cases
            ts = parse(Timestamp64, iso8601)
            @test ts == expected
        end
    end

    @testset "Base.parse(Timestamp64, [iso 8601 strings], Dates.ISODateTimeFormat)" begin
        cases = [
            (
                "2021-02-03T04:05:06.789123456",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            (
                "2021-02-03T04:05:06.789123456Z",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            ("2021-02-03T04:05:06.789123", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000)),
            (
                "2021-02-03T04:05:06.789123Z",
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000),
            ),
            ("2021-02-03T04:05:06.789", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000)),
            ("2021-02-03T04:05:06.789Z", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000)),
            ("2021-02-03T04:05:06", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=0)),
            ("2021-02-03T04:05:06Z", Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=0)),
        ]
        for (iso8601, expected) in cases
            ts = parse(Timestamp64, iso8601, Dates.ISODateTimeFormat)
            @test ts == expected
        end
    end

    @testset "Base.parse(Timestamp64, [iso 8601 strings], ISOTimestamp64Format)" begin
        cases = [
            (
                "2021-02-03T04:05:06.789123456", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            (
                "2021-02-03T04:05:06.789123456Z", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123456),
            ),
            (
                "2021-02-03T04:05:06.789123", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000),
            ),
            (
                "2021-02-03T04:05:06.789123Z", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789123000),
            ),
            (
                "2021-02-03T04:05:06.789", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000),
            ),
            (
                "2021-02-03T04:05:06.789Z", #
                Timestamp64(2021, 2, 3, 4, 5, 6; nanoseconds=789000000),
            ),
            (
                "2021-02-03T04:05:06", #
                Timestamp64(2021, 2, 3, 4, 5, 6),
            ),
            (
                "2021-02-03T04:05:06Z", #
                Timestamp64(2021, 2, 3, 4, 5, 6),
            ),
        ]
        for (iso8601, expected) in cases
            ts = parse(Timestamp64, iso8601, ISOTimestamp64Format)
            @test ts == expected
        end
    end
end
