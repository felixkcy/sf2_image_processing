function qpy = pyquantise(pyramid, step)
%PYQUANTISE Quantise all layers of the pyramid
%   'step' can be a single value or an array (variable step size)
[r, c] = size(step);
if (r == 1) && (c == 1)
    step = ones(1, length(pyramid)) .* step;
end
qpy = cell(size(pyramid));
for i=1:length(pyramid)
    qpy{i} = quantise(pyramid{i}, step(i));
end
end

