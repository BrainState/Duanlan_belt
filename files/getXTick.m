function [xtt,xtL,xlabel1]=getXTick(header,tt,varargin)
% getxtick
% jiangjian@ion.ac.cn
% 2019-09-04
% code2db('getXTick');
% input: tt-total time (h); [x1]
% input: header.dur(seconds)
% output: xtt-xtick, xtL-xtickLabel, xlabel1-xlabel
% update:
% 2020-04-02, add x(1)
% 2020-05-09,add example
% example:
% [xt,xtL]=getXTick(struct('dur',1/sr,'st',st),tt,x(1));
% set(gca,'xtick',xt/3600/sr)
% set(gca,'xtickLabel',xtL)

if exist('header','var') && isfield(header,'st') && isa(header.st,'datetime')
    minu=60-minute(header.st); % 2019-06-12,debug, 60-minu
    if minu==60
        minu=0;
    end
    st0=hour(header.st);
    if minu>0
        st0=st0+1;
    end
else
    st0=0;
    minu=0;
end
dur=1;
if exist('header','var') && isfield(header,'dur')
    dur=header.dur;
end

x1=1;
if nargin>2
    x1=varargin{1};
end

if tt*60<5
    tt=tt*3600; % s
    dt1=round(tt/10); % time interval for labels
    pdt=[1,5,10,20,30,60];
    [~,ind1]=min(abs(dt1-pdt));
    dt=pdt(ind1);
    
    
    xt=1:dt:tt*2;
    xtt=xt/dur; xtt(1)=1;
    %xtt=xtt+minu*60/dur;
    %xt=xt+ceil(st0);
    xtL=xt;
    xlabel1='Time (sec)';
elseif tt<2
    tt=tt*60; % min
    dt1=round(tt/6); % time interval for labels
    pdt=[0.1,0.5,1,5,10,20,30,60];
    [~,ind1]=min(abs(dt1-pdt));
    dt=pdt(ind1);
    
    
    xt=0:dt:tt*2;
    xtt=xt*60/dur; xtt(1)=1;
    xtL=xt;
    %xtt=xtt+minu*60/dur;
    %xt=xt+ceil(st0);
    xlabel1='Time (min)';
else
    pdt=[1,2,3,6,12];
    dt1=round(tt/6);
    [~,ind1]=min(abs(dt1-pdt));
    dt=pdt(ind1);
    
    xt=0:dt:tt+1;
    xtt=xt*3600/dur; xtt(1)=x1;
    xtt=xtt+minu*60/dur;
    xtL=xt+ceil(st0);
    while max(xtL)>24
        xtL(xtL>24)=xtL(xtL>24)-24;
    end
    xlabel1='Time (h)';
end
end