using RasterHistograms, StatsBase, Test
using LinearAlgebra: normalize, normalize!

include("test_rasterhistograms.jl")

@testset "RasterLayerHistogram" begin

    for i ∈ eachindex(RLH)
        for hf ∈ hist_fields
            @test getproperty(RLH[i].histogram, hf) == getproperty(raster_array_hists[i], hf)
        end
    end

end

@testset "RasterStackHistogram" begin

    for i ∈ eachindex(RSH)
        for hf ∈ hist_fields
            @test getproperty(RSH[i].histogram, hf)  == getproperty(stack_array_hists[i], hf)
        end
    end

end

@testset "RasterSeriesHistogram" begin

    for i ∈ eachindex(RSEH)
        for hf ∈ hist_fields
            if hf == :weights
                #Floating point errors appear so use approx for weights
                @test getproperty(RSEH[i].histogram, hf) ≈ getproperty(series_array_hists[i], hf)
            else
                @test getproperty(RSEH[i].histogram, hf) == getproperty(series_array_hists[i], hf)
            end
        end
    end

end

@testset "normalize!" begin

    for (i, mode) ∈ enumerate(modes)
        normalize!(RLH[i]; mode)
        normalize!(RSH[i]; mode)
        @test getproperty(RLH[i].histogram, :weights) ≈
                getproperty(normalize(raster_array_hists[i]; mode), :weights)
        @test getproperty(RSH[i].histogram, :weights) ≈
              getproperty(normalize(stack_array_hists[i]; mode), :weights)
        if i ≤ 2
            normalize!(RSEH[i]; mode)
            @test getproperty(RSEH[i].histogram, :weights) ≈
                    getproperty(normalize(series_array_hists[i]; mode), :weights)
        end

    end
end

@testset "Weight functions" begin

    @test dA_XY == area_weights(rs_stack[Z(1)]).values
    @test dA_XZ == area_weights(rs_stack[Y(1)]).values
    @test dA_YZ == area_weights(rs_stack[X(1)]).values
    @test dV == volume_weights(rs_stack).values

end

@testset "Not exported functions" begin

    @test RasterHistograms.find_stack_non_missing(rs_stack) == find_nm_stack

end
