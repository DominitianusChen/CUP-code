clc
clear
close all;
%% data pruning
organ = ["Colon";"Esophagus";"Breast";"Pancreas"];

splitedWSIPath = strcat('E:\MvP\FinalExperimentWithPancreas\Heterogenicity\ReducePatchSize\Mets256By256\**\');
dirim=dir(strcat(splitedWSIPath,'*.png'));
nullImgIdx =  find([dirim.bytes]<=90*1024);%find file <=10 kb
count = 1;
for i = 1:length(nullImgIdx)
    fprintf('On %d/%dth image\n',i,length(nullImgIdx))
    idx = nullImgIdx(i);
    dirNull = [dirim(idx).folder '\' dirim(idx).name];
    if exist(dirNull,'file')~=0
        delete(dirNull)
    end
end
