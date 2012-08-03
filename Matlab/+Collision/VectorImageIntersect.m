function [ptIntersectRes, valAtPt] = VectorImageIntersect(pt1, pt2, img)
    ptVec = pt1;
    vVec = pt2-pt1;
    ptGrid = [0, 0, 0]';
    radGrid = max(size(img));
    stepGrid = 1;
    ptIntersectX = Collision.VectorGridIntersect(ptVec, vVec, ptGrid, radGrid, stepGrid);
    sImg = size(img);
    ptIntersectRes = nan(3, 0);
    %valAtPt = nan(0, 0);
    for k = 1:size(ptIntersectX, 2)
        pt = ptIntersectX(:, k);        
        for k2 = 1:3
            if (vVec(k2) < 0)
                pt(k2) = ceil(pt(k2));
            else
                pt(k2) = floor(pt(k2));
            end
        end
        if (all(pt>=1) && all(pt<=sImg'))
            ptIntersectRes = [ptIntersectRes, pt];
        end
    end
    
    nPt = size(ptIntersectRes, 2);
    valAtPt = nan(1, nPt);
    for k = 1:nPt
        valAtPt(k) = img(ptIntersectRes(1,k), ptIntersectRes(2,k), ptIntersectRes(3,k));
    end
    
end