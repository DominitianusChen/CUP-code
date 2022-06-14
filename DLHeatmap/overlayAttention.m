clc
clear
close all
%% Overlay Attention map as heatmap
priName = '40 II_131073_21249';
mskDir = dir(strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Overlay\',priName,'-*'));
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
msk = imread(fullfile(mskDir.folder,mskDir.name));
heatMap = rgb2gray(msk);
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
[wsi,~,~] = imread(strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Overlay/',priName,'.png'));
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
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(wsi);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])

ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
