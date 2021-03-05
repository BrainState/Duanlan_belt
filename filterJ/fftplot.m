function fftplot( data,fs)
%FFTPLOT Summary of this function goes here
%   Detailed explanation goes here
f=fft(data);
y1=abs(f);%.*conj(f);
y1=y1(1:end/2);
x=linspace(0,fs/2,length(y1));


figure,
plot(x,y1)
ylabel('FFT index');
xlabel('Frequency (Hz)');
end

