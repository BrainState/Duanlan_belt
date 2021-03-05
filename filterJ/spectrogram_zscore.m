function [sp_abs,sp_rel,select_obj,d3]=spectrogram_zscore(d,dur,sr,varargin)
% spectrogram
% jiangjian@ion.ac.cn
% 2019-06-05
% input: varargin-method(mean,population,middle)
% related function: s190410_zhongshan_spectrogram
% update:
% 2019-11-01, add diff, to test long constant values
% 2020-02-29, remove epoch=0 before psg_spectrum
% 2020-03-23, round(dur*sr)
% 2020-05-22, findpeaks, remove epoches with abnormal high-frequency noise

m_method='mean';
max_threshold=1e5;
if nargin>3
    m_method=varargin{1};
end
dn=round(dur*sr);
n=floor(length(d)/dn);
d=d(1:dn*n);
d1=reshape(d,dn,n);

inds=1:n;
% for i=1:n
%     t=d1(:,i);
%     t(abs(t)<10)=0;
%       if sum(t==0)<dur*sr
%           inds(end+1)=i;
%       end
% end
d2=d1(:,inds);
max_d1=max(abs(d2));
if max_d1>max_threshold
    del_inds1=max_d1>1e3 | max_d1<20; % too large or too small
    d3=d2;
    d3(:,del_inds1)=0;
else
    d3=d2;
end

d3(isnan(d3))=0;
% find the all constant volume
diff_d1=sum(diff(d3))';
del_ind=find(abs(diff_d1)<1e-5); % constant value
select_ind=find(abs(diff_d1)>1e-5);
d3(:,del_ind)=0;
[sp,n2]=psg_spectrum(d3(:),dur,sr);

if strcmpi(m_method,'population')
    dn=floor(size(sp,1)/10);
    mp=zeros(1,size(sp,2));
    for i=1:size(sp,2)
        [y,E] = histcounts(sp(:,i),dn);
        y=smooth(y);
        [~,ind]=max(y);
        mp(i)=mean(E(ind(1):ind(1)+1));
    end
elseif strcmpi(m_method,'middle')
else
    mp=mean(sp);
end

sp2=sp-repmat(mp,size(sp,1),1);
sp2=sp2./repmat(std(sp2),size(sp,1),1);
sp22=sp2;
threhold_del=mean(sp22,2);

% 2019-06-12,add a new threshold for the absolute values
[b,a]=butter(3,1/(sr/2),'high');
d0=filter(b,a,d);
dr=reshape(d0(1:dn*n2),dn,n2);
dr=max(abs(dr))';

% del_ind=[];
% del_ind=threhold_del>2 | max(sp22,[],2)>5 | min(sp22,[],2)>0 |max(sp22,[],2)<0 | dr>500 | abs(diff_d1)<1e-4;
del_ind2=min(sp22(:,1:end/2),[],2)>0;
% del_ind=[del_ind;find(del_ind2)];
% sp22(del_ind,:)=0;


select_obj.del_ind=del_ind;
select_obj.dr=dr;
select_obj.n=n;

sp0=sp;
% sp0(del_ind,:)=[];
mp0=mean(sp0);
m1=repmat(mp0,size(sp,1),1);
std1=repmat(std(sp0-repmat(mp0,size(sp0,1),1)),size(sp,1),1);
sp2=sp-m1;
sp2=sp2./std1;
sp22=sp2;

% 2020-05-22, add
% t=sp22(:,60*dur);
% t(abs(t)>3)=3;
% [pks,inds]=findpeaks(t,'MinPeakProminence',4);
% figure,plot(t)
% hold on
% plot(inds,pks,'or')
% hold off

%select_obj.del_ind=[select_obj.del_ind;inds];

sp_2=sp;
sp_2(select_obj.del_ind,:)=[];
d3(:,select_obj.del_ind)=0;

mp0=mean(sp_2);
m1=repmat(mp0,size(sp_2,1),1);
std1=repmat(std(sp_2-repmat(mp0,size(sp_2,1),1)),size(sp_2,1),1);
sp2=sp_2-m1;
sp2=sp2./std1;
sp22=sp2;

sp_rel=zeros(n,size(sp22,2))+0;
inds=ones(n,1);inds(select_obj.del_ind)=0;
sp_rel(inds>0,:)=sp22;

%sp(inds,:)=nan;
sp_abs=sp;
sp_abs(inds<1,:)=nan;
end