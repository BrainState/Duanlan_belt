
function fig_spectrogram=spectrogram_plot(sp22,header,varargin)
% jiangjian@ion.ac.cn
% 2019-04-10
% input: sp22,header,[isvisible='on/off',savep]
% related function: [sp,sp23,select_obj]=spectrogram_zscore(d,dur,sr,varargin)
% 
% necessary fields for header
%     header.sr=sr;
%     header.dur=dur;
%     header.caxis=[-1,1]*2;
%     header.ylim=[0,100];
%     header.codepath=which('s190722_scizhophrenia_guangji_jijun');
% log:
% 2019-09-05, change name from s190410_zhongshan_spectrogram to spectrogram_plot
% see also: fft2spectra

if nargin>2
    isvisible=varargin{1};
end
if nargin>3 && ~isempty(varargin{2})
    savep=varargin{2};
end

if ~exist('isvisible','var')
    isvisible='on';
end

% input: d, dur, sr,heder(st)

%bin=ones(50,3);
%bin=bin/sum(bin(:));
dur=header.dur;
sr=header.sr;


fig_spectrogram=figure('PaperOrientation','landscape','position', [0,0,1200,600],'visible',isvisible,'color','white');
% yyaxis left
pcolor(sp22(:,1:min(100*dur,sr/2*dur))')
caxis(header.caxis)
shading interp

yt=[0,10,20,30,40,50,100];
if sr/2<100
    yt=0:round(sr/2/5):sr/2;
else
    ylim([0,header.ylim(2)*dur])
end
ytt=yt*dur;
ytt(1)=1;

set(gca,'ytick',ytt)
set(gca,'ytickLabel',yt)
% 

tt=size(sp22,1)*dur/3600;
[xtt,xt,xlabel1]=getXTick(header,tt);

set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)


ylabel('Frequency (Hz)')
xlabel(xlabel1)

set(gca,'fontSize',18)
set(gca,'tickdir','out')
% colorbar;

if exist('savep','var')
    ptemp=[savep,'.fig'];
    [fp,~,~]=fileparts(ptemp);
    if ~exist(fp,'dir')
        mkdir(fp)
    end  
    printJ(header.codepath,fig_spectrogram,savep,isvisible)
    close(fig_spectrogram);
end

end


