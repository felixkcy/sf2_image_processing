function step = opt_step_const(X, h, levels, fstep, lower, upper, epsilon)
%OPT_STEP3 Summary of this function goes here
%   Detailed explanation goes here

% rms error of direct quantisation
Z = quantise(X, fstep);
rmse_ref = get_rmse(X, Z);

% bisection method
maxiter = 1e4;
pyramid = pyenc(X, h, levels);

l_val = pyrmse(X, pyramid, h, lower);
u_val = pyrmse(X, pyramid, h, upper);
if sign(rmse_ref-l_val) == sign(rmse_ref-u_val)
    step = -1;
    return
end

step = (lower+upper)/2;
rmse = pyrmse(X, pyramid, h, step);

i = 0;
while abs(rmse_ref - rmse) > epsilon && i < maxiter
    if rmse <= rmse_ref
        lower = step;
    else
        upper = step;
    end
    step = (lower+upper)/2;
    rmse = pyrmse(X, pyramid, h, step);
    i=i+1;
end
if i == maxiter
    disp(step)
    step = -2;
end
disp(rmse);
disp(pyentropy(pyramid, step));
end

