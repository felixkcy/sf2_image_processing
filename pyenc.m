function pyramid = pyenc(X, h, levels)
%PYENC Laplacian pyramid encoder
%   Returns the Laplacian pyramid as a cell array
%   Output format: {Y0 Y1 ... Y(n-1) Xn}
X0 = X;
pyramid = cell(1, levels+1);
for i=1:levels
    X1 = (rowdec((rowdec(X0, h)).', h)).';
    Y = X0 - (rowint((rowint(X1, 2*h)).', 2*h)).';
    pyramid{i} = Y;
    X0 = X1;
end
pyramid{levels+1} = X1;
end
