function save_path = printJ(txt,varargin)
% print into default pathway, and open as HTML5
% jiangjian@ion.ac.cn
% 2019-05-22

% input:
% 0: 
% 1, txt
% 2, fig, 'E:\demo\abc' [nore, no ext]
% 3, fig,path,'isopen'[on/off]

% update:
% 2019-06-04, add watermarker. C#. in order to label the generate functions

if nargin==2
    fig=varargin{1};
else
    fig=gcf;
end

folder=['K:\EEG_figures\Temp\J',datestr(datetime(),'yymm'),'\'];

if nargin>2
    fig=varargin{1};
    path_0=varargin{2};
else
    path_0=[folder,'J',datestr(datetime(),'yymmdd_HHMM_ssfff')];
end
t=java.io.File(path_0).getParentFile();
if ~t.exists
    mkdir(char(t))
end

isopen='on';
if nargin==4
    isopen=varargin{3};
end
ax=get(gcf,'CurrentAxes');
set(ax,'fontSize',18)
set(ax,'tickdir','out')
print(fig,path_0,'-dpng','-r300'); % in order to immediately show in HTML


%% create html5
htmls=['<div style="width:100%;text-align:center;margin:auto;">',...   
    '<p>',char(t),'</p>',...  
    '<div><a href="',path_0,'.png" target="_blank"><img src="',path_0,'.png" style="width:500px;"/></a><br/>(',path_0,'.png)</div>',...  
    '<div style="margin-top:50px;"><a href="',path_0,'.pdf" target="_blank">download pdf</a> <br/>(',path_0,'_.pdf)</div>',...  
    '<div style="margin-top:50px;">Fig: ',path_0,'.fig</div>',... 
    '</div>'];

save_path=[path_0,'.html'];
fid=fopen(save_path,'w');
fprintf(fid,'%s\n',htmls);
fclose(fid);

if strcmp(isopen,'on')
    %winopen(save_path)
end
print(fig,path_0,'-dpdf','-r300')
print(fig,[path_0,'_'],'-dpdf','-r300','-bestfit')
try
    %disp(txt)
    addText2Pdf([path_0,'.pdf'],txt);
    addText2Pdf([path_0,'_.pdf'],txt);
catch
    fprintf('no water mask: %s \n',path_0)
end

% when fig is too large, not save it
saveas(fig,[path_0,'.fig']);
end

