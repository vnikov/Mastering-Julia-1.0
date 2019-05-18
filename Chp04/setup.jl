#!/usr/local/bin/julia
#
const PKGS = ["BenchmarkTools","MacroTools", "Lazy"]
println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
