function [] = drawsphere(a,b,c,r)
% jiangjian@ion.ac.cn
% 2020-10-13
nbin=21;
ang=linspace(0,pi*2,360*2);
% xy
hold on
zz=linspace(-r,r,nbin);
r_xy=sqrt(r^2-zz.^2);
for i=1:nbin
    x=r_xy(i)*cos(ang);
    y=r_xy(i)*sin(ang);
    z=x-x+zz(i);
    plot3(x+a,y+b,z+c,'-k');    
end

theta=linspace(-pi,pi,nbin);
z=r*sin(ang);
for i=1:nbin
    x=r*cos(ang)*cos(theta(i));
    y=r*cos(ang)*sin(theta(i));
    plot3(x+a,y+b,z+c,'-k'); 
end

axis equal
grid on


hold off
view(3)

end

