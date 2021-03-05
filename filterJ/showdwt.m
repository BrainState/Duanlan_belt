function showdwt(f,h,z,NJ)
% function showdwt(f,h,NJ,z); Calculates the DWT of periodic f
% with scaling filter  h  and  NJ  scales.   rag & csb 3/17/94.

% The guts of this program are taken from the program dwt supplied in the book
% Introduction to Wavelets and Wavelet Transforms by Burrus, Gopinath, and Guo.

% Modifications to display the wavelet transform were made by Craig Zirbel.

cla;

N = length(h);  
L = length(f);
c = f(1:2^floor(log(L)/log(2))); % truncate f to a multiple of 2
                                 % this is only to make display easier - CLZ
L = length(c);
M = L/z;                         % z is the number of data points per unit time
t = [];
if nargin==3, NJ = round(log10(L)/log10(2)); end; % Number of scales
h0  = fliplr(h);                          % Scaling filter
h1 = h;  
h1(1:2:N) = -h1(1:2:N);                   % Wavelet filter
for j = 1:NJ                              % Mallat's algorithm
   L = length(c);
   c = [c(mod((-(N-1):-1),L)+1) c];       % Make periodic
   d = conv(c,h1);   
   d = d(N:2:(N+L-2));                    % Convolve & d-sample
   c = conv(c,h0);
   c = c(N:2:(N+L-2));                    % Convolve & d-sample
 
   d=abs(d);                              % d contains the coefficients
                                          % at the current scale
   if NJ-j < 12,                          % don't display the finest scales
                                          % (they take too long and are
                                          % usually very small anyway)
     pcolor([0:(M/length(d)):M], [max(NJ-j,0.5) NJ-j+1], [[d(1) d]; [d(1) d]]);
   end;
hold on
end;

shading faceted;
pcolor([0:(M/length(d)):M], [0 0.5], [[c(1) c]; [c(1) c]]);
                                          % display the scaling coefficients
                                          % as the bottom half of the lowest
                                          % bar

axis([0 M 0 NJ]);                         % change NJ to 11 here
                                          % to remove blank space at top
colormap(sqrt(gray));                     % gray-scale image
xlabel('Time');
ylabel('Frequency (logarithmic scale)');
title('Absolute value of wavelet coefficients');
