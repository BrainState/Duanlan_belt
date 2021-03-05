
%% pmusic
n = 0:199;
x = cos(0.257*pi*n) + sin(0.2*pi*n) + 0.01*randn(size(n));
figure
subplot(1,2,1)
pmusic(x,4)      % Set p to 4 because there are two real inputs
subplot(1,2,2)
[p,f]=frequencyShow(x) ;
plot(f,p)

%% Wigner-Ville