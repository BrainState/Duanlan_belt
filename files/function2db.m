
% save Files into db
% jiangjian@ion.ac.cn
% 2019-07-03


% update or insert
fp='D:\Codes\MatlabLib\files\script';
mfiles=listFiles(fp,'m',@file2db);

% set type1
db=nodeCreate('code');
db.isPageing=0>1;
ds=db.getRecordsJsonArrayBySql(['SELECT * FROM ', char(db.fullTableName),' WHERE rubbish<>1 OR rubbish IS NULL']);
ds=jsondecode(char(ds));
for i=1:length(ds.data)
    d=ds.data(i);
    db.rcode=d.rcode;
    ind=regexp(d.path,'\\');
    if length(ind)>=4
        ty=d.path(ind(3)+1:ind(4)-1);
        db.Update({'type1'},{ty});
    end
    disp(i)
end

% delete empty
db=nodeCreate('code');
db.isPageing=0>1;
ds=db.getRecordsJsonArrayBySql(['SELECT * FROM ', char(db.fullTableName),' WHERE rubbish<>1 OR rubbish IS NULL']);
ds=jsondecode(char(ds));
for i=1:length(ds.data)
    d=ds.data(i);
    if ~exist(d.path,'file')
        db.rcode=d.rcode;
        db.Update('rubbish',1)
    end
end




