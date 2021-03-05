function components = icaJ( data, varargin )
%ICAJ Summary of this function goes here
%   Detailed explanation goes here
% Jerry 2016-01-07
% ICA analysis
if nargin<2
    n=10;
else
    n=varargin{1};
end
[weights,~,~,~,icaD.signs,icaD.lrates] = runica(data,'PCA',n);
components=weights*data;
end

