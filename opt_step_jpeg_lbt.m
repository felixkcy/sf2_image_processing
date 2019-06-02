function [opt_step, bits] = opt_step_jpeg_lbt(X, N, M, s, opthuff, lower, upper)
maxiter = 1e4;
ref_bits = 40960;
if opthuff
    ref_bits = ref_bits - 1424;     % header bits
end
epsilon = 10;

[vlc, ~, ~] = jpegenc_lbt(X, lower, N, M, s, opthuff);
l_val = sum(vlc(:,2));
[vlc, ~, ~] = jpegenc_lbt(X, upper, N, M, s, opthuff);
u_val = sum(vlc(:,2));

if sign(ref_bits-l_val) == sign(ref_bits-u_val)
    opt_step = -1; bits = -1;
    return
end

opt_step = (lower+upper)/2;
[vlc, ~, ~] = jpegenc_lbt(X, opt_step, N, M, s, opthuff);
bits = sum(vlc(:,2));

i = 0;
while abs(ref_bits - bits) > epsilon && i < maxiter
    if bits <= ref_bits
        upper = opt_step;
    else
        lower = opt_step;
    end
    opt_step = (lower+upper)/2;
    [vlc, ~, ~] = jpegenc_lbt(X, opt_step, N, M, s, opthuff);
    new_bits = sum(vlc(:,2));
    %disp(new_bits)
    i=i+1;
    if new_bits == bits
        return
    end
    bits = new_bits;
end
if i == maxiter
    disp(opt_step)
    disp(bits)
    opt_step = -2;
end
end