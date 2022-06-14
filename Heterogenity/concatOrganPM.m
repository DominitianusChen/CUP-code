clc
clear
close all
%% Concate PatchWise allFeats
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\AllfeatsOrgan\';
featsMainPath = 'E:\MvP\PatchSelected\';
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
for i =1:3%length(saveMainPath)
    organ = organs(i);
    savePath = strcat(saveMainPath,organ,'\');
    LcreateFolder(savePath)
    featsPath = strcat(featsMainPath,organ,'\');
    featsDir = dir(strcat(featsPath,'*\featureTable.mat'));
    allfeats = [];
    label = [];
    for j = 1:length(featsDir)
        caseName = split(featsDir(j).folder,'\');
        caseName = char(caseName(end));
        ff = load(fullfile(featsDir(j).folder,featsDir(j).name));
        ff = ff.x(:,2:end);% first colmn is filler to replace string feature name to reduce size
        ll = ~contains(caseName,'P').*ones(size(ff,2),1); % 0: P 1:M
        allfeats = [allfeats,ff];
        label = [label;ll];
    end
    save(strcat(savePath,'allFeats.mat'),'allfeats')
    save(strcat(savePath,'labels.mat'),'label')
end