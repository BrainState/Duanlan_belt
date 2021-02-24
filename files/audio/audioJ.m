classdef audioJ<handle
    %AUDIOJ Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % property of loading a audio file
        filePath=[];
        audio;
        fs;
    end
    
    methods
        function this=audioJ()
        end
        function read(this,varargin)
            if nargin>1
                this.filePath=varargin{1};
            end
            if isempty(this.filePath)
                fps=uipickfiles('FilterSpec','.wav','Prompt','Load Audio files');
                this.filePath=fps{1};
            end
            [this.audio,this.fs]=audioread(this.filePath);
        end
        function playJ(this)
            player=audioplayer(this.audio,this.fs);
            play(player);
        end
        function fftShow(this)
            
        end
        function spectrumJ(this)
            [pxx,~] = pwelch(this.audio(:,1),500,300,500,this.fs);
            %pow2db: convert power to decibels(dB): 10*log10(b)
            plot(pow2db(pxx))
            xlabel('Hz');
            ylabel('dB');
            title('power spectrum');
        end
        
        function energyWave(this)
            sr=100;
            x=this.audio(1:this.fs/sr:end);
            x(x<0)=0;
            
            % sr=1000;
            f1=fft(x);
            L=length(x);
            f = 1:L/2;
            f2=f1.*conj(f1);%abs(f1);
            P=f2(f);
            x2=f/L*sr; %计算频率的关键点
            x2=x2-x2(1);
            
            figure,
            %             subplot(211),
            plot(x2,P,'lineWidth',3)
            xlabel('Hz');
            ylabel('dB');
            title('power spectrum');
            xlim([0.5,10]);
            
            
