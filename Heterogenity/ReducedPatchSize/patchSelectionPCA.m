clc
clear
close all
%% Patch selection Using PCA
organ = '';
path = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\CombinedData\Mets\*\featureTable.mat');
sp = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Feats\PatchSelected\Mets\';
dirFile = dir(path);
for j = 1:length(dirFile)
    %fprintf('%i',j)
    allcellFeat = load(strcat(dirFile(j).folder,'\',dirFile(j).name));
    allcellFeat = allcellFeat.x;
    descriptor = allcellFeat(:,1);
    allcellFeat = double(allcellFeat(:,2:end))';
    [a,b] = size(allcellFeat);
    
    % check if is only 1 Patch
    if a >= 10
        % Apply the PCA
        lsl = sortElementsByPCA(allcellFeat,false);
        if a>=50
            % Take the 20% of the top tiles
            lsl_top_num = round(0.2*length(lsl));
            lsl_top = sort(lsl(1:lsl_top_num));
            allcellFeat = allcellFeat(lsl_top',:);
        elseif (50>a)&&(a>=20)
            % Take the 30% of the top tiles
            lsl_top_num = round(0.3*length(lsl));
            lsl_top = sort(lsl(1:lsl_top_num));
            allcellFeat = allcellFeat(lsl_top',:);
        elseif a<20
            % Take the 40% of the top tiles
            lsl_top_num = round(0.4*length(lsl));
            lsl_top = sort(lsl(1:lsl_top_num));
            allcellFeat = allcellFeat(lsl_top',:);
        end
    else
        lsl_top = 1:a;
    end
    x = allcellFeat';
    idx = lsl_top;
    featureMean = mean(allcellFeat,1)';
    featureStd = std(allcellFeat,0,1)';
    featureStats = [descriptor,featureMean,featureStd];
    featureTable = [descriptor,x];
    imageName = extractAfter(dirFile(j).folder,'Mets\');
    pp = char(strcat(sp,...
        organ,'\',imageName));
    LcreateFolder(pp)
    parsave([pp '\featureStats.mat'],featureStats)
    parsave([pp '\featureTable.mat'],featureTable)
    parsave([pp '\selectedPatchIdx.mat'],idx)
end

function parsave(fname, x)
save(fname, 'x')
end