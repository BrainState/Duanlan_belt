function [c]=filter_lowpass1(a,N,F)

SampleRate=1629;
Fc=2*F/SampleRate;
coefficient=fir1(N,Fc);
hd=dfilt.dfsymfir(coefficient);
c=filter(hd,a);
