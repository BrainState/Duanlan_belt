function varargout = plotsr(data,sr)
%PLOTSR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x=linspace(0,length(data)/sr,length(data));
plot(x,data);
xlabel('time (s)')
if nargout>0
    varargout{1}=x;
end
end

