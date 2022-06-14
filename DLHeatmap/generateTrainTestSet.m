clc
clear
close all
%% copy and move
metsPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\';
priPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\';
savePath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Train\';
for stage = 1:2
    switch stage
        case 1
            dirFile = dir(metsPath);
            strSavePath = strcat(savePath,'Met\');
        case 2
            dirFile = dir(priPath);
            strSavePath = strcat(savePath,'Pri\');
    end
    dirFile = dirFile(3:end);
    dirFile = dirFile([1 2 4]);
    for i =1:length(dirFile)
        patchDir = dir(fullfile(dirFile(i).folder,dirFile(i).name,'*.png'));
        parfor j = 1:length(patchDir)
            imgLoc =fullfile(patchDir(j).folder,patchDir(j).name);
            strSaveName = strcat(strSavePath,patchDir(j).name);
            copyfile(imgLoc,strSaveName);
        end
    end
end