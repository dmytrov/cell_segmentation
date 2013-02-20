%function Test()

%%
clc;
close all;
clear classes;
%sScanFileName = '../Data/D_distal.tif';
sScanFileName = '../Data/Q3 FF2.tif';
scan = ImageUtils.LoadTIFF(sScanFileName);
scan = scan(:, 4:end, 2:end);

viewerCorr = UI.StackCorrelationViewer(scan);
% scan(:,:,:) = 0;
% for k = 1:200
%     scan(round(30+k/20), round(20+k/10), k) = 1;
% end
scanAligned = ImageUtils.AlignSlices(scan, 1);
viewerCorrAligned = UI.StackCorrelationViewer(scanAligned);

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
viewerDecorr = UI.StackCorrelationViewer(scanDecorr);


%end