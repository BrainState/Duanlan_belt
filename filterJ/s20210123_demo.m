
% jiangjian@ion.ac.cn
% 2021-01-23
% function: demo



sr=1000;

Wp = [10 20]/(sr/2); %  Wp and Ws are respectively the passband and stopband edge frequencies of the filter, normalized from 0 to 1
Ws = [0.1 50]/(sr/2);
Rp=3; %  no more than Rp dB of passband ripple
Rs=40; % at least Rs dB of attenuation in the stopband
[n,Wn] = buttord(Wp,Ws,Rp,60);

[b,a] = butter(n,Wn);

x=linspace(0,1000,10000);
y=randn(1,length(x))+sin(x);

figure,plot(x,y)

[P,X]=frequencyShow(y,sr);
figure,plot(X,log(P))

y2=filter(b,a,y);

[P,X]=frequencyShow(y2,sr);
figure,plot(X,log(P))

%% 

[b,a]=butter(2,[10,20]/(sr),'bandpass');
y2=filter(b,a,y);

[P,X]=frequencyShow(y2,sr);
figure,plot(X,log(P))
