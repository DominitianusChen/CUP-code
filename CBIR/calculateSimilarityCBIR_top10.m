clc
clear
close all
%% Generate bag of image & calculate similarity using Top10 feats
dbstop if error
mainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Test\';
featFamilies = dir('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Train');
savePath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\CBIR\Distance\Distance\';
indMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\ModelTrained_CVfixed\wilcoxon\';
featFamilies = featFamilies(3:end);
featFamilies = featFamilies([featFamilies.isdir]);
featFamilies = string({featFamilies.name}');
%load('E:\MvP\PatchSelected\metStatus.mat')
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\trainIdx.mat')
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\testIdx.mat')
for j = 1:length(featFamilies)
    featLoc = strcat(mainPath,featFamilies(j));
    idxLoc = strcat(indMainPath,featFamilies(j));
    feats = load(strcat(featLoc,'\featuresCombined_normalized.mat'));
    feats = feats.featuresCombined_normalized;
    topInds = load(strcat(idxLoc,'\topInds_RF.mat'));
    topIdx = topInds.topInds;
    if j == 5 %special case for FD due to only 4 FD features exists
        numFeats = 4;
        ti = topIdx(:);
        ti(ti ==0) = []; 
    else
        numFeats = 10;
        ti = topIdx(:);
    end
    [gr,gc] = groupcounts(ti);
    [~,idx] = sort(gr,'descend');
    top10Idx = gc(idx(1:numFeats));
    featsTop10 = feats(:,top10Idx);
    featureFamily = featFamilies(j);
    %     setDir = 'E:\ColonMetastasisVsPrim\Thumbnails\Paired\';
    %     imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
    %         'foldernames');
    %     flagDistance = 2;% Euclidian
    
    %
    %     featImportance = ones(3,1);
    
    %     for i =1:length(imds.Files)
    %         imgLoc = imds.Files{i};
    %         imageName = imgLoc;
    %
    %         [distance{i}] = searchImage0912UMAP(imageName, imds.Files,...
    %             flagDistance,featLoc,featImportance);
    %     end
    distance = squareform(pdist(featsTop10));
    
    LcreateFolder(savePath);
    saveName = strcat(savePath,'distance_',featureFamily,'_top10.mat');
    save(saveName,'distance')
end