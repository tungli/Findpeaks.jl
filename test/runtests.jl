using Findpeaks
using Base.Test

gaussian(x,μ,σ) = 1/sqrt(2*π)/σ*exp(-((x-μ)^2)/2/σ^2)
x = collect(linspace(1,1000,1000))
μ = rand(x)
data = gaussian.(x,μ,rand(x)/3)

p = findpeaks(data)
@test length(p) == 1
@test p[1] == μ
p = findpeaks(data,x)
@test length(p) == 1
@test p[1] == μ
