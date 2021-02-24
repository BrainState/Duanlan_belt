function plotAccDynamics(x,sr,tw)
%plotAccDynamics(x,sr,tw) plot the activity of the subject based on the
%acceleration info

% x: signals from motion sensor
% sr: sampling rate
% tw: the window time size

% get the position info
x_acc = x(:,1); % horizontal
y_acc = x(:,2); % lateral
z_acc = x(:,3); % vertical

% compute the velocity
x_acc_dyn = diff(x_acc);% horizontal
y_acc_dyn = diff(y_acc);% lateral
z_acc_dyn = diff(z_acc);% vertical
net_acc_dyn = sqrt(x_acc_dyn.^2 + y_acc_dyn.^2 + z_acc_dyn.^2); % the net velcity

mean_acc_dyn = movmean(net_acc_dyn,tw);

% determine the quiet and active period
motion_threshold = 6*median(net_acc_dyn);
active_ = mean_acc_dyn>=motion_threshold;
quiet_ = (mean_acc_dyn<motion_threshold)&(mean_acc_dyn>=motion_threshold/2);
sleep_ = mean_acc_dyn<motion_threshold/2;

% prepare for plotting
select_active =ones(size(active_));
select_quiet =ones(size(active_));
select_sleep = ones(size(active_));
select_active(quiet_|sleep_) = nan;
select_quiet(active_|sleep_) = nan;
select_sleep(active_|quiet_) = nan;

x_plot = [1:length(net_acc_dyn)]/sr/60;
plot(x_plot,mean_acc_dyn.*select_active ,'r-','linewidth',1.5,'displayname','��Ծ')
hold on
plot(x_plot,mean_acc_dyn.*select_quiet,'b-','linewidth',1.5,'displayname','����')
plot(x_plot,mean_acc_dyn.*select_sleep,'k-','linewidth',1.5,'displayname','˯��')
legend
title(['��Ծ�ٷֱ�:' num2str(sum(active_)/length(active_)*100,2) '%�� �����ٷֱȣ�' num2str(sum(quiet_)/length(quiet_)*max(x_plot),2) '%'])
xlabel('ʱ��/��')
ylabel('��Ծ�̶�')
title('���ٶȵı仯���')

set(gca,'linewidth',1)
box off
set(findobj('fontsize',10),'fontsize',13)


end



