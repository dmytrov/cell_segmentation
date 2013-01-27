function [distToNearest, nearestCellID, distPrior] = FindRaysNearestRegions(settings, model, cellID, cellsRegions, distances)
    % Pack points into an array for batch processing
    allPts = nan(3, length(distances), model.nVertices);
    k = 1;
    for ve = model.lVertices(1:model.nVertices)
        pts = bsxfun(@times, Collision.VectorUnit(ve.pt - model.ptCenter), distances);
        pts = bsxfun(@plus, pts, model.ptCenter);
        allPts(:, :, k) = pts;
        k = k + 1;
    end
    
    allPtsReshaped = reshape(allPts, 3, []);
    
    % Find all points and IDs
    [nearestPts, nearestCellID] = cellsRegions.NearestPoint(allPtsReshaped);
    % Calculate distances to the nearest cell
    distToNearest = VectorLen(allPtsReshaped - nearestPts);
    % Calculate distances to the current cell    
    distToCurrent = VectorLen(allPtsReshaped - cellsRegions.RegionDesc(cellID).NearestPoint(allPtsReshaped));
    % Calculate the proximity based priors
    distPrior = (distToNearest ./ distToCurrent).^2; % square makes fast non-linear decay
    distPrior(nearestCellID == cellID) = 1;
    %distPrior(nearestCellID ~= cellID) = 0; % very strong prior!
    
    % Reshape everything back
    distToNearest = reshape(distToNearest, length(distances), model.nVertices);
    nearestCellID = reshape(nearestCellID, length(distances), model.nVertices);
    distPrior = reshape(distPrior, length(distances), model.nVertices);
    
    % Distance prior must be monotonic
    for k = 2:length(distances)
        distPrior(k, :) = min(distPrior(k-1, :), distPrior(k, :));
    end
    
    % Fill the vertices tags
    k = 1;
    for ve = model.lVertices(1:model.nVertices)
        ve.tag.distToNearest = distToNearest(:, k);
        ve.tag.nearestCellID = nearestCellID(:, k);
        ve.tag.distPrior = distPrior(:, k);
        k = k + 1;
    end
end

function res = VectorLen(v)
    res = sqrt(sum(v.^2, 1));
end