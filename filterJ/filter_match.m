
% jiangjian@ion.ac.cn
% 2019-08-13
%% Pulse Compress
clear all; close all; clc;

% LFM parameter
B       =   4e+6;       % 4MHz??
Tao     =   200e-6;     % 200us??
T       =   2e-3;       % 2ms?????? 
fs      =   8e+6;       %????
SNR     =   20;         % ???20dB
dis     =   T*fs/2;     % ???????????

% Generate LFM
t = -round(Tao*fs/2):1:round(Tao*fs/2)-1; % ????? 
lfm = (10^(SNR/20))*exp(1i*pi*B/Tao*(t/fs).^2);

figure;
subplot(2,1,1); plot(real(lfm),'b'); title('????????');
subplot(2,1,2); plot(imag(lfm),'r'); title('????????');

lfm2=fliplr(lfm);
figure;
hold on
plot(real(lfm),imag(lfm))
% plot(imag(lfm))
hold off

% Generate echo
echo  = zeros(1,T*fs);
echo(dis:1:dis+Tao*fs-1) = lfm;
noise = normrnd(0,1,1,T*fs) + 1i*normrnd(0,1,1,T*fs);
echo = echo + noise;

figure;
subplot(2,1,1); plot(real(echo),'b'); title('??????');
subplot(2,1,2); plot(imag(echo),'r'); title('??????');

% Generate filter coeff
coeff = conj(fliplr(lfm)).* hamming(Tao*fs)'; %????/????
t=hamming(Tao*fs);
figure; freqz(coeff);

% pulse compress
fft_n = 2^(floor(log2(T*fs)) + 1);
pc_res = ifft(fft(echo,fft_n).*fft(coeff,fft_n)); % ?????????
%pc_res=conv(echo,coeff,'same');

figure;
plot(db(abs(pc_res)/max(abs(pc_res))),'r');  title('???????');