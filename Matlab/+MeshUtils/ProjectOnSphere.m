% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function ProjectOnSphere(model, ptModelCenter, fRadius)
     for ve = model.lVertices(1:model.nVertices)
         v = ve.pt - ptModelCenter;
         v = v / norm(v);
         ve.pt = ptModelCenter + v * fRadius;
     end
end