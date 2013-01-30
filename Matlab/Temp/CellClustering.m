%close all;

scan = double(imread('CellImages\q1_Ch0_Ave.tif'));
scan = scan(:,5:end);

[fx, fy] = gradient(scan);
fxy = abs(fx) + abs(fy);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% Display the input image
% figure;
% subplot 231, imagesc(scan), axis image;
% subplot 232, surf(scan'); 
% 
% %% Local max map
% H = fspecial('gaussian', [3, 3], 0.2);
% %scanBlurred = imfilter(scan, H, 'replicate');
% [maxMap, nMax] = ELLocalMax(scan, 3);
% subplot 233, imagesc(scan + 200 *boolean(maxMap)), axis image;
% 
% %% Display the final clustering
% clusterID = ELWatershed(scan, 4);
% subplot 234, imagesc(clusterID), axis image;
% 
% %% Discrete Laplacian
% %lapl = del2(scan);
% %subplot 235, imagesc(lapl), axis image;
% 
% %% Borders map
% borders = fxy./(5+scan) < 1;
% subplot 235, imagesc(borders), axis image;
% scanBordered = scan .* borders;
% scanBordered = ELWatershed(scanBordered, 4);
% subplot 236, imagesc(scanBordered), axis image;

%% Gradient vector
figure;
[x, y] = meshgrid(1:size(scan,2), 1:size(scan,1));

fx = ELClamp(fx, -1, 1);
fy = ELClamp(fy, -1, 1);

subplot 231, imagesc(scan);
subplot 234, quiver(x, y, fx, fy);

%% Image slicing
% c = improfile(scan, [1, 1], [1, 60]);

%% Convergence
conv = -divergence(fx, fy) + 2;
subplot 232, imagesc(conv);
clusterID = ELWatershed(conv, 4);
subplot 233, imagesc(clusterID + (clusterID>0)*10);

%% Convergence 2
%gKernel = zeros(3,3) + 1;
%gKernel = [0,1,0; 1,0,1; 0,1,0];
gKernel = fspecial('gaussian', [5, 5], 1);
conv = ELConvergence(fx, fy, gKernel) + 1;
subplot 235, imagesc(conv);
tic
clusterID = ELWatershed(conv, 4);
toc
clusterID = ELLimitCluestersRange(scan, clusterID, 0.2);
subplot 236, imagesc(clusterID + (clusterID>0)*10);
