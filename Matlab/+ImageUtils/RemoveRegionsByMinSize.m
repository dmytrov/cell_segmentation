function res = RemoveRegionsByMinSize(img, minRegionSize)
    res = img;
    res(res < 0) = 0;
    nRegions = max(res(:));
    lRegionSize = zeros(1, nRegions);
    for k = res(:)'
        if (k > 0)
            lRegionSize(k) = lRegionSize(k) + 1;
        end
    end
    newIDs = zeros(1, nRegions);
    n = 1;
    for k = 1:nRegions
        if (lRegionSize(k) >= minRegionSize)
            newIDs(k) = n;
            n = n + 1;
        end
    end
    for k = 1:length(res(:))
        if (res(k) > 0)
            res(k) = newIDs(res(k));
        end
    end
end