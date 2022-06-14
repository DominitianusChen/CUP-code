clc
clear
close all
%% Concate PatchWise allFeats 0: P 1:M
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\AllfeatsOrgan\';
featsMainPath = 'E:\MvP\PatchSelected\';
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
patchMainPath = 'F:\CWRU-Research\ColonMetastasisVsPrim\';
for i =1%:3%length(saveMainPath)
    organ = organs(i);
    savePath = strcat(saveMainPath,organ,'\');
    LcreateFolder(savePath)
    featsPath = strcat(featsMainPath,organ,'\');
    featsDir = dir(strcat(featsPath,'*\selectedPatchIdx.mat'));
    patchPath = strcat(patchMainPath,sprintf('SplitWSI40x_patch_size_2048_%sPatho\\',organ));
    allfeats = [];
    loc = [];
    for j = 1:length(featsDir)
        caseName = split(featsDir(j).folder,'\');
        caseName = char(caseName(end));
        pp = dir(fullfile(patchPath,caseName));
        pp = pp(3:end);
        ff = load(fullfile(featsDir(j).folder,featsDir(j).name));
        ff = ff.x;
        pp = pp(ff);
        ll = strcat(string({pp.folder})','\',string({pp.name})');
        ll = strrep(ll,'\','/');% covert to location could recongnize by python
        loc = [loc;ll];
    end
    writematrix(loc,strcat(savePath,'fileLoc.xlsx'))
end