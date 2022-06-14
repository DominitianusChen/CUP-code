%% Calculate simlarity for 2v2 scenario
clc
clear
close all
%% Generate bag of image & calculate similarity
metMainPath = 'E:\MvP\PatchSelection\Results_Final\NewNormalization\';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\Patch\';
featMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\Feats\';
featFamilies = dir(metMainPath);
featFamilies = featFamilies(3:end);
featFamilies = string({featFamilies.name}');
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\allFeats.mat')
featuresCombined = allFeats';
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\caseID.mat');
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\metStatus.mat')
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\criteriaNaN.mat')
for k = 1:length(thumbDir)
    
    idxP = find(strcmp(caseID,thumbDir(k).name));
    correspondingMet = caseID(idxP);
    correspondingMetFeat = featuresCombined(idxP-1,:);
    setDir = strcat(thumbMainPath,thumbDir(k).name,'\');
    savePath = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Distance\',thumbDir(k).name,'\');
    LcreateFolder(savePath)
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    flagDistance = 2;% Euclidian
    featureFamily = featFamilies(1);% all feats
    
%     featImportance = load(strcat('E:\MvP\PatchSelection\Results_Final\CBIR\','FeatImportance\',thumbDir(k).name,'\',des,'\featImportance_',...
%         organPair,'_',char(featureFamily),'_09-29-2020.mat'));
%     featImportance = featImportance.featImportance';
    %featImportance = ones(length(featImportance),1);
    clear distance
    for i =1:length(imds.Files)
        imgLoc = imds.Files{i};
        patchName = extractBetween(imgLoc,[thumbDir(k).name '\'],'.png');
        patchName = patchName{1};
        fileName = strcat(patchName,'.png_allFeats.mat');
        featLoc = strcat(featMainPath,...
        thumbDir(k).name,'\',patchName,'\',fileName);
        distance(i) = searchImageHetero(flagDistance,featLoc,correspondingMetFeat,criteriaNaN);
        fprintf(strcat(patchName,' is Done\n'));
    end
    
    saveName = strcat(savePath,'distance_',...
        featureFamily,'_HeteroMets.mat');
    save(saveName,'distance')
end
