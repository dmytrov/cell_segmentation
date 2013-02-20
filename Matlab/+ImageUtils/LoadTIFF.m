% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function img = LoadTIFF(fileName)
    info = imfinfo(fileName);
    imgToLoad = 1:numel(info);
    img(1:info(1).Height, 1:info(1).Width, size(imgToLoad)) = 0;
    for k = imgToLoad
        img(:,:,k) = imread(fileName, k);
    end
end