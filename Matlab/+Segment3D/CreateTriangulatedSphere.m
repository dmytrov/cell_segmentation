function model = CreateTriangulatedSphere(tesselationLevel)
    model = WEMesh.TModel(12*4^tesselationLevel);
    MeshUtils.MakeIcosahedron(model);

    ptCenter = MeshUtils.GetCenter(model);
    fRadius = 1;
    for k = 1:tesselationLevel
        model.DivideAllEdges();
        model.TriangulateAllFacets();
        MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
    end
    
    % "Relax" the mesh
    
    edgesLen = 0;
    for kEdge = model.lEdges(1:model.nEdges)
        edgesLen = edgesLen + norm(kEdge.vertex.pt - kEdge.eOpposite.vertex.pt);
    end
    meanEdgeLen = edgesLen / model.nEdges;
    
    nIterations = 1;
    relaxFactor = 0.1;
    for kIteration = 1:nIterations
        for kVertex = model.lVertices(1:model.nVertices)
            kVertex.tag = [0, 0, 0]';
        end
        for kEdge = model.lEdges(1:model.nEdges)
            edgeLen = norm(kEdge.vertex.pt - kEdge.eOpposite.vertex.pt);
            vEdge = kEdge.vertex.pt - kEdge.eOpposite.vertex.pt;
            kEdge.vertex.tag = kEdge.vertex.tag - vEdge * (edgeLen-meanEdgeLen);
        end
        for kVertex = model.lVertices(1:model.nVertices)
            kVertex.pt = kVertex.pt + relaxFactor * kVertex.tag;
        end
    end
    
    for kVertex = model.lVertices(1:model.nVertices)
    	kVertex.tag = [];
    end
    
    MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
end