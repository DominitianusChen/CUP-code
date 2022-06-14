function [vote, score] = majorityVote(status,nClass)
% Status is an M x N matrix where: M is the patient number, N is the number
% of majority-N vote. nClass is number of classes
label = 1:nClass;
[M,N]=size(status);
vote = zeros(M,1);
score = zeros(M,nClass);
for i = 1:M
    [gc{i},gr{i}] = groupcounts(status(i,:)');
    
    if length(gc{i}) >= round(N/2)
        mostFreq = mode(gc{i});
        idx = gc{i} == mostFreq;
        ties = gr{i}(idx);
        minInd = zeros(1,length(ties));
        for j = 1:length(ties)
            ind = find(status(i,:)==ties(j));
            minInd(j) = min(ind);
        end
        vote(i,:) = ties(minInd == min(minInd));
    else
        idx = find(gc{i} == max(gc{i}), 1 );
        vote(i,:) = gr{i}(idx);
    end
    for j = 1:nClass
        score(i,j) = sum(status(i,:) == j)/N;
    end
end


end