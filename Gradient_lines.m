function [SecX,SecY,levels_deriv1]=Gradient_lines(X,Y,delta,IM)
%Compute gradient along normal line to every pixel of the object perimeter.
%Small x,y represent coordinates
%Capital X,Y represent line sections (coordinate 1, coordinate 2)
%Capital SecX,SecY reprsent coordinates of pixels along line section

%Input:
%X,Y line sections to compute gradient
%Delta normalized displacement along perimenter
%IM only for gray value input

%Output:
%SecX & SecY pixel coordinates along normal line section
%levels_deriv1 First derivative of gray levels along normal line section


%Pixel coordinates along normal line section
%Preallocate
SecX = cell(1,length(delta));
SecY = cell(1,length(delta));
for i=1:length(delta)
    %March inwards convexhull boundary is start point
    if delta(i,2)>0
        XX=X(i,2):X(i,1);
        if delta(i,1)<0
            YY=Y(i,2):Y(i,1);
        elseif delta(i,1)>0
            YY=flip(Y(i,1):Y(i,2));
        else
            YY=Y(i,2)*ones(1,numel(XX));
        end
    elseif delta(i,2)<0
        XX=flip(X(i,1):X(i,2));
        if delta(i,1)<0
            YY=Y(i,2):Y(i,1);
        elseif delta(i,1)>0
            YY=flip(Y(i,1):Y(i,2));
        else
            YY=Y(i,2)*ones(1,numel(XX));
        end
    else
        if delta(i,1)<0
            YY=Y(i,2):Y(i,1);
        else
            YY=flip(Y(i,1):Y(i,2));
        end
        XX=X(i,2)*ones(1,numel(YY));
    end
    %SecX,SecY are pixel coordinates along X,Y line section
    SecX{1,i}=XX;
    SecY{1,i}=YY;
    clear XX
    clear YY
end
%Gray levels along line sections
%Preallocation
levels = cell(1,numel(SecX));
for i=1:numel(SecX)
        for idx=1:numel(SecX{1,i})
            level_loc(idx) = IM(SecX{1,i}(idx),SecY{1,i}(idx));
        end
        levels{1,i}=level_loc;
        clear level_loc
end
%Compute derivatives, change to signed int16
%Preallocation
levels_deriv1=cell(1,numel(SecX));
for i = 1:numel(SecX)
        level_signed= int16(levels{1,i});
        levels_deriv1{1,i} = diff(level_signed);
        %levels_deriv2{1,i} = diff(level_signed,2);
        clear level_signed
end
end
