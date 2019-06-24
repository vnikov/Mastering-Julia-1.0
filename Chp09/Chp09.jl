
using SQLite

db = SQLite.DB("quotes.db")   # SQLiteDB() etc., are not exported

SQLite.tables(db)

SQLite.columns(db,"quotes")

# New syntax, using dataframes

df = DataFrame(SQLite.Query(db, "select count(*) as N from quotes"))

df[1]

df = DataFrame(SQLite.Query(db, "select * from quotes limit 10"))

sql =  "select q.quoname, q.author, c.catname from quotes q ";
sql *= "join categories c on q.cid = c.id limit 5";

df = DataFrame(SQLite.Query(db,sql))

# The feather package can be used to store snapshots of queries
using Feather

Feather.write("QuoView01.feather", df)

# Retrieving fro a feather file is "lazy"
# That is the metadata is read but records are fetched when they are referenced
# So feather files can hold very large datasets with little memory overhead.

dfx = Feather.read("QuoView01.feather");
size(dfx)

dfx[1,1]   # Get first quote

sql =  "select q.quoname from quotes q ";
sql *= " where q.author = 'Oscar Wilde'";
SQLite.Query(db,sql) |> DataFrame

sql =  "select q.quoname, q.author, c.catname from quotes q ";
sql *= "join categories c on q.cid = c.id";

df = DataFrame(SQLite.Query(db,sql));
nrows = size(df)[1];
println("Number of rows: $nrows" )



# Assumes Postgres is running and the Chinook dataset loaded into a database 'chinnok'
using LibPQ, DataStreams
conn = LibPQ.Connection("dbname=chinook");

res = execute(conn, "SELECT count(*) FROM \"Album\"");  # Note escaping the quotes
Data.stream!(res, NamedTuple)

qry = fetch!(NamedTuple, execute(conn, "SELECT count(*) as NA FROM \"Album\""));
qry[1][1]

qry = fetch!(NamedTuple, execute(conn, "SELECT * FROM \"MediaType\""))

qry[:Name]

qry.FirstName[1]

sqlx = """select e."FirstName", e."LastName", count(i."InvoiceId") as "Sales"
 from "Employee" as e
 join "Customer" as c on e."EmployeeId" = c."SupportRepId"
 join "Invoice" as i on i."CustomerId" = c."CustomerId"
 group by e."EmployeeId"
""";

qry = fetch!(NamedTuple, execute(conn, sqlx))

using Printf
for i in 1:length(qry)
    @printf("%s %s has %d sales\n",
        qry.FirstName[i],qry.LastName[i],qry.Sales[i])
end


