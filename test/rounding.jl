using TestItemRunner

@testitem "Rounding: floor C++ chrono generated test cases" begin
    using Dates
    using Timestamps64

    # Original time: Timestamp64(1970, 1, 1, 0, 0, 0, nanoseconds=123456789)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456788)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456780)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123452000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123450000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123000000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123000000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=119000000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=120000000)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(3)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(7)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)
    @test floor(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(10)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0)

    # Original time: Timestamp64(2020, 1, 1, 23, 59, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Nanosecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=0)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Nanosecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=999999998)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Nanosecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=999999999)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Nanosecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=0)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Microsecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=0)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Microsecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=999998000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Microsecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=999994000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Microsecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=0)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Millisecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=0)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Millisecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=998000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Millisecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 58; nanoseconds=999000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Millisecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Second(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Second(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 57)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Second(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 53)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Second(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 50)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Minute(1)) == Timestamp64(2020, 1, 1, 23, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Minute(3)) == Timestamp64(2020, 1, 1, 23, 57)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Minute(7)) == Timestamp64(2020, 1, 1, 23, 53)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Minute(10)) == Timestamp64(2020, 1, 1, 23, 50)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Hour(1)) == Timestamp64(2020, 1, 1, 23)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Hour(3)) == Timestamp64(2020, 1, 1, 21)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Hour(7)) == Timestamp64(2020, 1, 1, 17)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59), Hour(10)) == Timestamp64(2020, 1, 1, 22)

    # Original time: Timestamp64(2020, 1, 1, 23, 59, 59, nanoseconds=123456789)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Nanosecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Nanosecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456787)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Nanosecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456787)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Nanosecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456780)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Microsecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Microsecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123454000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Microsecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123453000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Microsecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123450000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Millisecond(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Millisecond(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=121000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Millisecond(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=118000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Millisecond(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=120000000)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Second(1)) ==
        Timestamp64(2020, 1, 1, 23, 59, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Second(3)) ==
        Timestamp64(2020, 1, 1, 23, 59, 57)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Second(7)) ==
        Timestamp64(2020, 1, 1, 23, 59, 53)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Second(10)) ==
        Timestamp64(2020, 1, 1, 23, 59, 50)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Minute(1)) ==
        Timestamp64(2020, 1, 1, 23, 59)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Minute(3)) ==
        Timestamp64(2020, 1, 1, 23, 57)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Minute(7)) ==
        Timestamp64(2020, 1, 1, 23, 53)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Minute(10)) ==
        Timestamp64(2020, 1, 1, 23, 50)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Hour(1)) ==
        Timestamp64(2020, 1, 1, 23)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Hour(3)) ==
        Timestamp64(2020, 1, 1, 21)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Hour(7)) ==
        Timestamp64(2020, 1, 1, 17)
    @test floor(Timestamp64(2020, 1, 1, 23, 59, 59; nanoseconds=123456789), Hour(10)) ==
        Timestamp64(2020, 1, 1, 22)

    # Original time: Timestamp64(2030, 1, 1, 0, 0, 0, nanoseconds=123456789)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(7)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456783)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456780)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(7)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123450000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Microsecond(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123450000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123000000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123000000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(7)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=121000000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Millisecond(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=120000000)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(7)) ==
        Timestamp64(2029, 12, 31, 23, 59, 58; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Second(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(7)) ==
        Timestamp64(2029, 12, 31, 23, 56, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Minute(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(1)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(3)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(7)) ==
        Timestamp64(2029, 12, 31, 23, 0, 0; nanoseconds=0)
    @test floor(Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=123456789), Hour(10)) ==
        Timestamp64(2030, 1, 1, 0, 0, 0; nanoseconds=0)
end

@testitem "Rounding: ceil" begin
    using Dates
    using Timestamps64

    @test ceil(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789)
end

@testitem "Rounding: round" begin
    using Dates
    using Timestamps64

    @test round(Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789), Nanosecond(1)) ==
        Timestamp64(1970, 1, 1, 0, 0, 0; nanoseconds=123456789)
end

@testitem "Rounding: floor DatePeriod" begin
    using Dates
    using Timestamps64

    for i in [1, 5, 7]
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
            for period in periods
                @test floor(Timestamp64(dt), period) == Timestamp64(floor(dt, period))
            end
        end
    end
end

@testitem "Rounding: ceil DatePeriod" begin
    using Dates
    using Timestamps64

    for i in [1, 5, 7]
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
            for period in periods
                @test ceil(Timestamp64(dt), period) == Timestamp64(ceil(dt, period))
            end
        end
    end
end

@testitem "Rounding: round DatePeriod" begin
    using Dates
    using Timestamps64

    for i in [1, 5, 7]
        for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
            periods = Dates.DatePeriod[Day(i), Week(i), Month(i), Quarter(i), Year(i)]
            for period in periods
                @test round(Timestamp64(dt), period) == Timestamp64(round(dt, period))
            end
        end
    end
end
