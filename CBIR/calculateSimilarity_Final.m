clc
clear
close all
%% Generate bag of image & calculate similarity
dbstop if error
featFamilies = dir('E:\MvP\PatchSelection\Results_Final\NewNormalization');
featFamilies = featFamilies(3:end);
featFamilies = string({featFamilies.name}');
for j = 1:length(featFamilies)
    featLoc = strcat('E:\MvP\PatchSelection\Results_Final\\NewNormalization\',featFamilies(j));
    setDir = 'E:\ColonMetastasisVsPrim\Thumbnails\Final\';
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    flagDistance = 2;% Euclidian
    featureFamily = featFamilies(j);
    featImportance = load(['E:\MvP\PatchSelection\Results_Final\CBIR\FeatImportance\featImportance_',...
        char(featureFamily),'_11-04-20.mat']);
    featImportance = featImportance.featImportance';
    for i =1:length(imds.Files)
        imgLoc = imds.Files{i};
        imageName = imgLoc;
        
        [distance{i}] = searchImage0718(imageName, imds.Files,...
            flagDistance,featLoc,featImportance);
    end
    savePath = 'E:\MvP\PatchSelection\Results_Final\CBIR\Distance\';
    saveName = strcat(savePath,'distance09-Sep-2020_',...
        featureFamily,'_Paired.mat');
    %save(saveName,'distance')
end