function [] = matrix2file(fp,header,varargin)
% function: save matlab matrix into binary data file,for other software
% reading, c++ eg
% jiangjian@ion.ac.c
% 2019-09-02
% code2db('matrix2file');
% header: fields-
% data: multiple channel saving-ch1,ch2,..chn; ch1,ch2,...chn;(this type is high for data showing)

%% save header
fp_header=[fp,'_data.jheader'];
if isfield(header,'data_type')
    header.data_type='float';
    header.Byte_number=4;
end
header.create_time=datestr(datetime(),'yyyy-mm-dd HH:MM:SS.FFF');
header_write_json(header,fp_header);

if nargin>2
    data=varargin{1};
    fp_data=[fp,'_data.bin'];
    fid=fopen(fp_data,'w+');
    fwrite(fid,data(:),header.data_type);
    fclose(fid);
end

end

function header_write_json(header,fp_header)
fid=fopen(fp_header,'w+');
he=jsonencode(header);
fprintf(fid,'%s',he);
fclose(fid);
end

function header_write_txt(header,fp_header)
fid=fopen(fp_header,'w+');

fns=fieldnames(header);
for i=1:length(fns)
    fprintf(fid,'%s:',fns{i});
    t=header.(fns{i});
    if isnumeric(t)
        fprintf(fid,'%s',num2str(t));
    elseif iscell(t)
        for j=1:length(t)
            if isnumeric(t)
                fprintf(fid,'%s,',num2str(t{j}));
            else
                fprintf(fid,'%s,',t{j});
            end            
        end
        
    else
        fprintf(fid,'%s',t);
    end    
    fprintf(fid,'\r\n');
end
fprintf(fid,'%s:%s\n','data_size',num2str(size(data)));
fprintf(fid,'%s:%s\n','create_time',datestr(datetime(),'yyyy-mm-dd HH:MM:SS.FFF'));
fclose(fid);
end
