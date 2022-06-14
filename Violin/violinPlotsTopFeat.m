clc
clear
close all
%% Violin plots top feats
featureFamilies = ["AllFeats"];%,"CytoHaralick","NucHaralick","NucShapeMorph"];
classifiers ="wilcoxon";
indMainPath = 'E:\MvP\FinalExperimentWithPancreas\ModelTraining\ModelTrained\';
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
featureMainPath = 'E:\MvP\FinalExperimentWithPancreas\NormalizedData\Test\';
caseID = load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\metStatus.mat');
caseID = caseID.metStatus;
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\trainIdx.mat')
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\testIdx.mat')
caseID = caseID(testIdx);
% BuildLabel

for i = 1:size(caseID,1)
    temp = char(caseID(i));
    noMetLabel(i) = string(temp(1:end-1));
end
%% Violin plot
for i = 1%:length(featureFamilies)
    featPath = strcat(featureMainPath,featureFamilies(i),'\');
    feats = load(strcat(featPath,'featuresCombined_normalized.mat'));
    descriptor = load(strcat(featPath,'descriptors_normalized.mat'));
    descriptor = descriptor.desNormal;
    feats = feats.featuresCombined_normalized;
    indPath = strcat(indMainPath,'topFeats_',classifiers,'.xlsx');
    [name,ind] = xlsread(indPath,'AllFeatsIdx');
    top1Inds = name(1,1).*[1,1,1,1];%;topInds(:,1);
    for j = 1:length(organs)
        topInd = top1Inds(j);
        topFeat = feats(:,topInd);
        topDes = descriptor(topInd);
        idx_outLier = find(topFeat>=0.01);
        topFeat(idx_outLier) = [];
        cc =caseID;
        cc(idx_outLier) = [];
        nn = noMetLabel;
        nn(idx_outLier) = [];
        figure()
        newNorm = (topFeat-min(topFeat))./(max(topFeat)-min(topFeat));
        violins = violinplot(newNorm, cc);
        ylabel(topDes);
        %ylim([0 0.05])
        title(sprintf('Best feat to group Mets and Primaries from %s', organs(j)))
    end
end
%% Try ridge plot
