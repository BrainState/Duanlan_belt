function eeg3=eeg_preprocess(eeg,sr)
%  function: preprocess the data for belt
% jiangjian@ion.ac.cn
% 2020-09-10
eeg2=eeg;

[b,a]=butter(2,0.5/(sr/2),'high');
eeg3=filter(b,a,eeg2);
eeg3(abs(eeg3)>200)=0;
[b,a]=butter(2,150/(sr/2),'low');
eeg3=filter(b,a,eeg3);
eeg3=notch(eeg3,sr);
end