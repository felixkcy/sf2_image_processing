function r = dwt_emse_r(m, N)
% Calcualte the ratio of quantisation steps that satisfies equal mse
% Start with an image with zero everywhere and apply transformation

Y = zeros(m, m);    % dwt of zeros is also zeros
r = ones(3, N+1);   % use ones since reciprocal is needed later
for i=1:N
    m=m/2;
    ind_r = [m/2, m*3/2, m*3/2];
    ind_c = [m*3/2, m*3/2, m/2];
    for k=1:3
        % k=1: top right; k=2: bottom right; k=3: bottom left
        % Apply impulse of 100 at centre and measure energy of
        % reconstructed image
        Y(ind_r(k), ind_c(k)) = 100;
        %figure(); draw(Y);
        Z = nlevidwt(Y, N);
        %figure(); draw(Z);
        r(k, i) = sum(Z(:).^2);
        Y(ind_r(k), ind_c(k)) = 0;  % recover original image
    end
end
% measure energy of final low-pass image
Y(m/2, m/2) = 100;
Z = nlevidwt(Y, N);
r(1, N+1) = sum(Z(:).^2);
disp(r);
r = 1 ./ sqrt(r);
r(2:3, N+1) = [0 0];
r = r ./ max(r(:));
end