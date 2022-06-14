function [morphfeats]=extract_morph_feats(bounds)
%% Morph
% gb_r = {bounds.r};
% gb_c = {bounds.c};

badglands = [];
for j = 1:length(bounds.nuclei)
    try
        curB=bounds.nuclei{j};
%         [feat] = morph_features([gb_r{j}]',[gb_c{j}]');
                [feat] = morph_features(curB(:,1),curB(:,2));
        feats(j,:) = feat;
        
    catch ME
        if badglands~=length(bounds.nuclei)
            badglands = [badglands j]; %track bad glands
        end
    end
end

feats(badglands,:) = []; %remove bad glands

morphfeats = [mean(feats) std(feats) median(feats) min(feats)./max(feats)];