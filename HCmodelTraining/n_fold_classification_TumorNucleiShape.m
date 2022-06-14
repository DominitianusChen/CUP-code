%% Not for SVM and I am setting this for MRMR
% For MvP project
%2021/03/24

clc;
clear
close all;
%% Load data
mm = ["wilcoxon";"mrmr"];
caseID = load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\caseID.mat');
caseID= caseID.caseID;
caseID(66) = [];
topID = strings(length(caseID),1);
for j = 1:length(caseID)
    if contains(caseID(j),';')
        topID(j) = extractBefore(caseID(j),';');
    elseif contains(caseID(j),' ')
        tempID = char(extractBefore(caseID(j),' '));
        if contains(tempID,'P')||contains(tempID,'M')
            topID(j) = string(tempID(1:end-1));
        else
            topID(j) = tempID;
        end
    else
        tempChar = char(caseID(j));
        if contains(tempChar,'P')||contains(tempChar,'M')
            topID(j) = string(tempChar(1:end-1));
        else
            topID(j) = tempChar;
        end
    end
end
for methods =1:length(mm)
    params.fsname = char(mm(methods));%params.fsname = 'mrmr' or 'wilcoxon';
    %mainPath = 'E:\MvP\FinalExperimentWithPancreas\NormalizedData\Train\';
    mainPath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\NormalizedData\Train\';
    %mainSavePath = 'E:\MvP\FinalExperimentWithPancreas\ModelTraining\';
    mainSavePath = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\ModelTraining\';
    dirFeatFamily = dir(mainPath);
    dirFeatFamily = dirFeatFamily(3:end);
    %organs = ["Colon";"Esophagus";"Breast";"Pancreas"];% temporarily ignore
    %pancreas
    organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
    load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\metStatus.mat')
    %load('E:\MvP\FinalExperimentWithPancreas\PatchSelectedWithPancreas\trainIdx.mat')
    load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\trainIdx.mat')
    
    metStatusTrain = metStatus(trainIdx);
    for j = 1:length(dirFeatFamily)
        familyName = dirFeatFamily(j).name;
        load(strcat(mainPath,familyName,'\descriptors_normalized.mat'));
        feat_list = string(desNormal);
        clear alldescription
        pp = strcat(mainSavePath,'ModelTrained_CVfixed\',params.fsname,'\'...
            ,familyName,'\');%Save path
        LcreateFolder(pp)
        filename = strcat(mainPath,familyName,'\featuresCombined_normalized.mat');
        load(filename);
        data_set = featuresCombined_normalized;
        %% Set up parameters
        params.classifier = 'LDA';
        params.classifieroptions = [];
        params.patient_ids = topID(trainIdx);
        %params.fsname = 'mrmr';
        %params.feature_list = [];
        params.shuffle = 1;
        params.n = 3;
        params.nIter = 100;
        params.num_top_feats = 10;
        if strcmp(dirFeatFamily(j).name,'FD')
            params.num_top_feats = 4;
        end
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
            label = contains(metStatusTrain,organ);
            %         switch organ
            %             case "Colon"
            %                 label = contains(metStatusTrain,organ);
            %
            %             case "Esophagus"
            %                 label = [zeros(22,1);... %Colon
            %                     ones(24,1) + 0 ;... %Esophagus
            %                     zeros(26,1) + 0 ;... %Breast
            %                     zeros(22,1) + 0];    %Pancreas
            %             case "Breast"
            %                 label = [zeros(22,1);... %Colon
            %                     zeros(24,1) + 0 ;... %Esophagus
            %                     ones(26,1) + 0 ;... %Breast
            %                     zeros(22,1) + 0];    %Pancreas
            % %             case "Pancreas"
            % %                 label = [zeros(22,1);... %Colon
            % %                     zeros(24,1) + 0 ;... %Esophagus
            % %                     zeros(26,1) + 0 ;... %Breast
            % %                     ones(22,1) + 0];    %Pancreas
            %         end
            %label = label(1:72);% Ignore Pancreas
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
            %         AUCs(i,:) = [mean(mean(LDA_AUC,2)),... % LDA
            %             mean(mean(QDA_AUC,2)),... % QDA
            %             mean(mean(SVM_AUC,2)) ,... % RF
            %             mean(mean(RF_AUC,2))];   % SVM
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
            strcat([mainSavePath,'ModelTrained_CVfixed\',params.fsname,'\'],...
            'AUCTable.xlsx'),'Sheet',familyName)
    end
end