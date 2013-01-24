function [distToNearest, nearestCellID, distPrior] = FindRaysNearestRegions(settings, model, cellID, cellsRegions, distances)
    %dist = nan(length(distances), length(model.lVertices));
    %IDs = nan(length(distances), length(model.lVertices));

    % Pack points into an array for batch processing
    allPts = nan(3, length(distances), length(model.lVertices));
    k = 1;
    for ve = model.lVertices
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
    distPrior = distToNearest ./ distToCurrent;
    distPrior(nearestCellID == cellID) = 1;
    
    % Reshape everything back
    distToNearest = reshape(distToNearest, length(distances), length(model.lVertices));
    nearestCellID = reshape(nearestCellID, length(distances), length(model.lVertices));
    distPrior = reshape(distPrior, length(distances), length(model.lVertices));
    
    % Fill the vertices tags
    k = 1;
    for ve = model.lVertices    
        ve.tag.distToNearest = distToNearest(:, k);
        ve.tag.nearestCellID = nearestCellID(:, k);
        ve.tag.distPrior = distPrior(:, k);
        k = k + 1;
    end
end

function res = VectorLen(v)
    res = sqrt(sum(v.^2, 1));
end