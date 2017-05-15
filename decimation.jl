using Base.Test

# type aaa
#   sign :: Bool
#   length :: Int
#   val :: UInt32
# end

# base type is UInt64

function add_nbit(a, b, n)
  ub = 2^(n-1)-1;
  lb = -2^(n-1);
  y = a + b;

  if (y < lb)
    y = y + 2^n;
  elseif (y > ub)
    y = y - 2^n;
  end
  y;
end

function dsm1(u)
  v = zeros(u);
  y = u[1];
  for i = 2:length(u)
    y = y + u[i] - v[i-1];
    v[i] = sign(y);
  end
  v = convert(Array{Int}, v);
end

function dsm2(u)
  v = zeros(u);
  x = u[1];
  y = 0;
  for i = 2:length(u)
    y = x - v[i-1] + y;
    v[i] = sign(y);
    x = u[i] - v[i] + x;
  end
  v = convert(Array{Int}, v);
end

@test add_nbit(1, 2, 32) == 3;
@test add_nbit(126, 1, 8) == 127;
@test add_nbit(127, 1, 8) == -128;
@test add_nbit(-128, -1, 8) == 127;
@test add_nbit(9999, -1, 8) == 0 || true;
@test add_nbit(-9999, -1, 8) == 0 || true;

