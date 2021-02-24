% <xml>
% <mfile>
% <name>
function varargout=timestr(strtype)
% </name>
% 
% <function>
% generate the string of time,like 130829,1308291208
% </function>
% 
% <example>
% </example>
% 
% <algorithm>
% 2013/08/28, write the function
% </algorithm>
% 
% <modifylog>
% <modifylog>
% 
% <seealso>
% see also:
% </seealso>
% 
% <copyright>
% copyright: Jiang Jian @2010-2013
% </copyright>
% 
% <version>1.0, 2013/8/23 <version>
% <codes>

strtype=lower(strtype);
strm='ymdhms';
if ~isempty(regexp(strtype,'y', 'once'))
    y=
end

% </codes>
end
% </mfile>