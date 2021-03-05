function varargout = cwt_spectrogram(dd0,sr)

% jiangjian@ion.ac.cn
% 2019-12-17
% transfer data into cwt spectrogram
% code2db('cwt_spectrogram')

[cfs,frq] = cwt(dd0,sr);
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



t = linspace(0,length(dd0)/sr,size(tmp0,2));
f=frq;%log10(frq);

% close all
if nargout<1
    yyaxis left
    pcolor(t,f,tmp0);
    shading interp
    ylabel('Frequency')
    % xlim([-100,300])
    % ylim(log10([0,150]))
    ylim([0,150])
    set(gca,'tickdir','out')
    set(gca,'fontSize',18)
    ylabel2=[0,10,30,100];
    % set(gca,'ytick',log10(ylabel2))
    set(gca,'ytick',ylabel2)
    set(gca,'ytickLabel',ylabel2)
    xlabel('Time(secs)')
    caxis([0,30])
    
    yyaxis right
    plot(t,dd0,'w')
else
    varargout{1}=tmp0;
    varargout{2}=frq;
    varargout{3}=t;
end


end

