function [outline,inline]=out_in_line(SecX,SecY,levels_deriv1,IM)
%Compute outer and inner boundery line of the shell.
%Capital X,Y represent line sections (coordinate 1, coordinate 2)
%Capital SecX,SecY reprsent coordinates of pixels along line section

%Input:
%X,Y line sections to compute gradient
%Delta normalized displacement along perimenter
%IM only for visulatisation

%Output:
%outline coordinates of outer perimeter
%inline coordnates of inner perimter
visualisation = true;

%Find outer- en inner line of the shell
%Preallocation
outline = zeros(2,numel(SecX));
inline = zeros(2,numel(SecY));
for i = 1:numel(SecX)
        [~,in_edg]=max(levels_deriv1{1,i});
        [~,out_edg]=min(levels_deriv1{1,i});
        outline(:,i)=[SecX{1,i}(in_edg),SecY{1,i}(in_edg)];
        inline(:,i)=[SecX{1,i}(out_edg),SecY{1,i}(out_edg)];
end
if visualisation
figure
imshow(IM)
hold on
scatter(outline(2,:),outline(1,:),'.r')
hold on
scatter(inline(2,:),inline(1,:),'.g')
end

end
