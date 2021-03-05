function data = notch(data,sr,varargin)
% notch 50Hz and harmonic noise
% jiangjian@ion.ac.cn
% 2019-08-21
% input: data,sr,[notch_width_single_side],[incudeHarmonic]

[r,c]=size(data);
if r>1 && c>1
    error("The size of the data must be one dimension");
end
notchHz=50; 

notch_width=2;
incudeHarmonic=0;
if nargin>2
    notch_width=varargin{1};
end

if nargin>3
    incudeHarmonic=varargin{2};
end

if nargin>4
    notchHz=varargin{3};
end
    
n=floor(sr/2/notchHz);
for i=1:n-1
    [b,a]=butter(2,([-1,1]*notch_width+notchHz*i)/(sr/2),'stop');
    data=filter(b,a,data);
end

[b,a]=butter(2,(-1*notch_width+notchHz*n)/(sr/2),'low');
data=filter(b,a,data);

end

