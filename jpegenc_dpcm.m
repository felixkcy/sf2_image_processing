function [vlc bits huffval] = jpegenc(X, qstep, N, M, opthuff, dcbits)
    
% JPEGENC Encode an image to a (simplified) JPEG bit stream
%
%  [vlc bits huffval] = jpegenc(X, qstep, N, M, opthuff, dcbits) Encodes the
%  image in X to generate the variable length bit stream in vlc.
%
%  X is the input greyscale image
%  qstep is the quantisation step to use in encoding
%  N is the width of the DCT block (defaults to 8)
%  M is the width of each block to be coded (defaults to N). Must be an
%  integer multiple of N - if it is larger, individual blocks are
%  regrouped.
%  if opthuff is true (defaults to false), the Huffman table is optimised
%  based on the data in X
%  dcbits determines how many bits are used to encode the DC coefficients
%  of the DCT (defaults to 8)
%
%  vlc is the variable length output code, where vlc(:,1) are the codes, and
%  vlc(:,2) the number of corresponding valid bits, so that sum(vlc(:,2))
%  gives the total number of bits in the image
%  bits and huffval are optional outputs which return the Huffman encoding
%  used in compression

% This is global to avoid too much copying when updated by huffenc
global huffhist  % Histogram of usage of Huffman codewords.

% Presume some default values if they have not been provided
error(nargchk(2, 6, nargin, 'struct'));
if ((nargout~=1) && (nargout~=3)) error('Must have one or three output arguments'); end
if (nargin<6)
  dcbits = 8;
  if (nargin<5)
    opthuff = false;
    if (nargin<4)
      if (nargin<3)
        N = 8;
        M = 8;
      else
        M = N;
      end
    else 
      if (mod(M, N)~=0) error('M must be an integer multiple of N'); end
    end
  end
end
 if ((opthuff==true) && (nargout==1)) error('Must output bits and huffval if optimising huffman tables'); end
 
% DCT on input image X.
fprintf(1, 'Forward %i x %i DCT\n', N, N);
% C8=dct_ii(N);
% Y=colxfm(colxfm(X,C8)',C8)'; 
Y = lbttrans(X, 8, sqrt(2));

% AKIL apply dpcm to DC bits
Y = apply_dpcm(Y, 8, 128);

% Quantise to integers.
fprintf(1, 'Quantising to step size of %i\n', qstep); 
Yq=quant1(Y,qstep,qstep);

% Generate zig-zag scan of AC coefs.
scan = diagscan(M);
dc_scan = [1 scan]; % AKIL this is a scan (list of indices) with the DC 
                    % value appended to it

% On the first pass use default huffman tables.
disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows')
sy=size(Yq);
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    ra1 = runampl(yq(dc_scan));
    vlc1 = [vlc1; huffenc(ra1, ehuf)];
    
%    yq(1) = yq(1) + 2^(dcbits-1); % yq size plus number of bits in penultimate level
%    if ((yq(1)<0) | (yq(1)>(2^dcbits-1))) % yq(1) must be less than remainder of largest level
%      error('DC coefficients too large for desired number of bits');
%    end
%    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
%    ra1 = runampl(yq(scan));
%    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end

% Return here if the default tables are sufficient, otherwise repeat the
% encoding process using the custom designed huffman tables.
if (opthuff==false) 
  if (nargout>1)
    bits = dbits;
    huffval = dhuffval;
  end
  fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)));
  return;
end

% Design custom huffman tables.
disp('Generating huffcode and ehuf using custom tables')
[dbits, dhuffval] = huffdes(huffhist);
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows (second pass)')
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end
fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)))
fprintf(1,'Bits for huffman table = %d\n', (16+max(size(dhuffval)))*8)

if (nargout>1)
  bits = dbits;
  huffval = dhuffval';
end

return

end

function Y = apply_dpcm(Y, M, k)
% Apply the DPCM to the DC values in a LBT / DCT matrix. Return the new
% matrix with transformed DC values
% Y input LBT/ DCT matrix
% M size of DCT/ LBT 'blocks' in matrix
% k size of the DPCM levels. A larger number gives higher quality.

% get the low pass values of the DCt / LBT
dc_indices = (1:M:size(Y)); % 32^2 is the number of sub images n a 256x256 img
Y_rows = Y(dc_indices, :); % get 1/8 rows
Y_dc = Y_rows(:, dc_indices); % get 1/8 cols

% apply the DPCM to DC bits
Y_dpcm = DPCM_encoder(Y_dc, k); % apply DPCM encoder
Y_idpcm = DPCM_decoder(Y_dpcm); % appply DPCM decoder

%%draw(beside(Yq_dpcm, beside(Yq_idpcm, Yq_dc)))

% replace indices of low pass in orginal Y matrix
Y(1:8:256, 1:8:256) = Y_dpcm;

%%draw(regroup(Yq,8))

end