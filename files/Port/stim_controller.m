
% jiangjian@ion.ac.cn
% 2021-01-16

% 使用STM32DAQ板进行Port输出的示例


%%
device_port='COM9';

hex_stim_start='A55A00060005'; % start stim
hex_stim_end=  'A55A00060006'; % end stim
hex_ADC_start= 'A55A00060008'; % start ADC
hex_ADC_end=   'A55A00060009'; % close ADC
obj=serial(device_port,'baudrate',115200,'parity','none','databits',8,'stopbits',1);%初始化串口
fopen(obj); %打开串口对象

D = sscanf(hex_ADC_start, '%2x'); %将字符串转换成十六进制数据
fwrite(obj,D,'uint8') %对定义的串口s发送该数据

seq=[];
d1=[];
d2=[];
stim=[];
figure
while 1>0
    TMP1=fread(obj,15,'uint8');%从串口读取3字节数据，后2个即是16bit温度数据
    if TMP1(1)~=244 || TMP1(2)~=152
        continue;
    end
    %TMP2=TMP1./256+mod(TMP1,256)*256;    
    TMP2=typecast(uint8(TMP1(14:-1:1)),'uint16');
    stim=str2double(dec2bin(TMP1(end)));
    fprintf('%g, %g, %g, %g, %g, %g, %g, %g\n',[TMP2(end:-1:1);stim])
    seq(end+1:end+2)=TMP2([6,3]);
%     d1(end+1:end+2)=TMP2([5,2]);
%     d2(end+1:end+2)=TMP2([4,1]);
%     yyaxis left
%     x=linspace(0,length(d1)/100,length(d1));
%     if length(d1)>10000
%         plot(x(end-9999:end),d1(end-9999:end))
%     else
%         plot(x,d1)
%     end    
%     yyaxis right
%     x=linspace(0,length(stim)/50,length(stim));
%     if length(stim)>5000
%         plot(x(end-4999:end),stim(end-4999:end))
%     else
%         plot(x,stim)
%     end    
    %pause(0.001)
end

hex='A55A00060006';
D = sscanf(hex, '%2x'); %将字符串转换成十六进制数据
fwrite(obj,D,'uint8') %对定义的串口s发送该数据

fclose(obj);%关闭串口设备对象
delete(obj);%删除内存中的串口设备对象
clear obj

tt=diff(seq);
figure,plot(tt(1:4500))

figure,plot(tt)

figure,plot(seq)

