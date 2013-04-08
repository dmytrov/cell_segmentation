% Low-resolution scan cell segmentation. 
% Uses a modified watershed clustering over gradinent convergence map.
%
% Parameters:   
%   scan - grayscale 2D image
%   borderType - 4 or 8 pixels. 4 is default
%   cellDiameterHint - 5 pixels is default
%   dynamicRange - limits cell's mask with respect to its max
%       intensity. 0.8 is default.
%
% Returns a map of clusters IDs of corresponding scan pixels 
%
% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen
function clusterID = ELCellSegmentation2D(scan, borderType, cellDiameterHint, dynamicRange)
    if (nargin < 2)
        borderType = 4;
    end
    if (nargin < 3)
        cellDiameterHint = 5;
    end
    if (nargin < 4)
        dynamicRange = 0.8;
    end
    
    [fx, fy] = gradient(scan);
    fx = Segment2DWS.ELClamp(fx, -1, 1);
    fy = Segment2DWS.ELClamp(fy, -1, 1);
    
    kernelSize = round(cellDiameterHint);
    kernelSize = kernelSize + mod(kernelSize+1, 2);
    kernel = fspecial('gaussian', [kernelSize, kernelSize], cellDiameterHint/5);
    convergence = Segment2DWS.ELConvergence(fx, fy, kernel) + 1;
    
    clusterID = Segment2DWS.ELWatershed(convergence, borderType, cellDiameterHint);
    clusterID = Segment2DWS.ELLimitClustersRange(scan, clusterID, 1-dynamicRange);
    
    % % Debug visualization
    % subplot(1, 3, 1), imagesc(scan);         axis image;
    % subplot(1, 3, 2), imagesc(convergence);  axis image;   
    % subplot(1, 3, 3), imagesc(clusterID);    axis image;
end