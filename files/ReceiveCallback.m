function [outputArg1,outputArg2] = ReceiveCallback(obj,event)
% callback function of serial port
%   �˴���ʾ��ϸ˵��
global s fid;
out = fread(s,1024,'uint8');%��ȡ����

fprintf('%X ',out);        %һ���ַ�ռ��λ���,%c�ַ���%d����
fprintf('\n');
fprintf(fid,'%X ',out);            % д���ļ���
fprintf(fid,'\n');

end

