figure,
subplot(211),plot(d1)
subplot(2,1,2),plot(d2)

clear,clc
fp='Y:\Users\Administrator\Desktop\audio\';
dd=[];
for i=1:3
    [d,fs]=audioread([fp,'“ÙπÏ ',num2str(i),'_020.wav']);
    dd(:,i)=d;
end

figure
h3=[];
n=size(dd,2);
for i=1:n
    h3(i)=subplot(n,1,i);
    plot(dd(:,i));
end
linkaxes(h3,'x');

[S,F,T,P]=spectrogram(dd(:,1),1800,[],[],fs);
    figure
surf(T,F,pow2db(P),'edgeColor','none');
axis tight
view(2)