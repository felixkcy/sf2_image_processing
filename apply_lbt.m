function Y = apply_lbt(Y, N, k)
% Apply the DPCM to the DC values in a LBT / DCT matrix. Return the new
% matrix with transformed DC values
% Y input LBT/ DCT matrix
% M size of DCT/ LBT 'blocks' in matrix
% k size of the DPCM levels. A larger number gives higher quality.

% get the low pass values of the DCt / LBT
dc_indices = (1:N:size(Y)); % 32^2 is the number of sub images n a 256x256 img
Y_rows = Y(dc_indices, :); % get 1/8 rows
Y_dc = Y_rows(:, dc_indices); % get 1/8 cols

% apply the DPCM to DC bits
Y_dpcm = lbttrans(Y_dc, N, k); % apply LBT encoder

%%draw(beside(Yq_dpcm, beside(Yq_idpcm, Yq_dc)))

% replace indices of low pass in orginal Y matrix
Y(1:8:256, 1:8:256) = Y_dpcm;

%%draw(regroup(Yq,8))

end