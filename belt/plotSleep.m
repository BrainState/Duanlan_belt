function plotSleep(filePath_h1)
% 2020-07-01 (create time)
% zxcheng123@ion.ac.cn
% function: read, save and plot Sleep data
% see also: 
% update:
% 2020-07-21,save sr=500. jiangjian@ion.ac.cn

matName = ['data_' filePath_h1(end-7:end) '.mat'];
figName = ['fig_' filePath_h1(end-7:end) '.ps'];

tic
[m] = read_save_sleep(filePath_h1,filePath_h1,matName);
toc

eegData = m.eeg;
motionData = m.motion;



if(~isempty(motionData))
    % plot acceleration information
figure('Name','Motion','Position',[450,50,600,600]);
subplot(2,2,1)
plotAcceleration(motionData,'线加速度')
subplot(2,2,2)
plotAcceleration(fliplr(motionData),'角速度')
subplot(2,2,3)
plotAccDynamics(motionData,1,600) % calculated over 10 minutes
subplot(2,2,4)
plotAccDynamics(fliplr(motionData),1,600) % calculated over 10 minutes
print(gcf,'-dpsc','-bestfit','-append',[filePath_h1 '\' figName]); % print to figure
end

% plotAccDynamics(motionData,1,300)
% keyboard
%% plot the EEG data
figure('Name', 'RawEEG','Position',[150,350,600,600]);
subplot(2,1,1)
plot(eegData);
set(gca,'xlim',[0 size(eegData,1)])
title('RawEEG')
%
eegData=eegData-mean(eegData);% subtract the baseline
eegData(abs(eegData)>2000)=0;% remove the large noise in the data
sr=500;
selectEEG=eegData(1*sr+1:floor(length(eegData)/sr)*sr);
% selectEEG=eegData(1*sr+1:2*3600*sr);

subplot(2,1,2)
plotJ(selectEEG,sr) % t is the signal, sr is used to convert the data into a proper unit
title('RawEEG-baseline')
print(gcf,'-dpsc','-bestfit','-append',[filePath_h1 '\' figName]); % print to figure

fft2spectra(selectEEG,sr,10) % t is the signal, sr is the sample rate, 10 is the duration of the window
                            %return two figures: (1) absolute spectrogram, (2) normalized spectrogram  
title('Spectrogram')
print(gcf,'-dpsc','-bestfit','-append',[filePath_h1 '\' figName]); % print to figure

[p,x]=frequencyShow(selectEEG,sr);
figure('Name','Power from FFT','Position',[750,350,500,300]),plot(x,p)
print(gcf,'-dpsc','-bestfit','-append',[filePath_h1 '\' figName]); % print to figure
% keyboard

end
