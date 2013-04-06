% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function Test()
    sx = 31;
    sz = 31;
    cx = 3;
    cy = 3;
    cz = 10;
    kernel = ImageUtils.Make3DGaussKernel([sx, sx, sz], [cx, cy, cz]);
    
    distorted = kernel;
    for k = 2:sz
        slice = kernel(:, :, k);
        dx = randi(2, 1);
        dy = randi(2, 1);
        chunk = slice(dx:end, dy:end);
        slice(:, :) = 0;
        slice(1:end-dx+1, 1:end-dy+1) = chunk;
        distorted(:, :, k) = slice;
    end
    viewerDistorted = UI.StackViewer(distorted);
    
    aligned = ImageUtils.AlignSlices(distorted, 'CONTINUOUS');
    viewerAligned = UI.StackViewer(aligned);
end
