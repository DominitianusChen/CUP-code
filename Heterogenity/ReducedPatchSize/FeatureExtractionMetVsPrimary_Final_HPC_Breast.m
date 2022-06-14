clc
clear
close all
%% Preperation for Met vs Primary
%addpath(genpath('/mnt/pan/Data7/cxc646/Code/Code/'));
%addpath(genpath('E:\Feature Extract Code\Code\Segmentation\veta_watershed'));
%dbstop if error
organs = ["Breast"];
for j = 1:length(organs)
    organ = organs(j);
    filePath = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\');
    savePath = ['E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\Mets\'];
    dirFile = dir(filePath);
    dirFile = dirFile(3:end);
    dirFile = dirFile([1 2 4]);% skip 40M since its finished
    nucMskMain = ['E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\NucCleansed\Mets\'];
    tic
    %% Extraction
    parfor i = 1:length(dirFile)
        %fprintf(sprintf('Working on %s \n',dirFile(i).name))
        strPathIM=char(strcat(filePath,'/',dirFile(i).name,'/'));%important Lextractfeature_v17 only take char array
        strSavePath=strcat(savePath,dirFile(i).name,'/');
        LcreateFolder(strSavePath);
        strEpiStrMaskPath='';
        %strNucleiMaskPath=char(strcat(nucMskPath,'\',dirFile(i).name,'\'));
        strNucleiMaskPath= [nucMskMain,dirFile(i).name,'/'];
        flag_nuclei_cluster_finding=0;
        image_format='.png';
        para_nulei_scale_low=8;
        para_nulei_scale_high=18;
        flag_have_nulei_mask=1;
        flag_epistroma=0;
        strWSIPath='';
        strWSI_format=image_format;
        idxBegin=1;
        %idxEnd=idxBegin;
        idxEnd=15;
        flag_Hosoya = 0;% proved useless
        flag_haralick =0;% Switch to faster version
        flag_CCM = 0;
        flag_WSI = 0;
        flagRandomPatch = [0,15];% Random Pick 15 pictures Modify by Chuheng
        
        Lextractfeature_v17_MvP_256(idxBegin,idxEnd,strWSIPath,flag_epistroma,strPathIM,strSavePath,...
            strEpiStrMaskPath,strNucleiMaskPath,flag_have_nulei_mask,flag_nuclei_cluster_finding,...
            image_format,flag_Hosoya,flag_haralick,flag_CCM,flag_WSI,para_nulei_scale_low,para_nulei_scale_high,flagRandomPatch)
        
    end
    toc
end