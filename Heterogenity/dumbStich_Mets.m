clc
clear
close all
%% Dumb way to Stich
distancePath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Distance\**\distance_AllFeats_HeteroMets.mat';
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\Patch\';
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Overlay\Mets\';
tifPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\WSI\';
distanceDir = dir(distancePath);
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
page = 3; %40x
outPage = 8;% 1.25x

for i =3%1:length(thumbDir)% 3 for 40 II(M)
    distance = load(fullfile(...
        distanceDir(i).folder,distanceDir(i).name));
    distance = distance.distance;
    outSize = 2048/(40/1.25);
    similarity = 1./distance;
    similarity_normal = (similarity-min(similarity))./(max(similarity)-min(similarity));
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    savePath = strcat(saveMainPath,thumbDir(i).name,'\');
    wsiInfo = imfinfo(strcat(tifPath,...
        thumbDir(i).name,'.tif'));
    outWidth = 1:outSize:wsiInfo(outPage).Width;
    outHeight = 1:outSize:wsiInfo(outPage).Height;
    Width = 1:2048:wsiInfo(page).Width;
    Height = 1:2048:wsiInfo(page).Height;
    dumbMask = zeros(wsiInfo(outPage).Height,wsiInfo(outPage).Width);
    [wsi,~,alpha_wsi] = imread(strcat(tifPath,thumbDir(i).name,'.tif'),'Index',8);
    
    green = cat(3, zeros(size(wsi(:,:,1)))...
        ,ones(size(wsi(:,:,1))), ones(size(wsi(:,:,1))));
    LcreateFolder(savePath)
    clear coordi coordiOut
    
    for j =1:length(imds.Files)
        patchNameSplit = split(imds.Files{j},'\');
        patchName = patchNameSplit{end};
        startPoint = strrep(patchName,'.png','');
        heatmap = ones(outSize,outSize).*similarity_normal(j);
        startPoint = split(startPoint,'_');
        coordi(j,:) = [str2double(startPoint{2}),str2double(startPoint{3})];
        idxY = find(Height==coordi(j,1));
        idxX = find(Width==coordi(j,2));
        coordiOut(j,:) = [outHeight(idxY),outWidth(idxX)];
        dumbMask( coordiOut(j,1):coordiOut(j,1)+63,coordiOut(j,2):coordiOut(j,2)+63) = heatmap;
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
    colormap(ax2,linspecer);
    caxis(ax2,[0 1]);
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
    colormap(ax2,linspecer);
    caxis(ax2,[0 1]);
    ax2.Visible = 'off';
    linkprop([ax1 ax2],'Position');
    export_fig(saveName2,'-png','-native')
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