% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = FindRaysCollisions(model, scan, ptCenter)
    %% Rough cell fit
    %pt1 = ptCenter;
    k = 1;
    for ve = model.lVertices
        %ve.pt = ve.pt/norm(ve.pt);
        %pt2 = ve.pt;                
        veLen = norm(ve.pt - ptCenter);
        veUnit = (ve.pt - ptCenter) / veLen;
        [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(ptCenter, ve.pt, scan, -veLen, veLen);
        % Quick dot product ray distance  
        dist = veUnit' * (ptIntersectRes - repmat(ptCenter, 1, size(ptIntersectRes, 2)));
        % sqrt(sum((ptIntersectRes - repmat(ptCenter, 1, size(ptIntersectRes, 2))).^2, 1))
        res(k) = Segment3D.TVectorImageIntersectRes(ptIntersectRes, imgCoords, imgValAtPt, dist);
        k = k + 1;
    end
end