clc
clear
close all
%% Nuclear mask
NucMaskPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\MetMasks\rest\';% processed to be 1.25* need to be resized
tileSize = [256, 256]; % has to be a multiple of 16.
dbstop if error

input_page= 3; %the page of the svs file we're interested in loading, 40*
str_folder='E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\WSI\';
base_str_savepath='E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\'; LcreateFolder(base_str_savepath);


% str_folder='/mnt/projects/CSE_BME_AXM788/home/rina/usableCases/';
% str_savepath='/scratch/users/cxl884/TCGA_LUAD_40x_patch_size_2992/';


% dirim=dir([str_folder '*.tiff']);
dirim=dir([str_folder '*.tif']);
dirMsk =dir([NucMaskPath '*.png']);
mskName = string({dirMsk.name}');
mskName = extractBefore(mskName,'_mask_tumor.png');
imName = string({dirim.name}');
imName = extractBefore(imName,'.tif');
[~,idxMsk,idxIM] = intersect(mskName,imName);
dirim = dirim(idxIM);
dirMsk = dirMsk(idxMsk);
for i= 2%1:length(dirim)
    
    input_file=dirim(i).name;
    imName = extractBefore(input_file,'.tif');
    [~,baseFilename,~]=fileparts(input_file);
    input_msk=[imName,'_mask_tumor.png'];
    fprintf('On %d/%dth image, Case name: %s Mask name: %s\n',i,length(dirMsk),dirim(i).name,input_msk);
    msk = im2bw(imread(strcat(NucMaskPath,input_msk)));
    imgInfo = imfinfo(strcat(str_folder,input_file));
    msk_resized = imresize(msk,[imgInfo(input_page).Height,imgInfo(input_page).Width]);
    str_savepath=strcat(base_str_savepath,baseFilename,'\'); LcreateFolder(str_savepath);
    % ff=imfinfo([str_folder input_svs_file]);
    svs_adapter =PagedTiffAdapterWithMskReduced([str_folder input_file],input_page,msk_resized); %create an adapter which modulates how the large svs file is accessed
    
    % tic
    fun=@(block) imwrite(block.data,...
        sprintf('%s%s_%d_%d.png',str_savepath,baseFilename,...
        block.location(1),block.location(2))); %make a function which saves the individual tile with the row/column information in the filename so that we can refind this tile later
    blockproc(svs_adapter,tileSize,fun); %perform the splitting
    % toc
end