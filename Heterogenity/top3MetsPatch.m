clc
clear
close all
%% Dumb way to Stich
distancePath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\DistanceReduced\**\distance_AllFeats_HeteroMets.mat';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\';
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\OverlayReducedSig\Mets\';
tifPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\WSI\';
distanceDir = dir(distancePath);
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
page = 3; %40x
outPage = 8;% 1.25x
numTopPatch = 3;
for i =1%1:length(thumbDir)% 3 for 40 II(M)
    distance = load(fullfile(...
        distanceDir(1).folder,distanceDir(1).name));
    distance = distance.distance;
    outSize = 2048/(40/1.25);
    similarity = 1./distance;
    similarity_normal = (similarity-min(similarity))./(max(similarity)-min(similarity));
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    ff = string(imds.Files);
    [similaritySortedNorm,idxSN] = sort(similarity_normal,'descend');
    critPoint4 = ~isnan(similaritySortedNorm);%similaritySortedNorm <=0.4
    idxSN = idxSN(critPoint4);
    top3PatchFile = ff(idxSN(1:5));
    bot3PatchFile = ff(idxSN(end-4:end));
    
end