function varargout = psg_spectrum(varargin)
% get spectrogram
% jiangjian@ion.ac.cn
% 
% ch: 1-4
% varargin: 
% type 1: ind,ch (abandon)
% type 2: data_ch1,dur
% modify
% 2020-03-23, round(dur*sr)

dur=30; % default
sr=200;
if nargin==1
    d4=varargin{1};
elseif nargin==2
    d4=varargin{1};
    dur=varargin{2};
%     ind=varargin{1};
%     ch=varargin{2};
%     [d,~]=loadData_PSG(ind); % load data: 1-199
%     d4=d(ch,:);
elseif nargin==3
    d4=varargin{1};
    dur=varargin{2};
    sr=varargin{3};
%     ind=varargin{1};
%     ch=varargin{2};
%     [d,~]=loadData_PSG(ind); % load data: 1-199
%     d4=d(ch,:);
end

dt=round(sr*dur);

n=floor(length(d4)/dt);
sp=zeros(n,floor(dt/2));
hn=hann(100)/sum(hann(100));
for i=1:n
    dd=d4(dt*(i-1)+1:dt*i);
    P=frequencyShow(dd,sr);
    P=conv(P,hn,'same');
    sp(i,:)=P;
end

if nargout>0
    varargout{1}=sp;
    varargout{2}=n;
else
    figure('PaperOrientation','landscape','position',[20,20,1000,300],'visible','on'),
    pcolor(sp')
    shading interp
    yt=0:300:3000;
    set(gca,'ytick',yt)
    set(gca,'ytickLabel',mat2cell(yt'/30))
    %xt=(1:906)/906*24;
    %h=906*30/3600;
    xt=0:10;
    set(gca,'xtick',xt*3600/30)
    set(gca,'xtickLabel',mat2cell(xt'))
    colormap jet
    xlim([1,10*3600/30])
    caxis([40,80])
    xlabel('Time (h)')
    ylabel('Frequency (Hz)')
    set(gca,'fontSize',18)
    set(gca,'tickDir','out')
end

end

