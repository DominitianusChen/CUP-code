clc
clear
close all
%% Dumb way to Stich
distancePath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\DistanceMetPatch\**\*.mat';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\';
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\OverlayPatchOrigin\';
tifPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\WSI\';
distanceDir = dir(distancePath);
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
page = 3; %40x
outPage = 8;% 1.25x
patchsize = 256;
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});
for i =3%[1,2,4]%1:length(thumbDir)
%     distance = load(fullfile(...
%         distanceDir(i).folder,distanceDir(i).name));
    distance = load(fullfile(...
        distanceDir(1).folder,distanceDir(1).name));% 40 II
    distance = distance.distance;
    outSize = patchsize/(40/1.25);
    similarity = 1./distance;
    similarity_normal = similarity;%(similarity-min(similarity))./(max(similarity)-min(similarity));
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    savePath = strcat(saveMainPath,thumbDir(i).name,'\');
    wsiInfo = imfinfo(strcat(tifPath,...
        thumbDir(i).name,'.tif'));
    outWidth = 1:outSize:wsiInfo(outPage).Width;
    outHeight = 1:outSize:wsiInfo(outPage).Height;
    Width = 1:patchsize:wsiInfo(page).Width;
    Height = 1:patchsize:wsiInfo(page).Height;
    dumbMask = zeros(wsiInfo(outPage).Height,wsiInfo(outPage).Width);
    [wsi,~,alpha_wsi] = imread(strcat(tifPath,thumbDir(i).name,'.tif'),'Index',8);
    
    green = cat(3, zeros(size(wsi(:,:,1)))...
        ,ones(size(wsi(:,:,1))), ones(size(wsi(:,:,1))));
    LcreateFolder(savePath)
    clear coordi coordiOut
    %coordi = zeros(length(imds.Files),2);
    %coordiOut = zeros(length(imds.Files),2);
    for j =1:length(imds.Files)
        patchNameSplit = split(imds.Files{j},'\');
        patchName = patchNameSplit{end};
        startPoint = strrep(patchName,'.png','');
        heatmap = ones(outSize,outSize).*similarity_normal(j);
        startPoint = split(startPoint,'_');
        %coordi(j,:) = [str2double(startPoint{2}),str2double(startPoint{3})];
        idxY = find(Height==str2double(startPoint{2}));
        idxX = find(Width==str2double(startPoint{3}));
        coordiOut(j,:) = [outHeight(idxY),outWidth(idxX)];
        rowEnd = coordiOut(j,1):coordiOut(j,1)+7;
        colEnd = coordiOut(j,2):coordiOut(j,2)+7;
        dumbMask( rowEnd,colEnd) = heatmap;% 256x256 pixel^2 @ 40x = 8x8 pixel^2 @ 1.25x
    end
    top = min(coordiOut(:,1));
    bottom = max(coordiOut(:,1));
    left = min(coordiOut(:,2));
    right = max(coordiOut(:,2));
    saveName1 = fullfile(savePath,[thumbDir(i).name,'_WholeWsi.png']);
    saveName2 = fullfile(savePath,[thumbDir(i).name,'_TumorRegion.png']);
    close
    figure(1);
    ax1 = axes;
    imshow(wsi);
    hold on
    ax2 = axes;
    imagesc(ax2,dumbMask,'alphadata',0.7.*(dumbMask>0));
    colormap(ax2,mycolormap);
    %caxis(ax2,[0 1]);
    ax2.Visible = 'off';
    linkprop([ax1 ax2],'Position');
    hold off
    export_fig(saveName1,'-png','-native')
    close
    figure(1);
    ax1 = axes;
    imshow(wsi(top:bottom,left:right,:));
    hold on
    ax2 = axes;
    imagesc(ax2,dumbMask(top:bottom,left:right),'alphadata',...
        0.7.*(dumbMask(top:bottom,left:right)>0));
    colormap(ax2,mycolormap);
    %caxis(ax2,[0 1]);
    ax2.Visible = 'off';
    linkprop([ax1 ax2],'Position');
    export_fig(saveName2,'-png','-native')
    save(fullfile(savePath,[thumbDir(i).name,'_heatMap.mat']),"dumbMask")
    %     figure1 = figure;
    %     imshow(wsi)
    %     hold on
    %     h = imshow(green);
    %     hold off
    %     set(h, 'AlphaData',dumbMask)
    %     img = export_fig(fullfile(savePath,[thumbDir(i).name,'_overlay.png']),'-native');
    %     saveName2 = fullfile(savePath,[thumbDir(i).name,'_TumorRegion.png']);
    %     figure()
    %     imshow(img(top:bottom,left:right,:));
    %     set(gcf,'MenuBar','none')
    %     set(gca,'DataAspectRatioMode','auto')
    %     set(gca,'Position',[0 0 1 1])
    %     export_fig(saveName2,'-png','-native')
end