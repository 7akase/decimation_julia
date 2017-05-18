module Reg

import Base: +, show, length, convert

abstract AbstractReg <: Integer;

type RegVar
  val :: UInt
  wl :: Int
end

type Reg8
  val :: UInt
end

Base.convert(Int, a::Reg8) = Base.convert(Int, a.val);

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

length(a :: RegVar) = a.wl;
length(a :: Reg8) = 8;

+(a :: Reg8, b :: Reg8) = addreg(a, b, 8);
++(a :: AbstractReg, b :: AbstractReg) = a;

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

end # module

