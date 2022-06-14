clc
clear
close all

% %% get list for existing files
% metsDir = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\');
% priDir  = dir('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Patch256By256\');
% metsDir = metsDir(3:end);
% priDir = priDir(3:end);
% metsName = string({metsDir.name}');
% priName = string({priDir.name}');
% existingFile = [metsName;priName];
indexing = 1:64;% 2048*2048=64x (256*256)
%% split 2048 patches into 256
organs = ["Colon","Esophagus","Breast",'Pancreas'];
caseID = load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\caseID.mat');
metStatus = load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\metStatus.mat');
caseID= caseID.caseID;
metStatus = metStatus.metStatus;
caseID(66) = []; % Remove lung Mets
metStatus(66) = []; % Remove lung Mets
testStatus = ones(length(caseID),1);
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\trainIdx.mat')
testStatus(trainIdx) = 0;
fullStatus = [caseID,metStatus,testStatus];
saveMainPath = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteClassifying\');
for j = 1:length(organs)
    organ = organs(j);
    
    fileDir = dir(sprintf('F:\\CWRU-Research\\ColonMetastasisVsPrim\\SplitWSI40x_patch_size_2048_%sPatho\\',organ));
    
    fileDir = fileDir(3:end);
    for i = 1:length(fileDir)
        %         if ~contains(fileDir(i).name,existingFile)
        %             continue
        %         end
        
        fullStatusIdx = find(strcmp(caseID,fileDir(i).name));
        %         if length(fullStatusIdx)>1
        %             clear organStatus
        %             organStatus = metStatus(fullStatusIdx);
        %             tempIdx = find(contains(organStatus,organ));
        %             if length(tempIdx)==1
        %                 fullStatusIdx = fullStatusIdx(tempIdx);
        %                 continue
        %             else
        %                 fprintf('Sth wrong on: %s, primary?: itr; %i,%i\n',fileDir(i).name,j,i)
        %
        %             end
        %         else
        %             fprintf('Now working on: %s, primary?: %s\n',fileDir(i).name,organ)
        %             continue
        %         end
        priStatus = strcmp(fullStatus(fullStatusIdx,3),"1");% 0:train
        %        fprintf('Now working on: %s, primary?: %i\n',fileDir(i).name,priStatus)
        patchDir = dir(fullfile(fileDir(i).folder,fileDir(i).name,'*.png'));
        epiPath = strcat('F:\CWRU-Research\ColonMetastasisVsPrim\Epi\',organ,'\',fileDir(i).name,'\');
        if priStatus
            sp = strcat(saveMainPath,'Test1\',organ,'\');
            thres = 125;
        else
            sp = strcat(saveMainPath,'Train1\',organ,'\');
            thres = 75;
        end
        LcreateFolder(sp)
        %         if length(patchDir)<=thres
        %             idx = 1:length(patchDir);
        %         else
        %             idx = 1:length(patchDir);% remove patch contain to much stroma
        %             %idx = randperm(length(patchDir),thres);
        %         end
        if j == 1 && length(patchDir)>50
            idx = randperm(length(patchDir),50);
        else
            idx = 1:length(patchDir);
        end
        patchDir = patchDir(idx);
        parfor jj =1:length(patchDir)
            patch = imread(fullfile(patchDir(jj).folder,patchDir(jj).name));
            epi = im2bw(imread(fullfile(epiPath,...
                strrep(patchDir(jj).name,'.png','_result.png'))));
            critEpi = sum(sum(epi))./(length(epi(:)))>=0.5;
            if sum(size(patch) == [2048 2048 3]) ~= 3||critEpi % skip cases with shape not equal to 2048x2048
                continue
            end
            tile256 = mat2tiles(patch,[256,256]);
            epiTile = mat2tiles(epi,[256,256]);
            tileList = {tile256{:}};
            epiList = {epiTile{:}};
            keep = cellfun(@checkEpiArea,epiList);
            nn = indexing(keep);
            for tt = nn
                sn = strcat(sp,strrep(patchDir(jj).name,'.png',sprintf('_%i.png',tt)));
                imwrite(tileList{tt},sn)
            end
        end
    end
end
