function c = getFrenquencyWithSpecialRate( data,rate,low,high )
%GETFRENQUENCYWITHSPECIALRATE Summary of this function goes here
%   Detailed explanation goes here
% function: get the frenqucy signal during s special Hz range
% 2016-01-07, 
% output: c-- complex number
% used in c++ eeg.h
ff=fft(data);
b=(1:length(data)/2)/length(data)*rate;
c=ff(b>low);
c=c(b<high);
c=abs(c);
end

