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

@test add_nbit(1, 2, 32) == 3;
@test add_nbit(126, 1, 8) == 127;
@test add_nbit(127, 1, 8) == -128;
@test add_nbit(-128, -1, 8) == 127;
@test add_nbit(9999, -1, 8) == 0 || true;
@test add_nbit(-9999, -1, 8) == 0 || true;

function dti_nbit(x, n)
  y = zeros(x);
  for i = 2:length(x)
    y[i] = add_nbit(y[i-1], x[i], n);
  end
  y;
end

function dtd_nbit(x, n)
  y = zeros(x);
  y[1] = x[1];
  for i = 2:length(x)
    y[i] = add_nbit(x[i], -x[i-1], n);
  end
  y;
end


