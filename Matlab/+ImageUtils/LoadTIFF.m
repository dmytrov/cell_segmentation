function img = LoadTIFF(fileName)
    info = imfinfo(fileName);
    %imgToLoad = 1:50;
    imgToLoad = 1:numel(info);
    img(1:info(1).Width, 1:info(1).Height, size(imgToLoad)) = 0;
    for k = imgToLoad
        img(:,:,k) = imread(fileName, k);
    end
end