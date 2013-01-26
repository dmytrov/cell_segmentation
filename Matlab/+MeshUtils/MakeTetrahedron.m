function MakeTetrahedron(model)
    model.Init();

    % Add vertices
    model.lVertices(4).pt = [ 1,  0, -1/sqrt(2)]';
    model.lVertices(3).pt = [-1,  0, -1/sqrt(2)]';
    model.lVertices(2).pt = [ 0,  1,  1/sqrt(2)]';
    model.lVertices(1).pt = [ 0, -1,  1/sqrt(2)]';
    v4 = model.lVertices(4);
    v3 = model.lVertices(3);
    v2 = model.lVertices(2);
    v1 = model.lVertices(1);

    % Add faces
    model.AddFacet(v1, v4, v2);
    model.AddFacet(v3, v2, v4);
    model.AddFacet(v3, v4, v1);
    model.AddFacet(v1, v2, v3);  
end