function [] = plot_imf(imf,sr)
% plot imf
% jiangjian@ion.ac.cn
% 2019-08-12
figure
n=size(imf,2);
x=linspace(0,size(imf,1)/sr,size(imf,1));
hs=[];
for i=1:n
    hs(i)=subplot(n,1,i);
    plot(x,imf(:,i));
end
linkaxes(hs,'x')
end

