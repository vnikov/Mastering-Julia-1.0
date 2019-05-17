module V3P

# import Base.+, Base.*, Base./, Base.norm, Base.==, Base.<, Base.>
import Base: +, *, /, ==, <, >, norm, dot
export Vec3, norm, dist

immutable Vec3{T}
    x::T
    y::T
    z::T
end

(+)(a::Vec3, b::Vec3) = Vec3(a.x+b.x, a.y+b.y, a.z+b.z)
(*)(p::Vec3, s::Real) = Vec3(p.x*s, p.y*s, p.z*s)
(*)(s::Real, p::Vec3) = p*s
(/)(p::Vec3, s::Real) = (1.0/s)*p

(==)(a::Vec3, b::Vec3) = (a.x==b.x)&&(a.y==b.y)&&(a.z==b.z) ? true : false;

dot(a::Vec3, b::Vec3) = a.x*b.x + a.y*b.y + a.z*b.z;
norm(a::Vec3) = sqrt(dot(a,a));

(<)(a::Vec3, b::Vec3) = norm(a) < norm(b) ? true : false;
(>)(a::Vec3, b::Vec3) = norm(a) > norm(b) ? true : false;

dist(a::Vec3, b::Vec3) = sqrt((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y) + (a.z-b.z)*(a.z-b.z))

end
