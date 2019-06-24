#!/usr/local/bin/julia
#
const PKGS = ["RDatasets","DataFrames","Plots","PyPlot","PlotlyJS","UnicodePlots","Images",
              "Winston","PGFPlots","Luxor","Gadfly","StatsPlots","GraphPlot","Makie"]

println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
