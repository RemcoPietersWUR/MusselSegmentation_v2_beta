%Wall thickness

BWhullT = bwconvhull(TMnew(:,:,20));
[TX,TY,Tdelta]=Normal_lines(BWhullT,100,TMnew(:,:,20));
[TSecX,TSecY,Tlevels_deriv1]=Gradient_lines(TX,TY,Tdelta,TMnew(:,:,20));
[Toutline,Tinline]=out_in_line(TSecX,TSecY,Tlevels_deriv1,TMnew(:,:,20));
%
for i = 1:length(Toutline)
    L(i)=sqrt((Toutline(1,i)-Tinline(1,i)).^2+(Toutline(2,i)-Tinline(2,i)).^2);
end
figure
plot(L)
ylabel('Shell thickness (pixels)')
xlabel('Position along shell perimeter')
figure
histogram(L)
title('Shell thickness distribution')
xlabel('Shell thickness (pixels)')
ylabel('Counts')