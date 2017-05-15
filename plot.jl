using PyPlot



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

function sincMN(x, order = 1, n = 2, precision = [])
  if precision == []
    precision = 32 * ones(order * 2);
  end
  if order * 2 != length(precision)
    error("sincMN precision error");
  end
  y = x;

  for i = 1:order
    y = dti_nbit(y, precision[i]); 
  end
  y = y[1:n:end];
  for i = 1:order
    y = dtd_nbit(y, precision[i+order]);
  end
  y = y / n;
end
  
Nfft = 2^14;
Ts = 1;
fsig = 23 / Nfft;

# ts = linspace(0, 2*pi, 100);

ts = collect(0:Nfft-1);
u = 0.9 * sinpi(2*fsig*ts);
v = dsm1(u);

order = 2;
n = 32;
precision = (1 + convert(Int, ceil(log2(n)))) * ones(order * 2);
w = sincMN(v, order, n, 11*ones(order*2));

plot(ts, u)
plot(ts[1:n:end], w)
