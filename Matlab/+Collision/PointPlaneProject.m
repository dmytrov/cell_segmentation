function ptProject = PointPlaneProject(pt, ptPlane, vnPlane)
    k = vnPlane'*(ptPlane-pt)/(vnPlane'*vnPlane);
    ptProject = pt + k*vnPlane;
end