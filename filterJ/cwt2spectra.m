function varargout = cwt2spectra(d,sr,varargin)

% jiangjian@ion.ac.cn
% 2019-12-12
% code2db('cwt2spectra')

st=0;
savep='';
isvisible='on';
if nargin>2
    st=varargin{1};
end
if nargin>3
    savep=varargin{2};
    isvisible='off';
end

[cfs,frq] = cwt(d,sr);
tmp0 = abs(cfs);
t1 = size(tmp0,2);
tmp1 = tmp0';
minv = min(tmp1);
tmp1 = (tmp1-minv(ones(1,t1),:));

maxv = max(tmp1);
maxvArray = maxv(ones(1,t1),:);
indx = maxvArray<eps;
tmp1 = 240*(tmp1./maxvArray);
tmp2 = 1+fix(tmp1);
tmp2(indx) = 1;
tmp2 = tmp2';



t = linspace(0,length(d)/sr,size(tmp0,2));
f=frq;%log10(frq);

% close all

gcf1=figure('PaperOrientation','landscape','position', [0,0,1200,600],'visible',isvisible);
yyaxis left
pcolor(t,f,tmp0);
shading interp
ylabel('Frequency')
% xlim([-100,300])
% ylim(log10([0,150]))
ylim([0,30])
set(gca,'tickdir','out')
set(gca,'fontSize',18)
ylabel2=[0,10,30,100];
% set(gca,'ytick',log10(ylabel2))
set(gca,'ytick',ylabel2)
set(gca,'ytickLabel',ylabel2)
xlabel('Time(secs)')
caxis([0,30])

yyaxis right
plot(t,d,'color',[1,0.3,0.3])
ylim([-1,1]*300)
if ~isempty(savep)
    savep1=[savep,'_abs'];
    printJ(which('cwt2spectra'),gcf1,savep1);
    close(gcf1)
end

tmp1=tmp0-repmat(mean(tmp0,2),1,size(tmp0,2));
tmp1=tmp1./repmat(std(tmp1,0,2),1,size(tmp1,2));

gcf1=figure('PaperOrientation','landscape','position', [0,0,1200,600],'visible',isvisible);
yyaxis left
pcolor(t,f,tmp1);
shading interp
ylabel('Frequency')
% xlim([-100,300])
% ylim(log10([0,150]))
ylim([0,150])
set(gca,'tickdir','out')
set(gca,'fontSize',18)
ylabel2=[0,10,30,50,100];
% set(gca,'ytick',log10(ylabel2))
set(gca,'ytick',ylabel2)
set(gca,'ytickLabel',ylabel2)
xlabel('Time(secs)')
caxis([-1,1]*2)

yyaxis right
plot(t,d,'w')

if ~isempty(savep)
    savep1=[savep,'_rel'];
    printJ(which('cwt2spectra'),gcf1,savep1);
    close(gcf1)
end

if nargout>0
    varargout{1}=tmp0;
    varargout{2}=frq;
    varargout{3}=t;
end

end

