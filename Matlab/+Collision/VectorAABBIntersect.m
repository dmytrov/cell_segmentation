% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [ptIntersect, bIntersect] = VectorAABBIntersect(ptRay, vRay, ptBBMin, ptBBMax)
    ptIntersect = nan(3, 1);
    BBSize = ptBBMax - ptBBMin;
    p = nan(3, 6);
    b = nan(1, 6);
    [p(:, 1), b(1)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMin, [1, 0, 0]', BBSize(2), BBSize(3));
    [p(:, 2), b(2)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMin, [0, 1, 0]', BBSize(1), BBSize(3));
    [p(:, 3), b(3)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMin, [0, 0, 1]', BBSize(1), BBSize(2));
    [p(:, 4), b(4)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMax, [1, 0, 0]', -BBSize(2), -BBSize(3));
    [p(:, 5), b(5)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMax, [0, 1, 0]', -BBSize(1), -BBSize(3));
    [p(:, 6), b(6)] = VectorAARectangleIntersect(ptRay, vRay, ptBBMax, [0, 0, 1]', -BBSize(1), -BBSize(2));
    bIntersect = any(b);
    if (bIntersect)
    	p(:, ~b) = [];
        dist = vRay' * (p - repmat(ptRay, 1, size(p, 2)));
        [~, I] = min(dist);        
        ptIntersect = p(:, I);
    end
end

function [ptIntersect, bIntersect] = VectorAARectangleIntersect(ptRay, vRay, ...
        pt, vn, displacement1, dispacement2)
    assert(sum(vn == 0) == 2);
    [ptIntersect, bIntersect] = Collision.VectorPlaneIntersect(ptRay, vRay, pt, vn);
    bIntersect = bIntersect && ...
                 ((all(ptIntersect(~vn) >= pt(~vn)) && ...
                   all(ptIntersect(~vn) <= (pt(~vn) + [displacement1, dispacement2]'))) || ...
                  (all(ptIntersect(~vn) <= pt(~vn)) && ...
                   all(ptIntersect(~vn) >= (pt(~vn) + [displacement1, dispacement2]'))) ...
                  );
end