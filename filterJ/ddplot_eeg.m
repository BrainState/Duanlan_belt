function [p,x]=ddplot_eeg(d,sr)
% ddplot of the spectra
% jiangjian@ion.ac.cn
% 2019-07-19

[p,x]=frequencyShow(d,sr);
figure
plot(log10(x),smooth(p,7))
xt=[0.01,0.1,1,5,10,20,30,50,100,250,500];

set(gca,'xtick',log10(xt))
set(gca,'xticklabel',xt)
set(gca,'tickdir','out')
% set(gca,'fontSize',18)

xlabel('Frequency (Hz)')
ylabel('Power (dB)')


figure
t=linspace(0,length(d)/sr,length(d));
plot(t,d)
xlabel('Time (sec)')
end