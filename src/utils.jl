"""
    function find_stack_non_missing(stack::RasterStack)
Return a `Raster` of type `Bool` that contains the intersection of the non-`missing` values
from the layers of a `RasterStack`.
"""
function find_stack_non_missing(stack::RasterStack)

    nm_raster_vec = [.!ismissing.(read(stack[var])) for var ∈ keys(stack)]
    intersection_non_missings = nm_raster_vec[1]
    for nm_rs ∈ nm_raster_vec[2:end]
        intersection_non_missings = intersection_non_missings .&& nm_rs .== 1
    end

    return intersection_non_missings
end
"`show` methods for `AbstractRasterHistogram`s."
function Base.show(io::IO, rlh::RasterLayerHistogram)
    println(io, "RasterLayerHistogram for the variable $(rlh.layer)")
    println(io, "┣━━ Layer dimensions: $(rlh.dimensions) ")
    println(io, "┣━━━━━━━━ Layer size: $(rlh.raster_size)")
    print(io,   "┗━━━━━━━━━ Histogram: 1-dimensional")
end
function Base.show(io::IO, rsh::RasterStackHistogram)
    println(io, "RasterStackHistogram for the variables $(rsh.layers)")
    println(io, "┣━━ Stack dimensions: $(rsh.dimensions)")
    println(io, "┣━━ Stack layer size: $(rsh.raster_size)")
    print(io,   "┗━━━━━━━━━ Histogram: $(length(rsh.layers))-dimensional")
end
function Base.show(io::IO, rseh::RasterSeriesHistogram)
    hist_dim = rseh.layers isa Symbol ? 1 : length(rseh.layers)
    println(io, "RasterSeriesHistogram for the variables $(rseh.layers)")
    println(io, "┣━━━━━━━━━━━━━━━━━━━━ Series dimension: $(rseh.series_dimension)")
    println(io, "┣━━━━━━━━━━━━━━━━━━━━━━━ Series length: $(rseh.series_length)")
    println(io, "┣━━ Data Dimensions of series elements: $(rseh.dimensions) ")
    println(io, "┣━━━━━━━━ Data size of series elements: $(rseh.raster_size)")
    print(io,   "┗━━━━━━━━━━━━━━━━━━━━━━━━━━━ Histogram: $(hist_dim)-dimensional")
end
"`iterate` methods for `AbstractRasterHistogram`s."
Base.iterate(arh::AbstractRasterHistogram, state = 1) =
    state > length(fieldnames(typeof(arh))) ? nothing :
                                            (getfield(arh, state), state + 1)
"""
    function normalize!(arh::AbstractRasterHistogram; mode::Symbol = :pdf)
Normalize the `Histogram` in the `AbstractRasterHistogram` according the desired `mode`.
See the [StatsBase.jl docs](https://juliastats.org/StatsBase.jl/latest/empirical/#LinearAlgebra.normalize)
for information on the possible `mode`s and how they work.
"""
function LinearAlgebra.normalize!(arh::AbstractRasterHistogram; mode::Symbol = :pdf)

    arh.histogram = LinearAlgebra.normalize(arh.histogram; mode)

    return nothing

end

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

    histogram_to_plot = show_empty_bins ? arh.histogram : raster_zeros_to_nan(arh)

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

"Conversion method for plotting in Plots.jl"
@recipe f(::Type{<:AbstractRasterHistogram}, arh::AbstractRasterHistogram) = arh.histogram
