
using JuliaDB, IndexedTables, OnlineStats

path =  joinpath(homedir(), "PacktPub","Chp09","Files","Stocks")

tickdata = loadndsparse(path, indexcols=["date", "ticker"])

using Dates
tickdata[Date("2010-06-01"), "GOOGL"] 

tickdata[Date("2012-01"):Dates.Month(1):Date("2014-12"), ["GOOGL", "KO"]]

filter(:date=>Dates.ismonday, tickdata)

filter((1=>Dates.ismonday, 2=>x->startswith(x, "G")), tickdata)

filter(x -> x.low > 10.0, tickdata)

diffs = map(x -> x.high - x.low, tickdata)

volumes = map(x -> x.volume, tickdata)

BigInt(reduce(+, map(x -> x.volume, tickdata)))

using MySQL, IndexedTables

conn = MySQL.connect("localhost", "root", "LQaLxxy6",db="Chinook", 
            unix_socket="/Applications/MAMP/tmp/mysql/mysql.sock");
            
sql = """select a.FirstName,a.LastName, sum(b.Total) as TotalSpent 
 from Customer a
 join Invoice b on a.CustomerId = b.CustomerId
 group by a.FirstName, a.LastName""";

tbl = MySQL.query(conn,sql) |> table

using Tables
rows = Tables.rows(tbl)
sch = Tables.schema(rows)
names = sch.names

for row in rows
    Tables.eachcolumn(sch, row) do val, col, name
        println(col," :: ",name)
    end
end


