clc
clear
close all
%% model performance
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\ValOut\Met\metScore.mat')
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\ValOut\Pri\priScore.mat')
truelabel = [zeros(length(priScore),1);ones(length(metScore),1)];
[X,Y] = perfcurve(truelabel,[priScore;metScore],1);
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification by Logistic Regression')
AUC = trapz(X,Y);
predPri = priScore>0.5;
priVoteScore = sum(predPri)./length(predPri);
predMet = metScore>0.5;
metVoteScore = sum(predMet)./length(predMet);