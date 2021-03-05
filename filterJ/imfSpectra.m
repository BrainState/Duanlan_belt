function imfSpectra(imf,sr)
% 2018-08-24, plot the spectra of all the elements in imf
% all for visualization
% x axis: log (frequency)
% y axis: smooth acoording the frequency, normalize to the max value
if size(imf,2)>50
    imf=imf';
end
n=size(imf,2);
labels=cell(n,1);
figure
hold on
j=0;
for i=1:n
    [fp,fh]=frequencyShow(imf(:,i),sr);
    labels{i}=num2str(i);
    fp=fp/max(fp);
    f_max=fh(fp==max(fp));
    if f_max<0.1
%         continue;
    end
    f_max=round(f_max(1)*50);
    f_max=max(f_max,50);
    hn=hann(f_max)/sum(hann(f_max));
    fp_smooth=conv(fp,hn, 'same');
    
    plot(log(fh),fp_smooth)
    j=j+1;
    %semilogx(fp_smooth)
end
hold off
legend(labels(1:j));
hz=[0,0.001,0.01,0.1,1,4,12,30,150,1000];
set(gca,'xtick',log(hz))
set(gca,'xtickLabel',hz)
xlabel('Hz')
ylabel('distribution')
end