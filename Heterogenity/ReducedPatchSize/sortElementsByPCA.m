function list=sortElementsByPCA(feature_matrix,plot)

if nargin<2
    plot=false;
end

feature_matrix=findFaultyValues(feature_matrix);

[~,components] = pca(feature_matrix');
components = components.M;
% Plotting the KDE map
if plot
    figure;
    scatter(components(:,1),components(:,2),'filled')
    colorbar
    xlabel('1st Principal Component')
    ylabel('2nd Principal Component')
end

% Kernel Density Estimation
density_list = ksdensity([components(:,1),components(:,2)],...
    [components(:,1),components(:,2)]);

% Sorting the density values from the highest to the lowest
[~, list] = sort(density_list, 'descend');

end