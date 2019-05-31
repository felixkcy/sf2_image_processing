function [step, rmse] = opt_step_golden(X, h, levels, fstep, lower, upper, epsilon)
%OPT_STEP Finds the optimal step size in the Laplacian scheme
%   Returns the optiaml step size and the corresponding rms error
%   given a fixed step size for direct quantisation

% rms error of direct quantisation
Z = quantise(X, fstep);
rmse_direct = get_rmse(X, Z);

% Golden section interval search
maxiter = 1e4;
r = 0.381966011;
pyramid = pyenc(X, h, levels);

u_val = pyrmse(X, pyramid, h, upper);
l_val = pyrmse(X, pyramid, h, lower);
rmse = (u_val+l_val)/2;

% iterate until the difference between the rms errors is smaller than
% epsilon
i = 0;
while abs(rmse_direct - rmse) > epsilon && i < maxiter
    delta = (upper-lower)*r;
    val1 = pyrmse(X, pyramid, h, lower+delta);
    val2 = pyrmse(X, pyramid, h, upper-delta);
    if val1 <= val2
        upper = upper-delta;
        u_val = val2;
    else
        lower = lower+delta;
        l_val = val1;
    end
    rmse = (u_val+l_val)/2;
    step = (upper+lower)/2;
    i=i+1;
end

% if number of iterations exceed the limit, return [-1, -1]
if i == maxiter
    step= -1; rmse = -1;
end

