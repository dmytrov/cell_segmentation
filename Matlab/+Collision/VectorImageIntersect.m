% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [ptIntersectRes, imgCoords, imgValAtPt] = VectorImageIntersect(pt1, pt2, img, vectorLenMin, vectorLenMax)
    ptVec = pt1;
    vVec = pt2-pt1;
    vVec = vVec / norm(vVec);
    ptGrid = round(pt1);
    if (nargin == 3)
        vectorLenMin = 0;
        vectorLenMax = max(size(img));
    end
    radGrid = max(abs([vectorLenMin, vectorLenMax]));
    stepGrid = 1;
    ptIntersectX = Collision.VectorGridIntersect(ptVec, vVec, ptGrid, radGrid, stepGrid);
    
    % Check min-max vector len    
    distOnRay = vVec' * (ptIntersectX - repmat(ptVec, 1, size(ptIntersectX, 2)));
    ptIntersectX = ptIntersectX(:, (distOnRay >= vectorLenMin) & (distOnRay <= vectorLenMax));
    
    sImg = size(img);
    ptIntersectRes = nan(3, 0);
    imgCoords = nan(3, 0);
    %valAtPt = nan(0, 0);
    for k = 1:size(ptIntersectX, 2)
        pt = ptIntersectX(:, k);        
        for k2 = 1:3
            if (vVec(k2) < 0)
                pt(k2) = floor(pt(k2)+1);
            else
                pt(k2) = ceil(pt(k2));
            end
        end
        if (all(pt>=1) && all(pt<=sImg'))
            ptIntersectRes = [ptIntersectRes, ptIntersectX(:, k)];
            imgCoords = [imgCoords, pt];
        end
    end
    
    nPt = size(ptIntersectRes, 2);
    imgValAtPt = nan(1, nPt);
    for k = 1:nPt
        imgValAtPt(k) = img(imgCoords(1,k), imgCoords(2,k), imgCoords(3,k));
    end
    
end