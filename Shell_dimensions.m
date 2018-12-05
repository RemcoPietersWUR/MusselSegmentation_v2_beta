%Measure shell dimensions
clear all
%Suffix
PreprocessingSuffix = 'preproc';
PostprocessingSuffix = 'postproc';
%Second Moment of Area
%Principale axis
ax_range = 100; %search range for centroid


%Get datafiles
rootdir = uigetdir('','Selected root folder with mussel files to measure');
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
Nmussel =1;
for sample = 1:Nmussel
    %m_pre = matfile(fullfile(files(files_idx(sample)).folder,strrep(files(files_idx(sample)).name,PostprocessingSuffix,PreprocessingSuffix)));
    
    m_post = matfile(fullfile(files(files_idx(sample)).folder,files(files_idx(sample)).name));
    TMnew=m_post.TMnew;
    
    [~,~,px_z]=size(TMnew);
    
    
    clear TM
    [path,name,ext]=fileparts(fullfile(files(files_idx(sample)).folder,files(files_idx(sample)).name));
    new_name = strrep(name, 'postproc', 'repostproc');
    
    
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
        [path,name,ext]=fileparts(fullfile(files(files_idx(sample)).folder,files(files_idx(sample)).name));
     new_name = strrep(name, 'postproc', 'repostproc');
    %    writetable(SliceProps,[path,filesep,new_name,'_ShellProps.csv'],'Delimiter','comma');
    
    %Find maximum width of the shell using the boundingbox
    BB = SliceProps.BoundingBox;
    [MaxWidth,MaxWidthSlice]=max(BB(:,4));
    
    %Find second moment of area 
    Centroids=SliceProps.Centroid;
    x_foot = mean(Centroids(1:ax_range,1));
    y_foot = mean(Centroids(1:ax_range,2));
    x_nose = mean(Centroids(px_z-ax_range:px_z,1));
    y_nose = mean(Centroids(px_z-ax_range:px_z,2));
    principal_x = ((x_nose-x_foot)/px_z)*([1:px_z]-1)+x_foot;
    principal_y = ((y_nose-y_foot)/px_z)*([1:px_z]-1)+y_foot;
    %preallocate
    Ixx=zeros(px_z,1);
    Iyy=zeros(px_z,1);
    Ixy=zeros(px_z,1);
    for slice = 1:px_z
        [Ixx(slice),Iyy(slice),Ixy(slice)] = sec_mom_area(principal_x(slice),principal_y(slice),TMnew(:,:,slice));
    end
    figure
    plot(Ixx,'b')
    hold on
    plot(Iyy,'r')
    hold on
    plot(Ixy,'g')
    xlabel('Postion along z-axis (foot-nose)');
    ylabel('Second moment of area (px)');
    legend('Ixx','Iyy','Ixy');
    %Shell wall thickness
    Wall=cell(3,px_z);
    Counts = cell(1,px_z);
    for slice = 1:px_z
        BWhull = bwconvhull(TMnew(:,:,slice));
        [X,Y,delta]=Normal_lines(BWhull,100,TMnew(:,:,slice));
        [SecX,SecY,levels_deriv1]=Gradient_lines(X,Y,delta,TMnew(:,:,slice));
        [outline,inline]=out_in_line(SecX,SecY,levels_deriv1,TMnew(:,:,slice));
        %
        for i = 1:length(outline)
            L(i)=sqrt((outline(1,i)-inline(1,i)).^2+(outline(2,i)-inline(2,i)).^2);
        end
        Wall{1,slice}=outline;
        Wall{2,slice}=inline;
        Wall{3,slice}=L;
        Counts{1,slice} = histcounts(Wall{3,slice},'BinMethod','integers');
    end
 dim_name = strrep(name, 'postproc', 'dim');
 save([path, filesep, dim_name,ext],'MaxWidth','MaxWidthSlice','Wall','Counts','Ixx','Iyy','Ixy');   
end
