clc
clear
close all
%% Pull out best epoch: Model and F1 score
methods ='wilcoxon';
mainPath = ['E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\ModelTrained_CVfixed\',methods,'\'];%E:\MvP\FinalExperimentWithPancreas\ModelTraining\ModelTrained_CVfixed\
saveMainPath = ['E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\BestModel_CVfixed\',methods,'\'];%E:\MvP\FinalExperimentWithPancreas\ModelTraining\BestModel_CVfixed\

familyDir = dir(mainPath);
familyDir = familyDir(3:end);
familyDir = familyDir([familyDir.isdir]);
familyList = string({familyDir.name}');
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
for i = 1:length(familyDir)
    status = load(strcat(mainPath,familyDir(i).name,'\stats_RF.mat'));
    savePath = strcat(saveMainPath,'\',familyDir(i).name,'\');
    LcreateFolder(savePath)
    status = status.stats_RF;
    for j = 1:length(organs)
        organ = organs(j);
        sprintf('Now Working on %s',string(organ))
        stats = status{j};
        AUC = cell2mat({stats.AUCs}');
        meanAUC = mean(AUC,2);
        idx_epoch = find(meanAUC ==  max(meanAUC), 1, 'last' );
        idx_CV = find(AUC(idx_epoch,:)==max(AUC(idx_epoch,:)), 1, 'last' );
        mdl = stats(idx_epoch).Mdl(idx_CV);
        mdl = mdl{1};
        modelStats = stats(idx_epoch);
        featIdx = stats(idx_epoch).topfeatinds(idx_CV,:);
        RF(i,j) = mean(stats(idx_epoch).Fscore);
        save(strcat(savePath,'bestRfFeatIdx_',organ,'.mat'),'featIdx')
        save(strcat(savePath,'bestRfMdl_',organ,'.mat'),'mdl')
        save(strcat(savePath,'bestRfModelStats_',organ,'.mat'),'modelStats')
    end
end
F1Table = table(familyList,RF(:,1),RF(:,2),RF(:,3),RF(:,4),...
    'VariableNames', ['FeatFamily',organs']);
writetable(F1Table,strcat(mainPath,'F1Table.xlsx'))