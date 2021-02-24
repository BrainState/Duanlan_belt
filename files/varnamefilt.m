function s2=varnamefilt(s)
% filter the variable name in matlab
% See also: pathupper, dirlist2
snum=double(s);
lett=[48:57,65:90,95,97:122]; % 0-9,a-Z,_
[~,ia]=setdiff(snum,lett);
s(ia)='';
% disp(s)
if isempty(s)
    s=num2str(rand(1)*10000);
    s=strrep(s,'.','');
%     disp(s)
    [~,ia]=setdiff(double(s),lett);
    s(ia)='';
end


while ismember(s(1),char(48:57))
    s=['j_',s];
end
s2=s;
end