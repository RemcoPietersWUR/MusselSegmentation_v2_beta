function [grayThreshold]=musselThreshold(IM,idx,ellipse_a,ellipse_b,ellipse_c,XY0)
%musselThreshold determine grey level threshold a cross section level using
%enclosing ellipse limitation. XY0 are the coordinates of the XY ellipse
%(from imellipse)

%Sample area (rectangular) is determined by the local radius of the ellipse
%local radius along x axis
r_x = ellipse_a*sqrt(1-((idx-(ellipse_c))/ellipse_c).^2);
r_y = ellipse_b*sqrt(1-((idx-(ellipse_c))/ellipse_c).^2);

%Image sub selection
IMsub=IM(round(XY0(1)+XY0(3)/2-r_x,0):round(XY0(1)+XY0(3)/2+r_x,0),...
    round(XY0(2)+XY0(4)/2-r_y,0):round(XY0(2)+XY0(4)/2+r_y,0));
grayThreshold=graythresh(IMsub);
%imshow(imbinarize(IMsub,grayThreshold))

%plotting
% figure
% imshow(imbinarize(IM,grayThreshold))
% hold on
% plot(XY0(2)+XY0(4)/2,XY0(1)+XY0(3)/2,'*b')
% plot(XY0(2)+XY0(4)/2+r_y,XY0(1)+XY0(3)/2+r_x,'*r')
% plot(XY0(2)+XY0(4)/2-r_y,XY0(1)+XY0(3)/2-r_x,'*r')