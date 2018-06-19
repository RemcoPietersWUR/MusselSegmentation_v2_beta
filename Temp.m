%close small gaps
IM = TM(:,:,686);%686
close all
% figure;
% imshow(IM)
% figure
% imshow(boundary_select2(IM))
% figure
IM2 = imadd(IM,boundary_select2(IM));
% imshow(IM2)
% figure
BW1=bwmorph(IM2,'remove');
% imshow(BW1)
% figure
BW2=bwmorph(IM2,'skel',Inf);
% imshow(BW2)
BWend=bwmorph(BW2,'endpoints');
figure
BW3 = immultiply(BWend,BW1);
imshow(BW3)
[row,col]=find(BW3);
%Nlines = ((length(row)-1)*length(row))/2; %summation 4+3+2+1
distances=zeros(length(row),length(row));
for k=1:length(row)
    for l = 1:length(row)
        distances(k,l) = sqrt((row(k)-row(l))^2+(col(k)-col(l))^2);
    end
end
[row2,col2]=find(distances>0 & distances<5);
hold on
plot(col(col2),row(col2),'*r')

%Get coordinates from col2 en fill BW image
