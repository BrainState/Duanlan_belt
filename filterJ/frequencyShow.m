function varargout = frequencyShow(a,varargin)
%FREQUENCYSHOW Summary of this function goes here
%   Detailed explanation goes here
% sr=1000;
if nargin<2
    sr=1000;
else
    sr=varargin{1};
end

isFull=0;
if nargin==3
    isFull=varargin{2}==1;
end
f1=fft(a);
L=length(a);
f = 1:L/2;
f2=abs(f1);
P=f2(f);
phase=angle(f1);
phase=phase(f);
%P(P>(1*10^6))=0;

x1=(1:L)/sr;
x2=f/L*sr;
x1=x1-x1(1); %第一个值是直流成分
x2=x2-x2(1);
a(1)=0;
P=20*log10(P);
P(1)=0;
P(P==-inf)=0;
x3=log10(x2);
h=[];

if(nargout<1)
    %     figure
    h(1)=subplot(311);plot(x1,a),xlabel('time(s)'),ylabel('')
    h(2)=subplot(312);plot(x3,P),xlabel('f(Hz)'),ylabel('energy (dB)');
    xt=[-1,0,1,2,2.5];
    xt_label=10.^xt;
    set(gca,'xtick',xt)
    set(gca,'xtickLabel',mat2cell(xt_label))
    h(3)=subplot(313);plot(x2,phase),xlabel('f(Hz)'),ylabel('phase')
    %linkaxes(h(2:3),'x')
else
    varargout{1}=P;
    varargout{2}=x2;
    varargout{3}=phase;
end
end

