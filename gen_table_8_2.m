% generate matrices of optstep and compression ratio for section 8.2
Href = entropy(Xn, 17);
N = [4, 8, 16];
s = [1, 1.1, 1.2, sqrt(2), 1.618, 1.8, 2];
table_8_2_optstep = zeros(length(s), length(N));
table_8_2_comp = zeros(length(s), length(N));
for i = 1:length(s)
    for j = 1:length(N)
        [opt_step, H] = opt_step_lbt(Xn, N(j), 16, s(i), 17, 1, 100, 0.0001);
        table_8_2_optstep(i, j) = opt_step;
        table_8_2_comp(i, j) = Href / H;
    end
end
