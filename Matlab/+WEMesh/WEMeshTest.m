function WEMeshTest()

    clear classes;
    %v = WEMesh.TVertex.empty;
    %v(3).pt = [1,2,3];
    model = WEMesh.TModel;
    model.MakeTetrahedron();
    model.DivideAllEdges();
    model.TriangulateAllFacets();
    plot(model);
    
end