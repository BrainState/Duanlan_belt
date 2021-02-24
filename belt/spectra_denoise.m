function varargout=spectra_denoise(eeg,infos,varargin)

% jiangjian@ion.ac.cn
% 2020-09-21

savep='';
if nargin>2
    savep=varargin{1};
end

info=infos{1};
sr=info.sr;
[b,a]=butter(2,[0.5,100]/(sr/2),'bandpass');
eeg2=filter(b,a,eeg);
eeg2=notch(eeg2,sr);

% zero cross rate
eeg3=eeg2;
eeg3(eeg3>0)=1;
eeg3(eeg3<0)=-1;

eeg4=abs(diff(eeg3));

n=floor(length(eeg4)/sr);
eeg5=reshape(eeg4(1:sr*n),sr,n);
eeg6=sum(eeg5);
% figure,plot(eeg6)
% hold on
% plot([0,n],[1,1]*130,'--k')
% hold off

cross_rate=130;
if isfield(info,'cross_rate')
    cross_rate=info.cross_rate;
end
inds=eeg6>cross_rate;
eeg_=reshape(eeg2(1:sr*n),sr,n);
eeg_(:,inds)=0;
eeg_=eeg_(:);

% fft2spectra(eeg_,sr,30);



% threshold

eeg_(abs(eeg_)>200)=0;
% figure,plotJ(eeg_,sr)

dur=1;
n=floor(length(eeg_)/dur/sr);
eeg1f2=reshape(eeg_(1:n*dur*sr),dur*sr,n);
pkss=[];
for in=1:n
    t=abs(eeg1f2(:,in));
    pkss(in)=max(t);
end
pkss(pkss<0)=nan;
pkss2=smooth(pkss);
pkss2(pkss2<0)=nan;
% figure,plot(pkss)

pkss2=[];
for i=1:30:length(pkss)-30
    pkss2(end+1)=median(pkss(i:i+30));
end

% slow wave plot
st=datetime(info.st);

% figureJ
% set(gcf,'visible','off')
% plot(pkss2,'lineWidth',2)
% axis tight
% tt=length(pkss2)*30/3600;
% header=struct('dur',30,'st',st);
% x1=1;
% [xtt,xt,xlabel1]=getXTick(header,tt,x1);
% set(gca,'xtick',xtt)
% set(gca,'xtickLabel',xt)
% xlabel(xlabel1);
% set(gca,'fontSize',18)
% close gcf

threshold=30;
if isfield(info,'threshold')
    threshold=info.threshold;
end
inds2=find(pkss>threshold);
eeg_=reshape(eeg_(1:sr*n),sr,n);
eeg_(:,inds2)=0;
eeg_=eeg_(:);

% re-calculate pkss
dur=1;
n=floor(length(eeg_)/dur/sr);
eeg1f2=reshape(eeg_(1:n*dur*sr),dur*sr,n);
pkss=[];
for in=1:n
    t=abs(eeg1f2(:,in));
    pkss(in)=max(t);
end
pkss(pkss<0)=nan;

% pkss(inds2)=0;
% figure,plot(pkss)
if nargout>0
    varargout{1}=eeg_;
    varargout{2}=eeg6; % cross_rate
    varargout{3}=pkss; % envelope
end
if isempty(savep)
    fft2spectra(eeg_,sr,30,datetime(info.st));
else
    fft2spectra(eeg_,sr,30,datetime(info.st),savep);
end


end

