function [step, H, rmse] = opt_step_dct(X, N, fstep, lower, upper, epsilon)
%OPT_STEP3 Summary of this function goes here
%   Detailed explanation goes here

% rms error of direct quantisation
Z = quantise(X, fstep);
rmse_ref = get_rmse(X, Z);

% bisection method
maxiter = 1e4;

l_val = dctrmse(X, N, lower);
u_val = dctrmse(X, N, upper);
if sign(rmse_ref-l_val) == sign(rmse_ref-u_val)
    disp('Error: optimal value not within range');
    return
end

step = (lower+upper)/2;
rmse = dctrmse(X, N, step);

i = 0;
while abs(rmse_ref - rmse) > epsilon && i < maxiter
    if rmse <= rmse_ref
        lower = step;
    else
        upper = step;
    end
    step = (lower+upper)/2;
    rmse = dctrmse(X, N, step);
    i=i+1;
end
if i == maxiter
    disp('Error: maxiter exceeded');
end
% compute entropy H
C = dct_ii(N);
Yq = quantise(dcttrans(X, N), step);
Yr = regroup(Yq, N) / N;
H = dctent(Yr, N);
end


