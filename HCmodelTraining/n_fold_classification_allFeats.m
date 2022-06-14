%% Not for SVM and I am setting this for MRMR
% For CUP project
%2021/03/05

clc;
clear
close all;

stringPrepend = strings(376,1);
stringPrepend(121:198) = "Cytoplasm";
featurename = load('F:\CWRU-Research\ColonMetastasisVsPrim\FeatureExtractionResults\MvP_Final\Colon\196 I (2)\196 I (2)_92161_30721\allFeatsNames.mat');
featurename = featurename.alldescription;
% featurename = string(featurename);
% featurename = strcat(stringPrepend,featurename);
feat_list = featurename;
clear alldescription
savePath = 'E:\MvP\PatchSelection\PairedResults\AllFeats\';
%% Load data
filename = 'E:\ColonMetastasisVsPrim\allFeats.mat';
organ = ["Colon";"Esophagus";"Breast"];%"Pancreas"];
load(filename);
training = normalizedFeatures;
clear normalizedFeatures
%Test run with Colon
label = [zeros(22,1);... %Colon
    zeros(24,1) + 0 ;... %Esophagus
    ones(24,1) + 0 ;... %Breast
    zeros(22,1) + 0];    %Pancreas

%% Train/test seperation

% % Cross varidation (train: 70%, test: 30%)
% cv = cvpartition(size(normalizedFeatures,1),'HoldOut',0.3);
% testIdx = cv.test;
% % Separate to training and test data
% dataTrain = normalizedFeatures(~testIdx,:);
% dataTest  = normalizedFeatures(testIdx,:);
% label = labelAll(~testIdx,:);
% labelTest = labelAll(testIdx,:);

%Remove columns having all zeros that is if the patient is not available
idx = find(~any(training,1) == 1);
training( :, idx ) = [] ;
feat_list(idx) = [];

idx = find(~any(training,2) == 1);
training(idx,: ) = [] ;
label(idx) = [];

% Remove Col contain NaNs
indx = all(~isnan(training));
training = training(:,indx);

% Remove rows with the non-zero values less than threshold
training = training';
count = sum(training(:,:)~=0);
indx = find(count <= 4);% Threshold = 4
training = training';
training(indx,:) = [];
feat_list(indx) = [];



cTrain = label;
% data = training'; % should be n patients x m features matrix
data = training;
classes = cTrain;

%% FS and classification options
FSmethod='mrmr';
%FSmethod = 'wilcoxon'; % see "help rankfeatures" for more options
nftrs= 5; % number of ftrs you want to select
niterations = 5;


%% Data scaling or normalizing
%% Significant feature extraction
stats=  nFold_FS(data,classes,1,3,niterations,[],nftrs,FSmethod);
% stats=  nFold_feat_select(data,classes,1,3,niterations,[],nftrs,FSmethod);


% data=svm_scale(data);

% tally feature selection counts and identify top ftrs for FS
tally = zeros(1,size(data,2));

for ii=1:length(stats)
    featmp=stats(ii).ftrs;
    for jj = 1:numel(featmp)
        tally(featmp(jj)) = tally(featmp(jj))+1;
    end
end
[topcounts,topind] = sort(tally,2,'descend');
topftrs = topind(1:nftrs);

%% Plot box plots
figure;
set(gcf,'color','w');
for ii = 1:nftrs
    subplot(1,nftrs,ii);
    boxplot(data(:,topftrs(ii)),classes);
    title(topftrs(ii));
end
top_feat = feat_list(topftrs(1:nftrs));
top_feat_indx = topftrs(1:nftrs);
top_feat_indx = top_feat_indx';

%% p_values
% Wilcoxon
p_Wilcox_vals = [];
p_ttest_vals = [];
for i = 1:nftrs
    p = ranksum(data(~~classes,top_feat_indx(i)),data(~classes,top_feat_indx(i)));
    p_Wilcox_vals = [p_Wilcox_vals; p];
    
end

%% Classification

%   CLASS = CLASSIFY(SAMPLE,TRAINING,GROUP,TYPE) allows you to specify the
%   type of discriminant function, one of 'linear', 'quadratic',
%   'diagLinear', 'diagQuadratic', or 'mahalanobis'.  Linear discrimination
%   fits a multivariate normal density to each group, with a pooled
%   estimate of covariance.  Quadratic discrimination fits MVN densities
%   with covariance estimates stratified by group.  Both methods use
%   likelihood ratios to assign observations to groups.  'diagLinear' and
%   'diagQuadratic' are similar to 'linear' and 'quadratic', but with
%   diagonal covariance matrix estimates.  These diagonal choices are
%   examples of naive Bayes classifiers.  Mahalanobis discrimination uses
%   Mahalanobis distances with stratified covariance estimates.  TYPE
%   defaults to 'linear'.

%% Classification using LDA
% stats = nFold_classification(data(:,topftrs),classes,1,3,niterations,[],classifier);
% mean([stats.AUC])
% std([stats.AUC])

niterations = 100;
classifier = 'diagLinear';


for i = 1:nftrs
    stats = nFold_classification(data(:,topftrs(1:i)),label,1,3,niterations,[],classifier);
    result(i,1) = mean([stats.AUC]);
end

classifier = 'linear';
for i = 1:nftrs
    stats = nFold_classification(data(:,topftrs(1:i)),label,1,3,niterations,[],classifier);
    result(i,2) = mean([stats.AUC]);
end

classifier = 'quadratic';
for i = 1:nftrs
    stats = nFold_classification(data(:,topftrs(1:i)),label,1,3,niterations,[],classifier);
    result(i,3) = mean([stats.AUC]);
end
classifier = 'diagQuadratic';
for i = 1:nftrs
    stats = nFold_classification(data(:,topftrs(1:i)),label,1,3,niterations,[],classifier);
    result(i,4) = mean([stats.AUC]);
end

p_vals = [p_Wilcox_vals top_feat_indx];
%% To see plots of different classifiers

% para.classifier='LDA';
% para.num_top_feature=5;
% [classresults, AUCs] = testmultipleclassifiers(data(:,topftrs),data(:,topftrs),classes',classes',1);
%



% para.feature_score_method='weighted';
% para.classifier='SVM';
% para.num_top_feature=4;
% para.featureranking='ttest';
% % para.featureranking='wilcoxon';
% para.correlation_factor=.9;
% [resultImbalancedC45,feature_scores] = nFold_AnyClassifier_withFeatureselection_v3(data_all_w,labels,feature_list_t,para,1,intFolds,intIter);
