function x = epochdata(record,fs,h,prestim,poststim,flipref,samplespertrial)

% global x;

% load(Name_Input)
% % trigger
% record=[zeros(fs*5,80);record];
% record(record(:,end)<.5,end)=0;
% record(record(:,end)>.5,end)=1;
% trig=diff(record(:,end));
% pt=find(trig>0.9)-1;

% record(:,257)=[];

% 滤波
record = filtfilt(h,1,record);
% for ch = 1:256
%     record2(:,ch) = butterworthhp(record(:,ch),0.8,50);
% end
% record=record([[length(h)-1]/2+1]:end,:);

% 去眼电
eyem = [record(:,18)-record(:,238),record(:,252)-record(:,226)];
record = record(:,1:256)-((record(:,1:256)'/eyem')*eyem')';

% kurtosis特别大的通道，去掉一些outlier
spikech = find(kurtosis(record)>10);  %峰度系数大于10的点
for ch = spikech
    x = record(:,ch);
    x = x-median(x);
    y = abs(x);
    x(x>6*median(y)) = 6*median(y);
    x(x<-6*median(y)) = -6*median(y);
    record(:,ch) = x;
end
clear x y

% 去除通道
record = double(record(:,1:256));
mpower = mean(abs(record(:,1:256)));
badch = [];
if kurtosis(mpower)>10
    badch = mpower>6*median(mpower);
end
record(:,badch) = 0;
record=demean(record);


% reference to all ch
% record = record(:,1:256)-mean(record(:,1:256),2)*ones(1,256);

for tv = 1:size(record,1)/samplespertrial  %要修改
    x(:,:,tv) = record((tv-1)*16*fs+1:tv*16*fs,:);
end

x = single(x);
szx = size(x,1);
x = unfold(x);

for ch=1:256
    xx = x(:,ch);
    xx = xx-median(xx);
    y = abs(xx);
    xx(xx>6*median(y)) = 6*median(y);
    xx(xx<-6*median(y)) = -6*median(y);
    x(:,ch) = xx;
end


x = fold(x,szx);

% save(Name_Output,'x','h');
