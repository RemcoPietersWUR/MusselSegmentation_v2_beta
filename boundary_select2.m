function [TMnew]=boundary_select2(IM)

%Remove single pixel objects
IM = bwareaopen(IM,2);

%find boundaries
[Boundaries,L,N,A] = bwboundaries(IM,8,'holes');

% A
% Nbound = length(Boundaries)
% Nobject = N
% NA = nnz(A)
% size(A)
%
%
% for k = 1:N
%     k
%     enclosing_boundary  = find(A(k,:))
%     enclosed_boundaries = find(A(:,k))
% end



% Boundary k is the parent of a hole if the k-th column
% of the adjacency matrix A contains a non-zero element
% enclosing_boundary  = find(A(k,:));
% enclosed_boundaries = find(A(:,k));

% Single object & no holes -> N == 1, length(Boundaries)==1, nnz(A)==0 (number of
% none-zero elements)
% Output: Do nothing return already solid area
%
% Single object & holes -> N == 1, length(Boundaries)>1, nnz(A)>1. Boundary = Boundaries{N,1} is the parent boundary
% Boundary = Boundaries{N>1, 1} are the childs of that parent
% Output: Find centroid of parent boundary. Find centroids of all holes.
% Minimize distance -> inner boundary of shell. Fill parent boundary, fill
% inner bound - subtract -> output solid area.
%
% Multiple objects & no holes -> N > 1, length(Boundaries)=N, nnz(A)=0.
% Output: Find centroid of union convex hull. Find centroids of all holes.
% Minimize distance -> assume closest object belongs to shell. Draw
% selected boundary, fill image -> output
%
% Multiple objects & with holes -> N > 1, length(Boundaries)>N, nnz(A)>0.
% Output: Find centroid of union convex hull of all parents. Select parent
% - process like single object.

% Single object or multiple object.
if N > 1
    %Holes or no holes. Holes if nnz(A)>0
    if nnz(A) > 0
        %N>1 & holes
        %Get union convex hull of parents
        BWconvex = zeros(size(IM));
        for idx = 1:N
            boundary = Boundaries{idx,1};
            for k = 1:length(boundary)
                BWconvex(boundary(k,1),boundary(k,2))=1;
            end
        end
        centroid_hull = centroid_convexhull(BWconvex);
        %Get centroids of all objects
        centroids = centroids_objects(Boundaries,IM);
        %Minimize centroid distances to centroid convex hull
        distances = (centroids(:,1)-centroid_hull(1,1)).^2+...
            (centroids(:,2)-centroid_hull(1,2)).^2;
        [~,label]=sort(distances);
        %Get shell area.
        TMnew = shell_area(Boundaries, IM, label(1:2));
    else
        %N>1 & no holes
        centroid_hull = centroid_convexhull(IM);
        %Get centroids of all objects
        centroids = centroids_objects(Boundaries,IM);
        %Minimize centroid distances to centroid convex hull
        distances = (centroids(:,1)-centroid_hull(1,1)).^2+...
            (centroids(:,2)-centroid_hull(1,2)).^2;
        [~,label]=sort(distances);
        %Get shell area.
        TMnew = shell_area(Boundaries, IM, label(1:2));
    end
else
    %Single object
    %Holes or no holes. Holes if nnz(A)>0
    if nnz(A)>0
    %N=1 & holes
    %The parent boundary is the first boundary in the Boundaries cell aray
    %Find all centroids
    centroids = centroids_objects(Boundaries,IM);
    %Minimize centroid distances to centroid of the parent
    distances = (centroids(:,1)-centroids(1,1)).^2+...
            (centroids(:,2)-centroids(1,2)).^2;
        [~,label]=sort(distances);
    %Get shell area.
        TMnew = shell_area(Boundaries, IM, label(1:2));
    else
        %Single object & no holes do nothing
        TMnew = IM;
    end
        
end


%% Nested functions

%Centroid of convex hull
    function centroid_hull = centroid_convexhull(BWconvex)
        BWconvex = bwconvhull(BWconvex,'union');
        %Get centroid of convex hull
        s_hull = regionprops(BWconvex,'centroid');
        centroid_hull = cat(1, s_hull.Centroid);
    end
%Centroids of all objects
    function centroids = centroids_objects(Boundaries,IM)
        Nbounds = length(Boundaries);
        centroids = zeros(Nbounds,2);
        for idx = 1:Nbounds
            BW = zeros(size(IM));
            boundary = Boundaries{idx,1};
            for k = 1:length(boundary)
                BW(boundary(k,1),boundary(k,2))=1;
            end
            BW = imfill(BW,'holes');
            s = regionprops(BW,'centroid');
            centroids(idx,:) = cat(1, s.Centroid);
        end
    end
%Segmented area of shell
    function TMnew = shell_area(Boundaries, IM, label)
        %Boundary 1
        boundary1 = Boundaries{label(1),1};
        TM1 = zeros(size(IM));
        for k = 1:length(boundary1)
            TM1(boundary1(k,1),boundary1(k,2))=1;
        end
        TM1=imfill(TM1,'holes');
        Area1=bwarea(TM1);
        %Boundary 2
        boundary2 = Boundaries{label(2),1};
        TM2 = zeros(size(IM));
        for k = 1:length(boundary2)
            TM2(boundary2(k,1),boundary2(k,2))=1;
        end
        TM2=imfill(TM2,'holes');
        Area2=bwarea(TM2);
        if Area1 > Area2
            TMnew = imsubtract(TM1,TM2);
        else
            TMnew = imsubtract(TM2,TM1);
        end
    end

end
