function Test()
    sx = 11;
    sz = 3;
    cx = 3;
    cy = 3;
    cz = 0.5;
    kernel = ImageUtils.Make3DGaussKernel(sx, sx, sz, cx, cy, cz);
    figure;
    for k = 1:sz
        subplot(2, sz, k); 
        imagesc(kernel(:, :, k));
        axis square;
        subplot(2, sz, sz+k); 
        imagesc(squeeze(kernel((sx+1)/2+k, :, :))');
    end
end
