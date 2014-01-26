% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2014
%   mailto:dmytro.velychko@student.uni-tuebingen.de

% Returns a bounding sphere, center is calculated as the center of the 
% axis-aligned boundary box of the model (for speed)
function [ptCenter, radius] = GetBoundingSphere(model)
    vertices = [model.lVertices(1:model.nVertices).pt];
    
    ptBBMin = min(vertices, [], 2);
    ptBBMax = max(vertices, [], 2);
    
    ptCenter = (ptBBMax + ptBBMin) / 2;
    distToCenterSqr = sum((vertices - repmat(ptCenter, 1, model.nVertices)).^2, 1);
    radius = sqrt(max(distToCenterSqr));
end