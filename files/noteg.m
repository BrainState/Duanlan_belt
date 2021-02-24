function mnote=noteg(paths,mname,usestr)
%% Introduction
% FUNCTION
% save the process information about codes into the files
% 
% 2014-05-15,write
% 
%% Codes  
if isempty(regexp(paths,'\.xml', 'once'))
    paths=fullfile(paths,'mnote.xml');
end
if ~exist('usestr','var')
    usestr='';
end
mnote.mname=mname;
mnote.time=['t',datestr(now,'yyyy-mm-dd hh:MM:ss')];
mnote.path=paths;
mnote.str=usestr;
struct2xml(mnote,mnote.path); % save the path

end