function Y = nlevdwt(X, N)
[m, n] = size(X);
Y = X;
for i=1:N
    Y(1:m, 1:n) = dwt(Y(1:m, 1:n));
    m=m/2; n=n/2;
end
end