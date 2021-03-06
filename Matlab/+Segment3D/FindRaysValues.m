% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function values = FindRaysValues(settings, model, scanAligned, distances)
    values = nan(length(distances), model.nVertices);
    regressor = Regression.LinearStackRegressor(scanAligned, settings);

    % Pack points into an array for batch processing
    allPts = nan(3, length(distances), model.nVertices);
    k = 1;
    for ve = model.lVertices(1:model.nVertices)
        pts = bsxfun(@times, Collision.VectorUnit(ve.pt - model.ptCenter), distances);
        pts = bsxfun(@plus, pts, model.ptCenter);
        allPts(:, :, k) = pts;
        k = k + 1;
    end
    
    % Find all points values
    values = reshape(regressor.Value(reshape(allPts, 3, [])), size(values));
    values(isnan(values)) = 0;
    
    % Fill the vertices tags
    k = 1;
    for ve = model.lVertices(1:model.nVertices)   
        ve.tag.scanValues = values(:, k);
        k = k + 1;
    end
end
