function [ output_args ] = indshow( i,len )
%INDSHOW �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

fprintf('%d,',i);
if mod(i,len)==0
    fprintf('\n');
end

end

