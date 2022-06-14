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
score_ML = zeros(54,4);
for i = 1%:length(dirFeatFamily)
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
        score_ML(:,j) = score;
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
dlIDList = ["1475;2299;D3M", "1904", "2246", "2778;3618;A1M", "2853;3706;C3M",...
    "2864;3721;D4M", "2891 (2)", "2904;3765;B1M", "3125", "3182",...
    "3208", "3218", "3346;4252;A6P", "3462;4364;A1M", "3469 (2)",...
    "3479", "5009;8844;C2M", "43M", "44M (2)", "50M", "57M", "58M",...
    "59M", "60M (3)", "72M", "83M", "84M", "85M", "20M", "22M", "29M",...
    "33M", "34M", "34P", "76M", "77M", "78M", "79M", "80M", "81M",...
    "82M", "BI17N7270 (9)", "13M", "16M", "17M", "19M", "4M", "54M",...
    "56M", "65M", "67M", "6M", "70M", "73M"]';
mlIDlist = caseID(testIdx);

primaryCase = ~contains(dlIDList,'P')';
dlIDList = dlIDList(primaryCase)';
load('patientScore_DL.mat');
patientScore_DL = patientScore_DL(primaryCase,:);
missingCase = setdiff(mlIDlist,dlIDList);
mlIDlist = mlIDlist(~contains(mlIDlist,missingCase));
trueLabelML = trueLabel(~contains(mlIDlist,missingCase));
score_ML = score_ML(~contains(mlIDlist,missingCase),:);
[mlIDlist,idxML] = sort(mlIDlist);
trueLabelML = trueLabelML(idxML);
[dlIDList,idxDL] = sort(dlIDList');
patientScore_DL = patientScore_DL(idxDL,:);
score_ML = score_ML(idxML,:);
fusionScore = zeros(52,4);
for i =1:size(score_ML,1)
    fs = [score_ML(i,:);patientScore_DL(i,:)];
    fusionScore(i,:) = max(fs);
end
for j = 1:length(organs)
    organ = organs(j);
    tl = contains(trueLabelML, organ);
    sc = fusionScore(:,j);
    [X,Y,~,AUC(j)] = perfcurve(tl,sc,1);
    figure(1)
    hold on
    plot(X,Y)
   
end
legend(organs,'Location','SouthEast')
 grid minor
AUCTableFs= AUC;
%% Majority Votes
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
score_ML = zeros(54,4);
for i = 1%:length(dirFeatFamily)
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
        score_ML(:,j) = score;
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
dlIDList = ["1475;2299;D3M", "1904", "2246", "2778;3618;A1M", "2853;3706;C3M",...
    "2864;3721;D4M", "2891 (2)", "2904;3765;B1M", "3125", "3182",...
    "3208", "3218", "3346;4252;A6P", "3462;4364;A1M", "3469 (2)",...
    "3479", "5009;8844;C2M", "43M", "44M (2)", "50M", "57M", "58M",...
    "59M", "60M (3)", "72M", "83M", "84M", "85M", "20M", "22M", "29M",...
    "33M", "34M", "34P", "76M", "77M", "78M", "79M", "80M", "81M",...
    "82M", "BI17N7270 (9)", "13M", "16M", "17M", "19M", "4M", "54M",...
    "56M", "65M", "67M", "6M", "70M", "73M"]';
mlIDlist = caseID(testIdx);

primaryCase = ~contains(dlIDList,'P')';
dlIDList = dlIDList(primaryCase)';
load('patientScore_DL.mat');
patientScore_DL = patientScore_DL(primaryCase,:);
missingCase = setdiff(mlIDlist,dlIDList);
mlIDlist = mlIDlist(~contains(mlIDlist,missingCase));
trueLabelML = trueLabel(~contains(mlIDlist,missingCase));
score_ML = score_ML(~contains(mlIDlist,missingCase),:);
[mlIDlist,idxML] = sort(mlIDlist);
trueLabelML = trueLabelML(idxML);
[dlIDList,idxDL] = sort(dlIDList');
patientScore_DL = patientScore_DL(idxDL,:);
score_ML = score_ML(idxML,:);
fusionScore = zeros(52,4);
fusionVote = zeros(52,2);
fusionVoteScore = zeros(52,4);
for i =1:size(score_ML,1)
    fs = [score_ML(i,:);patientScore_DL(i,:)];
    [scoreMl,idxMl] = max(score_ML(i,:));
    [scoreDl,idxDl] = max(patientScore_DL(i,:));
    classVotes = [idxMl,idxDl];
    if idxMl==idxDl
        fusionVoteScore(i,idxMl) = 1;
    else
        fusionVoteScore(i,idxMl) = 0.5;
        fusionVoteScore(i,idxDl) = 0.5;
    end
%     voteScore = [scoreMl,scoreDl];
     fusionScore(i,:) = max(fs);
     fusionVote(i,:) =classVotes;
%     fusionVoteScore(i,:) =voteScore;
end

for j = 1:length(organs)
    organ = organs(j);
    tl = contains(trueLabelML, organ);
    sc = fusionScore(:,j);
    [X,Y,~,AUC(j)] = perfcurve(tl,sc,1);
    figure(1)
    hold on
    plot(X,Y)
   
end
legend(organs,'Location','SouthEast')
 grid minor
AUCTableFs= AUC

for j = 1:length(organs)
    organ = organs(j);
    tl = contains(trueLabelML, organ);
    sc = fusionVoteScore(:,j);
    [X,Y,~,AUC(j)] = perfcurve(tl,sc,1);
    figure(2)
    hold on
    plot(X,Y)
   
end
legend(organs,'Location','SouthEast')
 grid minor
AUCTableFs= AUC;