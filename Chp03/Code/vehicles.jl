module Vehicles

export Contact, Vehicle, Car, Bike, Yacht, Powerboat, Boat
export Ford, BMW, VW, Scooter, MotorBike, Speedboat 
       
mutable struct Contact
    name::String
    email::String
    phone::String
end
                             
abstract type Vehicle end

abstract type Car <: Vehicle end
abstract type Bike <: Vehicle  end
abstract type Boat <: Vehicle end

abstract type Powerboat <: Boat end
       
mutable struct Ford <: Car
    owner::Contact
    make::String
    fuel::String
    color::String
	engine_cc::Int64
    speed_mph::Float64
    function Ford(owner, make, engine_cc,speed_mph)
        new (owner,make,"Petrol","Black",engine_cc,speed_mph)
     end
end
       
mutable struct BMW <: Car
    owner::Contact
    make::String
    fuel::String
    color::String
	engine_cc::Int64
    speed_mph::Float64
    function BMW(owner,make,engine_cc,speed_mph)
        new (owner,make,"Petrol","Blue",engine_cc,speed_mph)
   end
end
       
mutable struct VW <: Car
    owner::Contact
    make::String
    fuel::String
    color::String
	engine_cc::Int64
    speed_mph::Float64
end

mutable struct MotorBike <: Bike
    owner::Contact
    make::String
	engine_cc::Int64
    speed_mph::Float64
end
       
mutable struct Scooter <: Bike
    owner::Contact
    make::String
	engine_cc::Int64
    speed_mph::Float64
end

mutable struct Yacht <: Boat
    owner::Contact
    make::String
    length_m::Float64
end
              
mutable struct Speedboat <: Powerboat
    owner::Contact
    make::String
	fuel::String
	engine_cc::Int64
    speed_knots::Float64
	length_m::Float64
end
	          	
function is_quicker(a::VW, b::BMW)
   if (a.speed_mph == b.speed_mph) 
      return nothing
    else
      return(a.speed_mph > b.speed_mph ? a : b)
     end
end

function is_quicker(a::Speedboat, b::Scooter)
   const KNOTS_TO_MPH = 1.151
   a_mph = KNOTS_TO_MPH * a.speed_knots
   if (a_mph == b.speed_mph) 
       return nothing
    else
       return(a_mph > b.speed_mph ? a : b)
    end
end

function is_longer(a::Yacht, b::Speedboat)
   if (a.length_m == b.length_m) 
       return nothing
    else
       return(a.length > b.length_m ? a : b)
    end
end

is_quicker(a::BMW, b::VW) = is_quicker(b,a)
is_quicker(a::Scooter, b::Speedboat) = is_quicker(b,a)
is_longer(a::Speedboat, b::Yacht) = is_longer(b,a)


end
