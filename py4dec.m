function [Z0, Z1, Z2, Z3] = py4dec(Y0, Y1, Y2, Y3, X4, h)
%PY4DEC Summary of this function goes here
%   Detailed explanation goes here
Z3 = (rowint((rowint(X4, 2*h)).', 2*h)).' + Y3;
Z2 = (rowint((rowint(Z3, 2*h)).', 2*h)).' + Y2;
Z1 = (rowint((rowint(Z2, 2*h)).', 2*h)).' + Y1;
Z0 = (rowint((rowint(Z1, 2*h)).', 2*h)).' + Y0;
end
