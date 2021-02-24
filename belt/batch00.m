function [mat_pathway,fp_save,sleep_para] = batch00(fp_raw,mat_name,folder_save)
% function: batch process of the sleep data
% jiangjian@ion.ac.cn
% 2020-09-10
% input:
% fp_raw - file or folder pathway
% mat_name - name for the saveed mat file
% folder_save - folder where save data and figures

% fp_save=['\\10.10.44.152\public\006_Figures\03_Test200908\',mat_name,'\']; 
fp_save=[folder_save,'\',mat_name,'\'];
if ~isfolder(fp_save)
    mkdir(fp_save)
end
fp_mat=[fp_raw,'\' mat_name,'.mat'];
if exist(fp_mat,'file')
    load(fp_mat)
    mat_pathway=fp_mat;
else
    m = read_save_sleep(fp_raw,[mat_name,'.mat']);
    load(m.savep)
    mat_pathway=m.savep;
end



%% EEG
info=infos{1};sr=info.sr;
eeg3=eeg_preprocess(eeg,sr);

%% spectrogram
savep=[fp_save,'spectrogram'];
fft2spectra(eeg3,500,30,datetime(info.st),savep)

savep=[fp_save,'spectrogram_denoise'];
[eeg_,cr,pkss]=spectra_denoise(eeg3,infos,savep);

%% eeg envelope and motion
% inut: pkss, motion
pkss2=[];
for i=1:30:length(pkss)-30
    pkss2(end+1)=median(pkss(i:i+30));
end
pkss2(pkss2>20)=0; % for belt, remove noise

mg=sqrt(sum(motion(:,4:6)'.^2)); % abs
mg2=reshape(mg,10,length(mg)/10);
mg2=max(mg2);
x1=linspace(0,length(mg2),length(pkss2));
x2=linspace(0,length(mg2),length(mg2));

mg3=mg2(1:30*length(pkss2));
mg3=reshape(mg3,[30,length(pkss2)]);
mg3=sum(mg3);

figureJ
set(gcf,'visible','off')
hold on
plot(x1,smooth(pkss2),'lineWidth',3,'color','k')
ylabel('SWS')

yyaxis right
mg3=mg2;
mg3(mg3>1.2)=1.2;
plot(x2,mg3,'lineWidth',1)
ylabel('Motion')
set(gca,'ydir','reverse')
hold off
axis tight

st=datetime(info.st);
tt=length(pkss2)*30/3600;
header=struct('dur',1,'st',st);
x0=x1(1);
[xtt,xt,xlabel1]=getXTick(header,tt,x0);
set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)
xlabel(xlabel1);


xlabel('Time (h)')
savep=[fp_save,'eeg_envelope_motion'];
printJ(which('batch00'),gcf,savep)

sleep_para=struct();
%% position
savep=[fp_save,'position'];
try
    [position_new,angles]=acc2position(mat_pathway,savep);
    % get lie down time
    time_onbed=sum(position_new<=1)/info.sr_BMI/3600;
    sleep_para.time_onbed=sprintf('%.2f',time_onbed);    
    %sleep_onset=
catch
end

close all

end

