clc
clear
close all
%% Dumb way to Stich
distancePath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Distance\Pri\**\*.mat';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\';
% saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Overlay\';
% tifPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\WSI\';
distanceDir = dir(distancePath);
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
page = 3; %40x
outPage = 8;% 1.25x
patchsize = 256;
for i =3%[1,2,4]%1:length(thumbDir)
    distance = load(fullfile(...
        distanceDir(i).folder,distanceDir(i).name));
    distance = distance.distance;
    outSize = patchsize/(40/1.25);
    similarity = 1./distance;
    similarity_normal = (similarity-min(similarity))./(max(similarity)-min(similarity));
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    ff = string(imds.Files);
    [similaritySortedNorm,idxSN] = sort(similarity_normal,'descend');
    critPoint4 = ~isnan(similaritySortedNorm);%similaritySortedNorm <=0.4
    idxSN = idxSN(critPoint4);
    top3PatchFile = ff(idxSN(1:9));
    bot3PatchFile = ff(idxSN(end-9:end));
end