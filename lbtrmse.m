function lbtrmse = lbtrmse(X, N, step, rise1, s, O)
%LBTRMSE Summary of this function goes here
error(nargchk(1, 6, nargin, 'struct'));
if (nargin<6)
  O = N/2;
  if (nargin<5)
    s = (1+5^0.5)/2;
    if (nargin<4)
        rise1 = step/2;
    end
  end
else
  if ((O>(N/2)) || (O<1)) error('O is not a legal value'); end
end

Z = lbtrec(quantise(lbttrans(X, N, s, O), step, rise1), N, s);
lbtrmse = get_rmse(X, Z);
end

