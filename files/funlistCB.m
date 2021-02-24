function varargout=funlistCB(callbackFunction,varargin)
%%Introduction
% Function: tranverse all the file and process each file with the callback
% function
% INPUT: 
% filepaths--{'',''.}(ui: uipickfiles)
% �����ļ��еļ���:endLevel--0,1,...n
% �ļ�����: filetype: ���û��ָ��, ����������ļ�
% Ϊ�˱�������: varargin����eval��ֵ�ķ�ʽ
% 
% ������ʾ��:
% funlistCB(cbFun,'filepaths',filepaths,'endLevel','yes','filetype','.jpg');

%% input
leng=length(varargin);
filetype='\.oib|\.oif';
escapestr='';
endLevel=0; % if endlogi>0, don't go to deeper layer when find your target. ��ʱû��ʹ��
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
                %% ������ִ��callback function
                % cbinput ��funlistCB���ô������Զ���
                op{jj1}=callbackFunction(filepath,cbinput);
            end
        end
    end    
end
varargout{1}=op;
end