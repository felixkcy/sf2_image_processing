function Z = jpegdec_dpcm(vlc, qstep, N, M, bits, huffval, dcbits, W, H)

% JPEGDEC Decodes a (simplified) JPEG bit stream to an image
%
%  Z = jpegdec(vlc, qstep, N, M, bits huffval, dcbits, W, H) Decodes the
%  variable length bit stream in vlc to an image in Z.
%
%  vlc is the variable length output code from jpegenc
%  qstep is the quantisation step to use in decoding
%  N is the width of the DCT block (defaults to 8)
%  M is the width of each block to be coded (defaults to N). Must be an
%  integer multiple of N - if it is larger, individual blocks are
%  regrouped.
%  if bits and huffval are supplied, these will be used in Huffman decoding
%  of the data, otherwise default tables are used
%  dcbits determines how many bits are used to decode the DC coefficients
%  of the DCT (defaults to 8)
%  W and H determine the size of the image (defaults to 256 x 256)
%
%  Z is the output greyscale image

% Presume some default values if they have not been provided
error(nargchk(2, 9, nargin, 'struct'));
opthuff = true;
if (nargin<9)
  H = 256;
  W = 256;
  if (nargin<7)
    dcbits = 8;
    if (nargin<6)
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
end

% Set up standard scan sequence
scan = diagscan(M);
dc_scan = [1 scan]; % AKIL this is a scan (list of indices) with the DC 
                    % value appended to it

if (opthuff)
  disp('Generating huffcode and ehuf using custom tables')
else
  disp('Generating huffcode and ehuf using default tables')
  [bits huffval] = huffdflt(1);
end
% Define starting addresses of each new code length in huffcode.
huffstart=cumsum([1; bits(1:15)]); % Adds cumsum of bit levels to 1. Bit levels are how many codes in each huffman layer

% Set up huffman coding arrays.
[huffcode, ehuf] = huffgen(bits, huffval);

% Define array of powers of 2 from 1 to 2^16.
k=[1; cumprod(2*ones(16,1))];

% For each block in the image:

% Decode the dc coef (a fixed-length word)
% Look for any 15/0 code words.
% Choose alternate code words to be decoded (excluding 15/0 ones).
% and mark these with vector t until the next 0/0 EOB code is found.
% Decode all the t huffman codes, and the t+1 amplitude codes.

eob = ehuf(1,:);
run16 = ehuf(15*16+1,:);
run16
i = 1;
Zq = zeros(H, W);
t=1:M;

disp('Decoding rows')
for r=0:M:(H-M),
  for c=0:M:(W-M),
    yq = zeros(M,M);

% Decode DC coef - assume no of bits is correctly given in vlc table. AKIL
% no longer needed as DC enocded with AC
     cf = 1;
%     if (vlc(i,2)~=dcbits) error('The bits for the DC coefficient does not agree with vlc table'); end
%     yq(cf) = vlc(i,1) - 2^(dcbits-1);
%     i = i + 1;

% Loop for each non-zero AC coef.
    while any(vlc(i,:) ~= eob),
      run = 0;

% Decode any runs of 16 zeros first.
      while all(vlc(i,:) == run16), run = run + 16; i = i + 1; end

% Decode run and size (in bits) of AC coef.
      start = huffstart(vlc(i,2));
      res = huffval(start + vlc(i,1) - huffcode(start));
      run = run + fix(res/16);
      cf = cf + run + 1;  % Pointer to new coef.
      si = rem(res,16);
      i = i + 1;

% Decode amplitude of AC coef.
      if vlc(i,2) ~= si,
        error('Problem with decoding .. you might be using the wrong bits and huffval tables');
        return
      end
      ampl = vlc(i,1);

% Adjust ampl for negative coef (i.e. MSB = 0).
      thr = k(si);
      yq(dc_scan(cf-1)) = ampl - (ampl < thr) * (2 * thr - 1);

      i = i + 1;      
    end

% End-of-block detected, save block.
    i = i + 1;

    % Possibly regroup yq
    if (M > N) yq = regroup(yq, M/N); end
    Zq(r+t,c+t) = yq;
  end
end

fprintf(1, 'Inverse quantising to step size of %i\n', qstep);
Zi=quant2(Zq,qstep,qstep);

draw(Zi)

Zi = apply_idpcm(Zi, 8);

fprintf(1, 'Inverse %i x %i DCT\n', N, N);
% C8=dct_ii(N);
% Z=colxfm(colxfm(Zi',C8')',C8');
Z = lbtrec(Zi, 8, sqrt(2));

return
end


function Y = apply_idpcm(Y, M)
% Apply the DPCM decoder to the DC values in a LBT / DCT matrix. Return the new
% matrix with transformed DC values
% Y input LBT/ DCT matrix
% M size of DCT/ LBT 'blocks' in matrix
% k size of the DPCM levels. A larger number gives higher quality.

% get the low pass values of the DCt / LBT
dc_indices = (1:M:size(Y)); % 32^2 is the number of sub images n a 256x256 img
Y_rows = Y(dc_indices, :); % get 1/8 rows
Y_dc = Y_rows(:, dc_indices); % get 1/8 cols

% apply the DPCM to DC bits
Y_idpcm = DPCM_decoder(Y_dc); % appply DPCM decoder

%%draw(beside(Yq_dpcm, beside(Yq_idpcm, Yq_dc)))

% replace indices of low pass in orginal Y matrix
Y(1:8:256, 1:8:256) = Y_idpcm;

%%draw(regroup(Yq,8))

end