function [ptIntersect, bIntersect] = SegmentPlaneIntersect(pt1, pt2, ptPlane, vnPlane)
    ptIntersect = nan(3, 1);
    vVec = pt2 - pt1;
    bIntersect = (vnPlane'*vVec) ~= 0;
    if (bIntersect)
        k = (vnPlane'*(ptPlane - pt1)) / (vnPlane'*vVec);
        ptIntersect = pt1 + k*vVec;
        bIntersect =  ((ptIntersect - pt1)' * (ptIntersect - pt2)) <= 0;        
    end
end