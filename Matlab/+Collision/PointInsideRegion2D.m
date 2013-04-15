
function res = PointInsideRegion2D(pt, section)
    res = false;
    for k = 1:size(section, 3)
        pt1 = section(1, :, k);
        pt2 = section(2, :, k);
        if (Collision.RaySegmentIntersect2D(pt, [0, 1]', pt1, pt2))
            res = ~res;
        end
    end   
    
end




