clc
clear
close all
%% split 2048 patches into 256

saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Selected\Pri\';

fileDir = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\Patch\');
fileDir = fileDir(3:end);
for i = 1:length(fileDir)
    %         if ~contains(fileDir(i).name,existingFile)
    %             continue
    %         end
    fprintf('Now working on: %s\n',fileDir(i).name)
    patchDir = dir(fullfile(fileDir(i).folder,fileDir(i).name,'*.png'));
    sp = strcat(saveMainPath,'\',fileDir(i).name,'\');
    LcreateFolder(sp)
    idx = 1:length(patchDir);
    patchDir = patchDir(idx);
    parfor jj =1:length(patchDir)
        patch = imread(fullfile(patchDir(jj).folder,patchDir(jj).name));
        if sum(size(patch) == [2048 2048 3]) ~= 3 % skip cases with shape not equal to 2048x2048
            continue
        end
        tile256 = mat2tiles(patch,[256,256]);
        tileList = {tile256{:}};
        for tt = 1:length(tileList)
            sn = strcat(sp,strrep(patchDir(jj).name,'.png',sprintf('_%i.png',tt)));
            imwrite(tileList{tt},sn)
        end
    end
end
