function [c]=filter_highpass1(a,N,F)

SampleRate=1600;
Fc=2*F/SampleRate;
coefficient=fir1(N,Fc,'high');
hd=dfilt.dfsymfir(coefficient);
c=filter(hd,a);
