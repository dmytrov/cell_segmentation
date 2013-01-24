function regions = FindCellsRegions(settings, scan)
    % Blur
    kernelVariance = settings.ConvergenceBlurVariance;
    kernelSize = round(3 * kernelVariance / 2) * 2 + 1; % odd dimentionality    
    k = ImageUtils.Make3DGaussKernel(kernelSize, kernelVariance);
    scanBlurred = ImageUtils.FastConvolution3D(scan, k);
    [fx, fy, fz] = ImageUtils.Gradient3D(scanBlurred);
    [fx, fy, fz] = ImageUtils.Clamp3D(fx, fy, fz, 0, 0.1);
    
    % Construct convergence kernel
    kernelVariance = settings.MicronToPix(settings.ConvergenceKernelVariance); 
    kernelSize = round(3 * kernelVariance / 2) * 2 + 1; % odd dimentionality
    k = ImageUtils.Make3DGaussKernel(kernelSize, kernelVariance);

    % Fast convergence
    co = ImageUtils.FastConvergence3D(fx, fy, fz, k);
    %viewer = UI.StackProfileViewer(co);
    
    % Threshold
    coMax = max(co(:));
    thresh = 0.5 * coMax;
%     % Visualise the thresholded convergence 
%     coThreshInd = co < thresh;
%     coThresh = co;
%     coThresh(coThreshInd) = co(coThreshInd) - coMax;
%     convViewer = UI.StackViewer(coThresh);

    coThresh = co > thresh;
        
    % Find the centers of the thresholded regions
    connectedComponents = bwconncomp(coThresh, 18); % 6, 18, 26 (connectivity criteria)
    centroids = regionprops(connectedComponents, 'centroid');
    volumes = regionprops(connectedComponents, 'area'); % Matlab developers believe that area is equal to volume
    
    % TODO: classify cells/vessels/axons
    
    % Create search structures
    pixelList = regionprops(connectedComponents, 'PixelList');
    regions = Segment3D.TRegionDescsList();
    for k = 1:length(centroids)
        % Simple threshold classification        
        if (volumes(k).Area > settings.ConvergenceVolumeThresold)                
            type = Segment3D.TRegionDesc.CELL;
        else
            type = Segment3D.TRegionDesc.NOISE;
        end
        
        regions.AddRegionDesc( ...
            settings.PixToMicron(pixelList(k).PixelList'), ...
            settings.PixToMicron(centroids(k).Centroid'), ...
            type);
    end
end
