clc
clear
close all
%% Preperation for Met vs Primary
addpath(genpath('E:\Feature Extract Code\Code'));
%addpath(genpath('E:\Feature Extract Code\Code\Segmentation\veta_watershed'));
stages = ["Test";"Train"];
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
for k = 1:length(stages)
    stg = stages(k);
    filePath = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteClassifying\',stg,'\');
    savePath = ['E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\HandcraftFeats\',char(stg),'\'];
    nucMskPath = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteNucMsks\',stg,'\');
    dirFile = dir(filePath);
    dirFile = dirFile(3:end);
    %% Extraction
    parfor i = 1:length(dirFile)
        fprintf(sprintf('Working on %s \n',dirFile(i).name))
        strPathIM=char(strcat(filePath,dirFile(i).name,'\'));%important Lextractfeature_v17 only take char array
        strSavePath=strcat(savePath,dirFile(i).name,'\');
        LcreateFolder(strSavePath);
        strEpiStrMaskPath='';
        strNucleiMaskPath=char(strcat(nucMskPath,'\',dirFile(i).name,'\'));
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
        tic
        Lextractfeature_v17_CytoHaralick(idxBegin,idxEnd,strWSIPath,flag_epistroma,strPathIM,strSavePath,...
            strEpiStrMaskPath,strNucleiMaskPath,flag_have_nulei_mask,flag_nuclei_cluster_finding,...
            image_format,flag_Hosoya,flag_haralick,flag_CCM,flag_WSI,para_nulei_scale_low,para_nulei_scale_high,flagRandomPatch)
        toc
    end
    
end
%% 
string(alldescription)
% Lextractfeature_v17(idxBegin,idxEnd,strWSIPath,flag_epistroma,strPathIM,strSavePath,...
%     strEpiStrMaskPath,strNucleiMaskPath,flag_have_nulei_mask,flag_nuclei_cluster_finding,...
%     image_format,flag_Hosoya,flag_haralick,flag_CCM,flag_WSI,para_nulei_scale_low,para_nulei_scale_high);