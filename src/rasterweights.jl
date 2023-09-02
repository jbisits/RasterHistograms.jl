"""
    function area_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)
Return the `Weights` for a `Histogram` calculated from the area of each grid cell in a
`Raster` or `RasterStack`. The `Raster` or `RasterStack` must first be sliced over the
dimensions one wishes to look at, e.g. for area weights at sea surface the function need
`rs[Z(1)]` to be passed in. If the original `Raster` only has two spatial dimensions then
this step may be skipped.
The keyword argument `equator_one_degree` is one degree at the equator in metres.
The function returns a container `Weights` so can be passed straight into
the `fit(::Histogram)` function.
"""
function area_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)

    rs = typeof(rs) <: RasterStack ? rs[keys(rs)[1]] : rs

    dA = if !hasdim(rs, :Z)
             lon, lat = lookup(rs, X), lookup(rs, Y)
             lon_model_resolution = unique(diff(lon))[1]
             lat_model_resolution = unique(diff(lat))[1]
             dx = (equator_one_degree * lon_model_resolution) .* ones(length(lon))
             dy = (equator_one_degree * lat_model_resolution) .* cos.(deg2rad.(lat))
             hasdim(rs, Ti) ? repeat(reshape(dx * dy', :), outer = length(lookup(rs, Ti))) :
                              reshape(dx * dy', :)
         elseif !hasdim(rs, :Y)
             lon, z = lookup(rs, X), lookup(rs, Z)
             lon_model_resolution = unique(diff(lon))[1]
             dx = (equator_one_degree * lon_model_resolution) .* ones(length(lon))
             dz = diff(abs.(z))
             dz = vcat(dz[1], dz)
             hasdim(rs, Ti) ? repeat(reshape(dx * dz', :), outer = length(lookup(rs, Ti))) :
                              reshape(dx * dz', :)
         elseif !hasdim(rs, :X)
             lat, z = lookup(rs, Y), lookup(rs, Z)
             lat_model_resolution = unique(diff(lat))[1]
             dy = (equator_one_degree * lat_model_resolution) .* cos.(deg2rad.(lat))
             dz = diff(abs.(z))
             dz = vcat(dz[1], dz)
             hasdim(rs, Ti) ? repeat(reshape(dy * dz', :), outer = length(lookup(rs, Ti))) :
                              reshape(dy * dz', :)
         end

    return weights(dA)

end
"""
    function volume_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)
Return the `Weights` for a `Histogram` calculated from the volume of each grid cell in a
`Raster` or `RasterStack`. The model resolution is inferred from the `X` and `Y` dimensions
of the `Raster` or `RasterStack` and assumes that along the `X` and `Y` the resolution is
unique (though it can be different for `X` and `Y`).
The keyword argument `equator_one_degree` is one degree at the
equator in metres. The function returns a container `Weights` so can be passed straight into
the `fit(::Histogram)` function.
"""
function volume_weights(rs::Union{Raster, RasterStack}; equator_one_degree = 111e3)

    rs = typeof(rs) <: RasterStack ? rs[keys(rs)[1]] : rs
    lon, lat, z = lookup(rs, X), lookup(rs, Y), lookup(rs, Z)
    lon_model_resolution = unique(diff(lon))[1]
    lat_model_resolution = unique(diff(lat))[1]
    dx = (equator_one_degree * lon_model_resolution) .* ones(length(lon))
    dy = (equator_one_degree * lat_model_resolution) .* cos.(deg2rad.(lat))
    dz = diff(abs.(z))
    dz = vcat(dz[1], dz)
    dV = Array{Float64}(undef, length(dx), length(dy), length(dz))
    for i ∈ axes(dV, 3)
        dV[:, :, i] = (dx .* dy') * dz[i]
    end
    dV_vec = hasdim(rs, Ti) ? repeat(reshape(dV, :), outer = length(lookup(rs, Ti))) :
                              reshape(dV, :)

    return weights(dV_vec)

end
