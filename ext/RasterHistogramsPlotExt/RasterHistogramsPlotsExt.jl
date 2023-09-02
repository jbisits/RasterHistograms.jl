module RasterHistogramsPlotsExt

using RasterHistograms, RecipesBase

"Conversion method for plotting in Plots.jl"
@recipe f(::Type{<:AbstractRasterHistogram}, arh::AbstractRasterHistogram) = arh.histogram

end
