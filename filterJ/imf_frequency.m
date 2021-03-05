function [instfrq] = imf_frequency(imf,sr)
% calculate the frequency and phase of imf components
% jiangjian@ion.ac.cn
% 2019-08-12
for i=size(imf,2):-1:1
    x = hilbert(imf(:,i));
    instfrq(:,i) = sr/(2*pi)*diff(unwrap(angle(x)));
end

end

