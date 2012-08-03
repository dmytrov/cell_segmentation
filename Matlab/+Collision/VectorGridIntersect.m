function ptIntersectX = VectorGridIntersect(ptVec, vVec, ptGrid, radGrid, stepGrid)
    vVec = vVec/norm(vVec);
    nFullGrids = floor(radGrid/stepGrid);
    
    ptIntersectX = nan(3, 0);
    for k = 1:3
        gridX = ptGrid(1) - nFullGrids:stepGrid:ptGrid(1) + nFullGrids;
        gridSetK = repmat(ptGrid, 1, numel(gridX));
        gridSetK(k,:) = gridX;
        vnPlane = ([1, 2, 3]' == k);
        [ptIntersectNew, bIntersect] = Collision.VectorPlaneSetIntersect(ptVec, vVec, gridSetK, vnPlane);
        if (bIntersect)
            % Keep only the points on the line vector divection
            bPositive = (ptIntersectNew - repmat(ptVec, 1, size(ptIntersectNew, 2)))'*vVec >= 0;
            ptIntersectX = [ptIntersectX, ptIntersectNew(:, bPositive)];
        end
    end
    
    dists = nan(1, size(ptIntersectX, 2));
    for k =1:size(dists, 2)
        dists(k) = dot(vVec, ptIntersectX(:, k));
    end
    [~, sortIdx] = sort(dists, 'ascend');
    ptIntersectX = ptIntersectX(:, sortIdx);
    [ptIntersectX, uniqueIdx, ~] = unique(ptIntersectX', 'rows');
    ptIntersectX = ptIntersectX';
    
end