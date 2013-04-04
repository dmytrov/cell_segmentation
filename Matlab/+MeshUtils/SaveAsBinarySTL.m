% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

% See http://www.ennex.com/~fabbers/StL.asp for the STL file format
% description
function SaveAsBinarySTL(model, sFilename)
    assert(isa(model, 'WEMesh.TModel'));
    f = fopen(sFilename, 'w');
    
    % Arbitrary meaningfull header, 80 bytes
    header = 'http://www.cin.uni-tuebingen.de/. AG Euler, AG Bethge. Data produced by CellLab.';
    fwrite(f, header);
    % Number of fasets
    fwrite(f, model.nFacets, 'uint32');
    % Facets data
    for k = 1:model.nFacets
        nFacetEdges = min(3, size(model.lFacets(k).lEdges, 2));
        lPts = nan(3, nFacetEdges);
        edgeCurrent = model.lFacets(k).lEdges(1);
        for k2 = 1:nFacetEdges
            lPts(:, k2) = edgeCurrent.vertex.pt;
            edgeCurrent = edgeCurrent.eNext;
        end
        vn = cross((lPts(:, 3) - lPts(:, 2)), (lPts(:, 1) - lPts(:, 2)));
        vn = vn / norm(vn);
        if (any(isnan(vn)))
            vn = [0, 0, 0]';
        end
        
        fwrite(f, vn, 'single');  % normal vector
        fwrite(f, lPts, 'single');% vertices
        fwrite(f, 0, 'uint16');   % dummy attribute
    end    
    
    fclose(f);
end

