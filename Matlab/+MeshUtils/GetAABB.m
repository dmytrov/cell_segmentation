% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2014
%   mailto:dmytro.velychko@student.uni-tuebingen.de

% Returns axis-aligned boundary box of the model
function [ptBBMin, ptBBMax] = GetAABB(model)
    vertices = [model.lVertices(1:model.nVertices).pt];
    ptBBMin = min(vertices, [], 2);
    ptBBMax = max(vertices, [], 2);
end