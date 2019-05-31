function Xp = pottrans(X, N, s, O)
%LOT_II Summary of this function goes here
error(nargchk(1, 4, nargin, 'struct'));
if (nargin<4)
  O = N/2;
  if (nargin<3)
    s = (1+5^0.5)/2;
  end
else
  if ((O>(N/2)) || (O<1)) error('O is not a legal value'); end
end

Pf = pot_ii(N, s, O);
t = [(1+N/2):(length(X)-N/2)];
Xp = X;
Xp(t,:) = colxfm(Xp(t,:), Pf);
Xp(:,t) = colxfm(Xp(:,t)', Pf)';
end