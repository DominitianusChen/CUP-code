%function [features,discIdx] = findFaultyValues(features,removeFaultyCols)
function [features,discIdx] = findFaultyValues(features)
%FINDFAOULTYVALUES Finds faulty values (NaN, Inf, or Var=0) and deletes
%them 

%if nargin<2
%    removeFaultyCols=true;
%end

nanIdx=find(sum(isnan(features))>0);
infIdx=find(sum(isinf(features))>0);
var0Idx=find(var(features)==0);

discIdx=unique([nanIdx infIdx var0Idx]);

%if removeFaultyCols
    features(:,discIdx)=[];
%end

end

