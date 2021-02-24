function [ output_args ] = indshow( i,len )
%INDSHOW 此处显示有关此函数的摘要
%   此处显示详细说明

fprintf('%d,',i);
if mod(i,len)==0
    fprintf('\n');
end

end

