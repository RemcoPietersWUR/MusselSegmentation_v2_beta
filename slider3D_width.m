function [Zslide]=slider3D_width(CTvol)
%Slider #D volume GUI

%Image volume size
[px_x,px_y,px_z]=size(CTvol);


%Setup figure
scrsz = get(groot,'ScreenSize');
hFig = figure('Position',[20,50,scrsz(3)-40,scrsz(4)-150]);
hFig.Resize = 'off';
plotsz = hFig.InnerPosition;

subplot(1,3,1)
imshow(squeeze(CTvol(:,:,round(px_z/2,0))));
title('XY view')
XYaxis = gca;

subplot(1,3,2)
imshow(squeeze(CTvol(:,round(px_y/2,0),:)));
title('XZ view')
XZaxis = gca;

subplot(1,3,3)
imshow(squeeze(CTvol(round(px_x/2,0),:,:)));
title('YZ view')
YZaxis = gca;

%Slider control
sliceZ=round(px_z/2,0);
uicontrol('Parent',hFig, 'Style','slider', 'Value',sliceZ, 'Min',1,...
    'Max',px_z, 'SliderStep', [0.01 0.10], ...
    'Position',[plotsz(1)+20 plotsz(4)/2-150 20 300], 'Callback',@sliderZ_callback)
%Text above Z-slider
hTxtZ = uicontrol('Style','text', 'Position',[plotsz(1)+20 plotsz(4)/2-190 20 20], 'String',['Z']);
%Y-slider
sliceY=round(px_y/2,0);
uicontrol('Parent',hFig, 'Style','slider', 'Value',sliceY, 'Min',1,...
    'Max',px_y, 'SliderStep', [0.01 0.10], ...
    'Position',[plotsz(1)+50 plotsz(4)/2-150 20 300], 'Callback',@sliderY_callback)
%Text above Y-slider
hTxtY = uicontrol('Style','text', 'Position',[plotsz(1)+50 plotsz(4)/2-190 20 20], 'String',['Y']);
%X-slider
sliceX=round(px_x/2,0);
uicontrol('Parent',hFig, 'Style','slider', 'Value',sliceX, 'Min',1,...
    'Max',px_x, 'SliderStep', [0.01 0.10], ...
    'Position',[plotsz(1)+80 plotsz(4)/2-150 20 300], 'Callback',@sliderX_callback)
%Text above X-slider
hTxtX = uicontrol('Style','text', 'Position',[plotsz(1)+80 plotsz(4)/2-190 20 20], 'String',['X']);

% %Draw ellipse
% color_out='r';
% color_in='y';
% %Outer
% XYellipse_out=imellipse(XYaxis,[px_y*0.05,px_x*0.05,px_y*0.9,px_x*0.9]);
% setColor(XYellipse_out,color_out)
% XZellipse_out=imellipse(XZaxis,[px_z*0.05,px_x*0.05,px_z*0.9,px_x*0.9]);
% setColor(XZellipse_out,color_out)
% YZellipse_out=imellipse(YZaxis,[px_z*0.05,px_y*0.05,px_z*0.9,px_y*0.9]);
% setColor(YZellipse_out,color_out)

%Draw line in center
color_1='r';
color_2='y';
XYline1=imline(YZaxis,[px_z*0.5,px_z*0.5],[0, px_y]);
setColor(XYline1,color_1)
XYline2=imline(XZaxis,[px_z*0.5,px_z*0.5],[0, px_x]);
setColor(XYline2,color_2)
%Inner
% XYellipse_in=imellipse(XYaxis,[px_y*0.2,px_x*0.2,px_y*0.6,px_x*0.6]);
% setColor(XYellipse_in,color_in)
% XZellipse_in=imellipse(XZaxis,[px_z*0.2,px_x*0.2,px_z*0.6,px_x*0.6]);
% setColor(XZellipse_in,color_in)
% YZellipse_in=imellipse(YZaxis,[px_z*0.2,px_y*0.2,px_z*0.6,px_y*0.6]);
% setColor(YZellipse_in,color_in)
% Callback functions
    function sliderZ_callback(hObj, eventdata)
        %Get slide number from slider position
        sliceZ = round(get(hObj,'Value'),0);

         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
        subplot(1,3,1)
        imshowpair(squeeze(CTvol(:,:,round(sliceZ,0))),squeeze(CTvol(:,:,round(posXZ_out(1),0))));
        title('XY view (lateral view - purple / z-slider green)')
        hold off

         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
    end
    function sliderY_callback(hObj, eventdata)
        %Get slide number from slider position
        sliceY = round(get(hObj,'Value'),0);
         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
        subplot(1,3,2)
        imshow(squeeze(CTvol(:,round(sliceY,0),:)));
        title('XZ view ')
        hold off
        XYline2=imline(XZaxis,[posXZ_out(1),posXZ_out(1)],[0, px_x]);
        setColor(XYline2,color_2)
        
        subplot(1,3,1)
        imshowpair(squeeze(CTvol(:,:,round(sliceZ,0))),squeeze(CTvol(:,:,round(posXZ_out(1),0))));
        title('XY (lateral view - purple / z-slider green)')
        hold off

        subplot(1,3,3)
        imshow(squeeze(CTvol(round(sliceX,0),:,:)));
        title('YZ view')
        hold off
        XYline1=imline(YZaxis,[posXZ_out(1),posXZ_out(1)],[0, px_y]);
        setColor(XYline1,color_1)
         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
    end
    function sliderX_callback(hObj, eventdata)
        %Get slide number from slider position
        sliceX = round(get(hObj,'Value'),0);
         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
        subplot(1,3,3)
        imshow(squeeze(CTvol(round(sliceX,0),:,:)));
        title('YZ view')
        hold off
        XYline1=imline(YZaxis,[posYZ_out(1),posYZ_out(1)],[0, px_y]);
        setColor(XYline1,color_1)
        subplot(1,3,1)
        imshowpair(squeeze(CTvol(:,:,round(sliceZ,0))),squeeze(CTvol(:,:,round(posYZ_out(1),0))));
        title('XY view (lateral view - purple / z-slider green)')
        hold off
        subplot(1,3,2)
        imshow(squeeze(CTvol(:,round(sliceY,0),:)));
        title('XZ view')
        hold off
        XYline2=imline(XZaxis,[posYZ_out(1),posYZ_out(1)],[0, px_x]);
        setColor(XYline2,color_2)
         posXZ_out = getPosition(XYline2);
         posYZ_out = getPosition(XYline1);
    end
uiwait(hFig);
Zslide = round(posXZ_out(1),0);
end