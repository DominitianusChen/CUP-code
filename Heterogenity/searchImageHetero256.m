function Distance = searchImageHetero256(flagDistance,featureLoc,metFeat,criteriaSubfeats)

feat = metFeat';% Met Signal
featT = load(featureLoc);% Primary patch Signal
featT = featT.allFeats;
featT = featT(criteriaSubfeats);% sort and remove graph features
%% Compute the Minkowski distance
Distance = sum((feat- featT)...
    .^flagDistance).^(1/flagDistance);
%% Redundant code for CBIR

%     DIFF = abs(feat-featT) ./ feat;
%
%     % keep distance values for which the corresponding query image's values
%     % are larger than the predefined threshold:
%     DIFF = DIFF(feat>t);
%
%     % keep error values which are smaller than 1:
%     DIFF2 = DIFF(DIFF<t2);
%     L2 = length(DIFF2);
%
%     % compute the similarity meaasure:
%     Similarity(i) = length(DIFF) * mean(DIFF2) / (L2^2);
% (interface): plot images with small similarity measures:
%     plotThres = 0.5 * 10 / length(diff);
%     if (Similarity(i) < plotThres)
%         %        fprintf('%70s %5.2f %5d %5d\n', files{i}, median(DIFF2),
%         %        length(DIFF), L2);
%         subplot(2,2,1);imshow(RGBQ);
%         title('Query image');
%         RGB = imread(list{i});
%         subplot(2,2,2);imshow(RGB);
%         title('A similar image ... Still Searching ...');
%         subplot(2,2,3);
%         plot(diff)
%         if (length(diff2)>1)
%             subplot(2,2,4); plot(diff2);
%             axis([1 length(diff2) 0.2 1])
%         end
%         drawnow
%     end

%     % find the nResult "closest" images:
% [~, ISorted] = sort(Distance);
% ISortedReturn = ISorted(1:nResults);
%     NRows = ceil((nResults+1) / 3);
%     % plot query image:
%     subplot(NRows,3,1); imshow(RGBQ); title('Query Image');
%     % ... plot similar images:
%     for (i=1:nResults)
%         RGB = imread(list{ISorted(i)});
%         str = sprintf('%i st match Im %d: %.3f',i,ISorted(i),100*Sorted(i));
%         subplot(NRows,3,i+1); imshow(RGB);  title(str);
%     end

end