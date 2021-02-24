function mypublish
% publish all my m files
% 
conn=database('JerryWeb','sa','JJ@hust*','com.microsoft.sqlserver.jdbc.SQLServerDriver','jdbc:sqlserver://10.10.168.38:1433;databaseName=JerryWeb');
curs = exec(conn, 'SELECT paper_name FROM paperlist WHERE paper_subject= ''SourceCode''');
setdbprefs('DataReturnFormat','cellarray');
curs=fetch(curs);
aa140515=curs.data;
close(conn)

%%
for ii=length(aa140515)-1:-1:1
    disp(aa140515{ii})
    try
    publish([aa140515{ii},'.m'])
    catch
        continue
    end
    close all
end