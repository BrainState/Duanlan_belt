function plotAcceleration(motionData,titstr)
% plotAcceleration(motionData,titstr)
% plot the motion signals from the x-axis, y axis and z axis

    sr = 1;
    x_plot = [1:size(motionData,1)]/sr/60;
    plot(x_plot,motionData(:,1),'linewidth',1.5, 'displayname','X');
    hold on;
    plot(x_plot,motionData(:,2),'linewidth',1.5, 'displayname','Y');
    plot(x_plot,motionData(:,3),'linewidth',1.5, 'displayname','Z');
    xlabel('Time/min')
    ylabel('Acc (x G)')
    title(titstr)
    hold off;
    legend
    set(gca,'linewidth',1)
    box off
    set(findobj('fontsize',10),'fontsize',13)

end