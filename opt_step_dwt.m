function [step, comp, rmse] = opt_step_dwt(X, N, fstep, scheme, lower, upper, epsilon)
% Calculate the optimal step size that gives the same rms error as the
% reference image

% rms error of direct quantisation
rmse_ref = get_rmse(X, quantise(X, fstep));
Href = entropy(X, fstep);
Y = nlevdwt(X, N);

if strcmp(scheme, 'const')
    r = ones(3, N+1);
elseif strcmp(scheme, 'emse')
    r = dwt_emse_r(length(X), N);
else
    disp('Error: invalid scheme');
    return
end

% bisection method
l_val = get_rmse(X, nlevidwt(quantdwt(Y, N, lower*r), N));
u_val = get_rmse(X, nlevidwt(quantdwt(Y, N, upper*r), N));
if sign(rmse_ref-l_val) == sign(rmse_ref-u_val)
    disp('optimal not within range');
    disp([l_val, u_val]);
    disp(rmse_ref);
    step = -1;
    return
end

mid = (lower+upper)/2;
rmse = get_rmse(X, nlevidwt(quantdwt(Y, N, mid*r), N));

maxiter = 1e4;
i = 0;
while abs(rmse_ref - rmse) > epsilon && i < maxiter
    if rmse <= rmse_ref
        lower = mid;
    else
        upper = mid;
    end
    mid = (lower+upper)/2;
    rmse = get_rmse(X, nlevidwt(quantdwt(Y, N, mid*r), N));
    i=i+1;
end
if i == maxiter
    disp('Error: maxiter exceeded')
end
step = mid*r;
[~, H] = quantdwt(Y, N, step);
comp = Href / H;
end

