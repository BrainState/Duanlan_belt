function [c]=filter_bandpass1(a,N,Fl,Fh)

SampleRate=1000;
Fc1=2*Fl/SampleRate;
Fc2=2*Fh/SampleRate;
Fc=[Fc1 Fc2];
coefficient=fir1(N,Fc);
hd=dfilt.dfsymfir(coefficient);
c=filter(hd,a);
