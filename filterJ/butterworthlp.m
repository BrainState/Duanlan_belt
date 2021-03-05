function c=butterworthlp(data,fh,SampleRate)
%%butterworth low pass filter
%%data, inputdata
%%fh, absolute low pass cut off frequency
%%SampleRate, sample rate of data

add_on=100;
tlength=length(data);
new_length=1;
while(new_length<=tlength)
    new_length=2*new_length;
end
add_on=floor((new_length-tlength)/2);
front=zeros(add_on,1)+data(1);
if (mod(tlength,2)==1)
    front=[front(1);front];
end
last=length(data);
back=zeros(add_on,1)+data(last);
data=[front',data',back']';
n=length(data);
yF=zeros(n,1);
for(i=1:n)
    yF(i)=i-1;
end
if (mod(n,2)==1)
    yF((n+1)/2:n)=-yF((n+1)/2+1:-1:2);
else
    yF(n/2+1:n)=-yF(n/2+1:-1:2);
end
%%SampleRate=1629;
freq=2*fh/SampleRate;
w=2*yF/(freq*n);
yF=1./(1+(w.^10));
data=real(ifft((fft(data).*(yF))));
c=data(add_on+1:add_on+last);
