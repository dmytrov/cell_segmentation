% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function SaveTIFF(img, fileName)
    imwrite(img(:, :, 1), fileName, 'Compression','none');
    for k = 2:size(img, 3)
        imwrite(img(:, :, k), fileName, 'WriteMode', 'append', 'Compression','none');
    end
end