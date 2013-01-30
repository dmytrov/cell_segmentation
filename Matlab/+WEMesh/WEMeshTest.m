% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function WEMeshTest()

    clear classes;
    close all;
    %v = WEMesh.TVertex.empty;
    %v(3).pt = [1,2,3];
    model = WEMesh.TModel(1000);
    MeshUtils.MakeIcosahedron(model);

	ptCenter = MeshUtils.GetCenter(model);
	fRadius = 10;
    for k = 1:2
        model.DivideAllEdges();
        model.TriangulateAllFacets();
        MeshUtils.ProjectOnSphere(model, ptCenter, fRadius);
    end
    figure;
    opengl hardware;
    plot(model);
end