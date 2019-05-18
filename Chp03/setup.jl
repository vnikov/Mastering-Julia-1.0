#!/usr/local/bin/julia
#
const PKGS = ["BenchmarkTools","Match","PyPlot","StaticArrays"]
println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
