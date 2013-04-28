%function Test()

%%
clc;
close all;
clear classes;
settings = Segment3D.TSettings();
%sScanFileName = '../Data/D_distal.tif';
sScanFileName = '../Data/Q3 FF2.tif';
scan = ImageUtils.LoadTIFF(sScanFileName);
scan = scan(:, 4:end, 2:end);

scanFiltered = SignalUtils.FilterStack(settings, scan, 0.01, 'high');
scanAligned = ImageUtils.AlignSlices(scan, 'SINGLE_REFERENCE', 2);
scanAlignedFiltered = SignalUtils.FilterStack(settings, scanAligned, 0.01, 'high');

%%
viewerCorr = UI.StackCorrelationViewer(scanFiltered);
viewerCorr.settings = settings;
viewerCorrAligned = UI.StackCorrelationViewer(scanAlignedFiltered);
viewerCorrAligned.settings = settings;

viewer = UI.StackCorrelationViewer(scan);
viewerAligned = UI.StackCorrelationViewer(scanAligned);

%%
figure(10); hold on;
plot(squeeze(scanAligned(54, 34, :))-10, 'r');
plot(squeeze(scanAligned(54, 31, :)), 'b');

%%
scan(:,:,:) = 0;
for k = 1:200
    x = round(30+k/20);
    y = round(20+k/10);
    scan(x:x+3, y:y+2, k) = 1;
end
scanAligned = ImageUtils.AlignSlices(scan, 1);
viewerCorrAligned = UI.StackCorrelationViewer(scanAligned);


%%
scanMean = squeeze(mean(mean(scan, 1), 2));
mRep = repmat(scanMean, [1, size(scan, 1), size(scan, 2)]);
mRep = permute(mRep, [2, 3, 1]);
scanDecorr = scan ./ mRep;
scanDecorrMean = squeeze(mean(mean(scanDecorr, 1), 2));
figure(10);
plot(scanMean);

%%
imageStack = ImageUtils.TImageStack(scanFiltered);
corrMatrix1 = MathUtils.TCorrMatrix(imageStack, [10:19; 51:-1:42]);
corrMatrix2 = MathUtils.TCorrMatrix(imageStack, [20:39; 41:-1:22]);
corrMatrix = MathUtils.TCorrMatrix.CombineMatrices(corrMatrix1, corrMatrix2);
figure; imagesc(corrMatrix.CorrMatrix);
corrMatrixFull = MathUtils.TCorrMatrix(imageStack, [10:39; 51:-1:22]);
figure; imagesc(corrMatrixFull.CorrMatrix);

%%
clc;
close all;
scanAlignedFilteredChunk = scanAlignedFiltered(10:40, 10:40, 1:end);
viewerCorrAligned = UI.StackCorrelationViewer(scanAlignedFilteredChunk);
clear imStack;
clear likelihoodFunction;
clear regionsGraph;
imStack = ImageUtils.TImageStack(scanAlignedFilteredChunk);
likelihoodFunction = Segment2D.TRegionLikelihood();
regionsGraph = Segment2D.TRegionsGraph(imStack, likelihoodFunction);

clustering = regionsGraph.DoClustering();
viewerClustering = UI.StackViewer(clustering);
% [nRegions, regMap] = regionsGraph.BuildMap();
% figure(10);
% imagesc(regMap);
% axis 'image';
% set(gca, 'YDir', 'normal');
%%
clustersFinal = clustering(:,:,end);
minRegionSize = 5;
nRegions = max(clustersFinal(:));
lRegionSize = zeros(1, nRegions);
for k = clustersFinal(:)'
    lRegionSize(k) = lRegionSize(k) + 1;
end
newIDs = zeros(1, nRegions);
n = 1;
for k = 1:nRegions
    if (lRegionSize(k) >= minRegionSize)
        newIDs(k) = n;
        n = n + 1;
    end
end
for k = 1:length(clustersFinal(:))
    clustersFinal(k) = newIDs(clustersFinal(k));
end
clustersFinalViewer = UI.StackViewer(clustersFinal);



%end












