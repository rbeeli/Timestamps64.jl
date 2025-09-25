using TestItemRunner

@testitem "Ranges: Timestamp64(0):Day(1):Timestamp64(0)" begin
    using Dates
    using Timestamps64

    rng = Timestamp64(0):Day(1):Timestamp64(0)
    @test length(rng) == 1
    @test first(rng) == Timestamp64(0)
    @test last(rng) == Timestamp64(0)
end

@testitem "Ranges: Timestamp64(0):Day(1):Timestamp(typemax(Int64))" begin
    using Dates
    using Timestamps64

    rng = Timestamp64(0):Day(1):Timestamp64(typemax(Int64))
    @test length(rng) == length(DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11))
    @test first(rng) == Timestamp64(0)
    @test last(rng) == Timestamp64(2262, 4, 11)
end
