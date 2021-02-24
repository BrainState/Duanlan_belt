clear; clc;

load ascout;
load get_ele;
x(abs(x)>20) = 0;
sz = size(x,1);
x = unfold(x);
ref = x(:,setdiff(1:size(x,2),ge));
x = x-((x'/ref')*ref')';
x = fold(x,sz);

yx = x(:,ge,:);
yx = demean(yx);

clear x;
x = yx;

fs = 50;

[b,a] = butter(6,2*[3 5]/fs);
for tri = 1:size(x,3)
    x(:,:,tri) = filtfilt(b,a,double(x(:,:,tri)));
end
x(abs(x)>25) = 0;
p = unfold(x);
cmat1 = p'*p;

y = squeeze(mean(x,3));
cmat2 = y'*y;

[todss,fromdss,ratio,pwr] = dss0(cmat1,cmat2);
[T,F] = dss0(cmat1,cmat2);
for pp = 1:size(yx,3)
%     yy(:,:,pp)=yx(:,:,pp)*T(:,1:6);
    yy(:,:,pp) = yx(:,:,pp)*T(:,1:6)*F(1:6,:);
%     yy(:,:,pp)=x(:,:,pp)*T*F;
end
x = yy;

L = 800;
f = fs/L*(0:1:L-1);

for ch = 1:size(x,2)
    
    fa = angle(fft(squeeze(x(:,ch,:)),L)/L*2);
    
    r(:,ch) = mean(cos(fa),2).^2 + mean(sin(fa),2).^2;
    
end

figure
subplot 121
hold on;

plot(f,r,'Color',[0.7 0.7 0.7],'linewidth',2);
plot(f,mean(r,2),'k');

xlim([0.5 4.5]);

subplot 122
plot(f,abs(fft(mean(x,3),L)))
xlim([0.5 4.5]);



