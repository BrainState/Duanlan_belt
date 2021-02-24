
% export contracts
% jiangjian@ion.ac.cn
% 2019-07-08

db=nodeCreate('contract2');
db.isPageing=0>1;
ds=db.getRecordsJsonArrayBySql(['SELECT * FROM ', char(db.fullTableName),' WHERE contract_code LIKE ''%Äæ¾³ÖÐÐÄ%'' AND (rubbish<>1 OR rubbish IS NULL) ']);
ds=jsondecode(char(ds));

% 
for i=1703:length(ds.data)
    d=ds.data(i);
    if isempty(d.ppath)
        disp('error')
        continue;
    end
    path=['G:\papers\',d.ppath];
    path2=['H:\temp\',d.ccode,'-',d.ctitle,'.pdf'];
    try
        copyfile(path,path2)
    catch
        copyfile(path,['H:\temp\',d.ccode,'.pdf'])
    end
    
    disp(i)
end