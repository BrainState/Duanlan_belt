function s2=pathupper(s)
% return the upper level of path s
% See also: pnget, folderremember
% if isdir2(s)||exist(s,'file')
    s2=regexprep(s,pnget(s,'end'),'');
% else
%     error('The input must be dir!')
% end
end