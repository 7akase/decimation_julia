module Reg

import Base: convert, show, ==, +, -, length, zero, zeros

export RegVar, Reg8
export convert, show, ==, +, -, zero, zeros
export ++

# type definition
abstract AbstractReg

type RegVar <: AbstractReg
  val :: UInt
  wl :: Int
end

type Reg8 <: AbstractReg
  val :: UInt
end

# convert
wl(::Reg8) = 8
wl(x::RegVar) = x.wl

Base.convert(::Type{Reg8}, x::AbstractReg) = RegVar((1 << 8 - 1) & x.val, 8)
Base.convert(t::AbstractReg, x::AbstractReg) = RegVar((1 << wl(t) - 1) & x.val, wl(t))
function Base.convert(Int, x::AbstractReg)
  w = Int(log2(typemax(Int))) + 1;
  s = UInt(1) << (w - 1);
  if (s & x.val == 0)
    Int(x.val);
  else
    -1 * Int((1 << w) - a.val);
  end
end

# basic functions
function show(io::IO, x::AbstractReg)
  mroundup(x, n) = Int(ceil(x / n)) * n;
  print(io, wl(x));
  print(io, "'h");
  octmask = 1 << 4 -1;
  for i=mroundup(wl(x), 4)-4:-4:0
    z = octmask & (x.val >> i);
    if z < 10
      print(io, z);
    else
      print(io, 'a'+ (z-10));
    end
  end
end

==(a::AbstractReg, b::AbstractReg) = (a.val == b.val) && (wl(a) == wl(b))

# basic

length(a::AbstractReg) = wl(a);

zero(Reg8) = Reg8(0);
zero(::Type{Reg8}) = Reg8(0);
zeros(Reg8, n::Int) = fill!(Array{Reg8}(n), Reg8(0));
zeros(x::Array{Reg8,1}) = zeros(Reg8, length(x));

zeros(z::RegVar, n::Int) = fill!(Array{RegVar}(n), RegVar(0, z.wl));
zeros(x::Array{RegVar,1}) = zeros(RegVar(0, x[1].wl), length(x));

# arithmetics
+(a::AbstractReg, b::AbstractReg) = addreg(a, b)
function addreg(a::AbstractReg, b::AbstractReg)
  n = max(wl(a), wl(b)); 
  ub = 2^(n-1)-1
  lb = -2^(n-1)
  y = a.val + b.val
 
  if (y < lb)
    y = y + 2^n
  elseif (y > ub)
    y = y - 2^n
  end

  RegVar(y, n)
end

-(a::Reg8) = Reg8((1 << 8) - a.val); 
-(a::Reg8, b::Reg8) = a + (-b);

++(args...) = assoc(args);
assoc(x::Tuple{Any, Vararg{Any}}) = assoc(x...)
assoc(a::RegVar, args...) = assoc(a, assoc(args))
assoc(a::Reg8, args...) = assoc(a, assoc(args))
assoc(a::RegVar, b::RegVar) = RegVar(a.val << b.wl + b.val, a.wl + b.wl)
assoc(a::RegVar, b::Reg8  ) = RegVar(a.val << 8    + b.val, a.wl + 8   )
assoc(a::Reg8  , b::RegVar) = assoc(RegVar(a.val, 8), b) 
assoc(a::Reg8  , b::Reg8  ) = assoc(RegVar(a.val, 8), RegVar(b.val, 8)) 

end # module

