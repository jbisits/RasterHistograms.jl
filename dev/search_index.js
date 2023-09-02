var documenterSearchIndex = {"docs":
[{"location":"library/function_index/#Function-index-for-RasterHistograms","page":"Function index","title":"Function index for RasterHistograms","text":"","category":"section"},{"location":"library/function_index/#rh_func_index","page":"Function index","title":"RasterHistograms exported functions","text":"","category":"section"},{"location":"library/function_index/","page":"Function index","title":"Function index","text":"Modules = [RasterHistograms]\nPrivate = false","category":"page"},{"location":"library/function_index/#RasterHistograms.RasterLayerHistogram","page":"Function index","title":"RasterHistograms.RasterLayerHistogram","text":"mutable struct RasterLayerHistogram <: AbstractRasterHistogram\n\nA RasterLayerHistogram. The struct is mutable so that the histogram field can be updated using the normalize (or otherwise) function.\n\nlayer::Symbol: The layer (variable) from the Raster\ndimensions::Tuple: The dimensions of the Raster\nraster_size::Tuple: The size of the Raster\nhistogram::StatsBase.AbstractHistogram: The 1-dimensional histogram fitted to the Raster layer data\n\n\n\n\n\n","category":"type"},{"location":"library/function_index/#RasterHistograms.RasterLayerHistogram-Tuple{Rasters.Raster}","page":"Function index","title":"RasterHistograms.RasterLayerHistogram","text":"function RasterLayerHistogram(rs::Raster; closed = :left, nbins = nothing)\nfunction RasterLayerHistogram(rs::Raster, weights::AbstractWeights;\n                              closed = :left, nbins = nothing)\nfunction RasterLayerHistogram(rs::Raster, edges::AbstractVector; closed = :left)\nfunction RasterLayerHistogram(rs::Raster, weights::AbstractWeights,\n                              edges::AbstractVector; closed = :left)\n\nConstruct a RasterLayerHistogram from a Raster. The flattened Raster data, with the missing values removed, is passed to the fit(::Histogram) function from StatsBase.jl and a RasterLayerHistogram type is returned.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms.RasterSeriesHistogram","page":"Function index","title":"RasterHistograms.RasterSeriesHistogram","text":"mutable struct RasterSeriesHistogram <: AbstractRasterHistogram\n\nA RasterSeriesHistogram. The struct is mutable so that the histogram field can be updated using the normalize (or otherwise) function.\n\nlayers::Tuple: The layers (variables) from the RasterSeries used to fit the Histogram\nseries_dimension::Symbol: The dimension of the RasterSeries (usually this will be time)\nseries_length::Int64: The length of the `RasterSeries\ndimensions::Tuple: The dimensions of the elements (either a Raster or RasterStack) of the RasterSeries\nraster_size::Tuple: The size of the elements (either a Raster or RasterStack) of the RasterSeries\nhistogram::StatsBase.Histogram: The N-dimensional Histogram fitted to the N layers from RasterSeries\n\n\n\n\n\n","category":"type"},{"location":"library/function_index/#RasterHistograms.RasterSeriesHistogram-Union{Tuple{N}, Tuple{Rasters.RasterSeries, Tuple{Vararg{AbstractVector, N}}}} where N","page":"Function index","title":"RasterHistograms.RasterSeriesHistogram","text":"function RasterSeriesHistogram(series::RasterSeries, edges::NTuple{N, AbstractVector};\n                               closed = :left)\nfunction RasterSeriesHistogram(series::RasterSeries, weights::AbstractWeights,\n                               edges::NTuple{N, AbstractVector}; closed = :left)\n\nConstruct a RasterSeriesHistogram from a RasterSeries. Note that to merge Histograms the bin edges must be the same, so for this constructor the edges must be passed in. This constructor assumes that the dimensions are the same across all RasterStacks in the RasterSeries.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms.RasterStackHistogram","page":"Function index","title":"RasterHistograms.RasterStackHistogram","text":"mutable struct RasterStackHistogram <: AbstractRasterHistogram\n\nA RasterStackHistogram. The struct is mutable so that the histogram field can be updated using the normalize (or otherwise) function.\n\nlayers::Tuple: The layers (variables) from the RasterStack used to fit the Histogram\ndimensions::Tuple: The dimensions of the RasterStack\nraster_size::Tuple: The size of the RasterStack layers\nhistogram::StatsBase.Histogram: The N-dimensional Histogram fitted to the N layers from RasterStack\n\n\n\n\n\n","category":"type"},{"location":"library/function_index/#RasterHistograms.RasterStackHistogram-Tuple{Rasters.RasterStack}","page":"Function index","title":"RasterHistograms.RasterStackHistogram","text":"function RasterStackHistogram(stack::RasterStack; closed = :left, nbins = nothing)\nfunction RasterStackHistogram(stack::RasterStack, weights::AbstractWeights;\n                              closed = :left, nbins = nothing)\nfunction RasterStackHistogram(stack::RasterStack, edges::NTuple{N, AbstractVector};\n                              closed = :left)\nfunction RasterStackHistogram(stack::RasterStack, weights::AbstractWeights,\n                              edges::NTuple{N, AbstractVector}; closed = :left)\n\nConstruct a RasterStackHistogram from a RasterStack. The resulting Histogram is N-dimensional, where N is the number of layers. The flattened Raster data for each layer, with themissing values removed, is passed to the fit(::Histogram) function from StatsBase.jl and a RasterStackHistogram type is returned.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#LinearAlgebra.normalize!-Tuple{RasterHistograms.AbstractRasterHistogram}","page":"Function index","title":"LinearAlgebra.normalize!","text":"function normalize!(arh::AbstractRasterHistogram; mode::Symbol = :pdf)\n\nNormalize the Histogram in the AbstractRasterHistogram according the desired mode. See the StatsBase.jl docs for information on the possible modes and how they work.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#MakieCore.convert_arguments","page":"Function index","title":"MakieCore.convert_arguments","text":"function convert_arguments(P::Type{<:AbstractPlot}, arh::AbstractRasterHistogram)\n\nConverting method so Makie.jl can plot an AbstractRasterHistogram. Note for plotting purposes a value correspnding to zero is replaced with NaN. This is to avoid in 2D plotting many zero values and as a result not seeing the distribtution clearly (in Makie.kj heatmap the NaN value is left out in plotting).\n\n\n\n\n\n","category":"function"},{"location":"library/function_index/#RasterHistograms.area_weights-Tuple{Union{Rasters.Raster, Rasters.RasterStack}}","page":"Function index","title":"RasterHistograms.area_weights","text":"function area_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)\n\nReturn the Weights for a Histogram calculated from the area of each grid cell in a Raster or RasterStack. The Raster or RasterStack must first be sliced over the dimensions one wishes to look at, e.g. for area weights at sea surface the function need rs[Z(1)] to be passed in. If the original Raster only has two spatial dimensions then this step may be skipped. The keyword argument equator_one_degree is one degree at the equator in metres. The function returns a container Weights so can be passed straight into the fit(::Histogram) function.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms.volume_weights-Tuple{Union{Rasters.Raster, Rasters.RasterStack}}","page":"Function index","title":"RasterHistograms.volume_weights","text":"function volume_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)\n\nReturn the Weights for a Histogram calculated from the volume of each grid cell in a Raster or RasterStack. The model resolution is inferred from the X and Y dimensions of the Raster or RasterStack and assumes that along the X and Y the resolution is unique (though it can be different for X and Y). The keyword argument equator_one_degree is one degree at the equator in metres. The function returns a container Weights so can be passed straight into the fit(::Histogram) function.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms-private-functions","page":"Function index","title":"RasterHistograms private functions","text":"","category":"section"},{"location":"library/function_index/","page":"Function index","title":"Function index","text":"Modules = [RasterHistograms]\nPublic = false","category":"page"},{"location":"library/function_index/#RasterHistograms.AbstractRasterHistogram","page":"Function index","title":"RasterHistograms.AbstractRasterHistogram","text":"Abstract supertype for a RasterHistogram.\n\n\n\n\n\n","category":"type"},{"location":"library/function_index/#Base.iterate","page":"Function index","title":"Base.iterate","text":"iterate methods for AbstractRasterHistograms.\n\n\n\n\n\n","category":"function"},{"location":"library/function_index/#Base.show-Tuple{IO, RasterLayerHistogram}","page":"Function index","title":"Base.show","text":"show methods for AbstractRasterHistograms.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms.find_stack_non_missing-Tuple{Rasters.RasterStack}","page":"Function index","title":"RasterHistograms.find_stack_non_missing","text":"function find_stack_non_missing(stack::RasterStack)\n\nReturn a Raster of type Bool that contains the intersection of the non-missing values from the layers of a RasterStack.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RasterHistograms.raster_zeros_to_nan-Tuple{RasterHistograms.AbstractRasterHistogram}","page":"Function index","title":"RasterHistograms.raster_zeros_to_nan","text":"function raster_zeros_to_nan(arh::AbstractRasterHistogram)\n\nConvert the zeros (i.e. empty bins in the AbstractRasterHistogram) to NaNs for plotting in Makie.\n\n\n\n\n\n","category":"method"},{"location":"library/function_index/#RecipesBase.apply_recipe-Tuple{AbstractDict{Symbol, Any}, Type{<:RasterHistograms.AbstractRasterHistogram}, RasterHistograms.AbstractRasterHistogram}","page":"Function index","title":"RecipesBase.apply_recipe","text":"Conversion method for plotting in Plots.jl\n\n\n\n\n\n","category":"method"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"EditURL = \"../../../examples/raster_histograms.jl\"","category":"page"},{"location":"literated/raster_histograms/#raster_hist_example","page":"Histograms from Rasters","title":"Raster Histograms","text":"","category":"section"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"First, add the required depedencies","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"using Rasters, NCDatasets, Downloads, CairoMakie","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"and the RasterHistograms package.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"using RasterHistograms","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"Using this package we can produce Histograms from data that is in a Raster, RasterStack or RasterSeries, which are N-dimensional arrays, in a similar way that xhistogram works for xarray in python. This example is structured similarly to the xhistogram tutorial.","category":"page"},{"location":"literated/raster_histograms/#Randomly-generated-toy-data","page":"Histograms from Rasters","title":"Randomly generated toy data","text":"","category":"section"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"First we generate some randomly distributed data and form a Raster.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"x, t = range(-2π, 2π; length = 50), range(0, 4π; length = 100)\ndimensions = (X(x), Ti(t))\nrs = Raster(randn(length(x), length(t)), dimensions; name = :Toy_data)","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"The we can form a RasterLayerHistogram for the :Toy_data","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"rs_hist = RasterLayerHistogram(rs)","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"We can then plot the data and the Histogram","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"fig = Figure(size = (1000, 600))\nax1 = Axis(fig[1, 1];\n           title = \"Toy data\",\n           xlabel = \"x\",\n           ylabel = \"time\")\nhm = heatmap!(ax1, x, t, rs.data)\nColorbar(fig[2, 1], hm; vertical = false, flipaxis = false)\nax2 = Axis(fig[1, 2];\n          title = \"Histogram of Toy data\",\n          xlabel = \"Toy data\", ylabel = \"Counts\")\nplot!(ax2, rs_hist; color = :steelblue)\nfig","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"By default the Histogram has the counts in each bin. We can normalise the Histogram by calling the normalize! function on rs_hist and choosing a mode of normalisation. For more information about the possible modes of normalisation see here.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"normalize!(rs_hist; mode = :pdf)","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"Then replot with the normalised histogram","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"fig = Figure(size = (900, 600))\nax1 = Axis(fig[1, 1];\n           title = \"Toy data\",\n           xlabel = \"x\",\n           ylabel = \"time\")\nhm = heatmap!(ax1, x, t, rs.data)\nColorbar(fig[2, 1], hm; vertical = false, flipaxis = false)\nax2 = Axis(fig[1, 2];\n          title = \"Histogram (pdf) of Toy data\",\n          xlabel = \"Toy data\", ylabel = \"density\")\nplot!(ax2, rs_hist; color = :steelblue)\nfig","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"info: Info\nPlotting using Plots.jl is also possible. See the module documentation for more info.","category":"page"},{"location":"literated/raster_histograms/#Real-world-data-example","page":"Histograms from Rasters","title":"Real world data example","text":"","category":"section"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"This package is mainly concerned with ocean variables, so we now look at temperature and salinity distributions using ECCO model output.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"Downloads.download(\"https://opendap.earthdata.nasa.gov/providers/POCLOUD/collections/ECCO%2520Ocean%2520Temperature%2520and%2520Salinity%2520-%2520Daily%2520Mean%25200.5%2520Degree%2520(Version%25204%2520Release%25204)/granules/OCEAN_TEMPERATURE_SALINITY_day_mean_2007-01-01_ECCO_V4r4_latlon_0p50deg.dap.nc4\", \"ECCO_data.nc\")","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"This example also shows how the module works for 2-dimensional Histograms though it can be generalised to N dimensions depending on the number of variables (i.e. layers in the RasterStack) one is looking at.","category":"page"},{"location":"literated/raster_histograms/#Forming-the-RasterStack","page":"Histograms from Rasters","title":"Forming the RasterStack","text":"","category":"section"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"We form a RasterStack with only the :SALT (practical salinity) and :THETA (potential temperature) layers. This means the resulting RasterStackHistogram will be 2 dimensional. Note the order of the variables matters here for plotting purposes. The first layer, in this case :SALT will be the x-axis, and the second layer :THETA will be the y-axis.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"stack_TS = RasterStack(\"ECCO_data.nc\"; name = (:SALT, :THETA))\nedges = (31:0.025:38, -2:0.1:32)\nstack_hist = RasterStackHistogram(stack_TS, edges)","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"Now we can plot, the histogram and look at the unweighted distribtution of temperature and salinity. By default the empty bins are plotted with the value of zero. To not plot the empty bins argument we pass show_empty_bins = false to the plotting function.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"fig = Figure(size = (500, 500))\nax = Axis(fig[1, 1];\n          title = \"Temperature and salinity joint distribution (unweighted)\",\n          xlabel = \"Practical salinity (psu)\",\n          ylabel = \"Potential temperature (°C)\")\nhm = heatmap!(ax, stack_hist; colorscale = log10)\nColorbar(fig[1, 2], hm)\nfig","category":"page"},{"location":"literated/raster_histograms/#Weighting-the-Histogram","page":"Histograms from Rasters","title":"Weighting the Histogram","text":"","category":"section"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"The module also exports simple functions for calculating area and volume weights from the dimensions of the grid and plot the data. Where weights are available from model data they should be used in favour of the functions.","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"dV = volume_weights(stack_TS)\nweighted_stack_hist = RasterStackHistogram(stack_TS, dV, edges)\nfig = Figure(size = (500, 500))\nax = Axis(fig[1, 1];\n          title = \"Temperature and salinity joint distribution (weighted)\",\n          xlabel = \"Practical salinity (psu)\",\n          ylabel = \"Potential temperature (°C)\")\nhm = heatmap!(ax, weighted_stack_hist; colorscale = log10)\nColorbar(fig[1, 2], hm)\nfig","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"","category":"page"},{"location":"literated/raster_histograms/","page":"Histograms from Rasters","title":"Histograms from Rasters","text":"This page was generated using Literate.jl.","category":"page"},{"location":"modules/RasterHistograms/#raster_hist_module","page":"RasterHistograms","title":"RasterHistograms","text":"","category":"section"},{"location":"modules/RasterHistograms/#Package-workings","page":"RasterHistograms","title":"Package workings","text":"","category":"section"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"For a single Raster (i.e. one variable)","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"DocTestSetup = quote\n    using Rasters, RasterHistograms\nend","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"julia> dummy_data = repeat(1:10; outer = (1, 10));\n\njulia> rs = Raster(dummy_data, (X(1:10), Ti(1:10)); name = :dummy_variable);\n\njulia> rs_hist = RasterLayerHistogram(rs)\nRasterLayerHistogram for the variable dummy_variable\n┣━━ Layer dimensions: (:X, :Ti) \n┣━━━━━━━━ Layer size: (10, 10)\n┗━━━━━━━━━ Histogram: 1-dimensional\n\njulia> rs_hist.histogram\nStatsBase.Histogram{Int64, 1, Tuple{StepRangeLen{Float64, Base.TwicePrecision{Float64}, Base.TwicePrecision{Float64}, Int64}}}\nedges:\n  0.0:2.0:12.0\nweights: [10, 20, 20, 20, 20, 10]\nclosed: left\nisdensity: false\n","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"a one dimensional Histogram that has been fit to the dumy_variable data is returned in the rs_hist.histogram field as well as some information about the data the Histogram was fit to. If a RasterStack or RasterSeries with multiple layers is passed in the default behaviour is to fit an N-dimensional Histogram where N is the number of layers (i.e. the number of variables).","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"julia> vars = (v1 = randn(10, 10), v2 = randn(10, 10), v3 = randn(10, 10));\n\njulia> stack = RasterStack(vars, (X(1:10), Y(1:10)))\nRasterStack with dimensions: \n  X Sampled{Int64} 1:10 ForwardOrdered Regular Points,\n  Y Sampled{Int64} 1:10 ForwardOrdered Regular Points\nand 3 layers:\n  :v1 Float64 dims: X, Y (10×10)\n  :v2 Float64 dims: X, Y (10×10)\n  :v3 Float64 dims: X, Y (10×10)\n\n\njulia> RasterStackHistogram(stack)\nRasterStackHistogram for the variables (:v1, :v2, :v3)\n┣━━ Stack dimensions: (:X, :Y)\n┣━━ Stack layer size: (10, 10)\n┗━━━━━━━━━ Histogram: 3-dimensional\n","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"info: Info\nThe order of the variables for the Histogram is the order of the layers in the RasterStack or RasterSeries. This can be important for plotting when variables are desired to be on specific axes. In the example above v1 would be on the x-axis, v2 the y-axis and v3 the z-axis. To change which axes the variables correspond to, the order of the layers in the RasterStack would need to be altered (or you could plot from the histogram.weights matrix).","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"DocTestSetup = nothing","category":"page"},{"location":"modules/RasterHistograms/#Plotting","page":"RasterHistograms","title":"Plotting","text":"","category":"section"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"Both Makie.jl and Plots.jl have functions in the module to extract the Histogram object from the AbstractRasterHistogram for plotting. To plot in either package one can just call","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"julia> using #Plotting package e.g. CairoMakie.jl or PLots.jl \n\njulia> plot(::AbstractRasterHistogram)","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"and an N-dimensional Histogram will be plotted where N is the dimension of the ::AbstractRasterHistogram. Makie.jl is used in the exmaple.","category":"page"},{"location":"modules/RasterHistograms/","page":"RasterHistograms","title":"RasterHistograms","text":"For a full list of the functions in this module see the function index or look at the example to see the module in action.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = RasterHistograms","category":"page"},{"location":"#RasterHistograms.jl-Documentation","page":"Home","title":"RasterHistograms.jl Documentation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for RasterHistograms.","category":"page"},{"location":"","page":"Home","title":"Home","text":"RasterHistograms.jl uses empirical estimation from StatsBase.jl to fit Histograms to Raster, RasterStack or RasterSeries data structures. Arguments that can be passed to fit(::Histogram) can be passed to the constructors for the the various AbstractRasterHistograms. The aim of the module is to provide functionality similar to python's xhistogram for xarray in Julia.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For information about how the module works see here or take a look at the example","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you have find any bugs or have a feature request/suggestion please raise an issuu in the RasterHistograms.jl repository.","category":"page"}]
}