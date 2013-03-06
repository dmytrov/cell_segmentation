function res = RemoveMeanStackTraces(stack)
    [sx, sy, sz] = size(stack);                
    res = reshape(permute(stack, [3, 1, 2]), sz, []);
    res = SignalUtils.RemoveMean(res);
    res = reshape(res', sx, sy, []);
end