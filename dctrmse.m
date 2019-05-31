function dctrmse = dctrmse(X, N, step)
%DCTRMSE Calculate the rms error of the reconstructed DCT image
Z = dctrec(quantise(dcttrans(X, N), step), N);
dctrmse = get_rmse(X, Z);
end

