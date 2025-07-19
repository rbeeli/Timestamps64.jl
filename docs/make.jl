push!(LOAD_PATH, "../src/")

using Timestamps64
using Documenter

makedocs(;
    sitename="Timestamps64.jl",
    # format = Documenter.HTML(prettyurls=false),
)
