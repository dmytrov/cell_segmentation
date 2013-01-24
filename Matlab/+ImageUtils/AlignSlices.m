function res = AlignSlices(scan)
    % Due to some instability in mechanics/tissue/perfusion the slices may
    % be slightly shifted. 
    % Calculate slices correlation, realign the slices.
    
    res = scan;
    [sx, sy, sz] = size(scan);
    % TODO: Start from the middle slice
    corrSize = 7;
    corrHalfSize = round((corrSize - 1) / 2);
    [corrGridX, corrGridY] = meshgrid(-corrHalfSize:corrHalfSize, -corrHalfSize:corrHalfSize);
    [imgGridX, imgGridY] = meshgrid(1:sx, 1:sy);
    displFullX = 0;
    displFullY = 0;
    for k = 2:sz
        sliceCorr = ImageCorrelation(scan(:,:,k-1), scan(:,:,k), corrSize);
        sliceCorr = sliceCorr - mean([min(sliceCorr(:)), max(sliceCorr(:))]);
        sliceCorr(sliceCorr < 0) = 0;
        %sliceCorr(sliceCorr<mean([min(sliceCorr(:)), max(sliceCorr(:))])) = 0;
        sliceCorr = sliceCorr / sum(sliceCorr(:));
        % Find center of mass (expected value)
        displX = sum(sum(sliceCorr .* corrGridX));
        displY = sum(sum(sliceCorr .* corrGridY));
        displFullX = displFullX + displX;        
        displFullY = displFullY + displY;
        res(:,:,k) = interp2(imgGridX, imgGridY, scan(:,:,k), imgGridX + displFullX, imgGridY + displFullY, 'linear');
    end
    res(isnan(res)) = 0;
end

function res = ImageCorrelation(img1, img2, corrSize)
    [gx, gy] = gradient(img1);
    img1 = abs(gx) + abs(gy);
    [gx, gy] = gradient(img2);
    img2 = abs(gx) + abs(gy);
    [sx, sy] = size(img1);
    corrHalfSize = round((corrSize - 1) / 2);
    corrImgSizeX = sx - 2*corrHalfSize;
    corrImgSizeY = sy - 2*corrHalfSize;
    corrImgSize = corrImgSizeX * corrImgSizeY;
    vectors1 = reshape(img1(1+corrHalfSize:end-corrHalfSize, 1+corrHalfSize:end-corrHalfSize), [], 1);
    vectors2 = nan(corrImgSize, corrSize*corrSize);
    k = 1;
    for k1 = 1:corrSize
        for k2 = 1:corrSize
            vectors2(:, k) = reshape(img2(k1:k1+corrImgSizeX-1, k2:k2+corrImgSizeY-1), [], 1);
            k = k + 1;
        end
    end
    
    vectors1 = vectors1 - mean(vectors1, 1);
    vectors2 = vectors2 - repmat(mean(vectors2, 1), size(vectors2, 1), 1);
    
    c = vectors1' * vectors2;
    res = reshape(c, corrSize, corrSize)';    
end
