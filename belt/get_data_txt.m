function  [dt_adc,adc_data,dt_xl,xl_data,dt_ba,ba_data,info] = get_data_txt(fileName)
% update:
% 2021-01-13, version=[4 80];
xl_data = [];
adc_data = [];
ba_data = [];
dt_xl = [];
dt_adc = [];
dt_ba = [];
info=struct();

if_exist = exist(fileName,'file');
if(if_exist == 0 || java.io.File(fileName).length==0)
    return;
end


%% header read
% version,datetime, sample rate
fileID = fopen(fileName);
head= fread(fileID,2);
if head(1)==165 && head(2)==165
    info.setup='A5A5';
end

len= fread(fileID,1,'int16');
info.packet_len = 250;

fseek(fileID, 4, 'cof');
dt= fread(fileID,1,'uint32');%9-12
dt0=get_dt(dt);
info.st=dt0;
info.version=fread(fileID,2);
info.sr= fread(fileID,1,'int16'); %15-16 EEG sample rate
info.sr_BMI= fread(fileID,1,'int16'); % 17-18 BMI sample rate
info.sr_battery= fread(fileID,1,'int16'); % 19-20 battery sample rate
% 2020-09-10
BMI_len=6;
if sum(info.version==[0,0]')==2
    info.sr_BMI=1.5;
    info.sr_battery=1.5;
    BMI_len=6;
elseif info.version(1)==4 && info.version(2)==71
    BMI_len=6;
    info.sr_BMI=16.5;
elseif info.version(1)==4 && info.version(2)>=72
    BMI_len=120;
end
packet_len = info.packet_len;
info.company= fread(fileID,16,'char'); % 23-38, DuanLanNaoZhi
info.mac= fread(fileID,6,'uint8'); % 39-44 MAC

fclose(fileID);


%% data read
fileID = fopen(fileName);
A = fread(fileID);
fclose(fileID);

if(rem(size(A,1),2)~=0)
    disp(fileName);
    disp(size(A,1));
    disp('file error---Sleep');
    return;
end

if(rem(size(A,1),packet_len)~=0)
    disp(fileName);
    disp(size(A,1));
    disp('file error---Sleep');
    return;
end

packet_num = length(A)/packet_len;

B = reshape(A,2,size(A,1)/2);
C = B';
D = C;
D(:,1)=C(:,2);
D(:,2)=C(:,1);

compressed_group_num = 80;
compressed_data_len = 3;

flag_index = 6;
flag_ba = 1;
flag_xl = 2;
flag_adc = 5;
dt_xl_tmp = [];
dt_adc_tmp = [];
tmp_xl = [];
tmp_adc = [];
if_use_compressed_xl=0;
if_use_BMI270 = 1;
if_use_dma = 1;
for jk = 1:packet_num
    tmp = A((jk-1)*packet_len+1:jk*packet_len);
    tmp2 = tmp(9:10);
    dt_16b = typecast(uint8(tmp2), 'UINT16');
    dt_tmp = get_dt_16b(dt_16b);
    
    if(tmp(flag_index) == flag_xl) %xl data
        dt_xl_tmp = [dt_xl_tmp;dt_tmp];
        tmp3 = tmp(11:end);
        tmp4 = [];
        
        if(if_use_BMI270)
            tmp3_1= reshape(tmp3,2,length(tmp3)/2);
            for jj = 1:size(tmp3_1,2)
                tmp3_2(jj,:) = typecast((uint8(tmp3_1(:,jj))), 'INT16');
            end
            tmp_xl = [tmp_xl;tmp3_2(1:BMI_len,:)];
        end
        
        if (if_use_compressed_xl==1)
            for jj = 1:compressed_group_num
                tmp33 = tmp3((jj-1)*compressed_data_len+1:jj*compressed_data_len);
                tmp301(1) = uint8(tmp33(1));
                tmp301(3) = uint8(tmp33(3));
                
                tmp331 = tmp33(2);
                if(bitand(tmp331,8)==8)
                    tmp301(2) = bitor(bitand(tmp331,15),240);
                else
                    tmp301(2) = bitand(tmp331,15);
                end
                
                tmp3312 = bitshift(tmp331,-4);
                if(bitand(tmp3312,8)==8)
                    tmp301(4) = bitor(bitand(tmp3312,15),240);
                else
                    tmp301(4) = bitand(tmp3312,15);
                end
                
                
                tmp31= reshape(tmp301,2,2);
                tmp311 = uint8(tmp31(:,1));
                tmp312 = uint8(tmp31(:,2));
                tmp321 = typecast(tmp311, 'INT16');
                tmp322 = typecast(tmp312, 'INT16');
                
                tmp4 =  [tmp4;tmp321;tmp322];
                
            end
            tmp_xl = [tmp_xl;tmp4];
        end
    end
    if(tmp(flag_index) == flag_adc) %adc data
        dt_adc_tmp = [dt_adc_tmp;dt_tmp];
        tmp3 = tmp(11:end);
        tmp4 = [];
        
        tmp_1 = reshape(tmp3,2,size(tmp3,1)/2);
        tmp_1=tmp_1';
        tmp_2=tmp_1;
        if if_use_dma == 1
            
        else            
            tmp_2(:,1)=tmp_1(:,2);
            tmp_2(:,2)=tmp_1(:,1);
        end
        
        for kk = 1:size(tmp_2,1)
            if info.version(1)==4 && info.version(2)<80
                tmp4(kk,1) = typecast(uint8(tmp_2(kk,:)), 'INT16');   
            else 
                tmp4(kk,1) = typecast(uint8(tmp_2(kk,:)), 'UINT16');   
            end
                     
        end
        tmp_adc = [tmp_adc;tmp4];
    end
    
end
if(if_use_BMI270)
    z = reshape(tmp_xl,6,size(tmp_xl,1)/6);
end
if (if_use_compressed_xl==1)
    z = reshape(tmp_xl,4,size(tmp_xl,1)/4);
    
end

xl_data = z';
adc_data = tmp_adc;
dt_xl = dt_xl_tmp;
dt_adc = dt_adc_tmp;

end


function [ dt ] = get_dt( dt_32b )

yy = bitshift(dt_32b,-25);

f = bitshift(dt_32b,-21);
MM = bitand(f,15);

g = bitshift(dt_32b,-16);
dd = bitand(g,31);

h = bitshift(dt_32b,-11);
hh = bitand(h,31);

i = bitshift(dt_32b,-5);
mm = bitand(i,63);

j = bitand(dt_32b,31);
ss = bitshift(j,1);

dt = zeros(1,6);
dt(1) = yy+2000;
dt(2) = MM;
dt(3) = dd;
dt(4) = hh;
dt(5) = mm;
dt(6) = ss;
end

function [ dt ] = get_dt_16b( dt_32b )

h = bitshift(dt_32b,-11);
hh = bitand(h,31);
i = bitshift(dt_32b,-5);
ii = bitand(i,63);
j = bitand(dt_32b,31);
jj = bitshift(j,1);

dt = zeros(1,6);
dt(1) =0;
dt(2) = 0;
dt(3) = 0;
dt(4) = hh;
dt(5) = ii;
dt(6) = jj;
end
