% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function sXY = TwoPhotonPixelSizeXY(zoom, nPixels, calibratedZoom, calibratedSideSize)
    if (nargin < 1), zoom = 1.41; end
    if (nargin < 2), nPixels = 512; end
    if (nargin < 3), calibratedZoom = 1.41; end
    if (nargin < 4), calibratedSideSize = 112; end % micron
    
    sXY = calibratedZoom / zoom * calibratedSideSize / nPixels;
end