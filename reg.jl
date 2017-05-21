module Reg

import Base: convert, show, ==, +, -, length, zero, zeros

export RegVar, Reg8
export convert, show, ==, +, -, zero, zeros
export ++

# type definition
abstract AbstractReg;

type RegVar <: AbstractReg
  val :: UInt
  wl :: Int
end

type Reg8 <: AbstractReg
  val :: UInt
end

# convert
Base.convert(::Type{Reg8}, a::RegVar) = Reg8((1 << 8 - 1) & a.val);
Base.convert(::Type{Int}, a ::Reg8) = Base.convert(Int, RegVar(a.val, 8));
function Base.convert(Int, a::RegVar)
  wl = Int(log2(typemax(Int))) + 1;
  s = UInt(1) << (a.wl - 1);
  if (s & a.val == 0)
    Int(a.val);
  else
    -1 * Int((1 << a.wl) - a.val);
  end
end

# basic functions
function show(io::IO, a :: RegVar)
  mroundup(x, n) = Int(ceil(x / n)) * n;
  print(io, a.wl);
  print(io, "'h");
  octmask = 1 << 4 -1;
  for i=mroundup(a.wl, 4)-4:-4:0
    z = octmask & (a.val >> i);
    if z < 10
      print(io, z);
    else
      print(io, 'a'+ (z-10));
    end
  end
end

function show(io::IO, x :: Reg8)
  print(io, "8'h");
  mask = 1 << 4 -1;
  for i=(8-4):-4:0
    z = mask & (x.val >> i);
    if z < 10
      print(io, z);
    else
      print(io, 'a'+ (z-10));
    end
  end
end

==(a::Reg8, b::Reg8) = a.val == b.val
==(a::RegVar, b::RegVar) = (a.val == b.val) && (a.wl == b.wl)

# basic

length(a :: RegVar) = a.wl;
length(a :: Reg8) = 8;

zero(Reg8) = Reg8(0);
zero(::Type{Reg8}) = Reg8(0);
zeros(Reg8, n::Int) = fill!(Array{Reg8}(n), Reg8(0));
zeros(x::Array{Reg8,1}) = zeros(Reg8, length(x));

zeros(z::RegVar, n::Int) = fill!(Array{RegVar}(n), RegVar(0, z.wl));
zeros(x::Array{RegVar,1}) = zeros(RegVar(0, x[1].wl), length(x));

# arithmetics
+(a :: Reg8, b :: Reg8) = addreg8(a, b)

function addreg8(a::Reg8, b::Reg8)
  n = 8
  ub = 2^(n-1)-1
  lb = -2^(n-1)
  y = a.val + b.val
 
  if (y < lb)
    y = y + 2^n
  elseif (y > ub)
    y = y - 2^n
  end

  Reg8(y)
end

-(a::Reg8) = Reg8((1 << 8) - a.val); 
-(a::Reg8, b::Reg8) = a + (-b);

# ++(args...) = assoc(args);
# assoc(x :: Tuple{Any, Vararg{Any}}) = assoc(x...);
# assoc(a :: RegVar, b :: RegVar) = RegVar(a.val << b.wl + b.val, a.wl + b.wl);
# assoc(a :: RegVar, args...) = assoc(a, assoc(args));


end # module

