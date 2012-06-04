%seg = Segmentation();
%scan = double(imread('CellImages\q1_Ch0_Ave.tif'));
%scan = double(imread('CellImages\slice512x512.tif'));

close all;
% scan = min(scan, 40.0);
% for k1 = 0.1:0.2:2
%     H = fspecial('gaussian', [7, 7], k1);
%     scanFiltered = imfilter(scan, H, 'replicate');
%     figure; image(scanFiltered);
% end

% opt.sigma1 = 10;
% opt.sigma2 = 11;
% opt.min_area = 8;
% opt.max_area = 10;
% opt.max_eccentricity = 1;
% opt.min_rel_intensity = 8;
% m = Segmentation.convex(scan, 1, opt);

%figure; image(m);

%%

fileName = 'CellImages\ExampleStack.tif';
info = imfinfo(fileName);
%imgToLoad = 1:50;
imgToLoad = 1:numel(info);
img(1:info(1).Width, 1:info(1).Height, size(imgToLoad)) = 0;
for k = imgToLoad
    img(:,:,k) = imread(fileName, k);
end
    
im = img;
%im = double(imread('CellImages\q1_Ch0_Ave.tif'));

k = hamming(5); k=k/sum(k);  %  smoothing kernel
f = zeros([5,5,5]);
for k1 = 1:5
    f(:,:,k1) = k(k1)*(k*k');
end    
s = imfilter(im, f);
%imagesc(im);
thresh = 8;
%r = double(watershed(-s));  % watershed, thresholding
r = double(watershed(-s)).*(s>thresh);  % watershed, thresholding

figure;
%imagesc(r)
NeuronDetectorUI(r, [0, 1]);