% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [bIntersect, pt] = LineLineIntersect2D(p1, v1, p2, v2)
    pt = nan(2, 1);
    k1 = ((p1(2) - p2(2))*v2(1) - (p1(1) - p2(1))*v2(2)) / (v1(1)*v2(2) - v1(2)*v2(1));
    bIntersect = (~isnan(k1) && ~isinf(k1));
    if (bIntersect)
        pt = p1 + k1 * v1;
    end
end