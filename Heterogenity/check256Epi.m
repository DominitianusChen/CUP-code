clc
clear
close all
%% Check epi for 256 x 256
I = imread('F:\CWRU-Research\ColonMetastasisVsPrim\SplitWSI40x_patch_size_2048_ColonPatho\40 II\40 II_126977_20481.png');
msk2048 = im2bw(imread('F:\CWRU-Research\ColonMetastasisVsPrim\Epi\Colon\40 II\40 II_126977_20481_result.png'));
LshowBWonIM(msk2048,I,1);
rows = 126977:256:(126977+2048);
cols = 20481:256:(20481+2048);
msk256 = [];
for i = 1:length(rows)-1
    tt = [];
    for j = 1:length(cols)-1
        name = sprintf('E:\\MvP\\FinalExperimentWithPancreas\\Heterogenicity\\ReducePatchSize\\Epi\\Mets\\40 II\\40 II_%i_%i_result.png',rows(i),cols(j));
        if exist(name,'file')
            temp = im2bw(imread(name));
            
        else
            temp = zeros(256,256);
        end
        tt = [tt,temp];
    end
    msk256 = [msk256;tt];
end
figure();%LshowBWonIM(msk256,I,1);
imshow(I)
showMaskAsOverlay(0.5,msk256,'g')
figure();%LshowBWonIM(msk256,I,1);
imshow(I)
showMaskAsOverlay(0.5,msk2048,'g')