function varargout = fft2spectra(d,sr,dur,varargin)
% jiangjian@ion.ac.cn
% 2019-12-12
% code2db('fft2spectra')
% input: d,sr,dur,[st,savep(''/[]/-1/pathway),code_path]
% output: [sp_abs,sp_rel]
% see also: spectrogram_plot, spectrogram_zscore
%
% update:
% 2020-04-07, add code_path input


st=0;
savep0='';
savep='';
isvisible='on';
if nargin>3
    st=varargin{1};
end
if nargin>4
    savep0=varargin{2};
    if ~isempty(savep0)
        isvisible='off';
    end
end
code_path=which('fft2spectra');
if nargin>5
    code_path=varargin{3};
end

[sp_abs,sp_rel,select_obj,d_]=spectrogram_zscore(d,dur,sr);

if nargout>0
    varargout{1}=sp_abs;
end
if nargout>1
    varargout{2}=sp_rel;
end
if nargout>2
    varargout{3}=select_obj;
end
if nargout>3
    varargout{4}=d_;
end

if ~strcmp(savep0,'-1')
    [y,E] = histcounts(sp_abs(:),500);
    y=cumsum(y/sum(y));
    inds_5=find(y<=0.01);
    if isempty(inds_5)
        inds_5=E(1);
    else
        inds_5=inds_5(end);inds_5=E(inds_5);
    end
    % if inds_5<0
    %     inds_5=0;
    % end
    inds_95=find(y>=0.99);inds_95=inds_95(1);inds_95=E(inds_95);
    header.caxis=[inds_5,inds_95];
    header.st=st;
    header.sr=sr;
    header.dur=dur;
    header.ylim=[0,100];
    header.codepath=code_path;
    if ~isempty(savep0)
        savep=[savep0,'_fft_abs'];
    end
    
    fig_spectrogram=spectrogram_plot(sp_abs,header,isvisible,savep);
    
    header.sr=sr;
    header.dur=dur;
    header.caxis=[-1,1]*2;
    header.ylim=[0,100];
    header.codepath=code_path;
    if ~isempty(savep0)
        savep=[savep0,'_fft_rel'];
    end
    
    for i=1:size(sp_rel,1)
        if min(abs(sp_rel(i,:)))>2.5
            sp_rel(i,:)=nan;
        end
    end
    fig_spectrogram=spectrogram_plot(sp_rel,header,isvisible,savep);
end

end

