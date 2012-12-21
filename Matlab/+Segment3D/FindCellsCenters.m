function res = FindCellsCenters(scan)
    % Decimate the data as it does not fit into my RAM
    scan2X = ImageUtils.Downsample2X(scan);
    [fx, fy, fz] = ImageUtils.Gradient3D(scan2X);
    [fx, fy, fz] = ImageUtils.Clamp3D(fx, fy, fz, 0, 0.1);
    sx = 61; %midx = (sx+1)/2;
    sy = 61; %midy = (sy+1)/2;
    sz = 3; %midz = (sz+1)/2;
    k = ImageUtils.Make3DGaussKernel(sx, sy, sz, sx/3, sy/3, sx/3);

    % Fast convergence
    co = ImageUtils.FastConvergence3D(fx, fy, fz, k);
    coMax = max(co(:));
    thresh = 0.5 * coMax;
%     coThreshInd = co < thresh;
%     coThresh = co;
%     coThresh(coThreshInd) = co(coThreshInd) - coMax;
%     convViewer = UI.StackViewer(coThresh);
    coThresh = co > thresh;
    
    % Find the centers of the thresholded regions
    connComp = bwconncomp(coThresh, 18); % 6, 18, 26
    centroids = regionprops(connComp, 'centroid');
    volumes = regionprops(connComp, 'area'); % say "Hi" to Matlab developers
    res = nan(3, 0);
    areaThresh = 1;
    for k = 1:length(centroids)
        if (volumes(k).Area > areaThresh)
            res = [res, centroids(k).Centroid'];
        end
    end
    res = res * 2; % restore the scaling
end