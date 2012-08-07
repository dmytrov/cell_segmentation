function WEMeshTest()

    clear classes;
    close all;
    %v = WEMesh.TVertex.empty;
    %v(3).pt = [1,2,3];
    model = WEMesh.TModel;
    model.MakeTetrahedron();

	ptCenter = MeshUtils.GetCenter(model);
	fRadius = 10;
    for k = 1:4
        model.DivideAllEdges();
        model.TriangulateAllFacets();
        MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
    end
    figure;
    opengl hardware;
    plot(model);
end