
function angle_d = angle_included(v1,v2)
% function: calculate the included angle between two vectors
% jiangjian@ion.ac.cn
% 2020-08-23
% code2db('angle_included')
a=sum(v1.*v2);
b=sqrt(sum(v1.^2))*sqrt(sum(v2.^2));
cos1=a/b;
angle_d=acosd(cos1);
end