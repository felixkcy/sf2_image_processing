function r = equal_mse_ratio(levels, size, h)
%EQUALMSE Estimate the equal-MSE step ratio
%   Detailed explanation goes here
r = zeros(1, levels+1);
% construct pyramid
X = zeros(size);
py = pyenc(X, h, levels);

for i = 1:length(py)
    % place impulse of 100 and find energy of reconstructed image
    mid = fix(length(py{i})/2);
    py{i}(mid, mid) = 100;
    Z = pyrec(py, h);
    r(i) = sum(Z(:).^2);
    % recover the original pyramid
    py{i}(mid, mid) = 0;
end

% square root and inverse
r = 1 ./ r.^0.5;
r = r ./ r(length(r));

end

