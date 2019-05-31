load lighthouse;
hcos = halfcos(15);
h = [0.25 0.5 0.25];
% halfcos-filtered image
Xf = conv2(1, hcos, X, 'same');
% halfcos_filtered image without edge effect
Xf2 = conv2se(hcos, hcos, X);
Xf2 = (conv2se(hcos, hcos, Xf2.')).';
% high-pass-filtered image
Y = X - Xf2;
% energy contents
EX = sum(X(:).^2);
EXf2 = sum(Xf2(:).^2);
EY = sum(Y(:).^2);

% 4-level Laplacian pyramid
py4 = pyenc(X, h, 4);
[Y0, Y1, Y2, Y3, X4] = py4{:};
py4_dec = pydec(py4, h);
[Z0, Z1, Z2, Z3] = py4_dec{:};

% quantisation

