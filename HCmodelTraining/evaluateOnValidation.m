clc
clear
close all
%% Evaluate model on validation set
methods ='wilcoxon';
% mdlMainPath = ['E:\MvP\FinalExperimentWithPancreas\ModelTraining\BestModel_CVfixed\',methods,'\'];
% featMainPath = 'E:\MvP\FinalExperimentWithPancreas\NormalizedData\Test\';
mdlMainPath = ['E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\BestModel_CVfixed\',methods,'\'];
featMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Test\';
dirFeatFamily = dir(featMainPath);
dirFeatFamily = dirFeatFamily(3:end);
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
% load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\metStatus.mat')
% load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\testIdx.mat')
load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\metStatus.mat')
load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\caseID.mat')
metStatus(66) = [];
caseID(66) = [];
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\testIdx_Primoved.mat')
trueLabel =  metStatus(testIdx);
saveMainPath = ['E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\PerformaceOnValidation_CVfixed\',methods,'\'];
LcreateFolder(saveMainPath)
saveName = strcat(saveMainPath,'AUC_on_ValidationPremoved.mat');
for i = 1:length(dirFeatFamily)
    featFamily = dirFeatFamily(i).name;
    load(strcat(featMainPath,featFamily,'\featuresCombined_normalized.mat'))
    for j = 1:length(organs)
        organ = organs(j);
        tl(:,j) = contains(trueLabel, organ);
        load(strcat(mdlMainPath,featFamily,'\bestRfFeatIdx_',organ,'.mat'))
        load(strcat(mdlMainPath,featFamily,'\bestRfMdl_',organ,'.mat'))
        data = featuresCombined_normalized;
        data = data(:,featIdx);
        [predictLabel,score] = predict(mdl,data);
        score = score(:,2);
        [X,Y,~,AUC(j)] = perfcurve(tl(:,j),score,1);
        if iscell(predictLabel)
            pl(:,j) = str2num(cell2mat(predictLabel));
        else
            pl(:,j) = predictLabel;
        end
        cp{j} = classperf(tl(:,j),pl(:,j));
        conf = cp{j}.DiagnosticTable;
        tp = conf(1,1);
        fp = conf(1,2);
        fn = conf(2,1);
        tn = conf(2,2);
        F1(j) = tp/(tp+0.5*(fp+fn));
    end
    AUCTable(i,:) = AUC;
    F1Table(i,:) = F1;
end
save(saveName,'AUCTable')