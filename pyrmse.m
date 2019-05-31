function rmse = pyrmse(X, pyramid, h, step)
%PYRMS Computes the rms error of a quantised pyramid
%   Given a pyramid, quantise the sub-images then reconstruct the image.
%   Then outputs the rms error between the reconstruction and the original
%   image.
qpy = pyquantise(pyramid, step);
Z = pyrec(qpy, h);
rmse = get_rmse(X, Z);
end

