% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function ptIntersect = MeshPlaneIntersect(model, ptPlane, vnPlane)
    ptIntersect = nan(2, 3, model.nFacets);
    k = 0;
    for fa = model.lFacets(1:model.nFacets)
        [pts, bIntersect] = Collision.TrianglePlaneIntersect(fa.lEdges(1).vertex.pt,...
                                                             fa.lEdges(2).vertex.pt,...
                                                             fa.lEdges(3).vertex.pt,...
                                                             ptPlane, vnPlane);
        if (bIntersect)
            k = k + 1;
            ptIntersect(:, :, k) = pts(:,1:2)';
        end
    end
    ptIntersect = ptIntersect(:, :, 1:k);
end