function [header,varargout] = file2matrix(fp_header,varargin)
% read self-defined file into matlab workspace
% jiangjian@ion.ac.cn
% 2019-09-04
% input: pathway,[read_type='header/channel_name']

% test: fp_header='K:\EEG\human_MDD_DBS\190530_MDD_YiHuiGui\sleep_EEG_data.jheader';
% code2db('file2matrix')
read_type='';
if nargin>1
    read_type=varargin{1};
end

%% header read
% there are three types of header in planning: txt[header], xml[xheader],
% json[jheader]

str='';
fid=fopen(fp_header);
while ~feof(fid)
    tline=fgetl(fid);                                 
    str=[str,tline];
end
header=jsondecode(str);

if strcmp(read_type,'header')  
    return;
end

read_ch=-1;
if ~strcmp(read_type,'')
    for i=1:length(header.labels)
        if strcmp(read_type,header.labels{i})
            read_ch=i;
        end
    end
end

[fp,fn,~]=fileparts(fp_header);
fp_data=[fp,'/',fn,'.bin'];

fid=fopen(fp_data);
if read_ch==-1
    % read all
    data=fread(fid,header.data_size',header.data_type);
else  
    % read a channel
    fseek(fid,header.Byte_number*(read_ch-1),'bof');
    data=fread(fid,header.data_size(2),header.data_type,(header.data_size(1)-1)*header.Byte_number);
end
fclose(fid);
varargout{1}=data;
end



