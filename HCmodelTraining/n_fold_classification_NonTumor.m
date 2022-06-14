%% Not for SVM and I am setting this for MRMR
% For MvP project
%2020/06/29

clc;
clear
close all;
%% Load data
params.fsname = 'wilcoxon';
mainPath = 'E:\MvP\PatchSelection\Results_NonTumor_Final\NewNormalization_NonPancreas\';
mainSavePath = 'E:\MvP\PatchSelection\Results_NonTumor_Final\';
dirFeatFamily = dir(mainPath);
dirFeatFamily = dirFeatFamily(3:end);
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];% temporarily Include pancreas
% Exclude pancreas
organs = ["Colon";"Esophagus";"Breast"];
for j = 1:length(dirFeatFamily)
    familyName = dirFeatFamily(j).name;
    load(strcat(mainPath,familyName,'\descriptors_normalized.mat'));
    feat_list = string(desNormal);
    clear alldescription
    pp = strcat(mainSavePath,'ModelTrained_NonPancreas\',params.fsname,'\'...
        ,familyName,'\');%Save path
    LcreateFolder(pp)
    filename = strcat(mainPath,familyName,'\featuresCombined_normalized.mat');
    
    load(filename);
    data_set = featuresCombined_normalized;
    %% Set up parameters
    params.classifier = 'LDA';
    params.classifieroptions = [];
    %params.fsname = 'mrmr';
    %params.feature_list = [];
    params.shuffle = 1;
    params.n = 3;
    params.nIter = 100;
    params.num_top_feats = 10;
    params.feature_idxs = 1:size(data_set,2);
    % for svm
    p.kernel = 'rbf';
    AUCs = zeros(length(organs),4);
    SVM = zeros(length(organs),1);
    LDA = zeros(length(organs),1);
    QDA = zeros(length(organs),1);
    RF  = zeros(length(organs),1);
    for i = 1:length(organs)
        organ = organs(i);
        switch organ
            case "Colon"
                label = [ones(22,1);... %Colon
                    zeros(24,1) + 0 ;... %Esophagus
                    zeros(26,1) + 0 ;... %Breast
                    zeros(22,1) + 0];    %Pancreas
                
            case "Esophagus"
                label = [zeros(22,1);... %Colon
                    ones(24,1) + 0 ;... %Esophagus
                    zeros(26,1) + 0 ;... %Breast
                    zeros(22,1) + 0];    %Pancreas
            case "Breast"
                label = [zeros(22,1);... %Colon
                    zeros(24,1) + 0 ;... %Esophagus
                    ones(26,1) + 0 ;... %Breast
                    zeros(22,1) + 0];    %Pancreas
            case "Pancreas"
                label = [zeros(22,1);... %Colon
                    zeros(24,1) + 0 ;... %Esophagus
                    zeros(26,1) + 0 ;... %Breast
                    ones(22,1) + 0];    %Pancreas
        end
         
        %label = label(1:94);% Ignore Pancreas
        label = label(1:72);
        %% LDA
        [stats_LDA{i}]= nFoldCV_withFS_v3(data_set,label,params);
        LDA_AUC= {stats_LDA{i}.AUCs}';
        LDA_AUC = cell2mat(LDA_AUC);
        %% QDA
        params.classifier = 'QDA';
        [stats_QDA{i}]= nFoldCV_withFS_v3(data_set,label,params);
        QDA_AUC= {stats_QDA{i}.AUCs}';
        QDA_AUC = cell2mat(QDA_AUC);
        %% RANDOMFOREST
        params.classifier = 'RANDOMFOREST';
        [stats_RF{i}]= nFoldCV_withFS_v3(data_set,label,params);
        RF_AUC= {stats_RF{i}.AUCs}';
        RF_AUC = cell2mat(RF_AUC);
        %% SVM
        params.classifier = 'SVM';
        params.classifieroptions = p;
        [stats_SVM{i}]= nFoldCV_withFS_v3(data_set,label,params);
        SVM_AUC= {stats_SVM{i}.AUCs}';
        SVM_AUC = cell2mat(SVM_AUC);
        %% Summarize
        AUCs(i,:) = [mean(mean(LDA_AUC,2)),... % LDA
            mean(mean(QDA_AUC,2)),... % QDA
            mean(mean(RF_AUC,2)) ,... % RF
            mean(mean(SVM_AUC,2))];   % SVM
        LDA(i) = mean(mean(LDA_AUC,2));
        QDA(i) = mean(mean(QDA_AUC,2));
        SVM(i) = mean(mean(SVM_AUC,2));
        RF(i)  = mean(mean(RF_AUC, 2));
    end
    finalTable = table(organs,LDA,QDA,SVM,RF);
    save(strcat(pp,'stats_LDA.mat'),'stats_LDA')
    save(strcat(pp,'stats_QDA.mat'),'stats_QDA')
    save(strcat(pp,'stats_RF.mat'),'stats_RF')
    save(strcat(pp,'stats_SVM.mat'),'stats_SVM')
    writetable(finalTable,...
        strcat([mainSavePath,'ModelTrained_NonPancreas\',params.fsname,'\'],...
        'AUCTable.xlsx'),'Sheet',familyName)
end