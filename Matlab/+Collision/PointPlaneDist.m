function dist = PointPlaneDist(pt, ptPlane, vnPlane)
    dist = vnPlane' * (pt - ptPlane);
end