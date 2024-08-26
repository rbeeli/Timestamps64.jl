using Test
using Dates
using Timestamps64

@testset verbose = true "Rounding" begin

    @testset "floor C++ chrono generated test cases" begin
        # Original time: Timestamp64(1970, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456788)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456780)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Microsecond(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Microsecond(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Microsecond(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123452000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Microsecond(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123450000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Millisecond(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123000000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Millisecond(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123000000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Millisecond(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 119000000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Millisecond(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 120000000)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Second(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Second(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Second(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Second(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Minute(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Minute(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Minute(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Minute(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Hour(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Hour(3)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Hour(7)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Hour(10)) == Timestamp64(1970, 1, 1, 0, 0, 0, 0)

        # Original time: Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Nanosecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Nanosecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 58, 999999998)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Nanosecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 58, 999999999)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Nanosecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Microsecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Microsecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 58, 999998000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Microsecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 58, 999994000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Microsecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Millisecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Millisecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 58, 998000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Millisecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 58, 999000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Millisecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Second(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Second(3)) == Timestamp64(2020, 1, 1, 23, 59, 57, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Second(7)) == Timestamp64(2020, 1, 1, 23, 59, 53, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Second(10)) == Timestamp64(2020, 1, 1, 23, 59, 50, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Minute(1)) == Timestamp64(2020, 1, 1, 23, 59, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Minute(3)) == Timestamp64(2020, 1, 1, 23, 57, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Minute(7)) == Timestamp64(2020, 1, 1, 23, 53, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Minute(10)) == Timestamp64(2020, 1, 1, 23, 50, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Hour(1)) == Timestamp64(2020, 1, 1, 23, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Hour(3)) == Timestamp64(2020, 1, 1, 21, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Hour(7)) == Timestamp64(2020, 1, 1, 17, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 0), Hour(10)) == Timestamp64(2020, 1, 1, 22, 0, 0, 0)

        # Original time: Timestamp64(2020, 1, 1, 23, 59, 59, 123456789)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Nanosecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123456789)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Nanosecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123456787)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Nanosecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123456787)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Nanosecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123456780)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Microsecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123456000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Microsecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123454000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Microsecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123453000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Microsecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123450000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Millisecond(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 123000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Millisecond(3)) == Timestamp64(2020, 1, 1, 23, 59, 59, 121000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Millisecond(7)) == Timestamp64(2020, 1, 1, 23, 59, 59, 118000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Millisecond(10)) == Timestamp64(2020, 1, 1, 23, 59, 59, 120000000)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Second(1)) == Timestamp64(2020, 1, 1, 23, 59, 59, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Second(3)) == Timestamp64(2020, 1, 1, 23, 59, 57, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Second(7)) == Timestamp64(2020, 1, 1, 23, 59, 53, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Second(10)) == Timestamp64(2020, 1, 1, 23, 59, 50, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Minute(1)) == Timestamp64(2020, 1, 1, 23, 59, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Minute(3)) == Timestamp64(2020, 1, 1, 23, 57, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Minute(7)) == Timestamp64(2020, 1, 1, 23, 53, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Minute(10)) == Timestamp64(2020, 1, 1, 23, 50, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Hour(1)) == Timestamp64(2020, 1, 1, 23, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Hour(3)) == Timestamp64(2020, 1, 1, 21, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Hour(7)) == Timestamp64(2020, 1, 1, 17, 0, 0, 0)
        @test floor(Timestamp64(2020, 1, 1, 23, 59, 59, 123456789), Hour(10)) == Timestamp64(2020, 1, 1, 22, 0, 0, 0)

        # Original time: Timestamp64(2030, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Nanosecond(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Nanosecond(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456789)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Nanosecond(7)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456783)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Nanosecond(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456780)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Microsecond(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Microsecond(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123456000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Microsecond(7)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123450000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Microsecond(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123450000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Millisecond(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123000000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Millisecond(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 123000000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Millisecond(7)) == Timestamp64(2030, 1, 1, 0, 0, 0, 121000000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Millisecond(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 120000000)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Second(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Second(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Second(7)) == Timestamp64(2029, 12, 31, 23, 59, 58, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Second(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Minute(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Minute(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Minute(7)) == Timestamp64(2029, 12, 31, 23, 56, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Minute(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Hour(1)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Hour(3)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Hour(7)) == Timestamp64(2029, 12, 31, 23, 0, 0, 0)
        @test floor(Timestamp64(2030, 1, 1, 0, 0, 0, 123456789), Hour(10)) == Timestamp64(2030, 1, 1, 0, 0, 0, 0)
    end

    @testset "ceil" begin
        @test ceil(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456789)
    end

    @testset "round" begin
        @test round(Timestamp64(1970, 1, 1, 0, 0, 0, 123456789), Nanosecond(1)) == Timestamp64(1970, 1, 1, 0, 0, 0, 123456789)
    end

    @testset "floor DatePeriod" begin
        for i in [1, 5, 7]
            for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
                periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
                for period in periods
                    @test floor(Timestamp64(dt), period) == Timestamp64(floor(dt, period))
                end
            end
        end
    end

    @testset "ceil DatePeriod" begin
        for i in [1, 5, 7]
            for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
                periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
                for period in periods
                    @test ceil(Timestamp64(dt), period) == Timestamp64(ceil(dt, period))
                end
            end
        end
    end

    @testset "round DatePeriod" begin
        for i in [1, 5, 7]
            for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
                periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
                for period in periods
                    @test round(Timestamp64(dt), period) == Timestamp64(round(dt, period))
                end
            end
        end
    end

end
