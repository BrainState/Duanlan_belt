%     NI_Initialize;
%     DIO = daq.createSession('ni');%%%%%%%%%%%%% DIO output
%     addDigitalChannel(DIO,'J1', 'Port0/Line0:3', 'OutputOnly')% DIO Channel Port0/Line0:1 ;for trigger first
%     outputSingleScan(DIO,[0 0 0 0])% Set to 0  
    
    AI = daq.createSession('ni');%%%%%%%%%%%%%% Analog input
    ch = addAnalogInputChannel(AI,'J1', 0:7, 'Voltage');% Analog input Channel [0:3];For frame time and stimulus trigger
    for i=1:8
       ch(1, i).TerminalConfig ='SingleEnded';   
    end 
    
    AI.Rate = 2000;% Analog input sample rate
    AI.DurationInSeconds = 3600*3;% Analog sample time
    
    global data fid fid_t fid_header;
    global block_num;
    block_num=0;
    fid=fopen('data.bin','w');
    fid_t=fopen('time.bin','w');
    fid_header=fopen('header.tag','w');
    fprintf(fid_header,'<sample_rate>%d</sample_rate>\r\n',AI.Rate) ;
    fprintf(fid_header,'<channel>%d</channel>\r\n',length(ch)) ;
    fprintf(fid_header,'<totle_time>%.2f</totle_time>\r\n',AI.DurationInSeconds) ;
    fprintf(fid_header,'<start_time>%s</start_time>\r\n',datestr(datetime(),'yyyy-mm-dd HH:MM:ss.FFF')) ;
    
    figure
    lh = addlistener(AI,'DataAvailable', @plotData);
    startBackground(AI);% Start NI
    
    pause(AI.DurationInSeconds+5);
    
%     delete(DIO);
    delete(lh);
    delete(AI);
    fprintf(fid_header,'<end_time>%s</end_time>\r\n',datestr(datetime(),'yyyy-mm-dd HH:MM:ss.FFF')) ;
    fprintf(fid_header,'<total_blocks>%d</total_blocks>\r\n',block_num) ;
    
    fclose(fid);
    fclose(fid_t);
    fclose(fid_header);
    
%% data analysis
figure,plot(data);

t=3600*5;chn=8;
fid2=fopen('D:\Codes\MatlabLib\files\NI/data1/data.bin');
d=fread(fid2,t*10*100*chn,'double');
fclose(fid2);

figure,plot(d)

d2=reshape(d,[100,chn,t*10]);
d2=permute(d2,[1,3,2]);
d2=reshape(d2,[100*10*t,chn]);
figure,plot(d2)
