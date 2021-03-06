function res = ELImResize(img, factor)
    [sx, sy] = size(img);
    sxNew = floor((sx-factor)/factor) + 1;
    syNew = floor((sy-factor)/factor) + 1;
    res = nan(sxNew, syNew);
    for k1 = 1:sxNew
        for k2 = 1:syNew
            res(k1, k2) = mean(mean(img((k1-1)*factor+1:min(sx, k1*factor), (k2-1)*factor+1:min(sy, k2*factor))));
        end
    end
end