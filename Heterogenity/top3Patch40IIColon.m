clc
clear
close all
%% Dumb way to Stich
distancePath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\DistanceMets\**\*.mat';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\';
load('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\critBlurry_40II.mat')
distanceDir = dir(distancePath);
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
page = 3; %40x
outPage = 8;% 1.25x
patchsize = 256;
for i =1%1:length(thumbDir)
    distance = load(fullfile(...
        distanceDir(i).folder,distanceDir(i).name));
    distance = distance.distance;
    distance = distance(critBlurry);
    outSize = patchsize/(40/1.25);
    similarity = 1./distance;
    similarity_normal = (similarity-min(similarity))./(max(similarity)-min(similarity));
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    ff = string(imds.Files);
    ff = ff(critBlurry);
    [similaritySortedNorm,idxSN] = sort(similarity_normal,'descend');
    critPoint4 = ~isnan(similaritySortedNorm);%similaritySortedNorm <=0.4
    idxSN = idxSN(critPoint4);
    top3PatchFile = ff(idxSN(1:18));
    bot3PatchFile = ff(idxSN(end-8:end));
end