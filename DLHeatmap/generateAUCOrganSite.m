clc
clear
close all
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\ValOut\classPredScore.mat')
predictLabel = classScore;
%% generate AUC
patchDir = dir('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Test\**\*.png');
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\trainIdx.mat')
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\testIdx.mat')
caseID = load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\caseID.mat');
caseID= caseID.caseID;
topID = strings(length(caseID),1);
for j = 1:length(caseID)
    if contains(caseID(j),';')
        topID(j) = extractBefore(caseID(j),';');
    elseif contains(caseID(j),' ')
        tempID = char(extractBefore(caseID(j),' '));
        if contains(tempID,'P')||contains(tempID,'M')
            topID(j) = string(tempID(1:end-1));
        else
            topID(j) = tempID;
        end
    else
        tempChar = char(caseID(j));
        if contains(tempChar,'P')||contains(tempChar,'M')
            topID(j) = string(tempChar(1:end-1));
        else
            topID(j) = tempChar;
        end
    end
end
metStatusTrain = caseID(trainIdx);
metStatusTest = caseID(testIdx);
for i =1:length(patchDir)
    
end
trueLabelPatient = contains(metStatusTest,'P');
trueLabelPatch = contains(string({patchDir.folder}'),'Pri');
nameList = string({patchDir.name}');
%% patch wise AUC
[X,Y] = perfcurve(trueLabelPatch,predictLabel,0);
figure()
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification')
trapz(X,Y)
%% Patient wise aUC
for i =1:length(metStatusTest)
    caseName = metStatusTest(i);
    criteria = contains(nameList,caseName);
    ss = predictLabel(criteria);
    patientScore(i,:) = sum(ss>=0.5)/length(ss);
end
[X,Y] = perfcurve(trueLabelPatient,patientScore,0);
figure()
plot(X,Y)
xlabel('False positive rate') 
ylabel('True positive rate')
title('ROC for Classification')
trapz(X,Y)
