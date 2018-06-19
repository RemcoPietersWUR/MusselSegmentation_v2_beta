function [TMnew]=close_gap(IM, gap_size)
%Close small gaps along the segmented shell edge. 
%Parameter gap_size defines the minimum and maximum size between two gap
%points. eg. large than 0 and smaller than 5 pizels -> gap_size=[0 5]
% figure;
% imshow(IM)
% figure
% imshow(boundary_select2(IM))
%figure
%Combine raw segmentation + selected boundary
IM2 = imadd(IM,boundary_select2(IM));
%imshow(IM2)
% figure
%Remove interior pixels from the combined segmented shells
BW1=bwmorph(IM2,'remove');
% imshow(BW1)
% figure
%Skeletonize the combined segmented shells 
BW2=bwmorph(IM2,'skel',Inf);
% imshow(BW2)
%Get endpoints of skeleton
BWend=bwmorph(BW2,'endpoints');
%figure
%Get (extreme) coordinates of the gap points by multiplying the skeleton endpoints
%times the outline of the segmented shell.
BW3 = immultiply(BWend,BW1);
%imshow(BW3)
%Find coordinates of all gap points
[coord_x,coord_y]=find(BW3);
%Nlines = ((length(row)-1)*length(row))/2; %summation 4+3+2+1
%Compute distances between all gap points (so this is duplicated!)
Npoints=length(coord_x);
distances=zeros(Npoints,Npoints);
for k=1:Npoints
    for l = 1:Npoints
        distances(k,l) = sqrt((coord_x(k)-coord_x(l))^2+(coord_y(k)-coord_y(l))^2);
    end
end
%Get only lower triangular part of the distance matrix
distances=tril(distances);
%Find gap sizes within defined range
[idx_row,idx_col]=find(distances>gap_size(1) & distances<gap_size(2));
%Index of row and column coordinates match with each other (neighbour
%points)
idx=[idx_row,idx_col];
% hold on
% plot(coord_y(idx(gap,1)),coord_x(idx(gap,1)),'*r');
% plot(coord_y(idx(gap,2)),coord_x(idx(gap,2)),'*r');


%Close gaps in linear way
for gap = 1:numel(idx_row)
    %get image coordinates
    x1=coord_x(idx(gap,1));
    y1=coord_y(idx(gap,1));
    x2=coord_x(idx(gap,2));
    y2=coord_y(idx(gap,2));
    %Compute coordinates to make line between gap
    %n should cover the distance (eg very steep or small angles, 5 to the
    %right 1 in height) !look for x or y direction
    n=round(distances(idx(gap,1),idx(gap,2)),0);
    %n=abs(x1-x2)+1
    x=round(linspace(x1,x2,n),0);
    y=round(linspace(y1,y2,n),0);
    for pixel = 1:n
        IM2(x(pixel),y(pixel))=1;
    end
end
%Bridge one pixel gaps
IM3=bwmorph(IM2,'bridge');
%Compute new segmented shell 
TMnew=boundary_select2(IM3);