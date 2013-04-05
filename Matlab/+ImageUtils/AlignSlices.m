% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = AlignSlices(scan, sMode, kReferenceSlice, messageLog)
    % Due to some instability in mechanics/tissue/perfusion the slices may
    % be slightly shifted. 
    % Calculate slices correlation, realign the slices.
    CONTINUOUS = 0;
    SINGLE_REFERENCE = 1;
    res = scan;
    [sx, sy, sz] = size(scan);
    if (nargin < 4)
        messageLog = Core.TMessageLog();
    end
    if (nargin < 3)
        kReferenceSlice = 1;
    end
    if (nargin < 2)
        sMode = 'CONTINUOUS';
    end
    if (strcmp(sMode, 'CONTINUOUS'))
        mode = CONTINUOUS;
        alignOrder = 2:sz;
        alignReference = 0:sz - 1;
    else
        mode = SINGLE_REFERENCE;
        alignOrder = [kReferenceSlice-1:-1:1, kReferenceSlice+1:sz];        
        alignReference = kReferenceSlice + zeros(1, sz);
    end
    corrSize = 9;
    corrHalfSize = round((corrSize - 1) / 2);
    [corrGridX, corrGridY] = meshgrid(-corrHalfSize:corrHalfSize, -corrHalfSize:corrHalfSize);
    [imgGridX, imgGridY] = meshgrid(1:sx, 1:sy);
    displFullX = 0;
    displFullY = 0;
    for k = alignOrder
        messageLog.PrintLine(sprintf('Aligning slice %d of %d', k, sz));	
        sliceCorr = ImageCorrelation(scan(:,:,alignReference(k)), scan(:,:,k), corrSize);
        
        %maxBorder = max([sliceCorr(1, :), sliceCorr(end, :), sliceCorr(:, 1)', sliceCorr(:, end)']);
        %sliceCorr = sliceCorr - maxBorder;
        
        sliceCorr = sliceCorr - mean([min(sliceCorr(:)), max(sliceCorr(:))]);
        
        sliceCorr(sliceCorr < 0) = 0;
        sliceCorr = sliceCorr / sum(sliceCorr(:));
        % Find center of mass (expected value)
        displX = sum(sum(sliceCorr .* corrGridX));
        displY = sum(sum(sliceCorr .* corrGridY));
        if (isnan(displX) || isnan(displY));
            displX = 0;
            displY = 0;
        end
        if (mode == CONTINUOUS)
            displFullX = displFullX + displX;        
            displFullY = displFullY + displY;
        else
            displFullX = displX;        
            displFullY = displY;
        end
        % Due to inconsistency in matlab indexing order, X and Y are mixed:
        res(:,:,k) = interp2(imgGridX, imgGridY, scan(:,:,k)', imgGridX + displFullY, imgGridY + displFullX, 'linear')';
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
