function f0=GaussianHighpass
a=rgb2gray(imread('Y:\Users\Administrator\Desktop\img\111101C0201_C003T001.tif'));

[m, n]=size(a);
f_transform=fft2(a);
f_shift=fftshift(f_transform);

k=2; p=m/k; q=n/k;
d0=5;

[i,j]=meshgrid(1:m,1:n);
d1=sqrt((i-p).^2+(j-q).^2);
low_filter=exp(-d1.^2/(2*d0^2));

filter_apply=f_shift.*low_filter;
image_orignal=ifftshift(filter_apply);
image_filter_apply=abs(ifft2(image_orignal));

df=mean(image_filter_apply(:))-image_filter_apply;
f0=double(a)+df;