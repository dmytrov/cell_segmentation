function ptIntersect = MeshPlaneIntersect(model, ptPlane, vnPlane)
    nFacets = length(model.lFacets);
    ptIntersect = nan(2, 3, nFacets);
    k = 0;
    for fa = model.lFacets
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