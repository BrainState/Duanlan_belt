function logi=isdir2(s)
% Function: judge any input, not just char as isdir
% Modify History:
% 2013-06-15, Sat, Writing the function
% 
% See also: isdir

if ischar(s)
    if isdir(s)
        logi=~isempty(regexp(s,filesep, 'once'));
    else
        logi=1<0;
    end
else
    logi=1<0;
end
end