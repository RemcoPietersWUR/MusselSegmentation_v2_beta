%Reprocess segmented mussel
clear all
%Suffix
Suffix = 'reproc';

%Get datafiles
rootdir = uigetdir('','Selected root folder with files to reprocess');
filelist = dir(rootdir);
currentFolder = pwd;
cd(rootdir)
files=dir('**/*postproc.mat');
cd(currentFolder)
[files_idx,~] = listdlg('PromptString','Select mussels:',...
               'SelectionMode','multiple',...
                'ListString',{files.name});

%Loop along selected mussels
Nmussel = numel(files_idx);
for sample = 1:Nmussel
   m = matfile(fullfile(files(files_idx(sample)).folder,files(files_idx(sample)).name));
   TM=m.TMnew;
   TMnew = false(size(TM));
   [~,~,px_z]=size(TM);
 for slice = 1:px_z
     TMnew(:,:,slice)=close_gap2(TM(:,:,slice),[0,100]);
 end

   clear TM
   [path,name,ext]=fileparts(fullfile(files(files_idx(sample)).folder,files(files_idx(sample)).name));
   new_name = strrep(name, 'postproc', 'repostproc');
   save([path, filesep, new_name,ext],'TMnew');
   
   
   %Calculate region properties
%first for slice 1 to determine size table
stats = regionprops('table',TMnew(:,:,1),'Area',...
    'BoundingBox','Centroid','Perimeter');
Slice = ones(height(stats),1).*1;
SliceProps = [table(Slice),stats];
for slice = 2:px_z
stats = regionprops('table',TMnew(:,:,slice),'Area',...
    'BoundingBox','Centroid','Perimeter');
Slice = ones(height(stats),1).*slice;
SliceProps = [SliceProps;[table(Slice),stats]];
end

   writetable(SliceProps,[path,filesep,new_name,'_ShellProps.csv'],'Delimiter','comma');
 clear TMnew
end
