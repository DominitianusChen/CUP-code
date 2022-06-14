clc
clear 
close all
% [0:"Colon",1:"Esophagus", 2:"Breast", 3:"Pancreas"]
%% overlay grad cam as heat-map 
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Colon\40P (2)_20737_73217.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Colon\40P (2)_20737_73217-0_0_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Colon Predict: Esophagus
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Colon\40P (2)_28673_76545.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Colon\40P (2)_28673_76545-0_1_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Colon Predict: Breast
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Colon\40P (2)_61185_59137.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Colon\40P (2)_61185_59137-0_2_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Colon Predict: Pancreas
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Colon\40P (2)_24833_66817.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Colon\40P (2)_24833_66817-0_3_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Esophagus Predict: Colon
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Esophagus\51P_74497_17153.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Esophagus\51P_74497_17153-1_0_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Esophagus Predict: Esophagus
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Esophagus\51P_73473_20481.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Esophagus\51P_73473_20481-1_1_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Esophagus Predict: Breast
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Esophagus\51P_63233_13057.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Esophagus\51P_63233_13057-1_2_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Esophagus Predict: Pancreas
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Esophagus\51P_71169_50177.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Esophagus\51P_71169_50177-1_3_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Breast Predict: Breast
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Breast\21P_33537_31745.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Breast\21P_33537_31745-2_2_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off
%% True: Pancreas Predict: Pancreas
img = imread('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\Pancreas\12P_94209_42497.png');
heat = imread('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Gradcam\Pancreas\12P_94209_42497-3_3_gradCam.png');
heatMap = rgb2gray(heat);
mycolormap = customcolormap([0 0.33 0.66 1], {'#ff0000','#ecec5a','#7e80f2','#f0f0ed'});%mycolormap = customcolormap([0 0.5 1], {'#ff0000','#a95aec','#EDEDED'});
x0=10;
y0=10;
width=1024;
height=1024;
figure();
ax1 = axes;
imshow(img);
hold on
ax2 = axes;
imagesc(ax2,heatMap,'alphadata',0.4.*(heatMap>0));
%colormap(ax2,mycolormap); % other cmap option: linspecer
%caxis([0 1.1e-3])
%caxis([0 2*2.9153e-208])
colormap(ax2,mycolormap);
ax2.Visible = 'off';
linkprop([ax1 ax2],'Position');
hold off