clc
clear
close all
%% Clear nuclei mask
saveMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\NucCleansed\Mets';
LcreateFolder(saveMainPath)
epiMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Epi\Mets';
nucMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Nuclei\Mets';
imgMainPath = 'E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256';
organs = [""];%"Esophagus";"Breast"];
model=load('F:\CWRU-Research\Feature Extract Code\SpaTIL_v2\example_data\lymp_svm_matlab_40x.mat');
mdl = model.model;
for i =1:length(organs)
    organ = organs(i);
    epiPath = strcat(epiMainPath,organ,'\');
    nucPath = strcat(nucMainPath,organ,'\');
    imgPath = strcat(imgMainPath,organ,'\');
    savePath = strcat(saveMainPath,organ,'\');
    LcreateFolder(savePath)
    nucDir = dir(nucPath+"**\*.png");
    parfor j = 1:length(nucDir)
        nucMask = imread(strcat(nucDir(j).folder,'\',nucDir(j).name));
        wsiName = extractBefore(nucDir(j).name,'_');
        sp = strcat(savePath,wsiName,'\');
        LcreateFolder(sp)
        saveName = strcat(sp,strrep(nucDir(j).name,'_bwNuc.png','.png'));
        if ~exist(saveName,'file')
            %% Reading masks
            try
                patchEpiName = strrep(nucDir(j).name,'_bwNuc.png','_result.png');
                I = imread(strcat(imgPath,wsiName,'\',strrep(nucDir(j).name,'_bwNuc.png','.png')));
                epiMask = imread(strcat(epiPath,wsiName,'\',patchEpiName));
                nucMask = im2bw(nucMask);
                epiMask = im2bw(epiMask);
                real_bounds = Lmask2bounds(logical(nucMask));
                nuclei=Lbounds2nuclei(real_bounds);
                L = bwlabel(logical(nucMask));
                %show(L)
                %% Lymphocyte Label
                [nucleiCentroids,nucFeatures] = getNucLocalFeatures(I,L);
                [lympho_label,~,~] = predict(mdl,nucFeatures(:,1:7));%  If label == 1, cell is a TIL
                
                %% fill in some small holes due to inaccurate annotations.
                cc= bwconncomp(~epiMask);
                stats = regionprops(cc, 'Area');
                idx = find([stats.Area] > 100);
                bw_remove = ismember(labelmatrix(cc), idx); %show( bw_remove);
                mask= ~bw_remove;
                %%%% project the mask to original dimension
                mask=imresize(mask,[size(nucMask,1) size(nucMask,2)]);
                %LshowBWonIM(mask,I);
                %% find nuclei in epi/stroma, use 'nuclei_label' to indicate the nuclei
                %%% in epi-1, or stroma-0
                all_xy=nucleiCentroids;
                all_x=all_xy(:,1);all_y=all_xy(:,2);
                all_idx=sub2ind([size(I,1) size(I,2)],round(all_y),round(all_x));
                mask_list=mask(:);
                epi_label=mask_list(all_idx);
                idx = find(epi_label&lympho_label ~= 1);
                cc_nuc = bwconncomp(nucMask);
                BW2 = ismember(labelmatrix(cc_nuc),idx);
                
                % check
%                         LshowBWonIM(mask,I,1);hold on;
%                         for k = 1:length(nuclei)
%                             if epi_label(k)
%                                 plot(nuclei{k}(:,2), nuclei{k}(:,1), 'g-', 'LineWidth', 1);
%                             else
%                                 plot(nuclei{k}(:,2), nuclei{k}(:,1), 'r-', 'LineWidth', 1);
%                             end
%                         end
%                         hold off;
%                         LshowBWonIM(BW2,I)
                % Save
                
                imwrite(BW2,saveName)
            catch
                fid = fopen(fullfile(saveMainPath, strcat('StarDistNucMaslk-Error-',date,'.txt'))...
                    ,'a');
                fprintf(fid,'The organ is %s, job Error. Image name is %s,\n',organ,nucDir(j).name);
                fclose(fid);
            end
        end
    end
end