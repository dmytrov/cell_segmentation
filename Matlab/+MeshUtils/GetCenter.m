% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function pt = GetCenter(model)
     vertices = [model.lVertices(1:model.nVertices).pt];
     pt = mean(vertices, 2);
end