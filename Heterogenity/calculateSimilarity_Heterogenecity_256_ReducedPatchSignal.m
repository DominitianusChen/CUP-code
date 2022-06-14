%% Calculate simlarity Between met tumor signal and primary patches
clc
clear
close all
%% Generate bag of image & calculate similarity
metMainPath = 'E:\MvP\PatchSelection\Results_Final\NewNormalization\'; % Used to identify feature familes
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\';% Primary Patches
featMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\Mets\';% Features of Primary Patches 
featFamilies = dir(metMainPath);
featFamilies = featFamilies(3:end);
featFamilies = string({featFamilies.name}'); % Get list of feature families, currently using all features
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\PatchSelected\Mets\40 II\featureStats.mat')%   Met Signals using reduced patch
featuresCombined = x';
% load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\allFeats.mat')%   Met Signals
% featuresCombined = allFeats'; %  featuresCombined(m x n): m->Num of Image, n->Num of Features
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\caseID.mat');% Name of each image
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\metStatus.mat')% Tumor origination & Metastatic information eg. ColonM = Mets from Colon
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\finalSubfeatures.mat')% Feature Names
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\criteriaSubfeats.mat')% This was used to remove graph features
%load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\criteriaAllfeats.mat')% This was used to remove graph features

for k = 1%:length(thumbDir)%3: 40 p
    
    idxP = find(strcmp(caseID,thumbDir(k).name));
    correspondingMet = caseID(idxP-1);
    correspondingMetFeat = featuresCombined(criteriaSubfeats)';
    setDir = strcat(thumbMainPath,thumbDir(k).name,'\');
    savePath = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\DistanceReduced\',thumbDir(k).name,'\');
    LcreateFolder(savePath)
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    flagDistance = 2;% Euclidian
    featureFamily = featFamilies(1);% currently using all features
    clear distance
    for i =1:length(imds.Files)
        imgLoc = imds.Files{i};
        patchName = extractBetween(imgLoc,[thumbDir(k).name '\'],'.png');
        patchName = patchName{1};
        fileName = strcat(patchName,'.png_allFeats.mat');
        featLoc = strcat(featMainPath,...
            thumbDir(k).name,'\',patchName,'\',fileName);
        if exist(featLoc,'file')
            distance(i) = searchImageHetero256(flagDistance,featLoc,correspondingMetFeat,criteriaSubfeats);
            fprintf(strcat(patchName,' is Done\n'));
        else
            distance(i) = Inf;
        end
    end
    saveName = strcat(savePath,'distance_',...
        featureFamily,'_Hetero256.mat');
    save(saveName,'distance')
end
