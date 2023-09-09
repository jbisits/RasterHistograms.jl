using RasterHistograms
using Documenter, Literate, DocumenterCitations

DocMeta.setdocmeta!(RasterHistograms, :DocTestSetup, :(using RasterHistograms); recursive=true)
const EXAMPLES_DIR = joinpath(@__DIR__, "../examples")
const OUTPUT_DIR   = joinpath(@__DIR__, "src/literated")

to_be_literated = EXAMPLES_DIR .*"/".* readdir(EXAMPLES_DIR)

for file ∈ to_be_literated
    Literate.markdown(file, OUTPUT_DIR)
    Literate.script(file, OUTPUT_DIR)
end

example_pages = [
   "Histograms from `Raster`s" => "literated/raster_histograms.md"
]
module_pages = [
    "RasterHistograms"         => "modules/RasterHistograms.md"
]
library_pages = [
    "Function index" => "library/function_index.md"
]
pages = [
    "Home" => "index.md",
    "Modules" => module_pages,
    "Examples" => example_pages,
    "Library" => library_pages
]

bib = CitationBibliography(joinpath(@__DIR__, "src/refs.bib"))

makedocs(bib;
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
    pages = pages
)

deploydocs(;
    repo="github.com/jbisits/RasterHistograms.jl",
    devbranch="main",
)
