function H = entropy(X, step)
%ENTROPY Calculate the total entropy of an image in bits
H = bpp(quantise(X, step)) * numel(X);
end

