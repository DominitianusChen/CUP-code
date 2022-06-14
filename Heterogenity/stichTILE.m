clc
clear
close all
%% Stitch tiles back into one image

imagePath = 'F:\CWRU-Research\StageIII-Colon\TumorMask\level_2\';
imageDir = dir(imagePath);
imageDir = imageDir(3:end);
wsiPath = 'F:\CWRU-Research\StageIII-Colon\WSI\';
tile_info = [16, 29;...
    18, 27;...
    24, 30];
image = {};
idx = 8;
for i = 1:length(imageDir)
    imgPath = strcat(wsiPath,imageDir(i).name);
    info = imfinfo(imgPath);
    tile_rows = 0:tile_info(i,1)-1;
    tile_cols = 0:tile_info(i,2)-1;
    stitched = [];
    for j = tile_rows
        temp = [];
        for k = tile_cols
            images = dir(strcat(imageDir(i).folder,'\',...
                imageDir(i).name,'\*_',string(j),'_',string(k),'_*'));
            img = imread(strcat(images.folder,'\',images.name));
            img = im2bw(img);
            temp = [temp;img];
        end
        stitched = [stitched,temp];
    end
    image{i} = stitched;
    figure()
    orignal = imread(imgPath,...
        'Index',idx);
    imshow(orignal)
    showMaskAsOverlay(0.4,im2bw(imresize(image{i},...
        [info(idx).Height,info(idx).Width],'nearest')),'g')
    title(imageDir(i).name)
    imwrite(stitched,strcat(imagePath,strrep(imageDir(i).name,...
        '.tif','_10X_mask_tumor.png')))
end