clc
clear
close all
%% sort back into single files
distanceDir = dir('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\GradcamMvP\Pri\*.png');
nameList = extractBefore(string({distanceDir.name}'),'_');
uniqueName = unique(nameList);
%% Dumb way to Stich

saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\GradCamHeatMapPvM\';
tifPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\WSI\';
page = 3; %40x
outPage = 8;% 1.25x
outPage = 5;% 10x
patchsize = 256;
outSize = patchsize/(40/10);
for i =2%1:length(uniqueName)
    WSIname = strcat(uniqueName(i),'.tif');
    crit = strcmp(nameList,uniqueName(i));
    savePath = strcat(saveMainPath,WSIname,'\');
    wsiInfo = imfinfo(strcat(tifPath,WSIname));
    outWidth = 1:outSize:wsiInfo(outPage).Width;
    outHeight = 1:outSize:wsiInfo(outPage).Height;
    Width = 1:patchsize:wsiInfo(page).Width;
    Height = 1:patchsize:wsiInfo(page).Height;
    dumbMask = zeros(wsiInfo(outPage).Height,wsiInfo(outPage).Width);
    [wsi,~,alpha_wsi] = imread(strcat(tifPath,WSIname),'Index',8);
    gradCam = distanceDir(crit);
%     green = cat(3, zeros(size(wsi(:,:,1)))...
%         ,ones(size(wsi(:,:,1))), ones(size(wsi(:,:,1))));
    LcreateFolder(savePath)
    clear coordi coordiOut
    %coordi = zeros(length(imds.Files),2);
    %coordiOut = zeros(length(imds.Files),2);
    for j =1:length(gradCam)
        
        startPoint = strrep(gradCam(j).name,'.png','');
        heatmap = rgb2gray(imread(fullfile(gradCam(j).folder,gradCam(j).name)));
        startPoint = split(extractBefore(startPoint,'-'),'_');
        %coordi(j,:) = [str2double(startPoint{2}),str2double(startPoint{3})];
        idxY = find(Height==str2double(startPoint{2}));
        idxX = find(Width==str2double(startPoint{3}));
        coordiOut(j,:) = [outHeight(idxY),outWidth(idxX)];
        rowEnd = coordiOut(j,1):coordiOut(j,1)+outSize-1;
        colEnd = coordiOut(j,2):coordiOut(j,2)+outSize-1;
        dumbMask( rowEnd,colEnd) = imresize(heatmap,[outSize,outSize]);% 256x256 pixel^2 @ 40x = 8x8 pixel^2 @ 1.25x
    end
    top = min(coordiOut(:,1));
    bottom = max(coordiOut(:,1));
    left = min(coordiOut(:,2));
    right = max(coordiOut(:,2));
    nn = char(extractBefore(WSIname,'.tif'));
%     saveName1 = fullfile(savePath,[nn,'_WholeWsi.png']);
%     saveName2 = fullfile(savePath,[nn,'_TumorRegion.png']);
    save(fullfile(savePath,[nn,'_heatMap10X.mat']),"dumbMask")
    
end