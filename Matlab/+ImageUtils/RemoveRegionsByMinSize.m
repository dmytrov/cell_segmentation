function res = RemoveRegionsByMinSize(img, minRegionSize)
    res = img;
    nRegions = max(res(:));
    lRegionSize = zeros(1, nRegions);
    for k = res(:)'
        lRegionSize(k) = lRegionSize(k) + 1;
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
        res(k) = newIDs(res(k));
    end
end