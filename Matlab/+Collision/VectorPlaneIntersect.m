% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [ptIntersect, bIntersect] = VectorPlaneIntersect(ptVec, vVec, ptPlane, vnPlane)
    ptIntersect = nan(3, 1);
    bIntersect = (vnPlane'*vVec) ~= 0;
    if (bIntersect)
        k = (vnPlane'*(ptPlane - ptVec)) / (vnPlane'*vVec);
        ptIntersect = ptVec + k*vVec;
    end
end