%close all;

%% Load the data
fileName = '..\..\..\Data\Q5 512.tif';
info = imfinfo(fileName);
%imgToLoad = 1:50;
imgToLoad = 1:numel(info);
scan(1:info(1).Width, 1:info(1).Height, size(imgToLoad)) = 0;
for k = imgToLoad
    scan(:,:,k) = imread(fileName, k);
end
% Fix edges
scan = scan(:, 4:end, :);

% Crop scanning region
nMax = 300;
scan = scan(1:nMax, 1:nMax, :);
iResizeFactor = 5;
scan = ELImStackResize(scan, iResizeFactor);

[fx, fy, fz] = gradient(scan);
fxyz = abs(fx) + abs(fy) + abs(fz);

%% Gradient vector
figure(1);
[x, y, z] = meshgrid(1:size(scan,1), 1:size(scan,2), 1:size(scan,3));

fx = ELClamp(fx, -1, 1);
fy = ELClamp(fy, -1, 1);

kSlice = 20;
subplot(2, 3, 1), imagesc(scan(:, :, kSlice));
set(gca,'YDir','normal');
subplot(2, 3, 2), quiver(x(:, :, kSlice), y(:, :, kSlice), fx(:, :, kSlice), fy(:, :, kSlice));
set(gca,'YDir','normal');

%% Image slicing
% c = improfile(scan, [1, 1], [1, 60]);

%% Convergence
conver = -divergence(fx, fy, fz) + 2;
subplot(2,3,3), imagesc(conver(:,:,kSlice)); set(gca,'YDir','normal');
clusterID = watershed(conver, 18);
subplot(2,3,4), imagesc(double(clusterID(:,:,kSlice)) + (clusterID(:,:,kSlice)>0)*10); set(gca,'YDir','normal');

%gKernel = ones(3, 3);
gKernel = fspecial('gaussian', [7, 7], 2);
%pt = zeros(3,3); pt(2,:) = 1;
%[kox, koy] = gradient(pt);
%conver = ELConvergence3D(kox, koy, gKernel, gKernel) + 2;
conver3D = ELConvergence3D(fy, fx, fz, gKernel);
subplot(2,3,5), imagesc(conver3D(:,:,kSlice)); set(gca,'YDir','normal');
%conver = ELConvergence(kox, koy, gKernel) + 2;
conver = ELConvergence(fx(:,:,kSlice), fy(:,:,kSlice), gKernel);
subplot(2,3,6), imagesc(conver); set(gca,'YDir','normal');

clusterID = watershed(-conver3D, 26);
subplot(2,3,4), imagesc(double(clusterID(:,:,kSlice)) + (clusterID(:,:,kSlice)>0)*10); set(gca,'YDir','normal');

%% Convergence 2
%gKernel = zeros(3,3) + 1;
%gKernel = [0,1,0; 1,0,1; 0,1,0];
gKernel = fspecial('gaussian', [5, 5], 1);
conver = ELConvergence3D(fx, fy, fz, gKernel) + 1;
subplot(2,3,5), imagesc(conver(:,:,kSlice));
tic
clusterID = ELWatershed(conver, 4);
toc
clusterID = ELLimitCluestersRange(scan, clusterID, 0.2);
subplot(2,3,6), imagesc(double(clusterID(:,:,kSlice)) + (clusterID(:,:,kSlice)>0)*10);




















