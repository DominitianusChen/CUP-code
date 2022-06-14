function keptOrNot = checkEpiArea(x)
keptOrNot = sum(sum(x))./length(x(:))>=0.8;
end