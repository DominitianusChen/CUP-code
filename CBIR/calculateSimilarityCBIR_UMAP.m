clc
clear
close all
%% Generate bag of image & calculate similarity using UMAP embeded data
dbstop if error
mainPath = 'E:\MvP\PatchSelection\Results\UMAPDataToCalculateDistance\';
featFamilies = dir('E:\MvP\FinalExperiment\NormalizedData\Train');
featFamilies = featFamilies(3:end);
featFamilies = featFamilies([featFamilies.isdir]);
featFamilies = string({featFamilies.name}');
%load('E:\MvP\PatchSelected\metStatus.mat')
load('E:\MvP\PatchSelected\caseID.mat')
load('E:\MvP\PatchSelected\testIdx.mat')
% cd =  metStatus(testIdx);
fileName = caseID(testIdx);
load('E:\MvP\FinalExperimentWithPancreas\UMAP\umap_Embedded.mat')
for j = 1:length(featFamilies)
    featLoc = strcat(mainPath,featFamilies(j));
    featLoc = 'E:\MvP\FinalExperimentWithPancreas\UMAP\umap_Embedded.mat';
    setDir = 'E:\ColonMetastasisVsPrim\Thumbnails\Paired\';
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    flagDistance = 2;% Euclidian
    featureFamily = featFamilies(j);
    
    featImportance = ones(3,1);
    
%     for i =1:length(imds.Files)
%         imgLoc = imds.Files{i};
%         imageName = imgLoc;
%         
%         [distance{i}] = searchImage0912UMAP(imageName, imds.Files,...
%             flagDistance,featLoc,featImportance);
%     end
    distance = squareform(pdist(UMAP));
    savePath = 'E:\MvP\FinalExperimentWithPancreas\CBIR\Distance\UMAPDistance\';
    LcreateFolder(savePath);
    saveName = strcat(savePath,'distance_',featureFamily,'_UMAP.mat');
    save(saveName,'distance')
end