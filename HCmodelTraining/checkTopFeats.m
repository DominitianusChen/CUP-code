clc
clear
close all
%% Check top features
methods = 'wilcoxon';
modelType = 'RF';
numFeats = 10;
%savePath = 'E:\MvP\FinalExperimentWithPancreas\ModelTraining\ModelTrained\';
savePath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\ModelTrained_CVfixed\';
saveName = strcat(savePath,'topFeats_',methods,'.xlsx');
mdlPath = strcat(savePath,methods,'\');
mdlDir = dir(mdlPath);
mdlDir = mdlDir(3:end);
mdlDir = mdlDir([mdlDir.isdir]);
featFamilies = string({mdlDir.name})';
%desMainPath = 'E:\MvP\FinalExperimentWithPancreas\NormalizedData\Train\';
desMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Train\';
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
for i= 1:length(featFamilies)
    statsMdl = load(strcat(mdlPath,featFamilies(i)...
        ,'\stats_',modelType,'.mat'));
    statsMdl = statsMdl.stats_RF;
    desciptors = load(strcat(desMainPath,featFamilies(i),...
        '\descriptors_normalized.mat'));
    desciptors =  desciptors.desNormal;
    for j = 1:length(organs)
        statsOrgan = statsMdl{j};
        topIds = [statsOrgan.topfeatinds];
        topIds = topIds(:);
        [gc,gr] = groupcounts(topIds);
        [~,idx] = sort(gc,'descend');
        top5FeatIdx = gr(idx(1:min(length(idx),numFeats)));
        top5Feats(:,j) = desciptors(top5FeatIdx);
        top5IdxList(:,j)= top5FeatIdx;
    end
    featTable = table(top5Feats(:,1),top5Feats(:,2),...
        top5Feats(:,3),top5Feats(:,4),'VariableNames',organs);
    idxTable = table(top5IdxList(:,1),top5IdxList(:,2),...
        top5IdxList(:,3),top5IdxList(:,4),'VariableNames',organs);
    writetable(featTable,saveName,'Sheet',featFamilies(i))
    writetable(idxTable,saveName,'Sheet',strcat(featFamilies(i),'Idx'))
    clear top5Feats top5IdxList
end