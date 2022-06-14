clc
clear
close all
priName = '40P (2)';
metName = '21P';
%% better heat map for 40 P

mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/NewRNG/Run3/DeepLearningHeatmap/GradCamHeatMap/%s.tif/%s_heatMap.mat',priName,priName));
heatMap = hh.dumbMask;
heatMap = imgaussfilt(heatMap,2);
% [X,Y] = meshgrid(1:size(heatMap,2), 1:size(heatMap,1));
% 
% %// Define a finer grid of points
% [X2,Y2] = meshgrid(1:0.5:size(heatMap,2), 1:0.5:size(heatMap,1));
% heatMap = interp2(X, Y, heatMap, X2, Y2, 'linear');
% figure
% imagesc(heatMap)
% colormap(customcolormap([0 0.5 1], {'#f2ef50','#ff0000','#000000'}))
% %caxis([0.1 0.4])%[0.15 0.5]
% colorbar
% heatMapThresholded = heatMap;
% heatMapThresholded(heatMapThresholded<0.15) = NaN;
% %heatMapThresholded = (heatMapThresholded-min(heatMapThresholded))./(max(heatMapThresholded)-min(heatMapThresholded));
% figure
% imagesc(heatMapThresholded)
% colormap(mycolormap)
%caxis([0.1 0.4])
[wsi,~,alpha_wsi] = imread(strcat('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/WSI/',priName,'.tif'),'Index',8);
% figure();
% ax1 = axes;
% imshow(wsi);
% hold on
% ax2 = axes;
% imagesc(ax2,heatMapThresholded,'alphadata',0.6.*(heatMapThresholded>0));
% colormap(ax2,mycolormap); % other cmap option: linspecer
% %caxis([0.1 0.4])
% ax2.Visible = 'off';
% linkprop([ax1 ax2],'Position');
% hold off
figure();
ax1 = axes;
imshow(wsi);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.6.*(heatMap>0));
colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
caxis([-10 50])

ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% Load tumor region
% subTumorMsk = imread('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/40P (2)_mask.png');
% subTumorMsk = im2bw(imresize(subTumorMsk,size(heatMap)));
% CC = bwconncomp(subTumorMsk);
% avg = zeros(size(CC.PixelIdxList))';
% for i =1:length(CC.PixelIdxList)
%     sss = false(size(subTumorMsk));
%     sss(CC.PixelIdxList{i}) = 1;
%     temp = sss.*heatMap;
%     heat = temp(CC.PixelIdxList{i});
%     heat(isnan(heat)) = [];
%     avg(i) = mean(heat);
%     %     figure()
%     %     imagesc(temp)
%     %     colormap('hot')
% end
% figure()
% imagesc(subTumorMsk.*heatMap)
% colormap('hot')
%% 40 II

mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/NewRNG/Run3/DeepLearningHeatmap/GradCamHeatMap/%s.tif/%s_heatMap.mat',metName,metName));
heatMap = hh.dumbMask;
heatMap = imgaussfilt(heatMap,2);
% figure
% imagesc(heatMap)
% colormap(customcolormap([0 0.5 1], {'#f2ef50','#ff0000','#000000'}))
% %caxis([0.1 0.4])%[0.15 0.5]
% colorbar
% heatMapThresholded = heatMap;
% heatMapThresholded(heatMapThresholded<0.15) = NaN;
% %heatMapThresholded = (heatMapThresholded-min(heatMapThresholded))./(max(heatMapThresholded)-min(heatMapThresholded));
% figure
% imagesc(heatMapThresholded)
% colormap(mycolormap)
%caxis([0.1 0.4])
[wsi,~,alpha_wsi] = imread(strcat('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/WSI/',metName,'.tif'),'Index',8);
% figure();
% ax1 = axes;
% imshow(wsi);
% hold on
% ax2 = axes;
% imagesc(ax2,heatMapThresholded,'alphadata',0.6.*(heatMapThresholded>0));
% colormap(ax2,mycolormap); % other cmap option: linspecer
% %caxis([0.1 0.4])
% ax2.Visible = 'off';
% linkprop([ax1 ax2],'Position');
% hold off
figure();
ax1 = axes;
imshow(wsi);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.6.*(heatMap>0));
colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
caxis([0 70])

ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% MvP


mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/NewRNG/Run3/DeepLearningHeatmap/GradCamHeatMapPvM/%s.tif/%s_heatMap10X.mat',priName,priName));
heatMap = hh.dumbMask;
[wsi,~,alpha_wsi] = imread(strcat('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/WSI/',priName,'.tif'),'Index',8);
ss = size(wsi);
heatMap = imresize(heatMap,ss(1:2));
heatMap = imgaussfilt(heatMap,2);
figure();
ax1 = axes;
imshow(wsi);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.6.*(heatMap>0));
colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
caxis([0 60])
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off

%% MvP 2

mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/NewRNG/Run3/DeepLearningHeatmap/GradCamHeatMapPvM/%s.tif/%s_heatMap10X.mat',metName,metName));
heatMap = hh.dumbMask;
[wsi,~,alpha_wsi] = imread(strcat('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/WSI/',metName,'.tif'),'Index',8);
ss = size(wsi);
heatMap = imresize(heatMap,ss(1:2));
heatMap = imgaussfilt(heatMap,2);
figure();
ax1 = axes;
imshow(wsi);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.6.*(heatMap>0));
colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
caxis([0 60])
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off