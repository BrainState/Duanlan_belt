function [ dt_adc,data_adc,dt_xl,data_xl,dt_ba,data_ba, clock_hour,infos] = step1_fun( filePath_h1 )



expected_file_num = 100;

%%
mice_name_filter = 'A_';

dt_adc = [];
data_adc = [];
dt_xl = [];
data_xl = [];
dt_ba = [];
data_ba = [];
clock_hour = [];
infos={};

for h1 = 1:expected_file_num
    fileName = [mice_name_filter,num2str(h1-1),'.txt'];
    filePathName = [filePath_h1,'\',fileName];
    
    [dt_adc_tmp,data_adc_tmp,dt_xl_tmp,data_xl_tmp,dt_ba_tmp,data_ba_tmp,info] = get_data_txt(filePathName);
    
    if(~isempty(dt_adc_tmp))
        dt_adc =[ dt_adc;dt_adc_tmp];
        data_adc =[ data_adc;data_adc_tmp];
        dt_xl =[ dt_xl;dt_xl_tmp];
        data_xl = [data_xl;data_xl_tmp];
        dt_ba = [dt_ba;dt_ba_tmp];
        data_ba = [data_ba;data_ba_tmp];        
        fileStruct = dir([filePath_h1 '\*' fileName]);
        datevec_tmp = datevec(fileStruct.date);
        infos{end+1}=info;        
    end
end


data_adc = double(data_adc);
data_xl = double(data_xl);
% 1
end

