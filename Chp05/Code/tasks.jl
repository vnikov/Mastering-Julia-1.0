
#=

https://discourse.julialang.org/t/how-to-replace-consume-and-produce-with-channels/5125/4

Of course, you can specify larger capacity for channels to avoid to frequent switching between tasks.

To summarize:

Create a channel available for both - producer and consumer tasks.

Use put!(chnl, x) instead of produce() and take!(chnl) instead of consume(), or just iterate over the channel.
Call close(chnl) to finish.

=#

fib(n::Integer) = n < 3 ? 1 : fib(n-1) + fib(n-2)

n = 15;
@async for i=1:n
  put!(chnl, fib(i)) 
end

# chnl.data



OR

fib(n::Integer) = n < 3 ? 1 : fib(n-1) + fib(n-2)

n = 15;
@async begin 
  for i=1:n
    put!(chnl, fib(i)) 
  end
  put!(chnl,-1)
end

for x in chnl
    x < 0 ? break : println(x)
end

close(chnl)



