function [Y0, Y1, Y2, Y3, X4] = py4enc(X, h)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
X1 = (rowdec((rowdec(X, h)).', h)).';
Y0 = X - (rowint((rowint(X1, 2*h)).', 2*h)).';
X2 = (rowdec((rowdec(X1, h)).', h)).';
Y1 = X1 - (rowint((rowint(X2, 2*h)).', 2*h)).';
X3 = (rowdec((rowdec(X2, h)).', h)).';
Y2 = X2 - (rowint((rowint(X3, 2*h)).', 2*h)).';
X4 = (rowdec((rowdec(X3, h)).', h)).';
Y3 = X3 - (rowint((rowint(X4, 2*h)).', 2*h)).';
end
