function SearchObjectsTest()
%%
%clc;
%clear all;
load fisheriris
x = rand(100, 2);
kdtreeNS = KDTreeSearcher(x, 'Distance', 'euclidean', 'BucketSize', 10);
%

% Perform a knnsearch between X and a query point, using 
% first Minkowski then Chebychev distance metrics:
newpoint = [0.5, 0.5];
[n, d] = knnsearch(kdtreeNS, newpoint, 'k', 1);
%[ncb,dcb] = knnsearch(kdtreeNS,newpoint,'k',10,...
%   'distance','chebychev');
%

% Visualize the results of the two different nearest 
% neighbors searches:

% First plot the training data:
plot(x(:, 1), x(:, 2), 'x'); hold on;
% Zoom in on the points of interest:
%set(gca,'xlim',[4.5 5.5],'ylim',[1 2]); axis square
% Plot an X for the query point:
line(newpoint(1),newpoint(2),'marker','x','color','k',...
   'markersize',10,'linewidth',2,'linestyle','none')
% Use circles to denote the Minkowski nearest neighbors:
line(x(n,1),x(n,2),'color',[.5 .5 .5],'marker','o',...
   'linestyle','none','markersize',10)
% Use pentagrams to denote the Chebychev nearest neighbors:
%line(x(ncb,1),x(ncb,2),'color',[.5 .5 .5],'marker','p',...
%   'linestyle','none','markersize',10)
%legend('setosa','versicolor','virginica','query point',...
%   'minkowski')
set(legend,'location','best')
hold off;