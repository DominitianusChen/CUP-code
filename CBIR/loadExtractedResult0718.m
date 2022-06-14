function features = loadExtractedResult0718(imgLoc,featureLoc)
%global imgLoc
%mainPath = 'E:\MvP\PatchSelection\PairedResults_Final\';
mainLoc = strcat(featureLoc,'\caseIDSave.mat');
% [~,caseID] = xlsread(...
%     'E:\ColonMetastasisVsPrim\ImgRetrieval\Data\BasicShapeMorph\caseIDSave.xlsx',...
%     'CaseID','A1:A92');
caseID = load(mainLoc);
caseID = caseID.caseIDSave;
caseID = caseID(:,1);
caseID = caseID(caseID ~="");
split = strsplit(imgLoc,'\');
%organ = split{5};
fileName = extractBefore(split{end},'_thumb.png');
idx = caseID==fileName;
% [~,descirptor] = xlsread('E:\ColonMetastasisVsPrim\ImgRetrieval\Data\BasicShapeMorph\descriptors_normalized.xlsx');
% descirptor = load('E:\ColonMetastasisVsPrim\ImgRetrieval\Data\BasicShapeMorph\descriptors_normalized.mat');
% descirptor = descirptor.descirptor;
% nFeats = length(descirptor);
% alphabet = upper(char(97:122));
% remainder = mod(nFeats,length(alphabet));
% excelIdx = strcat(alphabet((nFeats-remainder)/length(alphabet)),...
%     alphabet(remainder));
% readRange = sprintf('A%i:%s%i',idx,excelIdx,idx);
% 
featurePath = strcat(featureLoc,'\featuresCombined_normalized.mat');
featuresMat = load(featurePath);
featuresMat = featuresMat.featuresCombined_normalized;
features = featuresMat(idx,:);
% features = xlsread(featurePath,readRange);
features = features';
% metrics = ones(length(features),1);
end