% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function regions = FindCellsRegions(settings, convergence)
    % Threshold
    coMax = max(convergence(:));
    thresh = settings.ConvergenceThreshold * coMax;
    
    if (settings.IsDebug)
        % Visualise the thresholded convergence 
        coThreshInd = convergence > thresh;
        coThresh = convergence;
        coThresh(coThreshInd) = convergence(coThreshInd) + coMax;
        convViewer = UI.StackViewer(cat(1, convergence, coThresh));
    end

    coThresh = convergence > thresh;
        
    % Find the centers of the thresholded regions
    connectedComponents = bwconncomp(coThresh, 18); % 6, 18, 26 (connectivity criteria)
    centroids = regionprops(connectedComponents, 'centroid');
    
    % Create search structures
    pixelList = regionprops(connectedComponents, 'PixelList');
    regions = Segment3D.TRegionDescsList();
    for k = 1:length(centroids)
        pixels = FixMatlabDimentionsOrder(pixelList(k).PixelList');
        center = FixMatlabDimentionsOrder(centroids(k).Centroid');
        surface = Segment3D.CreateSurfaceMesh(settings, pixels);
        regions.AddRegionDesc( ...
            settings.PixToMicron(pixels), ...
            settings.PixToMicron(center), ...
            surface, ...
            Segment3D.TRegionDesc.UNCLASSIFIED);
    end
end

function res = FixMatlabDimentionsOrder(x)
    res =  x([2, 1, 3], :);
end