%             %% cohorence
%             fps=uipickfiles();
%             for i=1:length(fps)
%                 [x,~]=audioread(fps{i});
%                 x=x(1:this.fs/sr:end);
%                 [r,~]=size(x);
%                 d=500;
%                 xx=reshape(x,d,r/d);
%                 
%                 A=angle(fft(xx));
%                 rr(:,i)=mean(cos(A),2).^2+mean(sin(A),2).^2;
%             end
%             
%             f=1:size(rr,1);f=f-1;f=sr*f/size(rr,1);
%             
%             
%             subplot(212)
%             plot(f,mean(rr,2),'-rx','linewidth',3,'color',[1,0,0])
%             xlim([0.5 10])
%             title('Phase Coherence')
%             xlabel('Hz');
%             ylabel('Coherence Index');
%             
%             
            set(findall(gcf,'-property','FontSize'),'FontSize',28); % all font size
            
            
        end
        
    end
    
    methods (Static)
        %*************************************************************************
        function X=getFrames(audio)
            wlen=200; inc=80; % 帧长、帧移
            audio=audio-mean(audio);
            win=hanning(wlen);
            X=enframe(audio,win,inc);
        end
        function [czr_num,e3]=czr(X)         
            % input: frames
            X2=sign(X);
            
            xx=X2(:,1:end-1).*X2(:,2:end);
            xx=xx>0;
            
            czr_num=sum(xx,2);
            e3=sum(X.^2,2);
        end
        function audio=addMarker(audio,voiceseg)
            fs=44100;
            a1=audioJ.audioG(100,50,fs)*0.1;
            for i=1:length(voiceseg)
                v=voiceseg(i);
                %disp(i)
                d=a1(1:v.duration*80);
                audio((v.begin-1)*80+1:v.end*80)=audio((v.begin-1)*80+1:v.end*80)+d';
            end
            
        end
        
        %***************************************************************************
        function [y,Fs,y2]=audioShow(fp2)
            
            javaaddpath('E:\Codes\java\jar\audio.jar')
            import audio.*;
            
            [y,Fs]=audioread(fp2);
            x=linspace(0,length(y)/Fs,length(y));
            
            range=audioCut.getRangeByTwoThreshHold(y,0.005,0.003);
            figure,
            subplot(211),plot(x,y),title(['frequency:',num2str(Fs),'  (',fp2,')']);
            y2=y(range(1):range(2));
            subplot(212),plot(x(range(1):range(2)),y2),title(['length: ',num2str(x(range(2))-x(range(1))),'s']);
            
        end
        function lens=allAudioRange(fp,thresh)
            javaaddpath('E:\Codes\java\jar\audio.jar')
            import audio.*;
            
            files=java.io.File(fp).listFiles();
            lens=zeros(1,files.length);
            for i=1:files.length
                %
                try
                    [y,fs]=audioread(char(files(i)));
                    lens(i)=-1;
                catch
                    disp(char(files(i)))
                    continue;                    
                end
                
                range=audioCut.getRangeByTwoThreshHold(y,0.005,0.003);
                range=double(range);
                lens(i)=(range(2)-range(1))/fs;
                if lens(i)>thresh
                    %disp([num2str(i),': length=',num2str(lens(i)),'; [',num2str(range(1)/fs),',',num2str(range(2)/fs),']'])
                end
                %disp(i)
            end
        end
        %select words by its speed length
        function [lens,fp_select]=audioLenChoose(fp,len)
            % len=0.3
            w_num=329;
            lens=zeros(9,w_num);
            for i=1:9
                fp2=[fp,'w',num2str(i)];
                disp([num2str(i),' ***************************'])
                lens(i,:)=audioJ.allAudioRange(fp2,len);
            end
            
            lens2=lens-len;
            %lens2(lens2>0)=-100;
            [v,ind]=min(abs(lens2));
            
            fp_select=[fp,'select',num2str(len),'\'];
            fp2=java.io.File(fp_select);
            if ~fp2.exists()
                fp2.mkdir();
            end
            for i=1:w_num
                disp(i)
                fp2=[fp,'w',num2str(ind(i))];
                fs=java.io.File(fp2).listFiles();
                f=fs(i);
                copyfile(char(f),[fp_select,char(f.getName())]);
            end
        end
        %combine single words into a 
        function combine_n170220(fp,len)
            % len=0.3
            javaaddpath('E:\Codes\java\jar\audio.jar')
            import audio.*;
            files=java.io.File(fp).listFiles();
            audios=Audio.createArray(files.length);
            for i=1:files.length
                disp(i)
                [y,Fs]=audioread(char(files(i)));
                audios(i)=Audio(y,Fs);
                audios(i).setThreshold(0.005,0.003);
                audios(i).getDataWithLength(len);
            end
            
            fp_save=[char(java.io.File(fp).getParent()),'/','combine',num2str(len)];
            fp2=java.io.File(fp_save);
            if ~fp2.exists()
                fp2.mkdir();
            end
            
            for i=1:30
                y1=Audio.combine_wn(audios,80,1);
                y2=Audio.combine_w2(audios,80,2);
                y4=Audio.combine_wn(audios,80,4);
                audiowrite([fp_save,'/',sprintf('words_1_%.2d.wav',i)],y1,Fs);
                audiowrite([fp_save,'/',sprintf('words_2_%.2d.wav',i)],y2,Fs);
                audiowrite([fp_save,'/',sprintf('words_4_%.2d.wav',i)],y4,Fs);
            end
        end
        
        
        %**************************************************************************
        function audio=audioG(hzs,duration,sr)
            
            %hzs=[350,700,1400]; duration=1.5;
            %sr=30000;
           x1=linspace(0,duration,sr*duration);
           d1=0*x1;
           for i=1:length(hzs)
               d1=d1+sin(x1*hzs(i)*2*pi);
           end
            audio=d1/length(hzs);
        end % comp pure tone
        function basicAudio()
            % abandon
            modify=[linspace(0,1,30*7),ones(1,36*30),linspace(01,0,30*7)];
            a1=audioJ.audioG([350,700,1400],0.05);
            a=a1.*modify;
            b1=audioJ.audioG([500,1000,2000],0.05);
            b=b1.*modify;
            sr=16000;
            audiowrite('E:\audio\a_basic.wav',a,sr);
            audiowrite('E:\audio\b_basic.wav',b,sr);
            
            c=zeros(1,100*30);                       
            AA=[a,c,a,c,a,c,a,c,a];
            AB=[a,c,a,c,a,c,a,c,b];
            BB=[b,c,b,c,b,c,b,c,b];
            BA=[b,c,b,c,b,c,b,c,a];
            
            audiowrite('E:\audio\basic_AA.wav',AA,sr);
            audiowrite('E:\audio\basic_AB.wav',AB,sr);
            audiowrite('E:\audio\basic_BB.wav',BB,sr);
            audiowrite('E:\audio\basic_BA.wav',BA,sr);
        end % abandon
        function audio=mmn_basic()
            path='F:\xEEG\MMN_basic\';
            sr=16000;
            
            modify=[linspace(0,1,sr/1000*7),ones(1,36*sr/1000),linspace(01,0,sr/1000*7)];
            a1=audioJ.audioG([350,700,1400],0.05,sr);
            a=a1.*modify;
            b1=audioJ.audioG([500,1000,2000],0.05,sr);
            b=b1.*modify;
            c=zeros(1,100*sr/1000);           
            
            AA=[a,c,a,c,a,c,a,c,a];
            AB=[a,c,a,c,a,c,a,c,b];
            BB=[b,c,b,c,b,c,b,c,b];
            BA=[b,c,b,c,b,c,b,c,a];
            audio={AA,AB,'AA-AB'; BB,BA,'BB-BA';AB,AA,'AB-AA';BA,BB,'BA-BB'};
            audiowrite([path,'lg_aa.wav'],AA,sr);
            audiowrite([path,'lg_ab.wav'],AB,sr);
            audiowrite([path,'lg_bb.wav'],BB,sr);
            audiowrite([path,'lg_ba.wav'],BA,sr);
        end
        function audio=ababa_basic()
            path='F:\xEEG\MMN_basic\';
            sr=16000;
            
            modify=[linspace(0,1,sr/1000*7),ones(1,36*sr/1000),linspace(01,0,sr/1000*7)];
            a1=audioJ.audioG([350,700,1400],0.05,sr);
            a=a1.*modify;
            b1=audioJ.audioG([500,1000,2000],0.05,sr);
            b=b1.*modify;
            c=zeros(1,100*sr/1000);           
            
            AA=[a,c,b,c,a,c,b,c,a];
            AB=[a,c,b,c,a,c,b,c,b];
            BB=[b,c,a,c,b,c,a,c,b];
            BA=[b,c,a,c,b,c,a,c,a];
            audio={AA,AB,'AA-AB'; BB,BA,'BB-BA';AB,AA,'AB-AA';BA,BB,'BA-BB'};
            audiowrite([path,'ababa.wav'],AA,sr);
            audiowrite([path,'ababb.wav'],AB,sr);
            audiowrite([path,'babab.wav'],BB,sr);
            audiowrite([path,'babaa.wav'],BA,sr);
        end
        
        function mmnAudio()
            % A为350, 700 and 1400 Hz，声音B为500, 1000and 2000 Hz
            % 单个时长50ms（包括7ms升调，7ms降调）
            % 单个声音间隔150ms；声音组合之间的间隔在1350—1650ms之间变动（步进50ms）。
            
            audio=audioJ.mmn_basic();
            sr=16000;        
            
            %% 准备20*4个声音文件
            
            for jj=1:4
                a=audio{jj,1};
                for i=1:30
                    d=[];
                    % 1: 常见组合数目
                    n1=22+round(rand*9);
                    for j=1:n1
                        dt=1350+50*round(rand*7)-50;
                        dt=dt*30;
                        d=[d,a,zeros(1,dt)];
                    end
                    % 2， 交替组合数目
                    n2=60+round(rand*10);
                    m2=[ones(1,round(n2*0.8)),ones(1,round(n2*0.2))*2];
                    m2=m2(randperm(length(m2)));
                    n2=length(m2);
                    for j=1:n2
                        dt=1350+50*round(rand*7)-50;
                        dt=dt*30;
                        d=[d,audio{jj,m2(j)},zeros(1,dt)];
                    end
                    t=length(d)/sr;
                    audiowrite(sprintf(['E:\\audio\\',audio{jj,3},'_%d_n1-%d_n2-%d_time-',num2str(t),'s.wav'],i,n1,n2),d,sr)
                end
                
            end
            
        end        
        
        function audioComp()
            audioJ.audioComp4();
            audioJ.audioComp2();
        end
        function audioFileCheck(path)
            files=java.io.File(path).listFiles();
            n=files.length;
            for i=1:n
                p=char(files(i).toString());
                try                    
                    [y,Fs]=audioread(p);
                catch
                    disp([num2str(i),'----',p])
                end
            end
        end
        function repeatCheck(path)
            files=java.io.File(path).listFiles();
            n=files.length;
            p1='abcs';
            for i=1:n
                p=char(files(i).toString());
                [~,fn,~]=fileparts(p);
                if strcmp(fn(1:4),p1(1:4))==1
                    disp(p)
                end
                p1=fn;
            end
        end
        
        function audio250=audioCut250(audio)
            len=4000; % 0.25*Fs
            y=audio;
            r=find(abs(y)>0);
            
            len1=r(end)-r(1);
            d2=floor((len1-len)/2);
            if d2<0
                y3=[zeros(abs(d2),1);y(r(1):r(end)-1);zeros(abs(d2),1)];
                if length(y3)<len
                    y3(end+1)=0;
                else
                    y3=y3(1:len);
                end
            else
                y3=y(r(1)+d2:r(1)+d2+len-1);
            end
            audio250=y3;%/max(y3);
        end
        
        function reWrite250(path)
            [y,Fs]=audioread(path);
            y=audioJ.audioCut250(y);
            [~,nam,ext]=fileparts(path);
            p2=['F:\xEEG\audio5_r\',nam,ext];
            audiowrite(p2,y,Fs);
        end        
        function reWriteAll(path)
            files=java.io.File(path).listFiles();
            n=files.length;
            for i=1:n
                disp(i)
                p=char(files(i).toString());
                audioJ.write250(p);
            end
        end
        function compAll(path)
            k=4000;
            files=java.io.File(path).listFiles();
            n=files.length;
            audio1=zeros(1,k*n);
            for i=1:n
                disp(i)
                p=char(files(i).toString());
                [y,Fs]=audioread(p);
                audio1(k*(i-1)+1:k*i)=audioJ.audioCut250(y);
            end
            audiowrite(['F:\xEEG\comp\all8_general','.wav'],audio1,Fs);
        end   
             
        function  audioComp8(path)
            % 2016-04-27
            files=java.io.File(path).listFiles();
            n=files.length;
            len=4000; % 0.25*Fs
            for j=1:20       
                nn2=64;
                audioFile2=zeros(1,nn2*len);
                
                seq=randperm(n/8);
                for i=1:nn2/8;
                    for jj=1:8
                        ii=8*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=8*(i-1)+jj;
                        audioFile2(len*(i2-1)+1:len*i2)=y3;
                        %disp(ii)
                    end
                    
                end
                audiowrite(['F:\xEEG\comp8general\sequence8_F_2nd_',num2str(j),'.wav'],audioFile2,Fs);
            end
        end 
        function  audioComp4(path)
            % 2016-04-27
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=200;
            for num=1:20  %1: 
                j=2;
                nn2=128;
                %audioFile=zeros(1,nn2*len);
                audioFile2=zeros(1,nn2*len);
                
                seq=randperm(50);
                disp(num)
                for i=1:nn2/4;
                    for jj=1:4
                        ii=(j-1)*nn+4*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=4*(i-1)+jj;
                        audioFile2(len*(i2-1)+1:len*i2)=y3;
                        %disp(ii)
                    end                    
                end
                audiowrite(['F:\xEEG\comp\sequence4_Female_30_',num2str(num),'.wav'],audioFile2,Fs);
                
            end
        end   
        function  audioComp2(path)
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=50; % 100 words_2
            nn2=32; % 60 words_2
            audioFile1=zeros(nn2*2*2*len,1);
            disp('')
            disp('words 2')
            
            for jj=1:20
                disp(jj)
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=2*(i-1)+1;
                    ind=4*(i2-1)+1+200;
                    p1=char(files(ind).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);
                    
                    j=j+1;
                    p1=char(files(ind+1).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=2*(i+nn2-1)+1;
                    ind=4*(i2-1)+1+400+2;
                    
                    p1=char(files(ind).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);
                    
                    j=j+1;
                    p1=char(files(ind+1).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                
                audiowrite(['F:\xEEG\comp\words2F_n_30_',num2str(jj),'.wav'],audioFile1,Fs);
            end            
        end
        function  audioComp1(path)
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=200; % 200 words_1
            nn2=128; % 64 words_1
            audioFile1=zeros(nn2*len,1);
            disp('')
            disp('words 2')
            
            for jj=1:20
                disp(jj)
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=i;
                    ind=i2+200;
                    p1=char(files(ind).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                audiowrite(['F:\xEEG\comp\words1F_30_',num2str(jj),'.wav'],audioFile1,Fs);
            end            
        end
        
        function  audioComp8_long(path)
            % 2016-04-27
            files=java.io.File(path).listFiles();
            n=files.length;
            len=4000; % 0.25*Fs
            
            % 400s
            audioFile2=zeros(1,400*4*len);
            nn2=64;
            for j=1:25                 
                seq=randperm(n/8);
                for i=1:nn2/8;
                    for jj=1:8
                        ii=8*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=8*(i-1)+jj;
                        s=(j-1)*nn2*len+len*(i2-1)+1;
                        e=(j-1)*nn2*len+len*i2;
                        audioFile2(s:e)=y3;
                    end                    
                end                
            end
            audioFile2=audioJ.add10Hz(audioFile2,16000);
            audiowrite(['F:\xEEG\comp_161212\sequence8_F_2nd_',num2str(j),'.wav'],audioFile2,Fs);
        end 
        function  audioComp4_long(path)
            % 2016-04-27
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            
            % 400s
            audioFile2=zeros(1,400*4*len);
            nn=200; % start index of words
            nn2=64;
            for num=1:30  %1:  
                seq=randperm(50);
                disp(num)
                for i=1:nn2/4;
                    for jj=1:4
                        ii=nn+4*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=4*(i-1)+jj;
                        
                        s=(num-1)*nn2*len+len*(i2-1)+1;
                        e=(num-1)*nn2*len+len*i2;
                        audioFile2(s:e)=y3;
                    end                    
                end 
            end
            audioFile2=audioJ.add10Hz(audioFile2,16000);
            audiowrite(['F:\xEEG\comp_161212\sequence4_Female_30_',num2str(num),'.wav'],audioFile2,Fs);
        end   
        function  audioComp2_long(path)
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=50; % 100 words_2
            nn2=16; % 60 words_2
            audioFile2=zeros(400*2*2*len,1);
            disp('')
            disp('words 2')
            
            for jj=1:30
                disp(jj)
                audioFile1=zeros(64*len,1);
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=2*(i-1)+1;
                    ind=4*(i2-1)+1+200;
                    p1=char(files(ind).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);
                    
                    j=j+1;
                    p1=char(files(ind+1).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=2*(i+nn2-1)+1;
                    ind=4*(i2-1)+1+400+2;
                    
                    p1=char(files(ind).toString());
                    disp(p1)
                    [y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);
                    
                    j=j+1;
                    p1=char(files(ind+1).toString());
                    disp(p1)
                    [y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                s=(jj-1)*64*len+1;
                e=jj*64*len;
                audioFile2(s:e)=audioFile1;
            end   
            audioFile2=audioJ.add10Hz(audioFile2,16000);
            audiowrite('F:\xEEG\comp_161212\words2F.wav',audioFile2,Fs);
        end
        function  fp=audioComp1_long(path)
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=200; % 200 words_1
            nn2=64; % 64 words_1
            audioFile1=zeros(nn2*len,1);
            audioFile2=zeros(400*4*len,1);
            disp('')
            disp('words 1')
            
            for jj=1:30
                disp(jj)
                seq=randperm(nn);
                for i=1:nn2
                    i2=seq(i);
                    j=i;
                    ind=i2+200;
                    p1=char(files(ind).toString());[y,Fs]=audioread(p1);
                    audioFile1((j-1)*len+1:j*len)=audioJ.audioCut250(y);                    
                end
                s=(jj-1)*64*len+1;
                e=jj*64*len;
                audioFile2(s:e)=audioFile1;
            end     
            audioFile2=audioJ.add10Hz(audioFile2,16000);
            fp=['F:\xEEG\comp_161212\words1F_30_',num2str(jj),'.wav'];
            audiowrite(fp,audioFile2,Fs);
        end
        
        function a=add10Hz(data,sr)
            a10=audioJ.audioG(10, length(data)/sr, sr);
            if size(data,1)~=size(a10,1)
                data=data';
            end
            a=0.9*data+a10*0.1;
        end
        
        function audioComp4_deviant(path)
            tones={[350,700,1400],[500,1000,2000],[500,800,2000],[300,700,2000]};
            
            files=java.io.File(path).listFiles();
            %n=files.length;
            len=4000; % 0.25*Fs
            nn=200;
            for j=1:20     
                disp(j)
                nn2=64;
                audioFile2=zeros(1,nn2*len);
                
                seq=randperm(50);
                for i=1:nn2/4;
                    for jj=1:4
                        ii=4*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
                        disp(p)
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=4*(i-1)+jj;
                        if jj==4 && rand>0.75
                            a=randperm(4);
                            y2=audioJ.audioG(tones{a(1)},0.2,16000);
                            y3=y3*0;
                            y3(0.025*16000:0.225*16000-1)=y2;
                            audioFile2(len*(i2-1)+1:len*i2)=y3;
                        else
                            audioFile2(len*(i2-1)+1:len*i2)=y3;
                        end
                        
                        
                    end
                    
                    
                end
                audiowrite(['F:\xEEG\comp_deviant\sequence4_deviant_',num2str(j),'.wav'],audioFile2,Fs);
                
            end
        end
        function audioComp8_deviant(path)
            tones={[350,700,1400],[500,1000,2000],[500,800,2000],[300,700,2000]};
            len1=8;
            
            files=java.io.File(path).listFiles();
            n=files.length;
            len=4000; % 0.25*Fs
            nn=200;
            for j=1:20     
                disp(j)
                nn2=128;
                audioFile2=zeros(1,nn2*len);
                last=0;
                seq=randperm(n/len1);
                for i=1:nn2/len1;
                    for jj=1:len1
                        ii=len1*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
%                         disp(p)
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=8*(i-1)+jj;
                        if jj==8 && rand>0.5 && last==0
                            a=randperm(4);
                            y2=audioJ.audioG(tones{a(1)},0.2,16000);
                            y3=y3*0;
                            y3(0.025*16000:0.225*16000-1)=y2;
                            audioFile2(len*(i2-1)+1:len*i2)=y3;
                            last=1;
                        else
                            audioFile2(len*(i2-1)+1:len*i2)=y3;
                            last=0;
                        end   
                    end
                end
                audiowrite(['F:\xEEG\comp_deviant\sequence8_32s_deviant_',num2str(j),'.wav'],audioFile2,Fs);
                
            end
        end
        function audioComp8_deviant_r(path)
            tones={[350,700,1400],[500,1000,2000],[500,800,2000],[300,700,2000]};
            len1=8;
            
            files=java.io.File(path).listFiles();
            n=files.length;
            len=4000; % 0.25*Fs
            nn=200;
            for j=1:20     
                disp(j)
                nn2=128;
                audioFile2=zeros(1,nn2*len);
                last=0;
                seq=randperm(n/len1);
                for i=1:nn2/len1;
                    for jj=1:len1
                        ii=len1*(seq(i)-1)+jj;
                        p=char(files(ii).toString());
%                         disp(p)
                        [y,Fs]=audioread(p);
                        y3=audioJ.audioCut250(y);
                        i2=8*(i-1)+jj;
                        if jj==8 && rand>0.6 && last==0
%                             a=randperm(4);
%                             y2=audioJ.audioG(tones{a(1)},0.2,16000);
%                             y3=y3*0;
%                             y3(0.025*16000:0.225*16000-1)=y2;
                            audioFile2(len*(i2-1)+1:len*i2)=y3(end:-1:1);
                            last=1;
                        else
                            audioFile2(len*(i2-1)+1:len*i2)=y3;
                            last=0;
                        end   
                    end
                end
                audiowrite(['F:\xEEG\comp_deviant\sequence8_32s_r_deviant_',num2str(j),'.wav'],audioFile2,Fs);
                
            end
        end
        
        function audioComp4_170908(path,ind_name)
            %4字一组，16组一个trial，其中12个正确，4个错误
            %随机合成100个trial，并输出错误字所在的位置
            trial_len=16;
            files=java.io.File(path).listFiles();
            words_num=files.length;
            trial_rand=randperm(words_num/7);
            wrong_trial_rand=randperm(trial_len);
            wrong_trial_rand=wrong_trial_rand(1:4);
            
            fs=16000;
            words_len=fs*0.25;
            audioFile2=zeros(1,trial_len*4*words_len);
            jj=0;
            
            fid = fopen('F:\EEG\实验材料\合成字.txt','r');
            words=fread(fid,'*char');
            words=words(1:47*9-2);
            fclose(fid);

            fid = fopen('F:\EEG\实验材料\comp\record3.txt','a');
            fseek(fid, 0, 'eof');
            fprintf(fid, '\r\n');
            fprintf(fid, [sprintf('%.2d',ind_name),': ******************************************************']);
            fprintf(fid, '\r\n');
            
            for jj=1:16
                i=trial_rand(jj);
                fprintf(fid, [sprintf('%.2d',jj),': ']);
                inds=1:4;
                if sum(wrong_trial_rand==jj)>0
                    wrong_word_rand=randperm(3);
                    inds(4)=4+wrong_word_rand(1);
                end
                
                for j=1:4
                    p=char(files((i-1)*7+inds(j)).toString());
                    fprintf(fid, words((i-1)*9+inds(j)));
                    
                    [y,~]=audioread(p);                    
                    y3=audioJ.audioCut250(y);
                    ind_start=((jj-1)*4+j-1)*words_len+1;                    
                    audioFile2(ind_start:ind_start+words_len-1)=y3;
                end
                if inds(4)~=4
                        disp(char(files((i-1)*7+inds(4)).toString()))
                        fprintf(fid, '*');
                end
                fprintf(fid, '\r\n');
            end
            
            fclose(fid);
            audiowrite(['F:\EEG\实验材料\comp\sequence7_16s_deviant_',sprintf('%.2d',ind_name),'.wav'],audioFile2,fs);
                
        end
        function audioLocalGlobal(path)            
        end
         
        
        function ft=spectrogram(x,sr)
            if(size(x,1)>size(x,2))    %size(x,1)为x的行数，size(x,2)为x的列数
                x=x';
            end
            s=length(x);
            w=round(10*sr/1000);   %窗长，取离44*sr/1000最近的整数
            n=w;                   %fft的点数
            ov=round(w/5*4);                %50%的重叠
            h=w-ov;
            % win=hanning(n)';  %汉宁窗
            win=hamming(n)';    %汉明窗
            c=1;
            ncols=1+fix((s-n)/h);
            nrows=round(1+n/2);
            d=zeros(nrows,ncols);
            for b=0:h:(s-n)
                u=win.*x((b+1):(b+n));
                t=fft(u);
                d(:,c)=t(1:nrows)';
                c=c+1;
            end
            tt=[0:h:(s-n)]/sr;
            ff=[0:(n/2)]*sr/n;
            ft=20*log10(abs(d));
            
            ft=ft(1:2:end,1:10:end);
            ft=ft(:);
        end
        
        function phee=getnp(phee_spectro)
            phee.mean=mean(phee_spectro);
            phee_spectro=phee_spectro-repmat(phee.mean,size(phee_spectro,1),1);
            cc=phee_spectro'*phee_spectro;
            [v,c]=eig(cc);
            cs=sum(c);
            cs2=sum(cs);            
            for i=1:length(cs)
                if sum(cs(end-i:end))/cs2>0.99
                    break;
                end
            end
            phee.np=v(:,i:end);
            phee.source=phee_spectro*phee.np;
        end
        
        function [phee_spectro1,files]=audioReadAll(fp)
            %fp='G:\Marmoset\marmoset_vocal\Tsik';
            fj='E:\Codes\java\jars\files.jar';
            javaaddpath(fj);
            a=fileJ.fileo();
            files=a.listf(fp);
            phee_spectro1=[];
            sr=44100;
            len=3*sr;
            warning off
            for i=1:files.length
                [x,sr]=audioread(char(files(i)));
                len0=length(x);
                if len0<len
                    x=[x;zeros(len-len0,1)];
                elseif len0>len
                    x=x(1:len);
                end
                ft=audioJ.spectrogram(x,sr);
                if i==1
                    phee_spectro1=zeros(files.length,length(ft));
                end
                ft(ft==-Inf)=-100;
                phee_spectro1(i,:)=ft;
                if mod(i,10)==0
                    disp(i)
                end
                
            end
        end
        
        function ds=distance_cal(spectro,phee)
            spectro=spectro-repmat(phee.mean,size(spectro,1),1);
            nps=spectro*phee.np;
            ds=zeros(size(nps,1),1);
            for i=1:size(nps,1)
                ds(i)=mean(sqrt(sum((repmat(nps(i,:),size(phee.source,1),1)-phee.source).^2,2)));
            end
        end
        
        function [r,types]=vocal_recognize(spectro,sources)
            ds=zeros(size(spectro,1),length(sources));
            for i=1:length(sources)
                ds(:,i)=audioJ.distance_cal(spectro,sources{i});
            end 
            [~,r]=min(ds,[],2);
            types={};
            for i=length(r):-1:1
                types{i}=sources{r(i)}.type;
            end
        end
        
    end
    
end

