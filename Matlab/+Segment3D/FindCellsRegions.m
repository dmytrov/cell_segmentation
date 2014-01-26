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
    nRegions = length(centroids);
    
    % Create search structures
    pixelList = regionprops(connectedComponents, 'PixelList');
    regions = Segment3D.TRegionDescsList();
    
    pixels = cell(1, nRegions);
    pixelsInMicrons = cell(1, nRegions);
    center = cell(1, nRegions);
    surface = cell(1, nRegions);
    for k = 1:nRegions
    %parfor k = 1:nRegions
        pixels{k} = FixMatlabDimensionsOrder(pixelList(k).PixelList');
        pixelsInMicrons{k} = settings.PixToMicron(pixels{k});
        center{k} = FixMatlabDimensionsOrder(centroids(k).Centroid');
        center{k} = settings.PixToMicron(center{k});
        surface{k} = Segment3D.CreateSurfaceMesh(settings, pixels{k});
    end
    
    for k = 1:nRegions
        regions.AddRegionDesc( ...
            pixelsInMicrons{k}, ...
            center{k}, ...
            surface{k}, ...
            Segment3D.TRegionDesc.UNCLASSIFIED);
    end
    
end

function res = FixMatlabDimensionsOrder(x)
    res =  x([2, 1, 3], :);
end




