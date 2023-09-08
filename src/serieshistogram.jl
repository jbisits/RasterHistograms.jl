"""
    mutable struct RasterSeriesHistogram <: AbstractRasterHistogram
A `RasterSeriesHistogram` where the `child`s of the `RasterSeries` are `RasterStack`s or `Raster`s.
The `struct` is `mutable` so that the `histogram` field can be updated using the `normalize`
(or otherwise) function.

$(TYPEDFIELDS)
"""
mutable struct RasterSeriesHistogram{L, SD, SL, D, S} <: AbstractRasterHistogram
    "The layers (variables) from the `RasterSeries` used to fit the `Histogram`"
        layers           :: L
    "The dimension of the `RasterSeries` (usually this will be time)"
        series_dimension :: SD
    "The length of the `RasterSeries"
        series_length    :: SL
    "The dimensions of the elements (either a `Raster` or `RasterStack`) of the `RasterSeries`"
        dimensions       :: D
    "The size of the elements (either a `Raster` or `RasterStack`) of the `RasterSeries`"
        raster_size      :: S
    "The N-dimensional `Histogram` fitted to the N layers from `RasterSeries`"
        histogram        :: Histogram
end
"""
    function RasterSeriesHistogram(series::RasterSeries, edges::NTuple{N, AbstractVector};
                                   closed = :left)
    function RasterSeriesHistogram(series::RasterSeries, weights::AbstractWeights,
                                   edges::NTuple{N, AbstractVector}; closed = :left)
Construct a `RasterSeriesHistogram` from a `RasterSeries`. Note that to `merge` `Histograms`
the bin edges must be the same, so for this constructor the edges must be passed in. This
constructor assumes that the dimensions are the same across all `RasterStack`s in the
`RasterSeries`.
"""
function RasterSeriesHistogram(series::RasterSeries{<:Raster}, edges::AbstractVector;
                               closed = :left)

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = name(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])

    histogram = RasterLayerHistogram(series[1], edges; closed).histogram

    for rs ∈ series[2:end]

        temp_rshist = RasterLayerHistogram(rs, edges; closed)
        merge!(histogram, temp_rshist.histogram)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
function RasterSeriesHistogram(series::RasterSeries{<:Raster}, weights::AbstractWeights,
                               edges::AbstractVector; closed = :left)

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = name(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])

    histogram = RasterLayerHistogram(series[1], weights, edges; closed).histogram

    for rs ∈ series[2:end]

        temp_rshist = RasterLayerHistogram(rs, weights, edges; closed)
        merge!(histogram, temp_rshist.histogram)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
function RasterSeriesHistogram(series::RasterSeries{<:RasterStack}, edges::NTuple{N, AbstractVector};
                               closed = :left) where {N}

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = names(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])

    histogram = RasterStackHistogram(series[1], edges; closed).histogram

    for stack ∈ series[2:end]

        temp_stackhist = RasterStackHistogram(stack, edges; closed)

        merge!(histogram, temp_stackhist.histogram)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
function RasterSeriesHistogram(series::RasterSeries{<:RasterStack}, weights::AbstractWeights,
                               edges::NTuple{N, AbstractVector}; closed = :left) where {N}

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = names(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])

    histogram = RasterStackHistogram(series[1], weights, edges).histogram

    for stack ∈ series[2:end]

        temp_stackhist = RasterStackHistogram(stack, weights, edges; closed)

        merge!(histogram, temp_stackhist.histogram)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
