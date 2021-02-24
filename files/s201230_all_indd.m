
% jiangjian@ion.ac.cn
% 2020-12-30
% function: list all indd files
% code2db('s201230_all_indd')

clear,clc
fps={};
for pan=68:90
    fp=[double(pan),':/'];
    if ~exist(fp,'dir')
        continue;
    end
    disp(fp)
    fps{end+1}=listFiles(fp,'indd');
end

