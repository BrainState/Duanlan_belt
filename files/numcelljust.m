% <xml>
% <mfile>
% <name>
function c5=numcelljust(b,aligntype)
% </name>
% 
% <function>
% The model of function correspond to xml
% </function>
% 
% <example>
% </example>
% 
% <algorithm>
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
if ~exist('aligntype','var')
    aligntype='center';
end
c=b;
for i=1:length(b)
    len2=length(b{i});
    strt=num2str(ones(len2,1));
    c{i}=strt';
end
c2=char(c);
c3=strjust(c2,aligntype);
c4=c3=='1';
c5=double(c4);
for i=1:length(b)
    c5(i,c4(i,:))=b{i};
end
% surfc(double(c5),'edgecolor','none')


% </codes>
end
% </mfile>