module RasterHistogramsMakieExt

using RasterHistograms
import MakieCore.convert_arguments


"""
    function convert_arguments(P::Type{<:AbstractPlot}, arh::AbstractRasterHistogram)
Converting method so Makie.jl can plot an `AbstractRasterHistogram`. **Note** for plotting
purposes a value correspnding to zero is replaced with `NaN`. This is to avoid in 2D
plotting many zero values and as a result not seeing the distribtution clearly (in Makie.kj
`heatmap` the `NaN` value is
[left out in plotting](https://docs.makie.org/stable/examples/plotting_functions/heatmap/#three_vectors)).
"""
function MakieCore.convert_arguments(P::Type{<:MakieCore.AbstractPlot},
                                     arh::AbstractRasterHistogram,
                                     show_empty_bins::Bool=false)

    histogram_to_plot = show_empty_bins ? raster_zeros_to_nan(arh) : arh.histogram

    return convert_arguments(P, histogram_to_plot)

end

"""
    function raster_zeros_to_nan(arh::AbstractRasterHistogram)
Convert the `zero`s (i.e. empty bins in the `AbstractRasterHistogram`) to `NaN`s for
plotting in Makie.
"""
function raster_zeros_to_nan(arh::AbstractRasterHistogram)

    temp = float(arh.histogram)
    replace!(temp.weights, 0 => NaN)

    return temp

end

end
