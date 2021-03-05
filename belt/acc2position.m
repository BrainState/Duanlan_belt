function [varargout] = acc2position(pathway_acc_data_or_data, varargin)
% function: transform the acceleration data into positions
% jiangjian@ion.ac.cn
% 2020-09-10
% input: pathway_acc_data_or_data(1, acc data n*3; 2, acc path way)
% output: position(-1,right; 0, up;1,left)
% output: [position,position_angles]
% update: 
% 2020-10-15, state estimate: whether stand up

load('data_headModel.mat')
motion2=-motion;
v_stand=mean(motion2(:,1:3));

% stand up
% load('\\10.10.44.152\public\005_Data\portable_data\01_newTestData\200823_headModel\11280257\data_11280257.mat')
% 20-08-23: model: stand -> face right  -> face left -> face up --> face down

savep_body='';
if nargin>1
    savep_body=varargin{1};
end

load(pathway_acc_data_or_data)
info=infos{1};
motion=-motion;
sr=info.sr_BMI;

[azimuth,elevation,r] = cart2sph(v_stand(1),v_stand(2),v_stand(3));
da=azimuth;
de=elevation-pi/2;
azimuth=azimuth-da;
elevation=elevation-de;
[v_stand2(1),v_stand2(2),v_stand2(3)]=sph2cart(azimuth,elevation,r);

%% included angle
angles=[];
ang_stand=[];      % new, 2020-10-15
ang_rotation=[];   % new, 2020-10-15
as=[];
es=[];
rs=[];
motion_r=motion;
hp=motion(:,1:3);
for i=1:size(motion,1)
    angles(i)=angle_included(v_stand,hp(i,:));
    ang_stand(i)=angle_included(hp(i,:),hp_mup);
    [azimuth,elevation,r] = cart2sph(motion(i,1),motion(i,2),motion(i,3));
    ang_rotation(i)=azimuth;
    azimuth=azimuth-da;
    elevation=elevation-de;
    as(i)=azimuth;
    es(i)=elevation;
    rs(i)=r;
    [motion_r(1),motion_r(2),motion_r(3)]=sph2cart(azimuth,elevation,r);
end
position_angles=angles;

as3=as/pi*180;
as2=as-as;
as2(as3<50)=-1; % right
as2(as3>120)=1; % left
position=as2;

position_new=position-position;
th=90/180*pi;
position_new(abs(ang_rotation)>=110/180*pi)=-1; % right
position_new(abs(ang_rotation)<=70/180*pi)=1; % left
% others is lie up
position_new(ang_stand<20 | ang_stand>160)=2; % stand/sit up

if nargout>0
    varargout{1}=position_new;% position_angles    
end
if nargout>1
    varargout{2}=position_angles;% position_angles    
end
st=datetime(info.st);

%% head ball

[a,b,c,r]=fitspherebyls(hp(1:round(length(hp)/200):end,:));
figure
set(gcf,'visible','off')
plot3(a,b,c,'ok','markerFaceColor','g','markerSize',8)
drawsphere(a,b,c,r)
hold on

[x,y,z] = sphere();
h = surfl(x*r+a, y*r+b, z*r+c); 
set(h, 'FaceAlpha', 0.2)
shading interp

plot3(hp(:,1),hp(:,2),hp(:,3),'or')
hold off
axis equal

hold on
hp_m=mean(hp)*2;
quiver3(a,b,c,hp_m(1),hp_m(2),hp_m(3),'lineWidth',6,'color','k');
hold off
xlabel('x')
ylabel('y')
zlabel('z')
view(-104,-90)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_head_ball'])
end
close gcf;

%% plot body position
figureJ
set(gcf,'visible','off')
plotJ(as2,3600*sr)
axis tight
set(gca,'ytick',[-1,0,1])
ylim([-1,1]*5)
set(gca,'ytickLabel',{'right','up','left'})
tt=length(as2)/3600/sr;
header=struct('dur',3600,'st',st);
x1=1/3600/sr;
[xtt,xt,xlabel1]=getXTick(header,tt,x1);
set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)
xlabel(xlabel1);
set(gca,'fontSize',18)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_body'])
end
close gcf;

%% body position and stand/sit up
figureJ
set(gcf,'visible','off')
plotJ(position_new,3600*sr)
axis tight
set(gca,'ytick',[-1,0,1,2])
ylim([-1,1]*5)
set(gca,'ytickLabel',{'right','up','left','stand/sit'})
tt=length(as2)/3600/sr;
header=struct('dur',3600,'st',st);
x1=1/3600/sr;
[xtt,xt,xlabel1]=getXTick(header,tt,x1);
set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)
xlabel(xlabel1);
set(gca,'fontSize',26)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_body_new'])
end
close gcf;
%% plot g vectors
figureJ,
set(gcf,'visible','off')
hold on
plot3(motion(:,1),motion(:,2),motion(:,3),'*r')
plot3(motion2(:,1),motion2(:,2),motion2(:,3),'*k') % stand up
quiver3(0,0,0,v_stand(1),v_stand(2),v_stand(3),'lineWidth',3)
quiver3(0,0,0,v_stand2(1),v_stand2(2),v_stand2(3),'lineWidth',3)
plot3(0,0,0,'ok','markerSize',8)
plot3(0,0,0,'ok','markerSize',80)
hold off
grid on
xlabel('x')
ylabel('y')
zlabel('z')
set(gca,'fontSize',18)
view(3)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_quiver'])
end
close gcf;
%% plot angles
figureJ,
set(gcf,'visible','off')
plotJ(angles,3600*sr)
tt=length(as2)/3600/sr;
header=struct('dur',3600,'st',st);
x1=1/3600/sr;
[xtt,xt,xlabel1]=getXTick(header,tt,x1);
set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)
xlabel(xlabel1);
set(gca,'fontSize',18)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_angle'])
end
close gcf;
%% plot motions
figureJ,
set(gcf,'visible','off')
t=-motion(:,4:6);
t(t>2)=2;
plotJ(-t,3600*sr)
tt=length(as2)/3600/sr;
header=struct('dur',3600,'st',st);
x1=1/3600/sr;
[xtt,xt,xlabel1]=getXTick(header,tt,x1);
set(gca,'xtick',xtt)
set(gca,'xtickLabel',xt)
xlabel(xlabel1);
set(gca,'fontSize',18)
if ~isempty(savep_body)
    printJ(which('acc2position'),gcf,[savep_body,'_gyroscope'])
end
close gcf;

end

