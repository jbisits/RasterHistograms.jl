using RasterHistograms
using Documenter

DocMeta.setdocmeta!(RasterHistograms, :DocTestSetup, :(using RasterHistograms); recursive=true)

makedocs(;
    modules=[RasterHistograms],
    authors="Josef Bisits <jbisits@gmail.com>",
    repo="https://github.com/jbisits/RasterHistograms.jl/blob/{commit}{path}#{line}",
    sitename="RasterHistograms.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://jbisits.github.io/RasterHistograms.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/jbisits/RasterHistograms.jl",
    devbranch="main",
)
