function varargout=folderremember(fn,s)
%function: save the folder opened by software
% INPUT:
% s: the path you want to save
% fn: function name--the function which use the s
% input model:
% fn,s : save s into fn name
% fn: load s
% 
% Use:
% folderremember(function-name,s);
% s=folderremember(function-name)
% 
% Note:
% this function must be used in pair
% 
% Modify History
% 2013-06-21, Fri, Debug: if s==0, s=matlabroot.This occured when the code
% error
% See also: mrecord


fsp='D:\mymatlab\folderremember'; % folder save pathway
if ~exist(fsp,'dir')
    mkdir(fsp);
end
fnpath=[fsp,filesep,fn,'_fsp.mat'];
switch nargin
    case 1
        if exist(fnpath,'file')
            S=load(fnpath);
            s2=S.s;
            if s2==0
                s2=matlabroot;
            end
            if length(s2)<4
                s2='F:\EEG'; % the 'G:\' is wrong input for pnget
            end
        else
            s2='F:\EEG';
        end
        varargout{1}=s2;
    case 2
        if s==0
            s=matlabroot;
        end
        save(fnpath,'s');
end
end