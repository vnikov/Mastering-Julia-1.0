
using JuliaDB, IndexedTables, OnlineStats

using StatsPlots, StaticArrays   # Note the name change from Stat[s]Plots

cd("/Users/malcolm/PacktPub/Chp09")

# Load the data
flights = loadtable("Files/hhflights.csv");

# Define a filter (1st day os each month)

filter(i -> (i.Month == 1) && (i.DayofMonth == 1), flights)

# Select all flights Departure/Arrival/FlightNum
select(flights, (:DepTime, :ArrTime, :FlightNum))

filter(i -> i.DepDelay > 60, select(flights, (:UniqueCarrier, :DepDelay)))

# Apply function to each row, using 'map'

speedy = map(i -> i.Distance / i.AirTime * 60, flights)

# Add speed to the dataset
flights = pushcol(flights, :Speedy, speedy)

using ShiftedArrays
y = groupby(length, flights, :Month)
lengths = columns(y, :length)
pushcol(y, :change, lengths .- lag(lengths))

# Apply several operations
import Lazy
Lazy.@as x flights begin
    select(x, (:UniqueCarrier, :DepDelay))
    filter(i -> i.DepDelay > 60, x)
end

# Performance

using BenchmarkTools
sortedflights = reindex(flights, :Dest)

# println("Presorted timing:")
# @benchmark groupby(NamedTuple(avg_delay = mean.(dropmissing(sortedflights), sortedflights, select = :ArrDelay)))

# Grouping

using StatsBase, Nullables
fc = filter(t->!isnull(t.DepDelay), flights)

gfc = groupby(fc, :UniqueCarrier, select = (:Month, :DayofMonth, :DepDelay), flatten = true) do dd
    rks = ordinalrank(column(dd, :DepDelay), rev = true)
    sort(dd[rks .<= 2], by =  i -> i.DepDelay, rev = true)
end

#=
groupby(fc, :UniqueCarrier, select = (:Month, :DayofMonth, :DepDelay), flatten = true) do dd
    select(dd, 1:2, by = i -> i.DepDelay, rev = true)
end
=#

# Visualization

using StatsPlots
gr(fmt = :png) # choose the fast GR backend and set format to png: svg would probably crash with so many points
@df flights scatter(:DepDelay, :ArrDelay, group = :Distance .> 1000,  fmt = :png, layout = 2, legend = :topleft)


# using Pkg

# path = Pkg.dir("JuliaDB", "test", "sample")
# path = joinpath(dirname(pathof(JuliaDB)), "..","test","sample")
path =  joinpath(homedir(), "PacktPub","Chp09","Files","Stocks")

### sampledata = loadfiles(path, indexcols=["date", "ticker"])
stockdata = loadndsparse(path, indexcols=["date", "ticker"])

using Dates
stockdata[Date("2010-06-01"), "GOOGL"] 

stockdata[Date("2012-01"):Dates.Month(1):Date("2014-12"), ["GOOGL", "KO"]]

filter(x ->  x.close >= 100.0 && x.close <= 140.0, stockdata[:, "GS"])

### select(stockdata, 1=>Dates.ismonday, 2=>x->startswith(x, "G"))
goFri = filter((1=>Dates.isfriday, 2=>x->startswith(x, "GO")), stockdata)

# Select just the GOOGLE stocks 
googl = stockdata[:, ["GOOGL"]]

# Create a set of spread values (i.e High - Low)
spread = map(x -> x.high - x.low, googl)

# Compute the average spread
round(reduce(+,(mean.(spread)))/length(spread), digits=4)

# More realistic is the average gain (i.e. Open - Close)
gain = map(x -> x.open - x.close, googl)
round(reduce(+,(mean.(gain)))/length(gain), digits=4)

# Note that dataset is only the FIRST day in the month so the value is not necessarily 

# pushcol(googl, :gain, gain)

# sratio = (Open - Close)/(High - Low ) ϵ [-1.0,1.0] 
ρ = map(x -> (x.open - x.close) / (x.high - x.low), googl)
round(reduce(+,(mean.(ρ)))/length(ρ),digits=4)

# If this is Weiner (Brownian) process the value should be about 0.5

using OnlineStats

reduce(Mean(), googl; select = :close)

groupreduce(Mean(),stockdata,:ticker; select=:close)

using StatsPlots

@df stockdata plot(:date, :close, group=:ticker, layout = 4, legend = :topleft)

spread[:,:]



volumes = map(x -> x.volume, stockdata)

describe(volumes)

# volumes = map(pick(:volume), stockdata)

reduce(+, map(x -> x.volume, stockdata))

# Does not work in Jupyter
#= 
@everywhere function agg_ohlcv(x, y)
    Named_Tuple(
        open = x.open, 
        high = maximum(x.high, y.high),
        low = minimum(x.low, y.low),
        close = y.close, 
        volume = x.volume + y.volume,
    )
end

reducedim(agg_ohlcv, sampledata, 1)
=#

using MySQL, IndexedTables

conn = MySQL.connect("localhost", "root", "LQaLxxy6",db="Chinook", 
            unix_socket="/Applications/MAMP/tmp/mysql/mysql.sock");
            
sql = "select a.FirstName,a.LastName, sum(b.Total) as 'TotalSpent'";
sql *= " from Customer a";
sql *= " join Invoice b on a.CustomerId = b.CustomerId";
sql *= " group by a.FirstName, a.LastName";

tbl = MySQL.query(conn,sql) |> table



t = table(NamedTuple(x = randn(100), y = randn(100)))
@df t scatter(:x, :y)

path = Pkg.dir(homedir(), "PacktPub", "Chp09")

cd(path)
# diamonds = loadtable("datasets/diamonds.csv"; indexcols = [:carat])
diamonds = loadndsparse("Files/diamonds.csv"; indexcols = [:carat])



t = table(1:100, rand(Bool, 100), randn(100))

reduce(Mean(), t; select = 3)

groupreduce(Mean(), t, 2; select=3)


