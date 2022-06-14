clc
clear
close all
%% get list for existing files
metsDir = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\');
priDir  = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\');
metsDir = metsDir(3:end);
priDir = priDir(3:end);
metsName = string({metsDir.name}');
priName = string({priDir.name}');
existingFile = [metsName;priName];
%% split 2048 patches into 256
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\Train\';
for j = 1:length(organs)
    organ = organs(j);
    fileDir = dir(sprintf('F:\\CWRU-Research\\ColonMetastasisVsPrim\\SplitWSI40x_patch_size_2048_%sPatho\\',organ));
    fileDir = fileDir(3:end);
    for i = 1:length(fileDir)
%         if ~contains(fileDir(i).name,existingFile)
%             continue
%         end
        priStatus = contains(fileDir(i).name,'P');
        fprintf('Now working on: %s, primary?: %i\n',fileDir(i).name,priStatus)
        patchDir = dir(fullfile(fileDir(i).folder,fileDir(i).name,'*.png'));
        if priStatus
            sp = strcat(saveMainPath,'Pri\');
            thres = 125;
        else
            sp = strcat(saveMainPath,'Met\');
            thres = 75;
        end
         LcreateFolder(sp)
        if length(patchDir)<=thres
            idx = 1:length(patchDir);
        else
            idx = 1:length(patchDir);% remove patch contain to much stroma
            %idx = randperm(length(patchDir),thres);
        end
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
end