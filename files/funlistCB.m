function varargout=funlistCB(callbackFunction,varargin)
%%Introduction
% Function: tranverse all the file and process each file with the callback
% function
% INPUT: 
% filepaths--{'',''.}(ui: uipickfiles)
% 遍历文件夹的级数:endLevel--0,1,...n
% 文件类型: filetype: 如果没有指定, 则遍历所有文件
% 为了便于扩充: varargin采用eval赋值的方式
% 
% 完整的示例:
% funlistCB(cbFun,'filepaths',filepaths,'endLevel','yes','filetype','.jpg');

%% input
leng=length(varargin);
filetype='\.oib|\.oif';
escapestr='';
endLevel=0; % if endlogi>0, don't go to deeper layer when find your target. 暂时没有使用
if mod(leng,2)>0
    error('The INPUT must has labels')
end
for i=1:2:leng
    eval([lower(varargin{i}),'=varargin{i+1};'])
end

if ~exist('filepaths','var')
    df=folderremember(mfilename);
    dp=uipickfiles('FilterSpec',pathupper(df),'Prompt','Select the path folder');
    filepaths=dp{1};
    folderremember(mfilename,s)
end

%%
op={};
jj1=0;
for j=1:length(filepaths)
    waitbar(j/length(filepaths));
    p1=filepaths{j};
    if isdir(p1)
        funxml=funlist('s',p1,'filetype',filetype);
    else
        funxml.filejj.mfile={p1};
    end
    
    fin2=fieldnames(funxml);
    for i=1:length(fin2)
        files=funxml.(fin2{i}).mfile;
        if ~isempty(files)
            for jj=1:length(files)
                filepath=files{jj};
                jj1=jj1+1;
                %% 在这里执行callback function
                % cbinput 从funlistCB引用处任意自定义
                op{jj1}=callbackFunction(filepath,cbinput);
            end
        end
    end    
end
varargout{1}=op;
end