clc
clear
close all
% VER 03-17-2021
%% Image retrevial using calculated similarity
featFamilies = dir('E:\MvP\FinalExperiment\NormalizedData\Train');
featFamilies = featFamilies(3:end);
featFamilies = featFamilies([featFamilies.isdir]);
featFamilies = string({featFamilies.name}');
avgAcc = zeros(length(featFamilies),1);
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\CBIR\';
saveMainFigPath = 'E:\MvP\FinalExperimentWithPancreas\CBIR\';
load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\metStatus.mat')
load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\caseID.mat')
load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\testIdx.mat')
fileName = caseID(testIdx);
labels =  metStatus(testIdx);
organs = ["Colon","Esophagus","Breast","Pancreas"];
for j = 1:length(featFamilies)
    featFamily = featFamilies(j);
    savePath = strcat(saveMainPath,featFamily,'\');
    saveFigPath = strcat(saveMainFigPath,featFamily,'\');
    LcreateFolder(savePath)
    LcreateFolder(saveFigPath)
    fn = 'E:\MvP\FinalExperimentWithPancreas\CBIR\Distance\UMAPDistance\distance';
    fn = strcat(fn,'_',featFamily,'_UMAP.mat');
    measure = load(fn);
    measure = measure.distance;
    [uniqueLabels,ia,ic] = unique(labels);
    
    %% PR curve
    fig = figure();
    hold on
    
    for jj = 1:length(organs)
        organ = organs(jj);
        idxLabel = find(contains(labels,organ));
        true_label = contains(labels,organ);
        clear prec reca
        for ii = 1:length(idxLabel)
            iii = idxLabel(ii);
            distance = measure(:,iii);
            distance_Normalized = 1./distance;
            thres = linspace(min(distance_Normalized),max(distance_Normalized),11);
            %[X, Y] = calculatePR(distance_Normalized,true_label,thres);
            [X, Y] = perfcurve(true_label, distance_Normalized,1,...
                'XCrit', 'reca', 'YCrit', 'prec');
            prec(ii,:) = Y;
            reca(ii,:) = X;
        end
        prec_MEAN = mean(prec);
        prec_MEAN(isnan(prec_MEAN)) = 1;
        reca_MEAN = mean(reca);
        AUCPR(jj) = trapz(reca_MEAN, prec_MEAN);
        jjLabel(jj) = uniqueLabels(jj);
        plot(reca_MEAN, prec_MEAN);
        xlabel('Recall');
        ylabel('Precision');
    end
    %title(thumbDir(l).name)
    legend(organs)
    axis([0 1 0 1])
    grid;
end