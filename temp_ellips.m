close all
x0=0;
y0=1;
a=2;
b=a/2;
x=(-a:0.01:a)+x0;
a=2;
b=a/2;
y=b*sqrt(1-((x-x0)/a).^2);
plot(x,y+y0)
hold on
plot(x,-y+y0)
axis equal
