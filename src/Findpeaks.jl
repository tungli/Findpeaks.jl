module Findpeaks

export findpeaks

"""
`findpeaks(y::Array{T},
x::Array{S}=collect(1:length(y))
;minHeight::T=minimum(y), minProm::T=minimum(y),
minDist::S=0, threshold::T=0 ) where {T<:Real,S}`\n
Returns indices of local maxima (sorted from highest peaks to lowest)
in 1D array of real numbers. Similar to MATLAB's findpeaks().\n
*Arguments*:\n
`y` -- data\n
*Optional*:\n
`x` -- x-data\n
*Keyword*:\n
`minHeight` -- minimal peak height\n
`minProm` -- minimal peak prominence\n
`minDist` -- minimal peak distance (keeping highest peaks)\n
`threshold` -- minimal difference (absolute value) between
 peak and neighboring points\n
"""
function findpeaks(y::Array{T},
    x::Array{S}=collect(1:length(y))
    ;minHeight::T=minimum(y), minProm::T=minimum(y),
    minDist::S=zero(x[1]), threshold::T=zero(y[1]) ) where {T<:Real,S}

    peaks = Array{Int64,1}()
    dy = diff(y)
    #differences inside threshold
    for i = 2:length(dy)
        if dy[i] <= -threshold && dy[i-1] >= threshold
            push!(peaks,i)
        end
    end

    #calculate prominences
    yP = y[peaks]
    prominence = zeros(Float64,length(yP))
    for (i,p) in enumerate(peaks)
        lP, rP = 1, length(y)
        for j = (i-1):-1:1
            if yP[j] > yP[i]
                lP = peaks[j]
                break
            end
        end
        ml = minimum(y[lP:p])
        for j = (i+1):length(yP)
            if yP[j] > yP[i]
                rP = peaks[j]
                break
            end
        end
        mr = minimum(y[p:rP])
        ref = max(mr,ml)
        prominence[i] = yP[i] - ref
    end

    #minimal prominence refinement
    peaks = peaks[prominence .> minProm]

    #minimal height refinement
    peaks = peaks[y[peaks] .> minHeight]
    yP = y[peaks]

    #minimal distance refinement
    peaks2del = zeros(Bool,length(peaks))
    inds = sortperm(y[peaks],rev=true)
    permute!(peaks,inds)
    for i = 1:length(peaks)
        for j = 1:(i-1)
            if abs(x[peaks[i]] - x[peaks[j]]) <= minDist
                if !peaks2del[j]
                    peaks2del[i] = true
                end
            end
        end
    end

    peaks[.!peaks2del]
end

end # module
