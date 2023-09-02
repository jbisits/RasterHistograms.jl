```@meta
CurrentModule = RasterHistograms
```

# RasterHistograms.jl Documentation

Documentation for [RasterHistograms](https://github.com/jbisits/RasterHistograms.jl).

RasterHistograms.jl uses [empirical estimation from StatsBase.jl](https://juliastats.org/StatsBase.jl/stable/empirical/) to fit `Histogram`s to `Raster`, `RasterStack` or `RasterSeries` data structures.
Arguments that can be passed to [`fit(::Histogram)`](https://juliastats.org/StatsBase.jl/stable/empirical/#StatsAPI.fit-Tuple{Type{Histogram},%20Vararg{Any}}) can be passed to the constructors for the the various `AbstractRasterHistogram`s.
The aim of the module is to provide functionality similar to python's [xhistogram](https://xhistogram.readthedocs.io/en/latest/index.html) for [xarray](https://docs.xarray.dev/en/stable/) in Julia.

For information about how the module works [see here](@ref raster_hist_module) or take a look at the [example](@ref raster_hist_example)

If you have find any bugs or have a feature request/suggestion please raise an issuu in the [RasterHistograms.jl repository](https://github.com/jbisits/RasterHistograms.jl).
