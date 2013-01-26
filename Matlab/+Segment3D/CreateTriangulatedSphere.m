function model = CreateTriangulatedSphere()
    model = WEMesh.TModel();
    MeshUtils.MakeIcosahedron(model);

    ptCenter = MeshUtils.GetCenter(model);
    fRadius = 1;
    for k = 1:4
        model.DivideAllEdges();
        model.TriangulateAllFacets();
        MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
    end
    
    % "Relax" the mesh
    
    edgesLen = 0;
    for kEdge = model.lEdges
        edgesLen = edgesLen + norm(kEdge.vertex.pt - kEdge.eOpposite.vertex.pt);
    end
    meanEdgeLen = edgesLen / length(model.lEdges);
    
    nIterations = 1;
    relaxFactor = 0.1;
    for kIteration = 1:nIterations
        for kVertex = model.lVertices
            kVertex.tag = [0, 0, 0]';
        end
        for kEdge = model.lEdges
            edgeLen = norm(kEdge.vertex.pt - kEdge.eOpposite.vertex.pt);
            vEdge = kEdge.vertex.pt - kEdge.eOpposite.vertex.pt;
            kEdge.vertex.tag = kEdge.vertex.tag - vEdge * (edgeLen-meanEdgeLen);
        end
        for kVertex = model.lVertices
            kVertex.pt = kVertex.pt + relaxFactor * kVertex.tag;
        end
    end
    
    for kVertex = model.lVertices
    	kVertex.tag = [];
    end
    
    MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
end