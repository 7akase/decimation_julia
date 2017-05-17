function getSNR(hwfft, osr, f, n)
  hwfft_ib = hwfft[1:convert(Int, floor(length(hwfft)/2/osr))];
  10log10(calculateSNR(hwfft_ib, f, n));
end

function calculateSNR(hwfft, f, n)
  s = sum(abs(hwfft[f-n+1:f+n+1]).^2);
  hwfft[f-n+1:f+n+1] = 0;
  n = sum(abs(hwfft).^2);
  s / n;
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
