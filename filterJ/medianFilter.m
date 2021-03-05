function eeg1 = medianFilter(eeg,threshold)
%MEDIANFILTER Summary of this function goes here
%   Detailed explanation goes here
a_i=find(eeg>threshold);
eeg1=eeg;
len=2000;
for jj=1:length(a_i)
    ind=a_i(jj);
    s=ind-len;
    e=ind+len;
    if s<=0
        s=1;
    end
    if e>length(eeg)
        e=length(eeg);
    end
%     disp([s,e])
    d=eeg(s:e);
    [~,inds]=sort(abs(d));
    eeg1(ind)=d(inds(len));
end
end

