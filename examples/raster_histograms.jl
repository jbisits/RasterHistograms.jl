# # [Raster Histograms](@id raster_hist_example)
# First, add the required depedencies
using Rasters, NCDatasets, Downloads, CairoMakie
# and the `RasterHistograms` package.
using RasterHistograms
# Using this package we can produce `Histogram`s from data that is in a `Raster`,
# `RasterStack` or `RasterSeries`, which are named N-dimensional arrays, in a similar way that
# [xhistogram](https://xhistogram.readthedocs.io/en/latest/index.html) works for xarray
# in python. This example is structured similarly to the
# [xhistogram tutorial](https://xhistogram.readthedocs.io/en/latest/tutorial.html).
# ## Randomly generated toy data
# First we generate some randomly distributed data and form a `Raster`.
x, t = range(-2π, 2π; length = 50), range(0, 4π; length = 100)
dimensions = (X(x), Ti(t))
rs = Raster(randn(length(x), length(t)), dimensions; name = :Toy_data)
# The we can form a `RasterLayerHistogram` for the `:Toy_data`
rs_hist = RasterLayerHistogram(rs)
# We can then plot the data and the `Histogram`
fig = Figure(size = (1000, 600))
ax1 = Axis(fig[1, 1];
           title = "Toy data",
           xlabel = "x",
           ylabel = "time")
hm = heatmap!(ax1, x, t, rs.data)
Colorbar(fig[2, 1], hm; vertical = false, flipaxis = false)
ax2 = Axis(fig[1, 2];
          title = "Histogram of Toy data",
          xlabel = "Toy data", ylabel = "Frequency")
plot!(ax2, rs_hist; color = :steelblue)
fig
# By default we have a frequency `Histogram`. We can normalise the `Histogram`
# by calling the `normalize!` function on `rs_hist` and choosing a `mode` of normalisation.
# For more information about the possible modes of normalisation
# [see here](https://juliastats.org/StatsBase.jl/latest/empirical/#LinearAlgebra.normalize).
normalize!(rs_hist; mode = :pdf)
# Then replot with the normalised histogram
fig = Figure(size = (900, 600))
ax1 = Axis(fig[1, 1];
           title = "Toy data",
           xlabel = "x",
           ylabel = "time")
hm = heatmap!(ax1, x, t, rs.data)
Colorbar(fig[2, 1], hm; vertical = false, flipaxis = false)
ax2 = Axis(fig[1, 2];
          title = "Histogram (pdf) of Toy data",
          xlabel = "Toy data", ylabel = "density")
plot!(ax2, rs_hist; color = :steelblue)
fig
# !!! info
#     Plotting using [Plots.jl](https://docs.juliaplots.org/latest/) is also possible.
#     See the [module documentation](@ref raster_hist_module) for more info.
# ## Real world data example
# We now look at temperature and salinity distributions using ECCOv4r4 [Fukumori2022](@cite),
# [Fukumori2021](@cite), [Forget2015](@cite) model output. The
# function uses `try` to download from NASA EarthData but this sometimes fails during the
# docs build.
# !!! info
#     See the [NCDatasets.jl example](https://alexander-barth.github.io/NCDatasets.jl/latest/tutorials/#Data-from-NASA-EarthData)
#     for information on how to download data from NASA EarthData.
function download_ECCO()

    try
        Downloads.download("https://opendap.earthdata.nasa.gov/providers/POCLOUD/collections/ECCO%2520Ocean%2520Temperature%2520and%2520Salinity%2520-%2520Daily%2520Mean%25200.5%2520Degree%2520(Version%25204%2520Release%25204)/granules/OCEAN_TEMPERATURE_SALINITY_day_mean_2007-01-01_ECCO_V4r4_latlon_0p50deg.dap.nc4", "ECCO_data.nc")
    catch
        @info "dowloading from drive"
        Downloads.download("https://drive.google.com/uc?id=1MNeThunqpY-nFzsZLZj9BV8sM5BJgnxT&export=download", "ECCO_data.nc")
    end

    return nothing

end
download_ECCO()
# This example shows how the package works for 2-dimensional `Histograms` though it can
# be generalised to N dimensions depending on the number of variables
# (i.e. layers in the `RasterStack`) one is looking at.
# ### Forming the `RasterStack`
# We form a `RasterStack` with only the `:SALT` (practical salinity) and `:THETA`
# (potential temperature) layers. This means the resulting `RasterStackHistogram` will be 2
# dimensional. Note the order of the variables matters here for plotting purposes. The first
# layer, in this case `:SALT` will be the x-axis, and the second layer `:THETA` will be
# the y-axis.
stack_TS = RasterStack("ECCO_data.nc", name = (:SALT, :THETA))
edges = (31:0.025:38, -2:0.1:32)
stack_hist = RasterStackHistogram(stack_TS, edges)
# Now we can plot, the histogram and look at the unweighted distribtution of temperature and
# salinity. By default the empty bins are plotted with the value of zero.
fig = Figure(size = (500, 500))
ax = Axis(fig[1, 1];
          title = "Temperature and salinity joint distribution (unweighted)",
          xlabel = "Practical salinity (psu)",
          ylabel = "Potential temperature (°C)")
hm = heatmap!(ax, stack_hist; colorscale = log10)
Colorbar(fig[1, 2], hm)
fig
# ### Weighting the `Histogram`
# The module also exports simple functions for calculating area and volume weights from the
# dimensions of the grid which can be used to weight an `AbstractRasterHistogram`.
# Where weights are available from model data they should be used in favour of the functions.
dV = volume_weights(stack_TS)
weighted_stack_hist = RasterStackHistogram(stack_TS, dV, edges)
fig = Figure(size = (500, 500))
ax = Axis(fig[1, 1];
          title = "Temperature and salinity joint distribution (weighted)",
          xlabel = "Practical salinity (psu)",
          ylabel = "Potential temperature (°C)")
hm = heatmap!(ax, weighted_stack_hist; colorscale = log10)
Colorbar(fig[1, 2], hm)
fig
# ```@bibliography
# ```
