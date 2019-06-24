#!/usr/local/bin/julia
#
const PKGS = ["BenchmarkTools","StatsBase","Nullables","SQLite","Feather","MySQL","LibPQ","DataStreams",
              "JuliaDB","IndexedTables","OnlineStats","StatsPlots","StaticArrays","ShiftedArrays","StatsPlots"]

println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
