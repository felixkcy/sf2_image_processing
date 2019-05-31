function Z = dctrec(Y, N)
%DCTREC Summary of this function goes here
C = dct_ii(N);
Z = colxfm(colxfm(Y', C')', C');
end

