function res = RemoveMean(x)
    res = bsxfun(@minus, x, mean(x, 1));
end