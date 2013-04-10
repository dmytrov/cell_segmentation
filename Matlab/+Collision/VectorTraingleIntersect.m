function [ptIntersect, bIntersect] = VectorTraingleIntersect(ptVec, vVec, pt1, pt2, pt3)
    vn = cross((pt2-pt1), (pt3-pt1));
    [ptIntersect, bIntersect] = Collision.VectorPlaneIntersect(ptVec, vVec, pt1, vn);
    if (bIntersect)
        pts = [pt1, pt2, pt3, pt1];
        % Check the point is on the same side w.r.t all edges 
        r = 0;
        for k = 1:3
           r = r + sign((ptIntersect-pts(:, k))' * cross(vn, pts(:, k) - pts(:, k+1)));
        end
        bIntersect = ((r <= -2) ||( r >= 2)); % allow point laying on an edge
    end
end