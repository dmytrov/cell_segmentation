% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = Downsample2X(img)
    res = ImageUtils.Downsample(img, 2, 2, 2);
end