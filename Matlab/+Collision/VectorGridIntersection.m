function lPts = VectorGridIntersection(pt, v)
    % Returns list of segment-grid intersections.
    
    sLen = norm(v);
    vDir = v/lLen;
    pt1 = pt;
    pt2 = pt + v;
    
    x1 = pt1(1)
    x2 = pt2(1);
    xCS = abs(floor(x1) - floor(x2));
    
end
