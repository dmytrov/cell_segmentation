% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function Scale(model, ptModelCenter, vFactor)
     for ve = model.lVertices(1:model.nVertices)
         v = ve.pt - ptModelCenter;
         ve.pt = v .* vFactor + ptModelCenter;
     end
end