function step = opt_step_emse(X, h, levels, fstep, lower, upper, epsilon)
%OPT_STEP_EMSE Find the optimal step sizes
%   Given the number of levels of the pyramid and the fixed number of
%   steps for the reference quantised image, it finds the maximum step
%   sizes which achieve equal-MSE contribution from each pyramid layer,
%   resulting in approximately the same rms error as the reference image
%   Error code: -1 - optimum is not in range; -2 - exceeds maxiter

% rms error of direct quantisation
Z = quantise(X, fstep);
rmse_ref = get_rmse(X, Z);

% find equal-MSE ratio of steps
r = equal_mse_ratio(levels, size(X), h);

% bisection method
maxiter = 1e4;
pyramid = pyenc(X, h, levels);

% check the range
l_val = pyrmse(X, pyramid, h, lower*r);
u_val = pyrmse(X, pyramid, h, upper*r);
if sign(rmse_ref-l_val) == sign(rmse_ref-u_val)
    step = -1;
    return
end

mid = (lower+upper)/2;
rmse = pyrmse(X, pyramid, h, mid*r);

i = 0;
while abs(rmse_ref - rmse) > epsilon && i < maxiter
    if rmse <= rmse_ref
        lower = mid;
    else
        upper = mid;
    end
    mid = (lower+upper)/2;
    rmse = pyrmse(X, pyramid, h, mid*r);
    i=i+1;
end
if i == maxiter
    step = -2;
else
    step = mid*r;
end
end

