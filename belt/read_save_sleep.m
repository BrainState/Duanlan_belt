function [m] = read_save_sleep(fileFolder,saveName)
%  [m] = read_save_sleep(fileFolder,saveFolder,saveName)
%  read all the files
%  save the data to a matfile 
%  czx 2020-07-13
% input: 
% output:
% see also: 
% update
% 2020-09-08: add info read; Jiangjian@ion.ac.cn
% fileFolder='\\10.10.44.152\public\005_Data\portable_data\03_Test200908\JiangJian-200911';
% 2020-12-08,can read a folder with multipl folders or files

files=java.io.File(fileFolder).listFiles();
hasFolder=0;
for i=1:files.length
    if files(i).isDirectory()
        hasFolder=1;
        break;
    end
end

if hasFolder==1
    saveFolder=fileFolder;
else   
    saveFolder=fileparts(fileFolder);
    files=java.io.File(fileFolder); % just read this file
end


dt_adc = [];%time for ADC data
data_adc = [];% analog to digital convertion
dt_xl = [];% time for acceleration data, 
data_xl = [];% acceleration data
dt_ba = []; % time for the battery info
data_ba = [];% battery info
clock_hour = [];
infos={};

if size(files,1)==0 && ~isempty(files)
    jj=1;
    fp = char(files(jj));
    [~,fn]=fileparts(fp);
    fprintf('Files %.2d, %s\n',jj,fn);
    [ dt_adc_tmp,data_adc_tmp,dt_xl_tmp,data_xl_tmp,dt_ba_tmp,data_ba_tmp,clock_hour_tmp,infos_] = step1_fun(fp);
    if(~isempty(dt_adc_tmp))
        dt_adc =[ dt_adc;dt_adc_tmp];
        data_adc =[ data_adc;data_adc_tmp];%
        dt_xl =[ dt_xl;dt_xl_tmp];
        data_xl = [data_xl;data_xl_tmp];
        dt_ba = [dt_ba;dt_ba_tmp];
        data_ba = [data_ba;data_ba_tmp];
        clock_hour = [clock_hour;clock_hour_tmp];
        infos = [infos,infos_];
    end
else
    for jj = 1:size(files,1)
        if ~files(jj).isDirectory()
            continue;
        end
        fp = char(files(jj));
        [~,fn]=fileparts(fp);
        fprintf('Files %.2d, %s\n',jj,fn);
        [ dt_adc_tmp,data_adc_tmp,dt_xl_tmp,data_xl_tmp,dt_ba_tmp,data_ba_tmp,clock_hour_tmp,infos_] = step1_fun(fp);
        if(~isempty(dt_adc_tmp))
            dt_adc =[ dt_adc;dt_adc_tmp];
            data_adc =[ data_adc;data_adc_tmp];%
            dt_xl =[ dt_xl;dt_xl_tmp];
            data_xl = [data_xl;data_xl_tmp];
            dt_ba = [dt_ba;dt_ba_tmp];
            data_ba = [data_ba;data_ba_tmp];
            clock_hour = [clock_hour;clock_hour_tmp];
            infos = [infos,infos_];
        end
    end
    
end



%% save the data
savep=[saveFolder,'\' saveName];
m = matfile(savep,'Writable',true);
m.savep=savep;
m.eeg = data_adc*0.4; % convert to uV
m.motion = data_xl/4096; % convert to 1*g
m.battery = data_ba;
m.eegTime = dt_adc;
m.motionTime = dt_xl;
m.batteryTime = dt_ba;
m.infos=infos;



