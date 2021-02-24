function sp=freespace(fp)
%%
% FUNCTION:
% check the free space of the hardware
% INPUT:
% fp: file pathway
% OUTPUT
% sp: free space (MB)

%% 
[~,d]=dos(['dir ',fp]);
d=regexp(d(1:end-2),'\n','split');
d=d{end};
d=regexprep(d,',| ','');
ind=regexp(d,'Ŀ¼|����');
sp=str2double(d(ind(1)+2:ind(2)-1))./(1024^2);

end