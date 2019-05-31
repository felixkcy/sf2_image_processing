function bpp = dctbpp(Yr, N)
%DCTBPP Calculate bpp of a regrouped quantised dct image
bpp = dctent(Yr, N) / numel(Yr);
end

