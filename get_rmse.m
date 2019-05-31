function rmse = get_rmse(X1, X2)
%RMSE Summary of this function goes here
%   Detailed explanation goes here
rmse = std(X1(:) - X2(:));
end

