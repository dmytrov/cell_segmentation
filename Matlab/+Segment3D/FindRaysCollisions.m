function res = FindRaysCollisions(model, scan, ptCenter)
    %% Rough cell fit
    %pt1 = ptCenter;
    k = 1;
    for ve = model.lVertices
        %ve.pt = ve.pt/norm(ve.pt);
        %pt2 = ve.pt;
        vectorLen = norm(ve.pt - ptCenter);
        [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(ptCenter, ve.pt, scan, -vectorLen, vectorLen);
        % Quick dot product ray distance  
        dist = (ve.pt-ptCenter)' * (ptIntersectRes - repmat(ptCenter, 1, size(ptIntersectRes, 2)));
        % sqrt(sum((ptIntersectRes - repmat(ptCenter, 1, size(ptIntersectRes, 2))).^2, 1))
        res(k) = Segment3D.TVectorImageIntersectRes(ptIntersectRes, imgCoords, imgValAtPt, dist);
        k = k + 1;
    end
end