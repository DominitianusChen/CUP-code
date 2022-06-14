clc
clear
close all
%% Excel sheets for CUP project
organs = ["Colon";"Esophagus";"Breast";"Pancreas"];
mainLoc = 'F:\CWRU-Research\ColonMetastasisVsPrim\';
saveFile = 'E:\MvP\mvpSpreadsheet.xlsx';
for i = 1:length(organs)
    organ = organs(i);
    organSiteDir = dir(fullfile(mainLoc,strcat('SplitWSI40x_patch_size_2048_',organ,'Patho')));
    organSiteDir = organSiteDir(3:end);
    label = strings(length(organSiteDir),1);
    caseName = string({organSiteDir.name}');
    for j = 1:length(organSiteDir)
        nn = organSiteDir(j).name;
        if contains(nn,'P')
            label(j) = "Primary";
        else
            label(j) = "Metastasis";
        end
    end
    T = table(caseName,label);
    writetable(T,saveFile,'Sheet',organ)
end