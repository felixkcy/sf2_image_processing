x = 0.5:0.05:1.5;
y = zeros(size(x));
for i=1:length(x)
    y(i) = lbtrmse(Xn, 8, 17, 17*x(i), sqrt(2));
end
figure()
plot(x, y)