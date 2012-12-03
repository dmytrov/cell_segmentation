function res = CropZeroes(img)
    d1 = find(squeeze(any(any(img > 0, 2), 3)));
    d1 = [d1(1), d1(end)];

    d2 = find(squeeze(any(any(img > 0, 1), 3)));
    d2 = [d2(1), d2(end)];

    d3 = find(squeeze(any(any(img > 0, 1), 2)));
    d3 = [d3(1), d3(end)];

    res = img(d1(1):d1(2), d2(1):d2(2), d3(1):d3(2));
end