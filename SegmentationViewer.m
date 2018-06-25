%Segmentation viewer

%Get preproc file
[File_preproc,Path,FilterIndex] = uigetfile('*.mat','Select preprocessing data-file');
%open preproc file
preproc = load(fullfile(Path,File_preproc));

%Get CT data folder
CT_path = uigetdir(preproc.FileInfo.path,'Select folder with CT images');
preproc.FileInfo.path=CT_path;

%Get post processed data
[File_postproc,Path,FilterIndex] = uigetfile('*.mat','Select postprocessing data-file',Path);

%Load CT images
FirstSlice = preproc.FileInfo.id_start; %First slice for segmentation, type char
LastSlice = preproc.FileInfo.id_stop;
CTstack=loadIMsequence(preproc.FileInfo,FirstSlice,LastSlice,1);

%Rotate stack
IMrot=zeros(size(squeeze(CTstack)),'uint16');
for slice=1:size(CTstack,4)
IMrot(:,:,slice) = imrotate(CTstack(:,:,:,slice),-preproc.orientation_angle-90,'crop');
end

%Free memory
clear CTstack
%Define IMrot again
Zstart=round(preproc.posXZ(1),0);
Zstop=Zstart+round(preproc.posXZ(3),0);
if Zstart < 1
    Zstart = 1;
end
if Zstop > (str2double(LastSlice)-str2double(FirstSlice)+1)
    Zstop = str2double(LastSlice)-str2double(FirstSlice)+1;
end
IMrot=IMrot(:,:,Zstart:Zstop);
[px_x,px_y,px_z] = size(IMrot);

%open post processed data
postproc = load(fullfile(Path,File_postproc));

%Start viewer
slider(FirstSlice,LastSlice,IMrot,postproc.TMnew,'Area');