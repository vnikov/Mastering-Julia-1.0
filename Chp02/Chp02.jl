# We need these as some functions have moved from Base to Stdlib
#
using Printf, SpecialFunctions, LinearAlgebra

x = 2;   typeof(x)

x = 2.0;  typeof(x)

x0 = 2^65
x1 = big(2)^65
@assert x0 == x1

for T = Any[Int8,Int16,Int32,Int64,Int128,UInt8,UInt16,UInt32,UInt64,UInt128]
    println("$(lpad(T,7)): [$(typemin(T)),$(typemax(T))]")
end

x = 0xbb31; y = 0xaa5f;  xor(x,y)

x = 0xbb31;  x << 8

x = 0xbb31; p = (2 < 3); x + p

# v1.0 requires the Statistics module for mean(), std() etc.
#
using Statistics

# Mean of 15 random numbers in range 0:100
#
A = rand(0:100,15)
mean(A)

# Create an empty array, note new syntax
# 'undef' will not initialise the elements
#
A = Array{Int64,1}(undef, 15)

# Verify: Tuple of the element type and the dimension sizes
#
(eltype(A),size(A))

# Fill array A with the first 15 Fibonnaci series
#
A[1] = 1
A[2] = 1
[A[i] = A[i-1] + A[i-2] for i = 3:length(A)]

# The 'recursive' definition of factorial function
# A simple loop is much quicker
#
function fac(n::Integer)
  @assert n > 0
  (n == 1) ? 1 : n*fac(n-1)
end

# This has difficulties with integer overflow
# We now need the Printf module to use the @printf macro
#
using Printf
for i = 1:30
  @printf "%3d : %d \n" i fac(i)
end

# But since a BigInt <: Integer if we pass a BigInt the reoutine returns one
#
fac(big(30))


# Find stdlib, location is O/S dependent

cd(Sys.BINDIR)
cd("../share/julia/stdlib/v1.0")
pwd()

# We can check this using the gamma function
# Again we need a module (SpecialFunctions)
#
using SpecialFunctions
gamma(31)     # Γ(n+1)  <=>  n!

# This non-recursive one liner works!
# Note that this returns a BigInt regardless of the input
#
fac(N::Integer) = 
  (N < 1) ? throw(ArgumentError("N must be positive")) : reduce(*,big.(collect(1:N)))

@time(fac(402))

gamma(big(403.0))

# The 'standard' recursive definition

function fib(k::Integer)
  @assert k > 0
  (k < 3) ? 1 : fib(k-1) + fib(k-2)
end

@time fib(15)

# A better version

function fib(n::Integer)
  @assert n > 0
  a = Array{typeof(n),1}(undef,n)
  a[1] = 0
  a[2] = 1
  for i = 3:n
    a[i] = a[i-1] + a[i-2]
  end
  return a[n]
end

@time(fib(big(402)))


# A still better version
# This requires no array storage

function fib(n::Integer)
  @assert n > 0
  (a, b) = (big(0), big(1))
  while n > 0
    (a, b) = (b, a+b)
    n -= 1
  end
  return a
end


# Golden ratio

@printf "%.15f" fib(101)/fib(100)


# Check with the actual value

γ = (1.0 + sqrt(5.0))/2.0

using Random # stdlib module needed for srand() => seed!()
#
tm = round(time());
seed = convert(Int64,tm);
Random.seed!(seed);

function bacs()
         bulls = cows = turns = 0
         a = Any[]
         while length(unique(a)) < 4 
           push!(a,rand('0':'9'))
         end
         my_guess = unique(a)
         println("Bulls and Cows")
         while (bulls != 4)
           print("Guess? > ")
           s = chomp(readline(stdin))
           if (s == "q")
             print("My guess was "); [print(my_guess[i]) for i=1:4]
             return
           end
           guess = collect(s)
           if !(length(unique(guess)) == length(guess) == 4 && all(isdigit,guess))
             print("\nEnter four distinct digits or q to quit: ")
             continue
           end
           bulls = sum(map(==, guess, my_guess))
           cows = length(intersect(guess,my_guess)) - bulls
           println("$bulls bulls and $cows cows!")
           turns += 1
         end
         println("\nYou guessed my number in $turns turns.")
       end

bacs()


# The matrix file is in Files subdirectory
# Check we are at the correct location
#
cd() # Change as needed
pwd()

#http://en.wikipedia.org/wiki/Stochastic_matrix
#
# Create stochastic matrix and write to disk
#
open("./cm3.txt","w") do f
  write(f,"0.0,0.0,0.5,0.0\n")
  write(f,"0.0,0.0,1.0,0.0\n")
  write(f,"0.25,0.25,0.0,0.25\n")
  write(f,"0.0,0.0,0.5,0.0\n")
end

using DelimitedFiles

I = zeros(4,4);
[I[i,i] = 1 for i in 1:4];

f = open("./cm3.txt","r")
T = readdlm(f,',');
close(f);

T

Ep = [0 1 0 0]*inv(I - T)*[1,1,1,1];

println("Expected lifetime for the mouse is $(Ep[1]) hops.")

