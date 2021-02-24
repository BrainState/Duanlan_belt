function [fp] = mat2txt(mat,file_name)
% save mat data to txt file
fp=['J:\',file_name,datestr(datetime(),'yyMMddHHmmss'),'.txt'];

[r,c]=size(mat);

fileID = fopen(fp,'w');

for i=1:r
    for j=1:c
        fprintf(fileID,'%s ',num2str(mat(i,j)));
    end
    fprintf(fileID,'\n');
end
fclose(fileID);



end

