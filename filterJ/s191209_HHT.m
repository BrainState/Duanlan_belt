
% jiangjian@ion.ac.cn
% 2019-12-09
% target: how to use the HHT to analyze data?
% important task!
% algorithm:sum(energy of all counts)
% usages: 1, schiophrenia sleep; 2, monkey sleep

%% plot HHT spectrogram
% fp='\\10.10.44.152\eeg\Schizophrenia_GuangJi_longTerm\D342WangYiFei\TRACKIT.EDF';
% fp='\\10.10.44.152\eeg\Schizophrenia_GuangJi_longTerm\D351WangQin\TRACKIT.EDF';

clear,clc
db1=nodeCreate('dataInfo');
db1.queryAllCols({'dataLabel'},{'schizophrenia_guangji'});
ds=dataInfoFormat(db1.getRecordsJsonArray());
isvisible='off';
dur=30; %s
ch=22;% Cz
isvisible='off';
for pind=20:length(ds.data)
    p1=ds.data(pind);
    disp(p1.name)
    header=ft_read_header(p1.path);
    header.st=datetime(header.orig.T0);
    data=ft_read_data(p1.path);
    sr=header.Fs;
    
    savep=['H:\eeg_figures\Guangji_schizophrenia\',p1.name,'\HHT_Ch_',sprintf('%.2d',ch),'_',header.label{ch}];
    d=data(ch,:); % Cz
    hht2spectra(d,sr,dur,header.st,savep);
end


%% replot
clear,clc
db1=nodeCreate('dataInfo');
db1.queryAllCols({'dataLabel'},{'schizophrenia_guangji'});
ds=dataInfoFormat(db1.getRecordsJsonArray());
isvisible='off';
dur=30; %s
ch=22;% Cz
isvisible='off';
for pind=19 %20:length(ds.data)
    p1=ds.data(pind);
    disp(p1.name)
    header=ft_read_header(p1.path);
    header.st=datetime(header.orig.T0);
    data=ft_read_data(p1.path);
    sr=header.Fs;
    
    savep=['H:\eeg_figures\Guangji_schizophrenia\',p1.name,'_notch\HHT_Ch_',sprintf('%.2d',ch),'_',header.label{ch}];
    d=data(ch,:); % Cz
    d=notch(d,sr);
    hht2spectra(d,sr,dur,header.st,savep);
end

%% 
% Li Fan Cheng
d=data(22,:);

x=linspace(0,length(d)/sr/3600,length(d));
figure,plot(x,d)

uiopen('H:\eeg_figures\Guangji_schizophrenia\Li_Fan_Cheng_notch\HHT_Ch_22_Cz-Ref_imfs_abs.fig',1)
set(gcf,'visible','on')
caxis([0,5])
printJ(which('s191209_HHT'),gcf,'H:\eeg_figures\Guangji_schizophrenia\Li_Fan_Cheng_notch\HHT_Ch_22_Cz-Ref_imfs_abs')

%% test
sr=200;
x=exp(1i*(0:0.1:20));
angs=angle(x);
% omega=2*pi./diff(angs);
dan=diff(angs);
inds=find(abs(dan)>pi);
dan(inds)=dan(inds-1);
F=dan*sr/(2*pi);

figure,plot(real(x))
hold on
% plot(angs)
plot(F)
hold off

