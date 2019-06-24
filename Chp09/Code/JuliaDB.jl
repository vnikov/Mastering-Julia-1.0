
using JuliaDB, IndexedTables, OnlineStats

using StatsPlots, StaticArrays   # Note the name change from Stat[s]Plots

# Load the data

flights = loadtable("Files/hhflights.csv");

# Define a filter (1st day os each month)

filter(i -> (i.Month == 1) && (i.DayofMonth == 1), flights);

# Select all flights Departure/Arrival/FlightNum
select(flights, (:DepTime, :ArrTime, :FlightNum))

filter(i -> i.DepDelay > 60, select(flights, (:UniqueCarrier, :DepDelay)))

# Apply function to each row, using 'map'

speed = map(i -> i.Distance / i.AirTime * 60, flights)

# Add speed to the dataset
flights = pushcol(flights, :Speed, speed);

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
# @benchmark groupby(NamedTuple(avg_delay = mean∘dropna), sortedflights, select = :ArrDelay)

# Grouping

using StatsBase, Nullables
fc = filter(t->!isnull(t.DepDelay), flights)

#=
gfc = groupby(fc, :UniqueCarrier, select = (:Month, :DayofMonth, :DepDelay), flatten = true) do dd
    rks = ordinalrank(column(dd, :DepDelay), rev = true)
    sort(dd[rks .<= 2], by =  i -> i.DepDelay, rev = true)
end


groupby(fc, :UniqueCarrier, select = (:Month, :DayofMonth, :DepDelay), flatten = true) do dd
    select(dd, 1:2, by = i -> i.DepDelay, rev = true)
end
=#

# Visualization

using StatsPlots
gr(fmt = :png) # choose the fast GR backend and set format to png: svg would probably crash with so many points
@df flights scatter(:DepDelay, :ArrDelay, group = :Distance .> 1000,  fmt = :png, layout = 2, legend = :topleft)


homedir()

# using Pkg

# path = Pkg.dir("JuliaDB", "test", "sample")
path = joinpath(dirname(pathof(JuliaDB)), "..","test","sample")
# path =  joinpath(homedir(), "PacktPub","Chp09","Files","Stocks")

### sampledata = loadfiles(path, indexcols=["date", "ticker"])
sampledata = loadndsparse(path, indexcols=["date", "ticker"])


using Dates
sampledata[Date("2010-06-01"), "GOOGL"] 

sampledata[Date("2012-01"):Dates.Month(1):Date("2014-12"), ["GOOGL", "KO"]]

### select(sampledata, :date=>Dates.ismonday)
filter(:date=>Dates.ismonday, sampledata)

### select(sampledata, 1=>Dates.ismonday, 2=>x->startswith(x, "G"))
filter((1=>Dates.ismonday, 2=>x->startswith(x, "G")), sampledata)

filter(x -> x.low > 10.0, sampledata)

diffs = map(x -> x.high - x.low, sampledata)

volumes = map(x -> x.volume, sampledata)

### volumes = map(pick(:volume), sampledata)
reduce(+, map(x -> x.volume, sampledata))

# Does not work in Jupyter
#= 
@everywhere function agg_ohlcv(x, y)
           @NT(
               open = x.open, # first
               high = max(x.high, y.high),
               low = min(x.low, y.low),
               close = y.close, # last
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


