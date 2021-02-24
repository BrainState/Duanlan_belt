function file_struct= listFiles(fp,ext,varargin)
% list the files selected as extension or other labels
% jiangjian@ion.ac.cn
% 2019-01-01
% input: varargin -cellfun/string
% usage:
% fps=listFiles('K:\EEG\Monkey_EEG_epilepsy','edf',@data2db);
% 2020-09-01, char match test

file_struct=struct();
files=java.io.File(fp).listFiles();
if isempty(files)
    return;
end

%java.util.Arrays.sort(files, org.apache.commons.io.comparator.LastModifiedFileComparator.LASTMODIFIED_COMPARATOR);

match_str=[];
if nargin>2
    if ischar(varargin{1})
        match_str=varargin{1};
    else
        fun1=varargin{1};
    end
    
end

for i=1:files.length
    if files(i).isFile()
        [ext1,fn_]=getExt(files(i));
        fn='files';
        if strcmpi(ext1,ext)==1
            si=files(i).length/1024/1024;
            s=struct('path',char(files(i)),'size',[num2str(si),'MB']);
            if ~isempty(match_str)
                if ~isempty(regexpi(fn_,match_str,'once'))
                    if isfield(file_struct,fn)
                        file_struct.(fn)(end+1)=s;
                    else
                        file_struct.(fn)=s;
                    end
                    if exist('fun1','var')
                        fun1(s);
                    end
                end
            else
                if isfield(file_struct,fn)
                        file_struct.(fn)(end+1)=s;
                    else
                        file_struct.(fn)=s;
                    end
                    if exist('fun1','var')
                        fun1(s);
                    end
                if exist('fun1','var')
                    fun1(s);
                end
            end
        end
        
    else
        fp2=char(files(i));
        if exist('fun1','var')
            fs=listFiles(fp2,ext,fun1);
        else
            fs=listFiles(fp2,ext);
        end
        
        if ~isempty(fieldnames(fs))
            p3=regexp(fp2,'\\');
            fn=fp2(p3(end)+1:end);
            fn=regexprep(fn,'\.','_');
            fn=regexprep(fn,' ','_');
            fn=regexprep(fn,'@','_');
            fn=regexprep(fn,'-','_');
            fn=regexprep(fn,'+','_');
            fn=regexprep(fn,'''','');
            fn=['f',fn];
            file_struct.(fn)=fs;
        end
    end
end

end


function [ext,fn]=getExt(file)
ext='';fn='';
if file.isFile()
    fp=char(file.getName());
    p=regexp(fp,'\.');
    if ~isempty(p) && p(end)<length(fp)
        fn=fp(1:p(end)-1);  
        ext=fp(p(end)+1:end);               
    end    
end
ext=lower(ext);
end

