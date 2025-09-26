using TestItemRunner

@testitem "Construction: DateTime(1970, 1, 1, 0, 0, 0)" begin
    using Dates
    using Timestamps64

    dt = DateTime(1970, 1, 1, 0, 0, 0)
    ts = Timestamp64(dt)
    @test ts.ts == 0
    @test DateTime(ts) == dt
end

@testitem "Construction: Date(1970, 1, 1)" begin
    using Dates
    using Timestamps64

    dt = Date(1970, 1, 1)
    ts = Timestamp64(dt)
    @test ts.ts == 0
    @test Date(ts) == dt
end

@testitem "Construction: Date(2021, 12, 31)" begin
    using Dates
    using Timestamps64

    dt = Date(2021, 12, 31)
    ts = Timestamp64(dt)
    @test Date(ts) == dt
end

@testitem "Construction: DateTime(2020, 1, 1, 0, 0, 0) #1" begin
    using Dates
    using Timestamps64

    dt = DateTime(2020, 1, 1, 0, 0, 0)
    ts = Timestamp64(dt)
    @test ts.ts == 1577836800000000000
    @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
    @test DateTime(ts) == dt
end

@testitem "Construction: DateTime(2020, 1, 1, 0, 0, 0) #2" begin
    using Dates
    using Timestamps64

    dt = DateTime(2020, 1, 1, 0, 0, 0)
    ts = Timestamp64(dt)
    @test ts.ts == 1577836800000000000
    @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
    @test DateTime(ts) == dt
end

@testitem "Construction: from Date and Time" begin
    using Dates
    using Timestamps64

    date = Date(2020, 1, 1)
    time = Time(23, 24, 35) + Nanosecond(123456789)
    @test Timestamp64(date, time) == Timestamp64(2020, 1, 1, 23, 24, 35; nanoseconds=123456789)
end

@testitem "Construction: Timestamp64(0)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(0)
    @test DateTime(ts) == DateTime(1970, 1, 1, 0, 0, 0)
    @test ts.ts == 0
end

@testitem "Construction: Timestamp64(typemax(Int64))" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(typemax(Int64))
    @test DateTime(ts) == DateTime(2262, 4, 11, 23, 47, 16, 855)
    @test ts.ts == typemax(Int64)
end

@testitem "Construction: Timestamp64(1577836800000000000)" begin
    using Dates
    using Timestamps64

    ts = Timestamp64(1577836800000000000)
    @test DateTime(ts) == DateTime(2020, 1, 1, 0, 0, 0)
    @test ts.ts == 1577836800000000000
end

@testitem "Construction: Timestamp64([yr], [mth], [d])" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        ts = Timestamp64(year(dt), month(dt), day(dt))
        @test DateTime(ts) == dt
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
    end
end

@testitem "Construction: Timestamp64([yr], [mth], [d], [hr], [min], [sec])" begin
    using Dates
    using Timestamps64

    for dt in DateTime(1970, 1, 1):Day(1):DateTime(2262, 4, 11)
        dt += Hour(12) + Minute(34) + Second(56)
        ts = Timestamp64(year(dt), month(dt), day(dt), 12, 34, 56)
        @test DateTime(ts) == dt
        @test ts.ts ≈ datetime2unix(dt) * 1_000_000_000
        @test year(ts) == year(dt)
        @test month(ts) == month(dt)
        @test day(ts) == day(dt)
        @test hour(ts) == 12
        @test minute(ts) == 34
        @test second(ts) == 56
    end
end

@testitem "Construction: now(Timestamp64)" begin
    using Dates
    using Timestamps64

    ts = now(Timestamp64)
    dt = Dates.now(UTC)
    @test abs(dt - DateTime(ts)) < Millisecond(50)
    ts_utc = now(Timestamp64, UTC)
    @test abs(DateTime(ts_utc) - DateTime(ts)) < Millisecond(50)
end

@testitem "Construction: now(Timestamp64, UTC)" begin
    using Dates
    using Timestamps64

    ts = now(Timestamp64, UTC)
    dt = Dates.now(UTC)
    @test abs(dt - DateTime(ts)) < Millisecond(50)
end

@testitem "Construction: today(Timestamp64)" begin
    using Dates
    using Timestamps64

    ts = today(Timestamp64)
    dt = floor(Dates.now(UTC), Dates.Day)
    @test DateTime(ts) == dt
    ts_utc = today(Timestamp64, UTC)
    @test DateTime(ts) == DateTime(ts_utc)
end

@testitem "Construction: today(Timestamp64, UTC)" begin
    using Dates
    using Timestamps64

    ts = today(Timestamp64, UTC)
    dt = Date(now(UTC))
    @test DateTime(ts) == dt
end

@static if Sys.iswindows()
    @testitem "Construction: Windows FILETIME helper" begin
        using Dates
        using Timestamps64

        epoch = Timestamps64._WINDOWS_FILETIME_EPOCH_OFFSET_100NS

        ts = Timestamps64._filetime_to_timespec(epoch)
        @test ts.tv_sec == 0
        @test ts.tv_nsec == 0

        ts = Timestamps64._filetime_to_timespec(epoch + UInt64(10_000_000 + 1_234))
        @test ts.tv_sec == 1
        @test ts.tv_nsec == 123_400

        ts = Timestamps64._filetime_to_timespec(epoch - UInt64(5_000_000))
        @test ts.tv_sec == -1
        @test ts.tv_nsec == 500_000_000
    end

    @testitem "Construction: Windows FILETIME to Timestamp64" begin
        using Dates
        using Timestamps64

        epoch = Timestamps64._WINDOWS_FILETIME_EPOCH_OFFSET_100NS

        tspec = Timestamps64._filetime_to_timespec(epoch + UInt64(42 * 10_000_000))
        ts = Timestamp64(Timestamps64._to_unix_ns(tspec))
        @test DateTime(ts) == DateTime(1970, 1, 1) + Dates.Second(42)

        tspec = Timestamps64._filetime_to_timespec(epoch - UInt64(3 * 10_000_000))
        ts = Timestamp64(Timestamps64._to_unix_ns(tspec))
        @test DateTime(ts) == DateTime(1969, 12, 31, 23, 59, 57)
    end

    @testitem "Construction: Windows FILETIME conversion" begin
        using Dates
        using Timestamps64

        epoch_filetime = UInt64(116_444_736_000_000_000)
        filetime = epoch_filetime
        delta = Int128(filetime) - Int128(Timestamps64._WINDOWS_FILETIME_EPOCH_OFFSET_100NS)
        nanoseconds = delta * 100
        seconds = nanoseconds ÷ 1_000_000_000
        subseconds = nanoseconds % 1_000_000_000
        @test seconds == 0
        @test subseconds == 0

        filetime = epoch_filetime + 10_000_000
        delta = Int128(filetime) - Int128(Timestamps64._WINDOWS_FILETIME_EPOCH_OFFSET_100NS)
        nanoseconds = delta * 100
        seconds = nanoseconds ÷ 1_000_000_000
        subseconds = nanoseconds % 1_000_000_000
        @test seconds == 1
        @test subseconds == 0

        filetime = filetime + 1_234
        delta = Int128(filetime) - Int128(Timestamps64._WINDOWS_FILETIME_EPOCH_OFFSET_100NS)
        nanoseconds = delta * 100
        seconds = nanoseconds ÷ 1_000_000_000
        subseconds = nanoseconds % 1_000_000_000
        @test seconds == 1
        @test subseconds == 123_400
    end
end
