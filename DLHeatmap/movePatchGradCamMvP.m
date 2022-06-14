clc
clear
close all
%% move patch for gradcam: MvP
oriDir = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\**\*.png');
saveLoc = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\PvM\WSI\Pri\';
parfor i = 1:length(oriDir)
    newLoc = fullfile(saveLoc,oriDir(i).name);
    oldLoc = fullfile(oriDir(i).folder,oriDir(i).name);
    copyfile(oldLoc,newLoc)
end