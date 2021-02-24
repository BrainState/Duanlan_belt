function plotData(src,event)
persistent tempData;
global data fid fid_t fid_header;
global block_num;
if(isempty(tempData))
    tempData = [];
end

fwrite(fid,event.Data,'double') ;
fwrite(fid_t,event.TimeStamps,'double') ;
% fprintf(fid_header,'%d, %d\r\n',size(event.Data,1),size(event.Data,2)) ;
block_num=block_num+1;
tempData = [tempData;event.Data];
tempData=tempData(max(end-1000*10+1,1):end,:);
data = tempData;
for ch=1:8
    subplot(8,1,ch)
    plot(data(:,ch))
end

end