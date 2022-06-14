clc
clear
close all
%% Mean AUC over 100 ITERATION
classifiers = ["LDA","QDA","SVM","RF"];
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
fileMainPath = 'E:\MvP\FinalExperimentWithPancreas\ModelTraining\ModelTrained_CVfixed\wilcoxon\';
fileDir = dir(fileMainPath);
fileDir = fileDir(3:end);
fileDir = fileDir([fileDir.isdir]);
featFamilies = string({fileDir.name}');
saveName = strcat(fileMainPath,'meanAUCoverIterations.xlsx');
for j = 1:length(featFamilies)
    featFamily = featFamilies(j);
    for i =1:length(classifiers)
        classifier = classifiers(i);
        statPath = strcat(fileMainPath,featFamily,'\stats_',classifier,'.mat');
        stats = load(statPath);
        switch classifier
            case 'LDA'
                stats = stats.stats_LDA;
            case 'QDA'
                stats = stats.stats_QDA;
            case 'SVM'
                stats = stats.stats_SVM;
            case 'RF'
                stats = stats.stats_RF;
        end
        for k = 1:length(stats)
            status = stats{k};
            AUCs = [status.AUCs];
            avgAUC(i,k) = mean(AUCs);
        end
    end
    AUCtable = table(avgAUC(:,1),avgAUC(:,2),avgAUC(:,3),avgAUC(:,4),...
        'VariableNames',organs,'RowNames',classifiers);
    writetable(AUCtable,saveName,'Sheet',featFamily)
end