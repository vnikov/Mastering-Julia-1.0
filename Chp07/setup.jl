#!/usr/local/bin/julia
#
const PKGS = ["Distributions","PyPlot","Plots","FFTW","DSP","OrdinaryDiffEq","Sundials","Roots",
              "Sundials","DifferentialEquations","Calculus","ForwardDiff","SymPy","QuadGK",
              "HCubature","JuMP","Clp","GLPK","Optim","SimJulia","ResumableFunctions"]

println("Installing required packages ...")

using Pkg
ipks = Pkg.installed()
for p in PKGS
    println("> $p")
    !haskey(ipks,p) && Pkg.add(p)
end
println("Done!")
