function Z = lbtrec(Y, N, s, O)
%LOT_II_REC Reconstructin of LBT (LOT-II) image
error(nargchk(1, 4, nargin, 'struct'));
if (nargin<4)
  O = N/2;
  if (nargin<3)
    s = (1+5^0.5)/2;
  end
else
  if ((O>(N/2)) || (O<1)) error('O is not a legal value'); end
end

[~, Pr] = pot_ii(N, s, O);
t = [(1+N/2):(length(Y)-N/2)];
Z = dctrec(Y, N);
Z(:,t) = colxfm(Z(:,t)', Pr')';
Z(t,:) = colxfm(Z(t,:), Pr');
end

