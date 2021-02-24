function varargout=varinput(varargin)
% See also: folderremember
leng=length(varargin);
if mod(leng,2)>0
    error('The INPUT must has labels')
end

for i=1:2:leng
    eval([varargin{i},'=varargin{i+1}'])
end

end