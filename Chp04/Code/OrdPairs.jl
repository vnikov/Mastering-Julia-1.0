module OrdPairs

import Base: +,-,*,/,==,!=,>,<,>=,<=
import Base: abs,conj,inv,zero,one,show
import LinearAlgebra: transpose,adjoint,norm

export OrdPair

struct OrdPair{T<:Number}
    a::T
    b::T
end

OrdPair(x::Number) = OrdPair(x, zero(T))

value(u::OrdPair)   = u.a
epsilon(u::OrdPair) = u.b

zero(::Type{OrdPairs.OrdPair}) = OrdPair(zero(T),zero(T))
one(::Type{OrdPairs.OrdPair})  = OrdPair(one(T),zero(T))

abs(u::OrdPair)  = abs(value(u))
norm(u::OrdPair) = norm(value(u))

+(u::OrdPair, v::OrdPair) = OrdPair(value(u) + value(v), epsilon(u) + epsilon(v))
-(u::OrdPair, v::OrdPair) = OrdPair(value(u) - value(v), epsilon(u) - epsilon(v))
*(u::OrdPair, v::OrdPair) = OrdPair(value(u)*value(v), epsilon(u)*value(v) + value(u)*epsilon(v))
/(u::OrdPair, v::OrdPair) = OrdPair(value(u)/value(v),(epsilon(u)*value(v) - value(u)*epsilon(v))/(value(v)*value(v)))

==(u::OrdPair, v::OrdPair) = norm(u) == norm(v)
!=(u::OrdPair, v::OrdPair) = norm(u) != norm(v)
>(u::OrdPair, v::OrdPair)  = norm(u) > norm(v)
>=(u::OrdPair, v::OrdPair) = norm(u) >= norm(v)
<(u::OrdPair, v::OrdPair)  = norm(u) < norm(v)
<=(u::OrdPair, v::OrdPair) = norm(u) <= norm(v)

+(x::Number, u::OrdPair) = OrdPair(value(u) + x, epsilon(u))
+(u::OrdPair, x::Number) = x + u

-(x::Number, u::OrdPair) = OrdPair(x - value(u), epsilon(u))
-(u::OrdPair, x::Number) = OrdPair(value(u) - x, epsilon(u))

*(x::Number, u::OrdPair) = OrdPair(x*value(u), x*epsilon(u))
*(u::OrdPair, x::Number) = x*u

/(u::OrdPair, x::Number) = (1.0/x)*u

conj(u::OrdPair)  = OrdPair(value(u),-epsilon(u))
inv(u::OrdPair)   = one(OrdPair)/u

transpose(u::OrdPair) = u
transpose(uu::Array{MyOrdPair.OrdPair,2}) = [uu[j,i] for i=1:size(uu)[1],j=1:size(uu)[2]]
adjoint(u::OrdPair) = u

convert(::Type{OrdPair}, x::Number) = OrdPair(x,zero(x))
promote_rule(::Type{OrdPair}, ::Type{<:Number}) = OrdPair

## show(io::IO,u::OrdPair) = print(io,value(u)," + (",epsilon(u),")ϵ")

function show(io::IO,u::OrdPair) 
 op::String = (epsilon(u) < 0.0) ? " - " : " + ";
 print(io,value(u),op,abs(epsilon(u))," ϵ")
end

end
