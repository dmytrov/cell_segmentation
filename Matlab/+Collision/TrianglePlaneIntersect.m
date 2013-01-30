% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [ptIntersect, bIntersect] = TrianglePlaneIntersect(pt1, pt2, pt3, ptPlane, vnPlane)
    ptIntersect = nan(3, 3);
    bIntersect = nan(1, 3);
    [ptIntersect(:, 1), bIntersect(1)] = Collision.SegmentPlaneIntersect(pt1, pt2, ptPlane, vnPlane);
    [ptIntersect(:, 2), bIntersect(2)] = Collision.SegmentPlaneIntersect(pt2, pt3, ptPlane, vnPlane);
    [ptIntersect(:, 3), bIntersect(3)] = Collision.SegmentPlaneIntersect(pt1, pt3, ptPlane, vnPlane);
    ptIntersect = ptIntersect(:, logical(bIntersect));
    bIntersect = sum(bIntersect) > 1;
end