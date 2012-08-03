function [ptIntersect, bIntersect] = VectorPlaneSetIntersect(ptVec, vVec, ptsPlane, vnPlane)
    nPlanes = size(ptsPlane, 2);
    ptIntersect = nan(3, nPlanes);
    bIntersect = (vnPlane'*vVec) ~= 0;
    if (bIntersect)
        for kPlane = 1:nPlanes
            ptPlane = ptsPlane(:, kPlane);
            k = (vnPlane'*(ptPlane - ptVec)) / (vnPlane'*vVec);
            ptIntersect(:, kPlane) = ptVec + k*vVec;
        end
    end
end
