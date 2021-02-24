
% jiangjian@ion.ac.cn
% 2019-07-16

% read data from serial port

% list all serial ports
sp=instrhwinfo('serial');
port_names=sp.AvailableSerialPorts;

% global s fid;
s=serial(port_names{3});
s.BytesAvailableFcnMode='byte';  % 串口设置; byte/terminator
s.InputBufferSize=115200;
s.OutputBufferSize=4096;
% s.BytesAvailableFcnCount=100;
% s.ReadAsyncMode='continuous';
% s.Terminator='CR';
% s.ByteOrder = 'bigEndian';

% s.BytesAvailableFcn=@ReceiveCallback;

fid=fopen('serial_data.txt','w+'); % 'a+'读写方式打开，将文件指针指向文件末尾。如果文件不存在则尝试创建之

fopen(s);                  %打开串口
% fprintf(s,'*IDN?')
% out = fscanf(s)



for i=1:10
    tic
    out=fread(s,100);   %一次读出10个字符
    fprintf('%d: length-%d; ',i,length(out));
%     fprintf('%X ',length(out),out);        %一个字符占三位输出,%c字符，%d整型 
    fprintf('\n');
    toc
%     fprintf(fid,'%X ',out);            % 写入文件中
%     fprintf(fid,'\n');
end

fclose(fid);
fclose(s);
