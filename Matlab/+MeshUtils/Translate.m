% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function Translate(model, v)
     for ve = model.lVertices(1:model.nVertices)
         ve.pt = ve.pt + v;
     end
     model.ptCenter = model.ptCenter + v;
end