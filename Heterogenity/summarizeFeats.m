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

load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\finalSubfeatures.mat')% Feature Names
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\criteriaSubfeats.mat')% This was used to remove graph features


for k = 1:length(thumbDir)
    setDir = strcat(thumbMainPath,thumbDir(k).name,'\');
    savePath = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Allfeats256\Mets\');
    LcreateFolder(savePath)
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    featureFamily = featFamilies(1);% currently using all features
    clear distance
    criteria = false(size(imds.Files));
    allfeats = zeros(length(imds.Files),length(finalSub));
    
    parfor i =1:length(imds.Files)
        
        imgLoc = imds.Files{i};
        patchName = extractBetween(imgLoc,[thumbDir(k).name '\'],'.png');
        patchName = patchName{1};
        fileName = strcat(patchName,'.png_allFeats.mat');
        featLoc = strcat(featMainPath,...
            thumbDir(k).name,'\',patchName,'\',fileName);
        if exist(featLoc,'file')
            temp = load(featLoc);
            tt = temp.allFeats;
            if sum(isnan(tt))+sum(isinf(tt))==0
                fprintf('Now Working on: %s, %i\n',thumbDir(k).name,i)
                patchFeats = tt(criteriaSubfeats);
                allfeats(i,:) = patchFeats;
                criteria(i) = 1;
            end
        end
    end
    saveName = strcat(savePath,'allFeats_',...
        featureFamily,'_',thumbDir(k).name,'_Hetero256.mat');
    save(saveName,'allfeats')
    save(strcat(savePath,'criteria_',...
        featureFamily,'_',thumbDir(k).name,'_Hetero256.mat'),'criteria')
end
