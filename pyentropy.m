function H = pyentropy(pyramid, step)
%PY_ENTROPY Entropy of a Laplacian pyramid
%   'step' can be a single value of an array (variable step sizes)
%   Output: [bpp, H]
%   bpp: bits per original number of pixels
%   H: total entropy of pyramid in bits
H = 0;
[r, c] = size(step);
% if step is a single value
if (r == 1) && (c == 1)
    step = ones(1, length(pyramid)) .* step;
end
for i = 1:length(pyramid)
    H = H + bpp(quantise(pyramid{i}, step(i))) * numel(pyramid{i});
end
end

