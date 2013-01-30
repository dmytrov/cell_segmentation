% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function ptProject = PointPlaneProject(pt, ptPlane, vnPlane)
    k = vnPlane'*(ptPlane-pt)/(vnPlane'*vnPlane);
    ptProject = pt + k*vnPlane;
end