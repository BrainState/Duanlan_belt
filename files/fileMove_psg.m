
fp='J:\Sleep_human\181012insomnia\';

files=java.io.File(fp).listFiles();
for i=1:files.length
    f=files(i);
    if ~f.isDirectory()
        na=f.getName().split('\.');
        nas=char(na(1));
        if ~java.io.File([fp,nas]).exists()
            mkdir([fp,nas])
        end
        movefile(char(f),[fp,nas])
    end
end