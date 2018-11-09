%Default factor=50
function [X,Y,delta]=Normal_lines(BWhull,factor,IM)   
%Compute normal line to every pixel of the object perimeter.
%Small x,y represent coordinates
%Capital X,Y represent line sections (coordinate 1, coordinate 2)

%Input:
%BWhull convexhull image of object
%Factor length in pixels for line sections
%IM only for visulatisation

%Output:
% X, Y coordinates of line sections X and Y
% delta normalized displacement between points
visualisation = false;

    
    %Get Boundary of convex hull
    B = bwboundaries(BWhull,'noholes');
    Bound= B{1,1};
    
    %Displacement between points
    for idx = 1:(length(Bound)-1)
        delta(idx,:)=Bound(idx+1,:)-Bound(idx,:);
    end
    %Compute the outline based on displacement delta
    x = zeros(length(Bound),1);
    y = zeros(length(Bound),1);
    x(1)=Bound(1,1);
    y(1)=Bound(1,2);
    for idx = 1:length(delta)
        x(idx+1) = x(idx) + delta(idx,1);
        y(idx+1) = y(idx) + delta(idx,2);
    end
    %Normalize delta
    for idx = 1:length(delta)
        delta(idx,:) = delta(idx,:) / norm(delta(idx,:));
    end
    if visualisation
    %Draw normal lines
    imshow(IM)
    hold on
    for i=1:length(delta)
        line([y(i)-delta(i,1), y(i)],[x(i)+delta(i,2), x(i)]);
    end
    end
    
    %Normal lines to boundary factor determines the length
    for i=1:length(delta)
        %round to full pixel
        Y(i,:)=round([y(i)-factor*delta(i,1),y(i)],0);
        X(i,:)=round([x(i)+factor*delta(i,2), x(i)],0);
    end
    if visualisation
    %Draw normal lines
    figure
    imshow(IM)
    hold on
    for i=1:length(delta)
        line([Y(i,1), Y(i,2)],[X(i,1), X(i,2)]);
    end
    end
end   
%     %Gradient
%     Gval = cell(1,length(delta));
%     for i=1:length(delta)
%         %March inwards convexhull boundary is start point
%         %XX & YY are local xy values to sample gray value
%         Xedge = x(i);
%         Yedge = y(i);
%         if delta(i,2)>0
%             XX=Xedge:X(i,1);
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             elseif delta(i,1)>0
%                 YY=flip(Y(i,1):Yedge);
%             else
%                 YY=Yedge*ones(1,numel(XX));
%             end
%         elseif delta(i,2)<0
%             XX=flip(X(i,1):Xedge);
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             elseif delta(i,1)>0
%                 YY=flip(Y(i,1):Yedge);
%             else
%                 YY=Yedge*ones(1,numel(XX));
%             end
%         else
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             else
%                 YY=flip(Y(i,1):Yedge);
%             end
%             XX=Xedge*ones(1,numel(YY));
%         end
%         for idp=1:numel(XX)
%             Gval_loc(idp) = IMrot(XX(idp),YY(idp),slice);
%         end
%         clear XX
%         clear YY
%         Gval{1,i}=Gval_loc;
%         clear Gval_loc
%     end
%     
%     %Compute derivatives, change to signed int16
%     for section = 1:length(delta)
%         Gval_s= int16(Gval{1,section});
%         Gval_d1{1,section} = diff(Gval_s);
%         Gval_d2{1,section} = diff(Gval_s,2);
%         clear Gval_s
%     end
%     
%     %Find outer- en innerline & plot
%     %     figure
%     %     imshow(IMrot(:,:,slice))
%     %     hold on
%     %     plot(A(:,2),A(:,1))%A is convexhull boundary
%     outline = zeros(2,length(delta));
%     inline = zeros(2,length(delta));
%     for i = 1:length(delta)
%         %March inwards convexhull boundary is start point
%         Xedge = x(i);
%         Yedge = y(i);
%         if delta(i,2)>0
%             XX=Xedge:X(i,1);
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             elseif delta(i,1)>0
%                 YY=flip(Y(i,1):Yedge);
%             else
%                 YY=Yedge*ones(1,numel(XX));
%             end
%         elseif delta(i,2)<0
%             XX=flip(X(i,1):Xedge);
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             elseif delta(i,1)>0
%                 YY=flip(Y(i,1):Yedge);
%             else
%                 YY=Yedge*ones(1,numel(XX));
%             end
%         else
%             if delta(i,1)<0
%                 YY=Yedge:Y(i,1);
%             else
%                 YY=flip(Y(i,1):Yedge);
%             end
%             XX=Xedge*ones(1,numel(YY));
%         end
%         [~,in_edg]=max(Gval_d1{1,i});
%         [~,out_edg]=min(Gval_d1{1,i});
%         %         plot(YY(in_edg),XX(in_edg),'.r')
%         %         plot(YY(out_edg),XX(out_edg),'.g')
%         outline(:,i)=[XX(in_edg),YY(in_edg)];
%         inline(:,i)=[XX(out_edg),YY(out_edg)];
%         clear XX
%         clear YY
%     end