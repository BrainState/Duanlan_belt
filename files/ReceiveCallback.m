function [outputArg1,outputArg2] = ReceiveCallback(obj,event)
% callback function of serial port
%   此处显示详细说明
global s fid;
out = fread(s,1024,'uint8');%读取数据

fprintf('%X ',out);        %一个字符占三位输出,%c字符，%d整型
fprintf('\n');
fprintf(fid,'%X ',out);            % 写入文件中
fprintf(fid,'\n');

end

