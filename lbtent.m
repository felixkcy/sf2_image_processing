function H = lbtent(X, N, N2, s, step, rise1)
if nargin <= 5, rise1 = step/2; end
Yq = quantise(lbttrans(X, N, s), step, rise1);
Yr = regroup(Yq, N) / N;
H = dctent(Yr, N2);
end