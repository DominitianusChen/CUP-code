clc
clear
close all
%% Nuclear mask

tileSize = [2048, 2048]; % has to be a multiple of 16.
dbstop if error

input_page= 3; %the page of the svs file we're interested in loading, 40*
str_folder='E:\MvP\PatchSelection\Results_Final\CBIR\Heterogenicity\';
base_str_savepath='E:\MvP\PatchSelection\Results_Final\CBIR\Heterogenicity\Patch\'; LcreateFolder(base_str_savepath);


% str_folder='/mnt/projects/CSE_BME_AXM788/home/rina/usableCases/';
% str_savepath='/scratch/users/cxl884/TCGA_LUAD_40x_patch_size_2992/';


% dirim=dir([str_folder '*.tiff']);
dirim=dir([str_folder '*.tif']);
imName = string({dirim.name}');
imName = extractBefore(imName,'.tif');
for i= 1:length(dirim)
    
    input_file=dirim(i).name;
    imName = extractBefore(input_file,'.tif');
    [~,baseFilename,~]=fileparts(input_file);
    
    str_savepath=strcat(base_str_savepath,baseFilename,'\'); LcreateFolder(str_savepath);
    % ff=imfinfo([str_folder input_svs_file]);
    svs_adapter =PagedTiffAdapter([str_folder input_file],input_page); %create an adapter which modulates how the large svs file is accessed
    
    % tic
    fun=@(block) imwrite(block.data,...
        sprintf('%s%s_%d_%d.png',str_savepath,baseFilename,...
        block.location(1),block.location(2))); %make a function which saves the individual tile with the row/column information in the filename so that we can refind this tile later
    blockproc(svs_adapter,tileSize,fun); %perform the splitting
    % toc
end