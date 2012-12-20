%% Correlative PSF
[fx, fy, fz] = ImageUtils.Gradient3D(scan);

%%
viewer = UI.StackViewer(fz);

%%
sampleLen = 45;
nSamples = 100000;
[sx, sy, sz] = size(fx);
samples = nan(sampleLen, nSamples);
for k = 1:nSamples
    switch (1)
        case 1
            r = randi(sx - sampleLen+1);
            samples(:, k) = scan(r:r+sampleLen-1, randi(sy), randi(sz));
        case 2
            r = randi(sz - sampleLen+1);
            samples(:, k) = scan(randi(sx), randi(sy), r:r+sampleLen-1);
    end
end

sampes = samples - repmat(mean(samples, 2), 1, nSamples);
imagesc(samples*samples'/nSamples);
colorbar;




