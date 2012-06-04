function res = ELImStackResize(img, factor)
    [sx, sy, sz] = size(img);
    sxNew = floor((sx-factor)/factor) + 1;
    syNew = floor((sy-factor)/factor) + 1;
    szNew = sz;
    res = nan(sxNew, syNew, szNew);
    for k1 = 1:szNew
        res(:,:,k1) = ELImResize(img(:,:,k1), factor);
    end
end