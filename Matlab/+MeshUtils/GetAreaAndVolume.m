% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [S, V] = GetAreaAndVolume(model)
    S = 0;
    V = 0;
    
    for k = 1:model.nFacets
        nFacetEdges = min(3, size(model.lFacets(k).lEdges, 2));
        lPts = nan(3, nFacetEdges);
        edgeCurrent = model.lFacets(k).lEdges(1);
        for k2 = 1:nFacetEdges
            lPts(:, k2) = edgeCurrent.vertex.pt;
            edgeCurrent = edgeCurrent.eNext;
        end
        
        V = V + (1/6) * det(lPts);
        S = S + 0.5 * norm(cross((lPts(:, 3) - lPts(:, 2)), (lPts(:, 1) - lPts(:, 2))));
    end    
end