function values = FindRaysValues(settings, model, scanAligned, distances)
    values = nan(length(distances), length(model.lVertices));
    regressor = Regression.LinearStackRegressor(scanAligned, settings);

    % Pack points into an array for batch processing
    allPts = nan(3, length(distances), length(model.lVertices));
    k = 1;
    for ve = model.lVertices
        pts = bsxfun(@times, Collision.VectorUnit(ve.pt - model.ptCenter), distances);
        pts = bsxfun(@plus, pts, model.ptCenter);
        allPts(:, :, k) = pts;
        k = k + 1;
    end
    
    % Find all points values
    values = reshape(regressor.Value(reshape(allPts, 3, [])), size(values));
    
    % Fill the vertices tags
    k = 1;
    for ve = model.lVertices    
        ve.tag.scanValues = values(:, k);
        k = k + 1;
    end
end
