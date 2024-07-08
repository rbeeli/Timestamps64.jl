using BenchmarkTools
using Timestamps64
using Dates

@benchmark Timestamp64("2021-01-01T00:00:01")

@benchmark DateTime("2021-01-01T00:00:01")

@benchmark Dates.format($Timestamp64("2021-01-01T00:00:01"), Dates.ISODateTimeFormat)
@benchmark Dates.format($Timestamp64("2021-01-01T00:00:01"), ISOTimestamp64Format)
@benchmark Dates.format($DateTime("2021-01-01T00:00:01"), Dates.ISODateTimeFormat)
