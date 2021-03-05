
% jiangjian@ion.ac.cn
% 2020-08-11
% function: cmp the methods of spectrogram calculations

% 1,fft
load('\\10.10.44.152\public\005_Data\portable_data\01_newTestData\07211003_XKW\data_1003_XKW.mat')
sr=500;
d=eeg(100*sr+1:200*sr);
[p,x]=frequencyShow(d,sr);
figure,plot(x,smooth(p,101))


% 2, multitaper
% https://www.mathworks.com/help/signal/ref/pmtm.html
[pxx,f] = pmtm(d,35,length(d),sr);
figure,plot(f,log10(pxx))

% practice
% use different parameters for pmtm and list the figures

%% demo 2
Fs = 1e3;
t = 0:1/Fs:1-1/Fs;
x = cos(2*pi*100*t)+randn(size(t));
psdPer = psd(spectrum.periodogram,x,'Fs',Fs,'NFFT',length(x));
% Welch estimate
hwelch = spectrum.welch;
% 5-Hz DFT bin spacing
hwelch.SegmentLength = 200;
psdWOSA = psd(hwelch,x,'Fs',Fs,'NFFT',hwelch.SegmentLength);
plot(psdPer);
figure;
plot(psdWOSA);