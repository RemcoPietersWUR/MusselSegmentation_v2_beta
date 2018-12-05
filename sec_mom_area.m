function [Ixx,Iyy,Ixy]=sec_mom_area(xaxis_pos,yaxis_pos, BW)
%Second moment of area

%Get coordinates of shell pixels
[y,x] = find(BW); 


%% Calculate Second Moment of Area

    Ixy=0;
    Ixx=0;
    Iyy=0;

    for i=1:length(x);
        distfrom_xaxis=(y(i)-xaxis_pos);
        distfrom_yaxis=(x(i)-yaxis_pos);
        
        xx=distfrom_xaxis.^2;
        yy=distfrom_yaxis.^2;
        xy=abs(distfrom_xaxis)*abs(distfrom_yaxis);
        
        Ixx=Ixx+xx;
        Iyy=Iyy+yy;
        Ixy=Ixy+xy;
    end
