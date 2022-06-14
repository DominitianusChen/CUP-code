clc
clear
close all
% warning off
%% generate nuc and epi masks for feature extraction
indexing = 1:64;% 2048*2048=64x (256*256)
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
patchMainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteClassifying\';
saveMainPath = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteClassifying\');
%saveMainPathEpi = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteEpiMsks\');
saveMainPathNuc = strcat('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\OrganSiteNucMsks\');
nucMskMain = 'E:\MvP\StarDistNucMaskCleansed\';
stages = ["Test";"Train"];
for k = 1:length(stages)
    stg = stages(k);
    patchDir = dir(strcat(patchMainPath,stg,'\**\*.png'));
    folderInfo = split(string({patchDir.folder}'),'\');
    organSite = folderInfo(:,end);
    pn_split = split(string({patchDir.name}'),'_');
    chunkNO = str2double(extractBefore(pn_split(:,end),'.png'));
    pn = strcat(pn_split(:,1),'_',pn_split(:,2),'_',pn_split(:,3));
    nucLoc = fullfile(nucMskMain,organSite,pn_split(:,1),strcat(pn,'.png'));
    [uniqueNucLoc,Ia,Ic] = unique(nucLoc);
    os = organSite(Ia);
    pn_unique = pn(Ia);
    parfor i = 1:length(uniqueNucLoc)
        nucMsk = imread(uniqueNucLoc(i));
        organ = os(i);
        nucTile = mat2tiles(nucMsk,[256,256]);
        nucList = {nucTile{:}};
        crit = Ic == i;
        chunks = chunkNO(crit);
        sf = fullfile(saveMainPathNuc,stg,organ);
        LcreateFolder(sf)
        for j = 1:length(chunks)
            numNuc = sum(sum(nucList{chunks(j)}));
            if numNuc ==0
                delete(fullfile(patchMainPath,stg,organ,strcat(pn_unique(i),'_',string(chunks(j)),'.png')));
            else
                nucn = fullfile(sf,strcat(pn_unique(i),'_',string(chunks(j)),'.png'));
                imwrite(nucList{chunks(j)},nucn)
            end
        end
    end
end
%%
% for j = 1:length(organs)
%     organ = organs(j);
%     fileDir = dir(sprintf('F:\\CWRU-Research\\ColonMetastasisVsPrim\\SplitWSI40x_patch_size_2048_%sPatho\\',organ));
%     fileDir = fileDir(3:end);
%     for i = 1:length(fileDir)
%         %         if ~contains(fileDir(i).name,existingFile)
%         %             continue
%         %         end
%
%         fullStatusIdx = find(strcmp(caseID,fileDir(i).name));
%         %         if length(fullStatusIdx)>1
%         %             clear organStatus
%         %             organStatus = metStatus(fullStatusIdx);
%         %             tempIdx = find(contains(organStatus,organ));
%         %             if length(tempIdx)==1
%         %                 fullStatusIdx = fullStatusIdx(tempIdx);
%         %                 continue
%         %             else
%         %                 fprintf('Sth wrong on: %s, primary?: itr; %i,%i\n',fileDir(i).name,j,i)
%         %
%         %             end
%         %         else
%         %             fprintf('Now working on: %s, primary?: %s\n',fileDir(i).name,organ)
%         %             continue
%         %         end
%         priStatus = strcmp(fullStatus(fullStatusIdx,3),"1");% 0:train
%         %        fprintf('Now working on: %s, primary?: %i\n',fileDir(i).name,priStatus)
%         patchDir = dir(fullfile(fileDir(i).folder,fileDir(i).name,'*.png'));
%         epiPath = strcat('F:\CWRU-Research\ColonMetastasisVsPrim\Epi\',organ,'\',fileDir(i).name,'\');
%         nucPath = strcat(nucMskMain,organ,'\',fileDir(i).name,'\');
%         if priStatus
%             sp = strcat(saveMainPath,'Test2\',organ,'\');
%             spe = strcat(saveMainPathEpi,'Test2\',organ,'\');
%             spn = strcat(saveMainPathNuc,'Test2\',organ,'\');
%             thres = 125;
%         else
%             sp = strcat(saveMainPath,'Train2\',organ,'\');
%             spe = strcat(saveMainPathEpi,'Train2\',organ,'\');
%             spn = strcat(saveMainPathNuc,'Train2\',organ,'\');
%             thres = 75;
%         end
%         LcreateFolder(sp)
%         LcreateFolder(spe)
%         LcreateFolder(spn)
%         %         if length(patchDir)<=thres
%         %             idx = 1:length(patchDir);
%         %         else
%         %             idx = 1:length(patchDir);% remove patch contain to much stroma
%         %             %idx = randperm(length(patchDir),thres);
%         %         end
% %         if j == 1 && length(patchDir)>50
% %             idx = randperm(length(patchDir),50);
% %         else
% %             idx = 1:length(patchDir);
% %         end
%         idx = 1:length(patchDir);
%         patchDir = patchDir(idx);
%         parfor jj =1:length(patchDir)
%             patch = imread(fullfile(patchDir(jj).folder,patchDir(jj).name));
%             epi = im2bw(imread(fullfile(epiPath,...
%                 strrep(patchDir(jj).name,'.png','_result.png'))));
%             nuc = im2bw(imread(fullfile(nucPath,...
%                 patchDir(jj).name)));
%             critEpi = sum(sum(epi))./(length(epi(:)))>=0.25;
%             if sum(size(patch) == [2048 2048 3]) ~= 3||critEpi % skip cases with shape not equal to 2048x2048
%                 continue
%             end
%             tile256 = mat2tiles(patch,[256,256]);
%             epiTile = mat2tiles(epi,[256,256]);
%             nucTile = mat2tiles(nuc,[256,256]);
%             tileList = {tile256{:}};
%             epiList = {epiTile{:}};
%             nucList = {nucTile{:}};
%             keep = cellfun(@checkEpiArea,epiList);
%             nn = indexing(keep);
%             for tt = nn
%                 sn =  strcat(sp,patchDir(jj).name);
%                 epin =  strcat(spe,strrep(patchDir(jj).name,'.png',sprintf('_%i_result.png',tt)));
%                 nucn =  strcat(spn,strrep(patchDir(jj).name,'.png',sprintf('_%i.png',tt)));
%                 imwrite(tileList{tt},sn)
%                 imwrite(epiList{tt},epin)
%                 imwrite(nucList{tt},nucn)
%             end
%         end
%     end
% end