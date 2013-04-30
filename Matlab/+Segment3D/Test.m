% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen
%   mailto:dmytro.velychko@student.uni-tuebingen.de

% TODO:
% 1. precalculate cross-sections
% 2. All models in 3D on the right
% 3. map 64x64 image (correlation based), map 2D ROIs on the models
% 4. extract volume, skew (asymmetricity), log-likelihood

%  TODO: Use priors for:
%   - cell radius
%   - isosurface (same boundary values in neighboring rays)
%   - prior for boundary intensity (say 20% of cell max of center)
%   - surface curvature
%   - optimization priority (lateral rays boundaries have higher
%   evidence)
    
%function Test()
    % cd 'D:\EulersLab\Code\Matlab'
	settings = Segment3D.TSettings();
    settings.IsDebug = 1;
    sScanFileName = '../Data/Q5 512.tif';
    scan = ImageUtils.LoadTIFF(sScanFileName);
    scan(:, 1:3, :) = 0; % fix the high values on the edge
    
    scanAligned = ImageUtils.AlignSlices(scan, 'CONTINUOUS', 2);        
    [models, regions] = Segment3D.RecognizeCells(settings, scanAligned);
    
	if (settings.IsDebug)
        clear viewer;
        viewer = UI.StackProfileViewer(scanAligned);
        viewer.settings = settings;
    
        clear stackSliceViewer;
        stackSliceViewer = UI.StackModelSliceViewer(scanAligned);
        stackSliceViewer.settings = settings;
        stackSliceViewer.SetModels(models);

        clear modelViewer;
        modelViewer = UI.ModelViewer;
        modelViewer.SetModels(models);        
	end
%end
