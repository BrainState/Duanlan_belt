function dat = filter_wavelet( data )
%FILTER_WAVELET Summary of this function goes here
%   Detailed explanation goes here
waveletFunction='db8';
[C,L] = wavedec(data,8,waveletFunction);
dat.gamma = wrcoef('d',C,L,waveletFunction,5); %GAMMA
dat.beta  = wrcoef('d',C,L,waveletFunction,6); %BETA
dat.alpha = wrcoef('d',C,L,waveletFunction,7); %ALPHA
dat.theta = wrcoef('d',C,L,waveletFunction,8); %THETA
dat.delta = wrcoef('a',C,L,waveletFunction,8); %DELTA
end

