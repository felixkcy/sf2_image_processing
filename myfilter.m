function h = myfilter(n)
%FILTER Summary of this function goes here
%   Detailed explanation goes here
h = zeros(1, n+1);
for i = 0:n
    h(i+1) = nchoosek(n, i) / 2^n;
end
end

