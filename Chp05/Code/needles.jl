using Distributed
addprocs(4);

function needles_seq(n::Integer)
  @assert n > 0
  hit = 0
  for i = 1:n
    mp = rand()
    phi = (rand() * pi) - pi / 2   # angle at which needle falls
    xright = mp + cos(phi)/2       # x-location of needle
    xleft = mp - cos(phi)/2
    # Does needle cross either x == 0 or x == 1?
    p = (xright >= 1 || xleft <= 0) ? 1 : 0
    hit += p
  end
  miss = n - hit
  piapprox = n / hit * 2
end
#-> needles_seq (generic function with 1 method)

function needles_par(n)
  hit = @distributed (+) for i = 1:n
    mp = rand()
    phi = (rand() * pi) - pi / 2
    xright = mp + cos(phi)/2
    xleft = mp - cos(phi)/2
    (xright >= 1 || xleft <= 0) ? 1 : 0
  end
  miss = n - hit
  piapprox = n / hit * 2
end
#-> needles_par (generic function with 1 method)

julia> @time needles_seq(100*10^6)
  4.280558 seconds (490.51 k allocations: 25.170 MiB, 0.12% gc time)
3.141853491224458

julia> @time needles_par(25*10^6)
  2.281972 seconds (1.90 M allocations: 96.490 MiB, 1.04% gc time)
3.1420477693063282


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cd("PacktPub/Chp05");
jabber = "jabberwocky.txt";
proc = open(`./rev.pl $jabber`,"r+");
close(proc.in);

poem = readlines(proc.out);
close(proc.out)

poem


link <- "https://raw.githubusercontent.com/DavZim/Efficient_Frontier/master/data/fin_data.csv"


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

using Distributed
addprocs(4);

function needles_seq(n::Integer)
  @assert n > 0
  k = 0
  for i = 1:n
    rho = rand()
    phi = (rand() * pi) - pi / 2   # angle at which needle falls
    xr = rho + cos(phi)/2          # x-location of needle
    xl = rho - cos(phi)/2
    # Does needle cross either x == 0 or x == 1?
    k += (xr >= 1 || xl <= 0) ? 1 : 0
  end
  m = n - k
  mypi = n / k * 2
end
#-> needles_seq (generic function with 1 method)

function needles_par(n)
  k = @distributed (+) for i = 1:n
    rho = rand()
    phi = (rand() * pi) - pi / 2
    xr = rho + cos(phi)/2
    xl = rho - cos(phi)/2
    (xr >= 1 || xl <= 0) ? 1 : 0
  end
  m = n - k
  mypi = n / k * 2
end

julia> @time needles_seq(4*10^8)
 16.007432 seconds (7 allocations: 208 bytes)
3.1415283291067277

julia> @time needles_par(10^8)
  1.502410 seconds (816 allocations: 57.578 KiB)
3.141524369095122

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

bash-3.2$ cat parallel.jl 
# start the following on the command line:
# julia -p n  # starts n processes on the local machine
# julia -p 8  # starts REPL with 8 workers
workers()
# 8-element Array{Int64,1}:
#   2
#   3
#   4
#   5
#   ⋮
#   8
#   9

# iterate over workers:
for pid in workers()
	# do something with pid
end
myid() # 1
addprocs(5)
# 5-element Array{Any,1}:
#  10
#  11
#  12
#  13
#  14
nprocs() # 14
rmprocs(3) #> Task (done) @0x0000000012f8f0f0
# worker with id 3 is removed

# cluster of computers:
# julia --machinefile machines driver.jl 
# Run processes specified in driver.jl on hosts listed in machines

# primitive operations with processes:
r1 = remotecall(x -> x^2, 2, 1000) #> Future(2, 1, 15, nothing)
fetch(r1) #> 1000000

remotecall_fetch(sin, 5, 2pi) # -2.4492935982947064e-16

r2 = @spawnat 4 sqrt(2) #> Future(4, 1, 18, nothing)
# lets worker 4 calculate sqrt(2)
fetch(r2)  #> 1.4142135623730951
r = [@spawnat w sqrt(5) for w in workers()]
# or in a freshly started REPL:
# r = [@spawnat i sqrt(5) for i=1:length(workers())]
# 12-element Array{Future,1}:
#  Future(2, 1, 20, nothing)
#  Future(4, 1, 21, nothing)
#  Future(5, 1, 22, nothing)
#  Future(6, 1, 23, nothing)
#  Future(7, 1, 24, nothing)
#  Future(8, 1, 25, nothing)
#  Future(9, 1, 26, nothing)
#  Future(10, 1, 27, nothing)
#  Future(11, 1, 28, nothing)
#  Future(12, 1, 29, nothing)
#  Future(13, 1, 30, nothing)
#  Future(14, 1, 31, nothing)
r3 = @spawn sqrt(5) #> Future(2, 1, 32, nothing)
fetch(r3) #> 2.23606797749979

# using @everywhere to make functions available to all workers:
@everywhere w = 8
@everywhere println(myid()) # 1
# 1
#       From worker 14:   14
#       From worker 8:    8
#       From worker 10:   10
#       From worker 7:    7
#       From worker 2:    2
#       From worker 4:    4
#       From worker 12:   12
#       From worker 9:    9
#       From worker 11:   11
#       From worker 6:    6
#       From worker 13:   13
#       From worker 5:    5

