module RasterHistograms

using Rasters, StatsBase, LinearAlgebra, DocStringExtensions, MakieCore, RecipesBase
import LinearAlgebra.normalize!
import Rasters.DimensionalData.dim2key
import MakieCore.convert_arguments
import Base: show, iterate

export RasterLayerHistogram, RasterStackHistogram, RasterSeriesHistogram,
       area_weights, volume_weights, convert_arguments, normalize!

"Abstract supertype for a `RasterHistogram`."
abstract type AbstractRasterHistogram end

include("rasterhistogram.jl")
include("stackhistogram.jl")
include("serieshistogram.jl")
include("rasterweights.jl")
include("utils.jl")

end
