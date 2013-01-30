% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function pt = GetCenter(model)
     pt = [0, 0, 0]';
     for ve = model.lVertices(1:model.nVertices)
         pt = pt + ve.pt;
     end
     pt = pt / model.nVertices;
end