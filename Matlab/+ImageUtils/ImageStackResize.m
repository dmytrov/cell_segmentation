% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = ImageStackResize(img, factor)
    % Resize stack of images by some factor
    
    [sx, sy, sz] = size(img);
    sxNew = floor((sx-factor)/factor) + 1;
    syNew = floor((sy-factor)/factor) + 1;
    szNew = sz;
    res = nan(sxNew, syNew, szNew);
    for k1 = 1:szNew
        res(:,:,k1) = ImageUtils.ImageResize(img(:,:,k1), factor);
    end
end