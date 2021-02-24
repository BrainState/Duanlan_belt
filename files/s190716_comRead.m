
% jiangjian@ion.ac.cn
% 2019-07-16

% read data from serial port

% list all serial ports
sp=instrhwinfo('serial');
port_names=sp.AvailableSerialPorts;

% global s fid;
s=serial(port_names{3});
s.BytesAvailableFcnMode='byte';  % ��������; byte/terminator
s.InputBufferSize=115200;
s.OutputBufferSize=4096;
% s.BytesAvailableFcnCount=100;
% s.ReadAsyncMode='continuous';
% s.Terminator='CR';
% s.ByteOrder = 'bigEndian';

% s.BytesAvailableFcn=@ReceiveCallback;

fid=fopen('serial_data.txt','w+'); % 'a+'��д��ʽ�򿪣����ļ�ָ��ָ���ļ�ĩβ������ļ����������Դ���֮

fopen(s);                  %�򿪴���
% fprintf(s,'*IDN?')
% out = fscanf(s)



for i=1:10
    tic
    out=fread(s,100);   %һ�ζ���10���ַ�
    fprintf('%d: length-%d; ',i,length(out));
%     fprintf('%X ',length(out),out);        %һ���ַ�ռ��λ���,%c�ַ���%d���� 
    fprintf('\n');
    toc
%     fprintf(fid,'%X ',out);            % д���ļ���
%     fprintf(fid,'\n');
end

fclose(fid);
fclose(s);