# Look at different definitions of the norm function
# For a Gaussian distribution of size N we should expect the answer ~= √N
# The first call f1(1) is to run in the function and not affect the timing
# This version uses the function in the stdlib LinearAlgebra module

using LinearAlgebra

f1(n) = norm(randn(n))
f1(10);
@time f1(100_000_000)


# We can get the same result using a mapreduce procedure
# Note that it is a new set of random number, so the answer is slightly different
# The time is about the same

f2(n) = sqrt(mapreduce(x -> x*x, +, randn(n)))
f2(10);
@time f2(100_000_000)


# Using a conventional mapping we need to pipe the result to sum it 
# and then take the square root
# This takes a little longer tha the previous 2

f3(n) = map(x -> x*x,randn(n)) |> sum |> sqrt
f3(10);
@time f3(100_000_000)


# Finally we can non-vectorize the code, which is much quicker,
# In Julia non-vectorized (i.e loopy) code is invariably faster
# than the vectorized equivalent.

function f4(n)
    t = 0.0
    for i = 1:n
        t += randn()^2
    end
    return sqrt(t)
end

f4(10);
@time f4(100_000_000)


# Define a very simple type to represent a 2-D point

struct Point
  x::Real
  y::Real
end


# We can define how to add and scale points
# This needs importing the + and * function from Base

import Base: +,*
+(u::Point,v::Point) = Point(u.x + v.x, u.y + v.y )
*(a::Real,u::Point)  = Point(a*u.x, a*u.y)
*(u::Point,a::Real)  = a*u


# Just test the type structure

u1 = Point(1.0,2.3)
u1*(17//13)


# Using Julia's aggregate object model this type "knows" all about arrays
# Note: I'll deal with the object model in greater detail the next two chapters
#
aa = [Point(randn(),randn()) for i = 1:100];
ab = reshape(aa,10,10)


# It is useful to define a zero function (not sure about a one())

zero(Point) = Point(0.0,0.0)


# The dot product is the sum of the product of the x and y coordinates

dot(u::Point)::Real = u.x^2 * u.y^2
dot(u::Point,v::Point)::Real = u.x*v.x * u.y*v.y
dot(ab[1])

# The distance between two points is determined by Pythagoras's rule

dist(u::Point,v::Point)::Real = sqrt((u.x - v.x)^2 + (u.y - v.y)^2)
dist(ab[4,1],ab[2,7])

# The distance of the point from the origin is equivalent to it's norm 
# We need to import the 'norm' function

import LinearAlgebra.norm

norm(u::Point)::Real = sqrt(u.x^2 + u.y^2)
norm(aa[17])


# It is also possible to define this as:

dist(u::Point)::Real = dist(u::Point,zero(Point))

# Although this requires slightly more work to compute and it may be
# better just to define it as dist(u::Point) = norm(u)

@assert(dist(aa[17]) == norm(aa[17]))  ## Should produce NO output if it is TRUE


typeof(aa)  # Note that this is an array of points
            # So norm will not work on this yet


# One way is to overload the norm function using the mapreduce function above
# (or write a non-vectorized one)

norm(a::Array{Point,1}) = sqrt(mapreduce(x -> dist(x), +, a))


# And now we can estimate PI (as in the previous chapter)

N = 1000000; ac = [Point(rand(),rand()) for i = 1:N];

# We need the let/end because of the scoping rules
let
  count = 0
  for i = 1:N
    (dist(ac[i]) < 1.0) && (count += 1)
  end
  4.0*(count/N)
end

# Note as yet norm(ab) will not work so we need to be a little more imaginative
# with the function definition. 

# In the next chapter we will generalise this type definition to 3-Vector and N-vector
# and revisit the quiestion then

norm(ab)


function juliaset(z, z0, nmax::Int64)
    for n = 1:nmax
        if abs(z) > 2 (return n-1) end
        z = z^2 + z0
    end
    return nmax
end


function create_pgmfile(img, outf::String)
    s = open(outf, "w")
    write(s, "P5\n")    
    n, m = size(img)
    write(s, "$m $n 255\n")
    for i=1:n, j=1:m
        p = min(img[i,j],255)
        write(s, UInt8(p))
    end
    close(s)
end


h = 400; 
w = 800; 
m = Array{Int64,2}(undef,h,w);

c0 = -0.8 + 0.16im;
pgm_name = "jset.pgm";

t0 = time();
for y=1:h, x=1:w
    c = complex((x-w/2)/(w/2), (y-h/2)/(w/2))
    m[y,x] = juliaset(c, c0, 256)
end
t1 = time();


# You should find the file in the same chapter as the notebook

create_pgmfile(m, pgm_name);
@printf "Written %s\nFinished in %.4f seconds.\n" pgm_name (t1-t0);


# Display the image using Imagemagick's display command
# Clicking the file may display it (OSX/XQuartz and Centos/Gnome certainly does)
# On OSX use:  brew reinstall imagemagick --with-x11
#
# Otherwise you make be able to click onit (OSX or Linux)
# or on WIndows use an image processing program such as Irfanview
# We will be looking at how to do this in Julia later.

here = pwd()
run(`display $here/$pgm_name`)
