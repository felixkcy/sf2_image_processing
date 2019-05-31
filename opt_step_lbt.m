function [step, H, rmse] = opt_step_lbt(X, N, N2, s, fstep, lower, upper, epsilon)
%OPT_STEP3 Optimise the step size given scaling factor s
%   Detailed explanation goes here

% rms error of direct quantisation
Z = quantise(X, fstep);
rmse_ref = get_rmse(X, Z);

% bisection method
maxiter = 1e4;

l_val = lbtrmse(X, N, lower, s);
u_val = lbtrmse(X, N, upper, s);
if sign(rmse_ref-l_val) == sign(rmse_ref-u_val)
    disp('Error: optimal value not within range');
    [step, H, rmse] = deal(-1, -1, -1);
    return
end

step = (lower+upper)/2;
rmse = lbtrmse(X, N, step, s);

i = 0;
while abs(rmse_ref - rmse) > epsilon && i < maxiter
    if rmse <= rmse_ref
        lower = step;
    else
        upper = step;
    end
    step = (lower+upper)/2;
    rmse = lbtrmse(X, N, step, s);
    i=i+1;
end
if i == maxiter
    disp('Error: maxiter exceeded');
end
% compute entropy H
Yq = quantise(lbttrans(X, N, s), step);
Yr = regroup(Yq, N) / N;
H = dctent(Yr, N2);
end


