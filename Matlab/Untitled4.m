%% Set the environment, compile Java code
%save('img_ws.mat', 'img', 'imgConv', 'ws');
clear java;
clc;
javaaddpath(pwd);
!javac WatershedUtils.java
WatershedUtils.Invoke();
load('img_ws.mat');

%% Load the data
fileName = '..\..\..\Data\Q5 512.tif';
info = imfinfo(fileName);
%imgToLoad = 1:50;
imgToLoad = 1:numel(info);
img(1:info(1).Width, 1:info(1).Height, size(imgToLoad)) = 0;
for k = imgToLoad
    img(:,:,k) = imread(fileName, k);
end
% Fix edges
img = img(:, 4:end, :);

% Crop scanning region
nMax = 300;
img = img(1:nMax, 1:nMax, :);

%% Plot all slices
figure(1);
k = 0;
kMax = 6;
for k1 = 1:kMax
    for k2 = 1:kMax
        k = k + 1;
        subplot(kMax, kMax, k)
        imagesc(img(:, :, k));
        %axis image;
        axis off;
        %title(num2str(k));
    end
end

%%
% figure, isosurface(img(:, :, 1:20), 2), axis equal;
% xlabel x, ylabel y, zlabel z
% view(3), camlight, lighting gouraud

%%
%  General approach:
% 3D Gaussian blur
% 3D watershed
% Merging of clusters which has similar boundaries
% Sorting by size, remove small clusters (noise)
% Assume every cluster contains 1 cell
% Find cell borders basaed on local statistics
% Filter (separate) cells and vessel


%% One slice; blurred; thresholded; gradient
figure(2);
sp = 0;
slice = squeeze(img(:, :, 20));
%slice = img(:, :, 20);
sp = sp + 1; subplot(2, 3, sp);
imagesc(slice);

H = fspecial('gaussian', 5 , 2);
slice = imfilter(slice , H, 'same');
sp = sp + 1; subplot(2, 3, sp);
imagesc(slice);
colormap(gray);
    
sliceThresh = slice > 2;
sp = sp + 1; subplot(2, 3, sp);
imagesc(sliceThresh);
    
[fX, fY] = gradient(slice);
gradLim = [-1, 1];
fX = max(min(fX, gradLim(2)), gradLim(1));
fY = max(min(fY, gradLim(2)), gradLim(1));

sliceThresh = sqrt(fX.^2 + fY.^2);
sp = sp + 1; subplot(2, 3, sp);
imagesc(sliceThresh);
colormap(jet);

%% Compute convoluted image and watershed. 
r = 7;
mdg = nan(7, 7, 3);
mCovar = eye(3);
mCovar(3,3) = 0.2;
mCovar = 2 * mCovar;
for k1 = 1:size(mdg, 1)
    for k2 = 1:size(mdg, 2)
        for k3 = 1:size(mdg, 3)
            mdg(k1, k2, k3) = mvnpdf([k1, k2, k3], (r-1)/2);
        end
    end
end

fprintf('Starting convolution...');
imgConv = convn(img, mdg, 'same');
fprintf(' done\n');

fprintf('Starting watershed...');
ws = watershed(-imgConv, 18); % 6, 18, 26
fprintf(' done\n');

%% Plot one image slice and a slice of the watershed
figure;
kSlice = kSlice + 1;
slice = squeeze(imgConv(:, :, kSlice));
subplot(1, 2, 1);
slice(1, 1) = 10;
imagesc(min(slice, 10));
colormap(1-gray);

slice = squeeze(ws(:, :, kSlice));
%slice = ws(:, :, 20);
subplot(1, 2, 2);
imagesc(slice);
 
% figure(3);
% k = 0;
% kMax = 6;
% for k1 = 1:kMax
%     for k2 = 1:kMax
%         k = k + 1;
%         subplot(kMax, kMax, k)
%         imagesc(ws(:, :, k));
%         %axis image;
%         axis off;
%         %title(num2str(k));
%     end
% end

%% Clusters max and min
nClusters = max(max(max(ws)));
clMaxVal = nan(nClusters, 1);
clMimVal = nan(nClusters, 1);
imgConVec = imgConv(:);
wsVec = ws(:);
for k1 = 1:length(wsVec)
    if (wsVec(k1) ~= 0)
        clMaxVal(wsVec(k1)) = max(clMaxVal(wsVec(k1)), imgConVec(k1));
        clMimVal(wsVec(k1)) = min(clMaxVal(wsVec(k1)), imgConVec(k1));
    end
end

%% Clusters adjacency statistics
tic;
    figure(6);
    r = WatershedUtils();
    r.AddToAdjacencyStatistics(imgConv, ws);
    m = 0;
    c1 = nan;
    c2 = nan;
    ma = [];
    toPlot = nan(3, 100000);
    nToPlot = 0;
    for ca = r.GetClustersArray()'    
        for aca = r.GetAdjacentClustersArray(ca)'
            adjStat = r.GetAdjacencyStatistics(ca, aca)';            
            if (length(adjStat) > m)
                m = max(m, length(adjStat));
                c1 = ca;
                c2 = aca;
                ma = adjStat;
            end            
            nToPlot = nToPlot + 1;
            toPlot(:, nToPlot) = [max(clMaxVal(ca), clMaxVal(aca)), ...
                                  min(clMaxVal(ca), clMaxVal(aca)), ...
                                  max(adjStat)];
            if (max(clMaxVal(ca), clMaxVal(aca)) > 1)
                fprintf('%d, %d\n', ca, aca);
            end
        end
    end
    toPlot = toPlot(:, 1:nToPlot);
    plot(toPlot(1, :), toPlot(3, :) ./ toPlot(2, :), '.', 'MarkerSize', 1);
    %plot3(toPlot(1, :), toPlot(2, :), toPlot(3, :), '.', 'MarkerSize', 1);
    grid on;
    xlabel('c1 max');
    ylabel('c2 max');
    zlabel('adj max');
toc

%% Plot all slices of the convoluted image
figure(1);
k = 0;
kMax = 6;
for k1 = 1:kMax
    for k2 = 1:kMax
        k = k + 1;
        subplot(kMax, kMax, k)
        imagesc(imgConv(:, :, k));
        %axis image;
        axis off;
        %title(num2str(k));
    end
end

%%
% center1 = -10;
% center2 = -center1;
% dist = sqrt(3*(2*center1)^2);
% radius = dist/2 * 1.4;
% lims = [floor(center1-1.2*radius) ceil(center2+1.2*radius)];
% [x,y,z] = meshgrid(lims(1):lims(2));
% bw1 = sqrt((x-center1).^2 + (y-center1).^2 + ...
%            (z-center1).^2) <= radius;
% bw2 = sqrt((x-center2).^2 + (y-center2).^2 + ...
%            (z-center2).^2) <= radius;
% bw = bw1 | bw2;
% figure, isosurface(x,y,z,bw,0.5), axis equal, title('BW')
% xlabel x, ylabel y, zlabel z
% xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud
% 
% D = bwdist(~bw);
% figure, isosurface(x,y,z,D,radius/2), axis equal
% title('Isosurface of distance transform')
% xlabel x, ylabel y, zlabel z
% xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud
% 
% D = -D;
% D(~bw) = -Inf;
% L = watershed(D);
% figure
% isosurface(x,y,z,L==2,0.5)
% isosurface(x,y,z,L==3,0.5)
% axis equal
% title('Segmented objects')
% xlabel x, ylabel y, zlabel z
% xlim(lims), ylim(lims), zlim(lims)
% view(3), camlight, lighting gouraud











































