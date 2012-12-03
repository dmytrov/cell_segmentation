cd 'D:\EulersLab\Code\Matlab';
sPSFFileName = '../../Data/PSFs/e120822psf.tif';
psf = ImageUtils.LoadTIFF(sPSFFileName);
psf(:,1:4,:) = 1;
psfDec = ImageUtils.Downsample2X(psf);
decViewer = UI.StackViewer(psfDec);
%% 
k = ImageUtils.Make3DGaussKernel(9, 9, 5, 3, 3, 2);
psfFiltered = ImageUtils.FastConvolution3D(psfDec, k);

% Limit by threshold value
densityThreshold = 2;
psfFiltered(psfFiltered < densityThreshold) = 0;
psfFiltered = ImageUtils.CropZeroes(psfFiltered);

%%
viewer = UI.StackViewer(psfFiltered);

%%
sScanFileName = '../../Data/Q5 512.tif';
scan = ImageUtils.LoadTIFF(sScanFileName);
scan(:, 1:3, :) = 0;

%scan = permute(scan, [3, 2, 1]);
scanViewer = UI.StackViewer(scan);

%%
k = ImageUtils.Make3DGaussKernel(21, 21, 11, 7, 7, 3);
scanConv = ImageUtils.FastConvolution3D(ImageUtils.Downsample2X(scan), k);
scanDiv = del2(-scanConv);
scanViewer = UI.StackViewer(scanDiv);

%%
% MU1 = [1 2];
% SIGMA1 = [2 0; 0 .5];
% MU2 = [-3 -5];
% SIGMA2 = [1 0; 0 1];
% X = [mvnrnd(MU1,SIGMA1,1000);mvnrnd(MU2,SIGMA2,1000)];
% 
% scatter(X(:,1),X(:,2),10,'.')
% hold on
% options = statset('Display','final');
% obj = gmdistribution.fit(X,2,'Options',options);
% h = ezcontour(@(x,y)pdf(obj,[x y]),[-8 6],[-8 6]);

%% This doesnt work
V = .0001;
BlurredNoisy = scan;
WT = zeros(size(BlurredNoisy));
WT(5:end-4, 5:end-4, 5:end-4) = 1;
INITPSF = ones(10, 10, 10);

[J, P] = deconvblind(BlurredNoisy, INITPSF, 20, 10*sqrt(V), WT);
%% Fast convergence
scan2X = ImageUtils.Downsample2X(scan);
[fx, fy, fz] = ImageUtils.Gradient3D(scan2X);
[fx, fy, fz] = ImageUtils.Clamp3D(fx, fy, fz, 0, 0.1);
sx = 61; midx = (sx+1)/2;
sy = 61; midy = (sy+1)/2;
sz = 3; midz = (sz+1)/2;
k = ImageUtils.Make3DGaussKernel(sx, sy, sz, sx/3, sy/3, sx/3);

co = ImageUtils.FastConvergence3D(fx, fy, fz, k);
coMax = max(co(:));
thresh = 0.5 * coMax;
coThreshInd = co < thresh;
coThresh = co;
coThresh(coThreshInd) = co(coThreshInd) - coMax;
convViewer = UI.StackViewer(coThresh);
%%
scanViewer = UI.StackViewer(scan2X);

%% Watershed 3D
co(~coThreshInd) = 100;
ws = watershed(-co, 6); % 6, 18, 26
wsViewer = UI.StackViewer(ws);

%% PSF and deconvolution
decXY = round(38.05 / 1.41 / 2);
decZ  = round(1/0.1 / 2);
decPSF = ImageUtils.SumDecimate(psfFiltered, decXY, decXY, decZ);
scanDeconv = deconvlucy(scan, decPSF, 10);
decViewer = UI.StackViewer(scanDeconv);














