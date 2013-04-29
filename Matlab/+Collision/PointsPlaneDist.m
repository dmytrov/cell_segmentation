% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function dists = PointsPlaneDist(pts, ptPlane, vnPlane)
    dists = vnPlane' * bsxfun(@minus, pts, ptPlane);
end