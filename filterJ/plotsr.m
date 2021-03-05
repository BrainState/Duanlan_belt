function varargout = plotsr(data,sr)
%PLOTSR 此处显示有关此函数的摘要
%   此处显示详细说明
x=linspace(0,length(data)/sr,length(data));
plot(x,data);
xlabel('time (s)')
if nargout>0
    varargout{1}=x;
end
end

