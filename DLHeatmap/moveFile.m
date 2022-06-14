clc
clear
close all
%% move files to new location
main_save_path_test = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Val\';
dirPatch = dir('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Train\**\*.png');
%% sort case Id
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

for i =1:length(dirPatch)
    patchNameFull = dirPatch(i).name;
    patchName = extractBefore(patchNameFull,'_');
    critTrain = any(contains(metStatusTrain,patchName));
    %critTest = any(contains(metStatusTest,patchName));
    if critTrain
       continue 
    end
    %% folder
    patchFolderFull = dirPatch(i).folder;
    patchFolder = extractAfter(patchFolderFull,'DeepLearningHeatmap\Train\');
    save_path = strcat(main_save_path_test,patchFolder,'\');
    LcreateFolder(save_path)
    sn = strcat(save_path,patchNameFull);
    movefile(fullfile(dirPatch(i).folder,dirPatch(i).name),sn)
end