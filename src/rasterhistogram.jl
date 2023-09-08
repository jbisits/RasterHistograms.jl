"""
    mutable struct RasterLayerHistogram <: AbstractRasterHistogram
A `RasterLayerHistogram`. The `struct` is `mutable` so that the `histogram` field can be
updated using the `normalize` (or otherwise) function.

$(TYPEDFIELDS)
"""
mutable struct RasterLayerHistogram{L, D, S} <: AbstractRasterHistogram
    "The layer (variable) from the `Raster`"
        layer       :: L
    "The dimensions of the `Raster`"
        dimensions  :: D
    "The size of the `Raster`"
        raster_size :: S
    "The 1-dimensional histogram fitted to the `Raster` layer data"
        histogram   :: Histogram
end
"""
    function RasterLayerHistogram(rs::Raster; closed = :left, nbins = nothing)
    function RasterLayerHistogram(rs::Raster, weights::AbstractWeights;
                                  closed = :left, nbins = nothing)
    function RasterLayerHistogram(rs::Raster, edges::AbstractVector; closed = :left)
    function RasterLayerHistogram(rs::Raster, weights::AbstractWeights,
                                  edges::AbstractVector; closed = :left)
Construct a `RasterLayerHistogram` from a `Raster`. The flattened `Raster` data, with the
`missing` values removed, is passed to the `fit(::Histogram)` function from
[StatsBase.jl](https://juliastats.org/StatsBase.jl/latest/empirical/) and a
`RasterLayerHistogram` type is returned.
"""
function RasterLayerHistogram(rs::Raster; closed = :left, nbins = nothing)

    rs = read(rs)
    layer = name(rs)
    dimensions = DimensionalData.dim2key(dims(rs))
    rs_size = size(rs)
    find_nm = @. !ismissing(rs)
    flattened_rs_data = collect(eltype(skipmissing(rs)), rs[find_nm])

    histogram = isnothing(nbins) ? StatsBase.fit(Histogram, flattened_rs_data; closed) :
                                   StatsBase.fit(Histogram, flattened_rs_data; closed, nbins)

    return RasterLayerHistogram(layer, dimensions, rs_size, histogram)

end
function RasterLayerHistogram(rs::Raster, weights::AbstractWeights;
                              closed = :left, nbins = nothing)

    rs = read(rs)
    layer = name(rs)
    dimensions = DimensionalData.dim2key(dims(rs))
    rs_size = size(rs)
    find_nm = @. !ismissing(rs)
    find_nm_vec = reshape(find_nm, :)
    flattened_rs_data = collect(eltype(skipmissing(rs)), rs[find_nm])

    histogram = isnothing(nbins) ? StatsBase.fit(Histogram, flattened_rs_data,
                                                 weights[find_nm_vec]; closed) :
                                   StatsBase.fit(Histogram, flattened_rs_data,
                                                 weights[find_nm_vec]; closed, nbins)

    return RasterLayerHistogram(layer, dimensions, rs_size, histogram)

end
function RasterLayerHistogram(rs::Raster, edges::AbstractVector; closed = :left)

    rs = read(rs)
    layer = name(rs)
    dimensions = DimensionalData.dim2key(dims(rs))
    rs_size = size(rs)
    find_nm = @. !ismissing(rs)
    flattened_rs_data = collect(eltype(skipmissing(rs)), rs[find_nm])

    histogram = StatsBase.fit(Histogram, flattened_rs_data, edges; closed)

    return RasterLayerHistogram(layer, dimensions, rs_size, histogram)

end
function RasterLayerHistogram(rs::Raster, weights::AbstractWeights, edges::AbstractVector;
                              closed = :left)

    rs = read(rs)
    layer = name(rs)
    dimensions = DimensionalData.dim2key(dims(rs))
    rs_size = size(rs)
    find_nm = @. !ismissing(rs)
    find_nm_vec = reshape(find_nm, :)
    flattened_rs_data = collect(eltype(skipmissing(rs)), rs[find_nm])

    histogram = StatsBase.fit(Histogram, flattened_rs_data, weights[find_nm_vec],
                              edges; closed)

    return RasterLayerHistogram(layer, dimensions, rs_size, histogram)

end
