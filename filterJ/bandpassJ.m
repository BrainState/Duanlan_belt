function d = bandpassJ( data,low,high,varargin )
%BANDPASSJ Summary of this function goes here
%   Detailed explanation goes here
if(nargin>3)
    rate=varargin{1};
else
    rate=1000;
end
sizeD=size(data);
if sizeD(1)==1
    data=data';
end
d1=butterworthlp(data,high,rate);
d=butterworthhp(d1,low,rate);
if sizeD(1)==1
    d=d';
end
end

