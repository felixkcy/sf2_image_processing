function [H, Hmat] = dctent(Yr, N)
%DCTENT Calculate the total entropy of a regrouped quantised dct image
% Returns the total entropy H and Hmap which shows the contribution of
% each sub-image to the total entropy

s = length(Yr) / N;
H = 0;
Hmat = zeros(N, N);
for i = 1:N
    for j= 1:N
        % iterate through the subimages and compute the entropy
        ind_i = (1+(i-1)*s):i*s;    % row indices
        ind_j = (1+(j-1)*s):j*s;    % column indices
        Ys = Yr(ind_i, ind_j);
        HYs = bpp(Ys)*numel(Ys);
        Hmat(i, j) = HYs;
        H = H + HYs;
    end
end
end

