%% Correlative PSF
[fx, fy, fz] = ImageUtils.Gradient3D(scan);

%%
viewer = UI.StackViewer(fx);

%%
sampleLen = 45;
nSamples = 100000;
[sx, sy, sz] = size(fx);
samples = nan(sampleLen, nSamples);
for k = 1:nSamples
    switch (2)
        case 1
            r = randi(sx - sampleLen+1);
            samples(:, k) = fx(r:r+sampleLen-1, randi(sy), randi(sz));
        case 2
            r = randi(sz - sampleLen+1);
            samples(:, k) = fz(randi(sx), randi(sy), r:r+sampleLen-1);
    end
end

sampes = samples - repmat(mean(samples, 2), 1, nSamples);
imagesc(samples*samples'/nSamples);
colorbar;




