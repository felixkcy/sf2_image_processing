function Y = dcttrans(X, N)
%DCTTRANS Summary of this function goes here
C = dct_ii(N);
Y = colxfm(colxfm(X, C)', C)';
end

