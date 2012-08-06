clear classes;
%v = WEMesh.TVertex.empty;
%v(3).pt = [1,2,3];
model = WEMesh.TModel;
model.MakeTetrahedron();
plot(model);