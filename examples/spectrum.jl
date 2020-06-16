using Findpeaks

using DelimitedFiles

using Plots
default(legend=false)


data = readdlm("../assets/example_spectrum.txt")
x = data[:, 1]
y = data[:, 2]

peaks = findpeaks(y, x, min_prom=1000.)

plot(x, y, title="Prominent peaks")
scatter!(x[peaks], y[peaks])
savefig("prom_peaks.png")

sep = 0.2

peaks = findpeaks(y, x, min_dist=sep)

plot(x, y, title="Peaks at least $sep units apart")
scatter!(x[peaks], y[peaks])
savefig("dist_peaks.png")



