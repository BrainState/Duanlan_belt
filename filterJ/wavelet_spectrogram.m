
% wavelet 
fp='D:\Codes\MatlabLib\eeg\monkey_eilepsy\seizure_sample_0418.mat';
fp='D:\Codes\MatlabLib\eeg\monkey_eilepsy\seizure_sample_0312_0294.mat';
load(fp)

% fft
sig=double(t);
wind=100;
nlap=90;
nfft=1024;
Fs=1000;
c=spectrogram(sig,wind,nlap,nfft,Fs,'yaxis');
ylim([0,150])

t2=10*log10(abs(c));
t2=t2-repmat(mean(t2,2),1,size(t2,2));
t2=t2./repmat(std(t2,0,2),1,size(t2,2));
figure
subplot(2,1,1)
pcolor(t2)
ylim([0,100])
caxis([-1,1]*2)
% set(gca,xtick,)
shading interp
subplot(2,1,2)
plot(t)

x=linspace(0,length(sig)/sr/60,length(sig));
% x2=linspace(0,length(sig)/sr/60,length(t));
figure,plot(x,sig)
hold on
plot(x2,t2(5,:))
hold off
axis tight



%wavelet
figure,plot(sample)
