function res = VectorHat(v)
    [~, idx] = min(v);
    r = ([1, 2, 3] == idx);
    res = cross(v, r)';
end