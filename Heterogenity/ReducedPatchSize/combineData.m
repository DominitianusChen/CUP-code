clc
clear
close all
%% Summary of feature extracted

organ = '';
path = ['E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\Mets\'];
spath = ['E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\CombinedData\Mets\'];
dirCase=dir(path);
dirCase = dirCase(3:end);% get rid of folder . and ..
%     caseName = string({dirCase.name}');
%     dirMsk = dir(['F:\CWRU-Research\ColonMetastasisVsPrim\',organ,'_Tumor\\\Pathologist\*.png']);
%     mskName = string({dirMsk.name}');
%     mskName = extractBefore(mskName,'_mask');
%     [~,idxCase,idxMsk] = intersect(caseName,mskName);
%     featurename = load('F:\CWRU-Research\ColonMetastasisVsPrim\FeatureExtractionResults\MvP\WithPathMask\Esophagus\37M\37M_69633_26625\allFeatsNames.mat');
%     featurename = featurename.alldescription;
%     featurename = string(featurename);
%     dirCase = dirCase(idxCase);

for i = 1:length(dirCase)
    fprintf(sprintf('Now parsing Case: %s \n',dirCase(i).name))
    folderName = [dirCase(i).folder '/' dirCase(i).name '/'];
    dirFe=dir([folderName '**/*allFeats.mat']);
    for j = 1:length(dirFe)
        fileName = [dirFe(j).folder '/' dirFe(j).name];
        allFeats = load(fileName);
        featureArray(:,j) = allFeats.allFeats;
    end
    
    featureTable = [zeros(length(allFeats.allFeats),1),featureArray];
    %         featureMean = mean(featureArray,2);
    %         featureStd = std(featureArray,0,2);
    %         featureStats = [featurename,featureMean,featureStd];
    %% Save
    savepath = [spath dirCase(i).name '/'];
    % writematrix(featureStats,[savepath 'featureStats.xlsx']);
    % writematrix(featureTable,[savepath 'featureTable.xlsx']);
    LcreateFolder(savepath)
    %parsave([savepath 'featureStats.mat'],featureStats)
    parsave([savepath 'featureTable.mat'],featureTable)
end

function parsave(fname, x)
save(fname, 'x')
end