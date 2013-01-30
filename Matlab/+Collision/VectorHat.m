% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = VectorHat(v)
    [~, idx] = min(v);
    r = ([1, 2, 3] == idx);
    res = cross(v, r)';
end