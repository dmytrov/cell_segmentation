% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function dist = PointPlaneDist(pt, ptPlane, vnPlane)
    dist = vnPlane' * (pt - ptPlane);
end