clc
clear
close all
%% Pull out top features extracted by FS and tested by 3-Fold CV RF classifier

featMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Test\';
dirFeatFamily = dir(featMainPath);
featureFamilies = dirFeatFamily(3:end);
classifiers ="RF";
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
mdlMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\ModelTrained_CVfixed\wilcoxon\';
numOfFeats = 10;
for i = 1:length(featureFamilies)
    mdlPath = strcat(mdlMainPath,featureFamilies(i).name,'\stats_',classifiers,'.mat');
    load(mdlPath);
    topInds = [];
    for j = 1:length(organs)
        stats = stats_RF{j};
        temp = [];
        for k = 1:100
            temp = [temp;stats(k).topfeatinds(:)];
            
        end
        [counts,FeatIndex] = groupcounts(temp);
        [~,ia]=sort(counts,'descend');
        FeatIndex = FeatIndex(ia);
        if length(FeatIndex)<numOfFeats
            topIndex = zeros(1,10);
            topIndex(1:length(FeatIndex)) = FeatIndex;
        else
        topIndex = FeatIndex(1:numOfFeats);
        end
        topInds(j,:) = topIndex;
    end
    savePath = strcat(mdlMainPath,featureFamilies(i).name,'\topInds_',classifiers,'.mat');
    save(savePath,'topInds')
end
