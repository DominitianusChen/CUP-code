clc
clear
close all
%% remove blurry patchs
msk = imread('F:\CWRU-Research\HistoQC-master\HistoQC-master\histoqc_output_20210714-124251\40 II.tif\40 II.tif_mask_use.png');
msk = im2bw(msk);
wsiInfo = imfinfo('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Mets\WSI\40 II.tif');
page = 7;% page 7 = 2.5 x
msk = imresize(msk,[wsiInfo(page).Height wsiInfo(page).Width]);
ratio = 40/2.5;
patchSize = 256/ratio;
thumbMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\';
thumbDir = dir(thumbMainPath);
thumbDir = thumbDir(3:end);
thumbDir = thumbDir([thumbDir.isdir]);
for i =1%1:length(thumbDir)
    setDir = strcat(thumbMainPath,thumbDir(i).name,'\');
    imds = imageDatastore(setDir,'IncludeSubfolders',true,'LabelSource',...
        'foldernames');
    critBlurry = true(length(imds.Files),1);
    for j = 1:length(imds.Files)
        file = string(imds.Files(j));
        rowCol = double(strsplit(extractBetween(file,'_','.png'),'_'));
        rowColResized = round(rowCol./ratio);
        msk_chuck = msk(rowColResized(1):rowColResized(1)+patchSize-1,...
            rowColResized(2):rowColResized(2)+patchSize-1);
        critBlurry(j) = any(any(msk_chuck))~=0;
    end
    
end