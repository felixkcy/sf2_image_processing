n = 7;
H0 = bpp(quantise(Xn, 17)) * numel(Xn);
comp_ratio = zeros(1, n);
for i=1:n
    s = opt_step_emse(Xn, h, i, 17, 0.01, 100, 0.1);
    H = pyentropy(pyenc(Xn, h, i), s);
    comp_ratio(i) = H0 / H;
end