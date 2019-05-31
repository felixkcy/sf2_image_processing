function decoded_py = pydec(pyramid, h)
%PYDEC Laplacian pyramid decoder
%   Returns the decoded images as a cell array
%   Output format: {Z0, ..., Z(n-1)}
decoded_py = cell(length(pyramid)-1);
Z = pyramid{length(pyramid)};
for i=length(pyramid)-1:-1:1
    Z = (rowint((rowint(Z, 2*h)).', 2*h)).' + pyramid{i};
    decoded_py{i} = Z;
end
end
