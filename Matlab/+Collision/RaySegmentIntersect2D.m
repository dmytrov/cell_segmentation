% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [bIntersect, pt] = RaySegmentIntersect2D(p1, v1, ptSeg1, ptSeg2)
    pt = nan(2, 1);
    p2 = ptSeg1;
    v2 = ptSeg2 - ptSeg1;
    k2 = ((p2(2) - p1(2))*v1(1) - (p2(1) - p1(1))*v1(2)) / (v2(1)*v1(2) - v2(2)*v1(1));
    k1 = ((p1(2) - p2(2))*v2(1) - (p1(1) - p2(1))*v2(2)) / (v1(1)*v2(2) - v1(2)*v2(1));
    bIntersect = (~isnan(k1) && ~isinf(k1) && (k1 >= 0) && (k2 >= 0) && (k2 <= 1));
    if (bIntersect)
        pt = p1 + k1 * v1;
    end
end