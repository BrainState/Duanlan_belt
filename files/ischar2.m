function logi=ischar2(s)
% Modify Log
% 2013/07/10, Wed, write the function
a=1;
if ischar(s)
    if isdir(s)&&~isempty(regexp(s,filesep, 'once'))
        logi=a<0;
    else
        logi=a>0;
    end
else
    logi=a<0;
end
end