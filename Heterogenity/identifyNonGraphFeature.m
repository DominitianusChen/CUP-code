clc
clear
close all
%% generate non-graph feature criteria
load('E:\MvP\FinalExperimentWithPancreas\NaNRemovedRaw\fixedAllFeatName.mat')
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\allFeatsNames.mat')
alldescription{199} = 'FD-Boxsize_6';
subDes = string(alldescription);
criteriaAllfeats = contains(descriptors,'BasicShape-')|...
    contains(descriptors,'CytoHara-')|...
    contains(descriptors,'Harralick')|...
    contains(descriptors,'Morph');
testSub = descriptors(criteriaAllfeats);
criteriaSubfeats = contains(subDes,'BasicShape-')|...
    contains(subDes,'CytoHara-')|...
    contains(subDes,'Harralick')|...
    contains(subDes,'Morph');
finalSub = subDes(criteriaSubfeats);
save('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\finalSubfeatures.mat','finalSub')
save('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\criteriaSubfeats.mat','criteriaSubfeats')
save('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\criteriaAllfeats.mat','criteriaAllfeats')