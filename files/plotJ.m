function varargout = plotJ(d,sr,varargin)
% jiangjian@ion.ac.cn
% 2019-12-18
% plot time serial data
% code2db('plotJ')
% update:
% 2020-04-02, add st for xtick; add xlabel

st=0;
XL='Time (s)';
if nargin>2
    st=varargin{1};
end
if nargin>3
    XL=varargin{2};
end


if size(d,2)<size(d,1)
    d=d';
end
x=linspace(0,size(d,2)/sr,size(d,2));
hold on
% hs=plot(x,d,'ok','markerFaceColor','k');
hs=plot(x,d);
xlim([x(1),x(end)])
hold off

xlabel(XL)

if strcmp(class(st),'datetime')==1
    tt=size(d,2)/sr;
    [xtt,xt,xlabel1]=getXTick(struct('st',st,'dur',3600),tt,x(1));
    set(gca,'xtick',xtt)
    set(gca,'xtickLabel',xt)
end

if nargout>=1
    varargout{1}=hs;
end
if nargout>=2
    varargout{2}=x;
end

end

