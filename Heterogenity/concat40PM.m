clc
clear
close all
%% Concatenate 40p and 40 II for UMAP
distance_40M = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Distance\40 II\distance_AllFeats_Hetero256.mat');
distance_40P = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Distance\40P (2)\distance_AllFeats_Hetero256.mat');
distance_40M = distance_40M.distance;
distance_40P = distance_40P.distance;
distance = [distance_40P,distance_40M];
label = [zeros(1,length(distance_40P)),ones(1,length(distance_40M))];
feats_40P = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Allfeats256\allFeats_AllFeats_40P (2)_Hetero256.mat');
feats_40M = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Allfeats256\Mets\allFeats_AllFeats_40 II_Hetero256.mat');
feats_40M = feats_40M.allfeats;
feats_40P = feats_40P.allfeats;
allfeats = [feats_40P;feats_40M];
cc_40P = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Allfeats256\criteria_AllFeats_40P (2)_Hetero256.mat');
cc_40M = load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Allfeats256\Mets\criteria_AllFeats_40 II_Hetero256.mat');
cc_40M = cc_40M.criteria;
cc_40P = cc_40P.criteria;
cc = [cc_40P;cc_40M];