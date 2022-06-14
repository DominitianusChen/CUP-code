clc
clear
close all
%% cleansing patches
patchDir = dir('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\PvM\**\*.png');
patchSize = cell2mat({patchDir.bytes}');
criteria = patchSize<= 1024*90;%remove patch<90 kb
patchDir = patchDir(criteria);
for i = 1:length(patchDir)
    delete(fullfile(patchDir(i).folder,patchDir(i).name))
end