#!/usr/local/bin/julia
#
const PKGS = ["Plots","Distributions","Loess","LossFunctions","RDatasets","Clustering",
              "DecisionTree","Flux","Metalhead","Images","Knet","Mamba","Gadfly"]

println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
