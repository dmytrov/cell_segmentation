function res = FilterStack(settings, stack, fCutoff, mode)
    [sx, sy, sz] = size(stack);                
    res = reshape(permute(stack, [3, 1, 2]), sz, []);
    res = SignalUtils.RemoveMean(res);
    res = SignalUtils.Butterworth(res, settings.FrameRate, fCutoff, mode);
    res = reshape(res', sx, sy, []);
end