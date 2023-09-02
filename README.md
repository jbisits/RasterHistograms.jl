# RasterHistograms

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://jbisits.github.io/RasterHistograms.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://jbisits.github.io/RasterHistograms.jl/dev/)
[![Build Status](https://github.com/jbisits/RasterHistograms.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jbisits/RasterHistograms.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/jbisits/RasterHistograms.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/jbisits/RasterHistograms.jl)

[Rasters.jl](https://rafaqz.github.io/Rasters.jl/dev/) provides excellent methods for reading, analysing and plotting for geospatial data.
This package provides empirical distribution fitting for `Raster` data structures aiming to provide functionality similar to python's [xhistogram](https://xhistogram.readthedocs.io/en/latest/index.html) for [xarray](https://docs.xarray.dev/en/stable/) in Julia.

## Using the package

The package is installed using Julia's package manager

```julia
julia> ]
(@v1.9) pkg> add RasterHistograms
```

This package makes use of package extensions and therefore requires Julia 1.9 or later to run.
