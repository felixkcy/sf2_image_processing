regrouped = regroup(Y, N)/N;
s = length(regrouped) / N;
subim_E = zeros(N, N);
for i = 1:N
    for j= 1:N
        % iterate through the subimages and compute the energy
        ind_i = (1+(i-1)*s):i*s;
        ind_j = (1+(j-1)*s):j*s;
        subim = regrouped(ind_i, ind_j);
        subim_E(i, j) = sum(subim(:).^2);
    end
end

figure();
imagesc(subim_E)
axis image
colorbar