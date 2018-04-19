function [TMnew]=boundary_select(IM)

%find boundaries
[Boundaries,L,N,A] = bwboundaries(IM,8,'holes');
Nbound = length(Boundaries);
Nobject = N;
%if Nbound > Nobjects these boundaries are holes.
for idx = 1:numel(Boundaries)
    BW=zeros(size(IM));
    Boundary=Boundaries{idx,1};
    for k = 1:length(Boundary)
        BW(Boundary(k,1),Boundary(k,2))=1;
    end
    BW2 = imfill(BW,'holes');
    s = regionprops(BW2,'centroid');
    centroids(idx,:) = cat(1, s.Centroid);
end

if Nobject < Nbound
    if Nobject ==  1
    s = regionprops(imfill(bwperim(L),'holes'),'centroid');
    centroids(idx+1,:) = cat(1, s.Centroid);
    %temp-section
        distances = (centroids(1:idx,1)-centroids(idx+1,1)).^2+...
    (centroids(1:idx,2)-centroids(idx+1,2)).^2;
[~,Label]=sort(distances);
    else
        %add function
%         Boundaries
%         for k = 1:Nobject
%             k
%     enclosing_boundary  = find(A(k,:))
%     enclosed_boundaries = find(A(:,k))
%         end
    end

else
    s = regionprops(bwconvhull(bwperim(L),'union'),'centroid');
    centroids(idx+1,:) = cat(1, s.Centroid);
    %temp-section
    distances = (centroids(1:idx,1)-centroids(idx+1,1)).^2+...
    (centroids(1:idx,2)-centroids(idx+1,2)).^2;
[~,Label]=sort(distances);
end
% distances = (centroids(1:idx,1)-centroids(idx+1,1)).^2+...
%     (centroids(1:idx,2)-centroids(idx+1,2)).^2;
% [~,Label]=sort(distances);
if Nobject < Nbound
    if Nobject ==  1
    select_centroid = Label(1:2);
    bound1 = Boundaries{Label(1),1}; %selected boundary 1
    bound2 = Boundaries{Label(2),1};
    TMbound1=zeros(size(IM));
    for k = 1:length(bound1)
        TMbound1(bound1(k,1),bound1(k,2))=1;
    end
    TMbound1 = imfill(TMbound1,'holes');
    Areabound1 = bwarea(TMbound1);
    TMbound2=zeros(size(IM));
    for k = 1:length(bound2)
        TMbound2(bound2(k,1),bound2(k,2))=1;
    end
    TMbound2 = imfill(TMbound2,'holes');
    Areabound2 = bwarea(TMbound2);
    if Areabound1 > Areabound2
        TMnew = imsubtract(TMbound1,TMbound2);
    else
        TMnew = imsubtract(TMbound2,TMbound1);
    end
    else
        %temp-section
        TMnew = IM;
    end
else
    select_centroid = Label(1); %single object without hole
    bound1 = Boundaries{Label(1),1}; 
        TMbound1=zeros(size(IM));
    for k = 1:length(bound1)
        TMbound1(bound1(k,1),bound1(k,2))=1;
    end
    TMnew = imfill(TMbound1,'holes');
end

% figure
% imshow(IM)
% hold on
% scatter(centroids(1:idx,1),centroids(1:idx,2),'b')
% scatter(centroids(idx+1,1),centroids(idx+1,2),'r')
% scatter(centroids(select_centroid(:),1),centroids(select_centroid(:),2),'g')
% if Nobject < Nbound
%     plot(bound1(:,2),bound1(:,1),'r')
%     plot(bound2(:,2),bound2(:,1),'g')
% else
%     plot(bound1(:,2),bound1(:,1),'r')
% end

%look for closest centroid to main centroid (hull)
% Use N for ignoring wax