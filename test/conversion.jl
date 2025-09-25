using TestItemRunner

@testitem "Conversion: DateTime(Timestamp64(1970, 1, 1))" begin
    using Dates
    using Timestamps64

    dt = DateTime(Timestamp64(1970, 1, 1))
    @test dt == DateTime(1970, 1, 1)
end

@testitem "Conversion: DateTime(Timestamp64(2020, 1, 1, 2, 3, 4))" begin
    using Dates
    using Timestamps64

    dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4))
    @test dt == DateTime(2020, 1, 1, 2, 3, 4)
end

@testitem "Conversion: DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, nanoseconds=987))" begin
    using Dates
    using Timestamps64

    # only keeps millisecond precision
    dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4; nanoseconds=987))
    @test dt == DateTime(2020, 1, 1, 2, 3, 4, 0)
end

@testitem "Conversion: DateTime(Timestamp64(2020, 1, 1, 2, 3, 4, nanoseconds=987000000))" begin
    using Dates
    using Timestamps64

    # only keeps millisecond precision
    dt = DateTime(Timestamp64(2020, 1, 1, 2, 3, 4; nanoseconds=987000000))
    @test dt == DateTime(2020, 1, 1, 2, 3, 4, 987)
end

@testitem "Conversion: Date(Timestamp64(2020, 1, 1, 0, 0, 0, nanoseconds=1))" begin
    using Dates
    using Timestamps64

    # truncates to Date part only
    dt = Date(Timestamp64(2020, 1, 1, 0, 0, 0; nanoseconds=1))
    @test dt == Date(2020, 1, 1)
end

@testitem "Conversion: Date(Timestamp64(2020, 1, 1, 2, 3, 4, nanoseconds=987000000))" begin
    using Dates
    using Timestamps64

    # truncates to Date part only
    dt = Date(Timestamp64(2020, 1, 1, 2, 3, 4; nanoseconds=987000000))
    @test dt == Date(2020, 1, 1)
end

@testitem "Conversion: Time(Timestamp64(2020, 1, 1, 2, 3, 4, nanoseconds=987000000))" begin
    using Dates
    using Timestamps64

    # truncates to Time part only
    dt = Time(Timestamp64(2020, 1, 1, 2, 3, 4; nanoseconds=987000000))
    @test dt == Time(2, 3, 4, 987)
end
