#!/usr/local/bin/julia
#
const PKGS = ["RDatasets","CSV","JLD","HDF5","Query","Match","PyPlot","GR","StatsBase",
	      "Distributions","GLM","HypothesisTests","KernelDensity","Clustering"]

println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
