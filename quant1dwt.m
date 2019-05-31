function [Yq, H, Hmat] = quant1dwt(Y, N, dwtstep)
H = 0;
Hmat = zeros(3, N+1);
Yq = Y;
m = length(Y);
for i=1:N
    m=m/2;
    ind_r = [1:m; m+1:2*m; m+1:2*m;];
    ind_c = [m+1:2*m; m+1:2*m; 1:m;];
    for k=1:3
        % k=1: top right; k=2: bottom right; k=3: bottom left
        %figure(); draw(Yq(ind_r(k,:), ind_c(k,:)))
        Yq(ind_r(k,:), ind_c(k,:)) = quant1(Yq(ind_r(k,:), ind_c(k,:)), dwtstep(k, i), dwtstep(k, i));
        Hmat(k, i) = bpp(Yq(ind_r(k,:), ind_c(k,:))) * m^2;
    end
end
% quantisation of the final low-pass image
Yq(1:m, 1:m) = quant1(Yq(1:m, 1:m), dwtstep(1, N+1), dwtstep(1, N+1));
Hmat(1, N+1) = bpp(Yq(1:m, 1:m)) * m^2;
H = sum(Hmat(:));
end