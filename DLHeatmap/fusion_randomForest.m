clc
clear
close all
%% load DL data
[loc,data] = xlsread('dlEmbedment.csv');
location = string(data(2:end));
dlEmbed = loc(2:end,3:end);
fullDataSet = zeros(length(location),376);
load('E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\HandcraftFeats\keptFeats.mat')
handLocMain = 'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\HandcraftFeats\';
caseID = strings(length(location),1);
organSites = strings(length(location),1);
containsNaN = false(length(location),1);
for i = 1:length(location)
    fileLocation = location(i);
    locSplit = split(fileLocation,'\');
    patchID = extractBefore(locSplit(end),'.png');
    caseID(i) = extractBefore(patchID,'_');
    organSites(i) = locSplit(end-1);
    handCraftLoc = fullfile(handLocMain,locSplit(end-2),...
        locSplit(end-1),patchID,strcat(locSplit(end),'_allFeats.mat'));
    allFeats = load(handCraftLoc);
    allFeats = allFeats.allFeats;
    keptFeats = allFeats(crit);
    if any(isnan(keptFeats))||any(isinf(keptFeats))
        containsNaN(i) = true;
    end
    fullDataSet(i,:) = keptFeats;
end
fusionData = [fullDataSet,dlEmbed];
fusionData = fusionData(~containsNaN,:);
caseID = caseID(~containsNaN);
organSites =  organSites(~containsNaN);
location = location(~containsNaN);
%% Averaging to get patientWise data
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
fusionDataP = [];
caseIDP = [];
organSitesP = [];
locationP = [];
for o = 1:length(organs)
    organ = organs(o);
    critOrgan = contains(organSites,organ);
    fusionO = fusionData(critOrgan,:);
    caseIDO = caseID(critOrgan);
    locO = location(critOrgan);
    caseIDOUnique = unique(caseIDO);
    for u = 1:length(caseIDOUnique)
        uID = caseIDOUnique(u);
        critUID = contains(caseIDO,uID);
        fusionTemp = fusionO(critUID,:);
        lO = locO(critUID); % train = 0 test = 1
        if size(fusionTemp,1)==1
            fTavg = fusionTemp;
        else
            fTavg = mean(fusionTemp);
        end
        organSitesP = [organSitesP;organ];
        caseIDP = [caseIDP;uID];
        fusionDataP = [fusionDataP;fTavg];
        locationP = [locationP;lO(1)];
    end
end
%% Train - Test
trainCrit = contains(locationP,'Train');
testCrit = contains(locationP,'Test');
topID = strings(length(caseIDP),1);
for j = 1:length(caseIDP)
    if contains(caseIDP(j),';')
        topID(j) = extractBefore(caseIDP(j),';');
    elseif contains(caseIDP(j),' ')
        tempID = char(extractBefore(caseIDP(j),' '));
        if contains(tempID,'P')||contains(tempID,'M')
            topID(j) = string(tempID(1:end-1));
        else
            topID(j) = tempID;
        end
    else
        tempChar = char(caseIDP(j));
        if contains(tempChar,'P')||contains(tempChar,'M')
            topID(j) = string(tempChar(1:end-1));
        else
            topID(j) = tempChar;
        end
    end
end
fusionTable = table(organSitesP,caseIDP,topID,locationP,trainCrit,testCrit,fusionDataP);
writetable(fusionTable,'E:\MvP\FinalExperimentWithPancreas\NewRNG\Run3\DeepLearningHeatmap\HandcraftFeats\Averaged\fusionTable.mat')