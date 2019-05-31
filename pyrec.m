function Z = pyrec(pyramid, h)
%PYREC Reconstruct the full-size image given the pyramid and filter
Z = pyramid{length(pyramid)};
for i=length(pyramid)-1:-1:1
    Z = (rowint((rowint(Z, 2*h)).', 2*h)).' + pyramid{i};
end
end

