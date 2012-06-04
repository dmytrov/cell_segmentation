function res = ELClamp(x, v1, v2)
    res = x;
    res = (res-v1).*(res>v1) + v1;
    res = (res-v2).*(res<v2) + v2;
end