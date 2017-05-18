module Reg

import Base: +, show, length, convert

export RegVar, Reg8, +, ++

abstract AbstractReg <: Integer;

type RegVar
  val :: UInt
  wl :: Int
end

type Reg8
  val :: UInt
end


function Base.convert(Int, a::RegVar)
  wl = Int(log2(typemax(Int))) + 1;
  s = UInt(1) << (a.wl - 1);
  if (s & a.val == 0)
    Int(a.val);
  else
    -1 * Int((1 << a.wl) - a.val);
  end
end

Base.convert(Int, a ::Reg8) = Base.convert(Int, RegVar(a.val, 8));


length(a :: RegVar) = a.wl;
length(a :: Reg8) = 8;


+(a :: Reg8, b :: Reg8) = addreg(a, b, 8);
++(args...) = assoc(args);

assoc(a :: RegVar, b :: RegVar) = RegVar(a.val << b.wl + b.val, a.wl + b.wl);
assoc(a :: RegVar, args...) = assoc(a, assoc(args));
assoc(x :: Tuple{Any, Vararg{Any}}) = assoc(x...);

addreg(a::Reg8, b::Reg8) = addreg(a, b, 8);
addreg(a::Reg8, b::Reg8, n::Int) = addreg(a, b, n);

function addreg(a :: Reg8, b :: Reg8, n :: Int)
  ub = 2^(n-1)-1;
  lb = -2^(n-1);
  y = a.val + b.val;
 
  if (y < lb)
    y = y + 2^n;
  elseif (y > ub)
    y = y - 2^n;
  end

  if n == 8
    Reg8(y);
  else
    RegVar(y, n);
  end
end

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

end # module