x = 5 #> 5
@everywhere println(x) #> 5
#   # exception on worker 2: ERROR: UndefVarError: x not defined ...
#        ...and 11 more exception(s)

@everywhere include("defs.jl")
@everywhere function fib(n)
	if (n < 2) then
	return n
	else return fib(n-1) + fib(n-2)
	end
end
include("functions.jl")

# broadcast data to all workers:
d = "Julia"
for pid in workers()
   remotecall(x -> (global d; d = x; nothing), pid, d)
   
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

julia> using Distributed

julia> addprocs(4)
4-element Array{Int64,1}:
 2
 3
 4
 5

julia> for pid in workers()
    @show pid
end
pid = 2
pid = 3
pid = 4
pid = 5

julia> r1 = remotecall(x -> x^2, 2, π)
Future(2, 1, 6, nothing)

julia> wp = WorkerPool([3,4,5])
WorkerPool(Channel{Int64}(sz_max:9223372036854775807,sz_curr:3), Set([4, 3, 5]), RemoteChannel{Channel{Any}}(1, 1, 7))

julia> fetch(r1)
9.869604401089358

julia> remotecall_fetch(sin, 5, π/4)
0.7071067811865475

julia> r2 = @spawnat 4 sqrt(2)
Future(4, 1, 12, nothing)

julia> fetch(r2)
1.4142135623730951

j
julia> @everywhere fac(n::Integer) = (n < 2) ? 1 : n*fac(n-1)

julia> r = [@spawnat w fac(3 + 2*w) for w in workers()]
4-element Array{Future,1}:
 Future(2, 1, 38, nothing)
 Future(3, 1, 39, nothing)
 Future(4, 1, 40, nothing)
 Future(5, 1, 41, nothing)

julia> for id in r
	@show id, fetch(id)
end
(id, fetch(id)) = (Future(2, 1, 38, Some(5040)), 5040)
(id, fetch(id)) = (Future(3, 1, 39, Some(362880)), 362880)
(id, fetch(id)) = (Future(4, 1, 40, Some(39916800)), 39916800)
(id, fetch(id)) = (Future(5, 1, 41, Some(6227020800)), 6227020800)

julia> (fac(7),fac(9),fac(11),fac(13)
(5040, 362880, 39916800, 6227020800)


julia> using DistributedArrays
julia> da = drandn(10,10,10,10);
julia> fieldnames(typeof(da))
(:id, :dims, :pids, :indices, :cuts, :localpart, :release)
julia> da.dims
(10, 10, 10, 10)

julia> da.indices
1×1×2×2 Array{NTuple{4,UnitRange{Int64}},4}:
[:, :, 1, 1] =
 (1:10, 1:10, 1:5, 1:5)

[:, :, 2, 1] =
 (1:10, 1:10, 6:10, 1:5)

[:, :, 1, 2] =
 (1:10, 1:10, 1:5, 6:10)

[:, :, 2, 2] =
 (1:10, 1:10, 6:10, 6:10)


@everywhere using DistributedArrays, Statistics

for ip in procs(da)
    rp = @spawnat ip mean(localpart(da))
    @show fetch(rp)
end

let mu = 0.0
  for ip in procs(da)
    rp = @spawnat ip mean(localpart(da))
    mu += fetch(rp)
  end
  @printf "Mean = %.3f ", mu/length(workers())
end


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Map reduce the Juila way

using DistributedArrays

julia> addprocs(3);
julia> d = drandn(300,300,300);

julia> fieldnames(typeof(d))
julia> d.dims
julia> d.indexes
julia> d.indices
1
julia> endof(d.pmap); # => 3

mu = reduce(+, map( fetch, {
		 @spawnat p mean(localpart(d)) 
			for p in procs(d) })) / endof(d.pmap)
-0.00012504848579078978

sigma = sqrt(reduce(+, map(fetch, { 
		@spawnat d var(localpart(d)) 
			for p in procs(d) })) / endof(d.pmap))
			
			

for _ = 1:25, f = [x -> Int128(x^2 + 2x - 1)], opt = [+, *]
  A = rand(1:5, rand(2:30))
  DA = distribute(A)
  mapreduce(f, opt, DA) 
  close(DA)
end


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


@everywhere using Distributed, DistributedArrays, SpecialFunctions

julia> aa = [rand() for i = 1:100,j = 1:100];
julia> da = distribute(aa);

julia> (da.dims, da.indices)
((100, 100), Tuple{UnitRange{Int64},UnitRange{Int64}}[(1:50, 1:50) (1:50, 51:100); (51:100, 1:50) (51:100, 51:100)])

julia> @elapsed map(x -> abs(bessely0(x)), aa)
0.03533777

julia> @elapsed map(x -> abs(bessely0(x)), da)
0.347106964











cd(string(ENV["HOME"],"/PacktPub/Chp05"))

try run(`wc $(readdir())`) catch end

macro traprun(c)
  quote
    if typeof($(esc(c))) == Cmd
      try
        run($(esc(c)))
     catch
     end
    end
  end
end

function filter(pat::Regex, dir=".")
  a = Any[]
  for f in readdir(dir)
    occursin(pat,f) && push!(a, f)
  end
  return a
end

julia> @traprun `wc $(filter(r"\.txt$"))`;
 734    4423   24491 hunting-the-snark.txt
 35     168     937 jabberwocky.txt
 769    4591   25428 total







