classdef filterJJ<handle
    %FILTERJJ Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
    end
    
    methods (Static)
        function sigplot(data,fs)
            n=length(data);
            x=linspace(0,n/fs,n);
            figure
            plot(x,data)
            xlabel('time (s)');
        end
        function fftplot( data,fs)
            %FFTPLOT Summary of this function goes here
            %   Detailed explanation goes here
            f=fft(data);
            y1=abs(f);%.*conj(f);
            y1=y1(1:end/2);
            x=linspace(0,fs/2,length(y1));
            
            
            figure,
            plot(x,y1)
            ylabel('FFT index');
            xlabel('Frequency (Hz)');
        end
        function spectPlot(data,fs)
            [S,F,T,P]=spectrogram(data,200,199,[],fs);
            figure
            surf(T,F,pow2db(P),'edgeColor','none');
            axis tight
            view(2)
        end
    end
    
end

