f1=imread('Y:\Users\Administrator\Desktop\poo\mark11\Movie 11-1_00004.tif');
f2=imread('Y:\Users\Administrator\Desktop\poo\mark8\Movie.S8_00015.tif');

fs=imread('Y:\Users\Administrator\Desktop\poo\spontaneous.png');
fm=imread('Y:\Users\Administrator\Desktop\poo\faceMarkTest.png');

f0=zeros(540,720,3);
files=java.io.File('Y:\Users\Administrator\Desktop\poo\mark11').listFiles();
for i=1:files.length
    disp(i)
    f2=fs;
    f=imread(char(files(i)));
    f2(67:end,:,:)=f2(67:end,:,:)+f;
    imwrite(f2,['Y:\Users\Administrator\Desktop\poo\mark11_\',sprintf('1%.4d.tiff',i)]);
end

files=java.io.File('Y:\Users\Administrator\Desktop\poo\mark8').listFiles();
for i=1:files.length
    disp(i)
    f2=fm;
    f=imread(char(files(i)));
    f2(67:end,:,:)=f2(67:end,:,:)+f;
    imwrite(f2,['Y:\Users\Administrator\Desktop\poo\mark11_\',sprintf('2%.4d.tiff',i)]);
end