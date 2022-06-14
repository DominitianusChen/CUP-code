clc
clear
close all
%% Test Ridge line plot
n = 8; % number of distributions
mu = linspace(0,100,n);
sd = (rand(size(mu)) +1).*2;
nSamp = 100; %number of samples per dist.
data = arrayfun(@normrnd,mu,sd,ones(size(mu)),nSamp.*ones(size(mu)),'UniformOutput',false); % req. stats & ML toolbox
yLabs = num2cell(char(64+cumsum(ones(1,n))));
% Generate figure.
fh = figure();
% Compute axes positions with contigunous edges
n = numel(data); 
margins = [.13 .13 .12 .15]; %left, right, bottom, top
height = (1-sum(margins(3:4)))/n; % height of each subplot
width = 1-sum(margins(1:2)); %width of each sp
vPos = linspace(margins(3),1-margins(4)-height,n); %vert pos of each sp
% Plot the histogram fits (normal density function)
% You can optionally specify the number of bins
% as well as the distribution to fit (not shown,
% see https://www.mathworks.com/help/stats/histfit.html)
% Note that histfit() does not allow the user to specify
% the axes (as of r2019b) which is why we need to create 
% the axes within a loop.
% (more info: https://www.mathworks.com/matlabcentral/answers/279951-how-can-i-assign-a-histfit-graph-to-a-parent-axis-in-a-gui#answer_218699)
% Otherwise we could use tiledlayout() (>=r2019b)
% https://www.mathworks.com/help/matlab/ref/tiledlayout.html
subHand = gobjects(1,n);
histHand = gobjects(2,n);
for i = 1:n
    subHand(i) = axes('position',[margins(1),vPos(i),width,height]); 
    histHand(:,i) = histfit(data{i});
end
% Link the subplot x-axes
linkaxes(subHand,'x')
% Extend density curves to edges of xlim and fill.
% This is easier, more readable (and maybe faster) to do in a loop. 
xl = xlim(subHand(end));
colors = jet(n); % Use any colormap you want
for i = 1:n
    x = [xl(1),histHand(2,i).XData,xl([2,1])]; 
    y = [0,histHand(2,i).YData,0,0]; 
    fillHand = fill(subHand(i),x,y,colors(i,:),'FaceAlpha',0.4,'EdgeColor','k','LineWidth',1);
    % Add vertical ref lines at xtick of bottom axis
    arrayfun(@(t)xline(subHand(i),t),subHand(1).XTick); %req. >=r2018b
    % Add y axis labels
    ylh = ylabel(subHand(i),yLabs{i}); 
    set(ylh,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','middle')
end
% Cosmetics
% Delete histogram bars & original density curves 
delete(histHand)
% remove axes (all but bottom) and 
% add vertical ref lines at x ticks of bottom axis
set(subHand(1),'Box','off')
arrayfun(@(i)set(subHand(i).XAxis,'Visible','off'),2:n)
set(subHand,'YTick',[])
set(subHand,'XLim',xl)