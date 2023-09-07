"""
    mutable struct RasterStackHistogram <: AbstractRasterHistogram
A `RasterStackHistogram`. The `struct` is `mutable` so that the `histogram` field can be
updated using the `normalize` (or otherwise) function.

    $(TYPEDFIELDS)
"""
mutable struct RasterStackHistogram <: AbstractRasterHistogram
    "The layers (variables) from the `RasterStack` used to fit the `Histogram`"
        layers      :: Tuple
    "The dimensions of the `RasterStack`"
        dimensions  :: Tuple
    "The size of the `RasterStack` layers"
        raster_size :: Tuple
    "The N-dimensional `Histogram` fitted to the N layers from `RasterStack`"
        histogram   :: Histogram
end
"""
    function RasterStackHistogram(stack::RasterStack; closed = :left, nbins = nothing)
    function RasterStackHistogram(stack::RasterStack, weights::AbstractWeights;
                                  closed = :left, nbins = nothing)
    function RasterStackHistogram(stack::RasterStack, edges::NTuple{N, AbstractVector};
                                  closed = :left)
    function RasterStackHistogram(stack::RasterStack, weights::AbstractWeights,
                                  edges::NTuple{N, AbstractVector}; closed = :left)
Construct a `RasterStackHistogram` from a `RasterStack`. The resulting `Histogram` is
N-dimensional, where N is the number of layers. The flattened `Raster` data for each layer,
with the`missing` values removed, is passed to the `fit(::Histogram)` function from
[StatsBase.jl](https://juliastats.org/StatsBase.jl/latest/empirical/) and a
`RasterStackHistogram` type is returned.
"""
function RasterStackHistogram(stack::RasterStack; closed = :left, nbins = nothing)

    layers = names(stack)
    dimensions = DimensionalData.dim2key(dims(stack))
    rs_size = size(stack)
    find_nm = find_stack_non_missing(stack)
    flattened_stack_data = Tuple(collect(Float64, read(layer)[find_nm]) for layer ∈ stack)

    histogram = isnothing(nbins) ? StatsBase.fit(Histogram, flattened_stack_data; closed) :
                                   StatsBase.fit(Histogram, flattened_stack_data;
                                                 closed, nbins)

    return RasterStackHistogram(layers, dimensions, rs_size, histogram)

end
function RasterStackHistogram(stack::RasterStack, weights::AbstractWeights;
                              closed = :left,  nbins = nothing)

    layers = names(stack)
    dimensions = DimensionalData.dim2key(dims(stack))
    rs_size = size(stack)
    find_nm = find_stack_non_missing(stack)
    find_nm_vec = reshape(find_nm, :)
    flattened_stack_data = Tuple(collect(Float64, read(layer)[find_nm]) for layer ∈ stack)

    histogram = isnothing(nbins) ? StatsBase.fit(Histogram, flattened_stack_data,
                                                 weights[find_nm_vec]; closed) :
                                   StatsBase.fit(Histogram, flattened_stack_data,
                                                 weights[find_nm_vec]; closed, nbins)


    return RasterStackHistogram(layers, dimensions, rs_size, histogram)

end
function RasterStackHistogram(stack::RasterStack, edges::NTuple{N, AbstractVector};
                              closed = :left) where {N}

    layers = names(stack)
    dimensions = DimensionalData.dim2key(dims(stack))
    rs_size = size(stack)
    find_nm = find_stack_non_missing(stack)
    flattened_stack_data = Tuple(collect(Float64, read(layer)[find_nm]) for layer ∈ stack)

    histogram = StatsBase.fit(Histogram, flattened_stack_data, edges; closed)

    return RasterStackHistogram(layers, dimensions, rs_size, histogram)

end
function RasterStackHistogram(stack::RasterStack, weights::AbstractWeights,
                              edges::NTuple{N, AbstractVector}; closed = :left) where {N}

    layers = names(stack)
    dimensions = DimensionalData.dim2key(dims(stack))
    rs_size = size(stack)
    find_nm = find_stack_non_missing(stack)
    find_nm_vec = reshape(find_nm, :)
    flattened_stack_data = Tuple(collect(Float64, read(layer)[find_nm]) for layer ∈ stack)

    histogram = StatsBase.fit(Histogram, flattened_stack_data, weights[find_nm_vec],
                              edges; closed)

    return RasterStackHistogram(layers, dimensions, rs_size, histogram)

end
