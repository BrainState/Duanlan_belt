%% plot 
x=0:0.1:30;
a=5*sin(x)+10;%);
dy=rand(1,length(x))+0.5;
yp=dy+a;
yn=a-dy;
x_fill=[x,x(end:-1:1)];
y_fill=[yp,yn(end:-1:1)];
figure,
hold on
plot(x,a,'lineWidth',3)
h1=fill(x_fill,y_fill,'y','facealpha',0.1);
hold off