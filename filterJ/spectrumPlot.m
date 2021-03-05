function varargout = spectrumPlot( a,varargin )
%SPECTRUMPLOT Summary of this function goes here
%   Detailed explanation goes here
if nargin<2
    sr=1000;
else
    sr=varargin{1};    
end
window=100;
if(window>length(a)) || length(a)/window<100
    window=length(a)/100;
end
[S,F,T,P]=spectrogram(a,256,128,[],sr);

if max(F)>1000
    F=F/1000;
end

if(nargout<1)
   %surf(T,F,pow2db(P),'edgeColor','none');
   imagesc(T,F,pow2db(P));
else
    varargout{1}=S;
    varargout{2}=F;
    varargout{3}=T;
    varargout{4}=pow2db(P);
end

end

