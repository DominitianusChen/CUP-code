clc
clear
close all
%% Violin plots top feats
featureFamilies = ["AllFeats","CytoHaralick","NucHaralick","NucShapeMorph"];
classifiers ="RF";
indMainPath = 'E:\MvP\FinalExperimentWithPancreas\ModelTraining\ModelTrained\wilcoxon\';
organs = ["Colon";"Esophagus";"Breast"];
featureMainPath = 'E:\MvP\FinalExperimentWithPancreas\NormalizedData\Test\';
caseID = load('E:\MvP\PatchSelection\Results_Final\NewNormalization\AllFeats\caseIDSave.mat');
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\metStatus.mat')
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\testIdx.mat')
cd =  metStatus(testIdx);
%% BuildLabel
% for i = 1:size(caseID,1)
%     temp = char(caseID(i));
%     if ~contains(caseID(i),'P')
%         caseID(i,3) = strcat(caseID,'M');
%         cd{i} = strcat(temp(1),'M');
%     else
%         caseID(i,3) = strcat(caseID(i,2),'P');
%         cd{i} = strcat(temp(1),'P');
%     end
% end
%% Random pick 12 cases
% rng('default')
% idxUse = [];
% for i = 1:length(organs)
%     idxM = find(caseID(:,3)==strcat(organs(i),'M'));
%     idxP = find(caseID(:,3)==strcat(organs(i),'P'));
%     rpM = randperm(length(idxM));
%     rpP = randperm(length(idxP));
%     idxUse = [idxUse;idxM(rpM(1:2));idxP(rpP(1:2))];
% end
idxUse = 1:51;
%% Violin plot
for i = 1%:length(featureFamilies)
    featPath = strcat(featureMainPath,featureFamilies(i),'\');
    %feats = load(strcat(featPath,'featuresCombined_normalized.mat'));
    descriptor = load(strcat(featPath,'descriptors_normalized.mat'));
    descriptor = descriptor.desNormal;
    %feats = feats.featuresCombined_normalized;
    feats = load('E:\MvP\FinalExperimentWithPancreas\UMAP\umap_Embedded.mat');
    feats = feats.UMAP;
    feats_norm = (feats-min(feats))./(max(feats)-min(feats));
    
    indPath = strcat(indMainPath,featureFamilies(i),'\topInds_',classifiers,'.mat');
    load(indPath);
    top1Inds = topInds(:,1);
    top1Inds = 1:3;
    for j = 1%:length(organs)
        top10FeatsData = feats(idxUse,:);
        top10FeatsData =top10FeatsData';
%         corrDist = pdist(top10FeatsData,'corr');
%         clusterTree = linkage(corrDist,'average');
%         clusters = cluster(clusterTree,'maxclust',3);
        rng('default');
        cgObj = clustergram(top10FeatsData,'ColumnLabels',cd(idxUse));
        cgObj.Colormap = redbluecmap;
        cgObj.DisplayRange = max(max(feats));
%         cgObj.ColumnPDist = 'correlation';
%         cgObj.Dendrogram = 0.1;
%         
    end
end
