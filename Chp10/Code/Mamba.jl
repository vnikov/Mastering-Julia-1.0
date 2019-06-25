
# https://mambajl.readthedocs.io/en/latest/tutorial.html#mcmc-simulation

using Mamba, LinearAlgebra, Distributions

model = Model(y = Stochastic(1,(μ , ν) ->  MvNormal(μ , sqrt(ν)), false),
              μ  = Logical(1,(xm, β) -> xm * β, false),
              β = Stochastic(1, () -> MvNormal(2, sqrt(1000))),
              ν = Stochastic(() -> InverseGamma(0.001, 0.001)) );

## Hybrid No-U-Turn and Slice Sampling Scheme
sc1 = [NUTS(:β), Slice(:ν, 3.0)];

## No-U-Turn Sampling Scheme
sc2 = [NUTS([:β, :ν])];

## User-Defined Samplers

Gibbs_β = Sampler([:β],
   (β, ν, xm, y) ->  begin
      β_mean = mean(β.distr)
      β_invcov = invcov(β.distr)
      σ = inv(Symmetric(xm' * xm / ν + β_invcov))
      μ = σ * (xm' * y / ν  +  β_invcov * β_mean)
      rand(MvNormal(μ , σ))
   end
);

Gibbs_ν = Sampler([:ν], (μ, ν, y) -> begin
      a = length(y) / 2.0 + shape(ν.distr)
      b = sum(abs2, y - μ) / 2.0 + scale(ν.distr)
      rand(InverseGamma(a, b))
    end
);

## User-Defined Sampling Scheme
sc3 = [Gibbs_β, Gibbs_ν];

setsamplers!(model, sc3);

draw(model, filename="lineDAG.dot");

run(`ls -l lineDAG.dot`)     # Recall wildcards do NOT work, they are a function of the shell

## Data
line = Dict{Symbol, Any}(:x => [1, 2, 3, 4, 5], :y => [1, 3, 3, 3, 5] )
line[:xm] = [ones(5) line[:x]];

## Initial Values
inits = [ Dict{Symbol, Any}( 
    :y => line[:y], :β => rand(Normal(0, 1), 2),:ν => rand(Gamma(1, 1))) for i in 1:3 ];

setsamplers!(model, sc1)
sim1 = mcmc(model, line, inits, 10000, burnin=250, thin=2, chains=3)

gelmandiag(sim1, mpsrf=true, transform=true) |> showall

setsamplers!(model, sc2)
sim2 = mcmc(model, line, inits, 10000, burnin=250, thin=2, chains=3)

gelmandiag(sim2, mpsrf=true, transform=true) |> showall

setsamplers!(model, sc3)
sim3 = mcmc(model, line, inits, 10000, burnin=250, thin=2, chains=3)

gelmandiag(sim3, mpsrf=true, transform=true) |> showall

sim = sim1

gewekediag(sim) |> showall

heideldiag(sim) |> showall

rafterydiag(sim) |> showall

# https://mambajl.readthedocs.io/en/latest/mcmc/chains.html#section-convergence-diagnostics

## Summary Statistics
describe(sim)

## Highest Posterior Density Intervals
hpd(sim)

## Lag-Autocorrelations
autocor(sim)

## State Space Change Rate (per Iteration)
changerate(sim)

## Deviance Information Criterion
dic(sim3)

## Subset Sampler Output
sim = sim[1000:5000, ["β[1]", "β[2]"], :]
describe(sim)

using Gadfly

p = plot(sim)

draw(p, filename="summaryplot.svg")
draw(p)

## Autocorrelation and running mean plots
p = plot(sim, [:autocor, :mean], legend=true)

draw(p, nrow=3, ncol=2, filename="autocormeanplot.svg")
draw(p, nrow=3, ncol=2)

## Pairwise contour plots
p = plot(sim, :contour)

draw(p, nrow=2, ncol=2, filename="contourplot.svg")
draw(p, nrow=2, ncol=2)


