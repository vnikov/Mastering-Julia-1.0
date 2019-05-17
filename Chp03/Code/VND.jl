module VND
using StaticArrays

import Base: +, *, /, ==, <, >, norm, dot
export VecN, norm, dist

type VecN
    elem::SVector;
end

sizeof(a::VecN) = length(a.elem)
sOK(a::VecN, b::VecN) = (sizeof(a) == sizeof(b)) ? true :
                         throw(BoundsError("Vector of different lengths"));

(+)(a::VecN, b::VecN) = [a.elem[i] + b.elem[i] for i in 1:sizeof(a) if sOK(a,b)]
(*)(x::Real, a::VecN) = [a.elem[i]*x for i in 1:sizeof(a)]
(*)(a::VecN, x::Real) = x*a
(/)(a::VecN, x::Real) = [a.elem[i]/x for i in 1:sizeof(a)]

(==)(a::VecN, b::VecN) = any([(a.elem[i] == b.elem[i]) for i in 1:sizeof(a) if sOK(a,b)])

dot(a::VecN, b::VecN) = sum([a.elem[i]*b.elem[i] for i in 1:sizeof(a) if sOK(a,b)])
norm(a::VecN) = sqrt(dot(a,a));
dist(a::VecN, b::VecN) = sum(map(x -> x*x,[a.elem[i]-b.elem[i] for i in 1:sizeof(a) if sOK(a,b)]))

end

#
# ----------
#  Examples
# ----------
#

using VND, StaticArrays

a = @SVector [1.1,2.2,3.3];
b = @SVector [2.1,3.2,4.3];

aa = VecN(a);
bb = VecN(b);

aa2 = 2.0*aa
bb3 = bb/3.0

cc = aa + bb
aa == bb

aanorm = norm(aa)
abdist = dist(aa,bb)

#
# Π can be calculated in higher dimensions
# For example the unit 4-ball has a volume of (Π * Π)/2.0
#
# see: https://en.wikipedia.org/wiki/Volume_of_an_n-ball
#
