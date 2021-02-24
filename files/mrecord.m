function trecord=mrecord(varargin)
% record the run time and numbers
% Input: 'filename',filename,'rwtype','r'/'w'
% Modify Log
% 2013/07/29, write it
% See also: folderremember

rwtype='w';
for i=1:2:nargin
    eval([lower(varargin{i}),'=varargin{i+1};'])
end
if ~exist('filename','var')
    [~,filename]=uigetfile('*.xml','Select time record files .xml','D:\mymatlab\timesRecord');
end
filepath=['D:\mymatlab\timesRecord',filesep,filename,'_record.xml'];

if strcmp(rwtype,'w')    
    try
        trecord=xml2struct(filepath);
        trecord.times=str2double(trecord.times)+1;
    catch
        trecord.filename=filename;
        trecord.path=filepath;
        trecord.times=1;
    end
    trecord.(sprintf('time%.5d',trecord.times))=datestr(clock);
    struct2xml(trecord,trecord.path)
elseif strcmp(rwtype,'r')
    trecord=xml2struct(filepath);
end

end