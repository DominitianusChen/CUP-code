clc
clear
close all
priName = '21P';
metName = '40P (2)';
%% better heat map for 40 P

mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/ReducePatchSize/Overlay/%s/%s_heatMap.mat',priName,priName));
distance = load(sprintf('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/ReducePatchSize/Distance/%s/distance_AllFeats_Hetero256.mat',priName));
distance = distance.distance;
similarity = 1./distance;
sp = similarity;
heatMap = hh.dumbMask;
heatMap = heatMap.*(max(similarity)-min(similarity))+min(similarity);
heatMapEuclidDistance = 1./heatMap;
heatMapEuclidDistance(isinf(heatMapEuclidDistance)) = nan;
heatMapEuclidDistance(heatMapEuclidDistance>4e3) =4e3;
heatMapEuclidDistanceNormalized =  (heatMapEuclidDistance-min(min(heatMapEuclidDistance)))./(max(max(heatMapEuclidDistance))-min(min(heatMapEuclidDistance)));
heatMap = imgaussfilt(heatMap,2);
%imshow(heatMapEuclidDistance)
% heatMapExponentialSim = exp(-1.*heatMapEuclidDistanceNormalized);
% heatMap = heatMapExponentialSim;
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
caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])

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
hh = load(sprintf('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/ReducePatchSize/Overlay/%s/%s_heatMap.mat',metName,metName));
distance = load(sprintf('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/ReducePatchSize/Distance/%s/distance_AllFeats_Hetero256.mat',metName));
distance = distance.distance;
similarity = 1./distance;
heatMap = hh.dumbMask;
heatMap = heatMap.*(max(similarity)-min(similarity))+min(similarity);
heatMap = imgaussfilt(heatMap,2);
% figure
% imagesc(heatMap)
% colormap(customcolormap([0 0.5 1], {'#f2ef50','#ff0000','#000000'}))
% %caxis([0 0.6])
% colorbar
heatMapThresholded = heatMap;
heatMapThresholded(heatMapThresholded<0.15) = NaN;
%heatMapThresholded = (heatMapThresholded-min(heatMapThresholded))./(max(heatMapThresholded)-min(heatMapThresholded));
% figure
% imagesc(heatMapThresholded)
% colormap(mycolormap)
%caxis([0 0.6])
[wsi,~,alpha_wsi] = imread(strcat('E:/MvP/FinalExperimentWithPancreas/Heterogenicity/WSI/',metName,'.tif'),'Index',8);
% figure();
% ax1 = axes;
% imshow(wsi);
% hold on
% ax2 = axes;
% imagesc(ax2,heatMapThresholded,'alphadata',0.6.*(heatMapThresholded>0));
% colormap(ax2,mycolormap); % other cmap option: linspecer
% %caxis([0 0.6])
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
caxis([0 1.1e-3])
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
