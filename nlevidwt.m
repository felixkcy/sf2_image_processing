function Z = nlevidwt(Y, N)
[m, n] = deal(size(Y) / 2^(N-1));
Z = Y;
for i=N:-1:1
    Z(1:m, 1:n) = idwt(Z(1:m, 1:n));
    m=m*2; n=n*2;
end
end