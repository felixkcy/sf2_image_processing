function y = below(top, bottom)
%BESIDE  Arrange two images beside each other.
%  Y = BELOW(X1, X2) puts X2 below X1 in Y.
%  Y is padded with zeros as necessary and the images are
%  separated by a blank row.

% work out size of Y
[m1,n1]=size(top);
[m2,n2]=size(bottom);
n = max(n1,n2);
y=zeros(m1+m2+1,n);

y([1:m1], (n-n1)/2+[1:n1]) = top;
y(m1+1+[1:m2], (n-n2)/2+[1:m2]) = bottom;
return
