"""
    mutable struct RasterSeriesHistogram <: AbstractRasterHistogram
A `RasterSeriesHistogram`. The `struct` is `mutable` so that the `histogram` field can be
updated using the `normalize` (or otherwise) function.

$(TYPEDFIELDS)
"""
mutable struct RasterSeriesHistogram <: AbstractRasterHistogram
    "The layers (variables) from the `RasterSeries` used to fit the `Histogram`"
        layers           :: Tuple
    "The dimension of the `RasterSeries` (usually this will be time)"
        series_dimension :: Symbol
    "The length of the `RasterSeries"
        series_length    :: Int64
    "The dimensions of the elements (either a `Raster` or `RasterStack`) of the `RasterSeries`"
        dimensions       :: Tuple
    "The size of the elements (either a `Raster` or `RasterStack`) of the `RasterSeries`"
        raster_size      :: Tuple
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
function RasterSeriesHistogram(series::RasterSeries, edges::NTuple{N, AbstractVector};
                               closed = :left) where {N}

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = names(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])
    find_nm = find_stack_non_missing(series[1])
    flattened_stack_data = Tuple(collect(skipmissing(read(layer)[find_nm])) for layer ∈ series[1])

    histogram = StatsBase.fit(Histogram, flattened_stack_data, edges; closed)

    for stack ∈ series[2:end]
        find_nm = find_stack_non_missing(stack)
        flattened_stack_data = Tuple(collect(skipmissing(read(layer)[find_nm])) for layer ∈ stack)

        h = StatsBase.fit(Histogram, flattened_stack_data, edges; closed)

        merge!(histogram, h)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
function RasterSeriesHistogram(series::RasterSeries, weights::AbstractWeights,
                               edges::NTuple{N, AbstractVector}; closed = :left) where {N}

    series_dimension = DimensionalData.dim2key(dims(series))[1]
    series_length = length(series)
    layers = names(series[1])
    dimensions = DimensionalData.dim2key(dims(series[1]))
    rs_size = size(series[1])
    find_nm = find_stack_non_missing(series[1])
    find_nm_vec = reshape(find_nm, :)
    flattened_stack_data = Tuple(collect(skipmissing(read(layer)[find_nm])) for layer ∈ series[1])

    histogram = StatsBase.fit(Histogram, flattened_stack_data, weights[find_nm_vec],
                              edges; closed)

    for stack ∈ series[2:end]

        find_nm_ = find_stack_non_missing(stack)
        find_nm_vec_ = reshape(find_nm_, :)
        flattened_stack_data = Tuple(collect(skipmissing(read(layer)[find_nm_])) for layer ∈ stack)

        h = StatsBase.fit(Histogram, flattened_stack_data, weights[find_nm_vec_],
                          edges; closed)

        merge!(histogram, h)

    end

    return RasterSeriesHistogram(layers, series_dimension, series_length,
                                 dimensions, rs_size, histogram)

end
