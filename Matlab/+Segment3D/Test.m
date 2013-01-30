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
    
function Test()
    % cd 'D:\EulersLab\Code\Matlab'
    clear classes;
	settings = Segment3D.TSettings();
    settings.IsDebug = 1;
    sScanFileName = '../../Data/Q5 512.tif';
    scan = ImageUtils.LoadTIFF(sScanFileName);
    scan(:, 1:3, :) = 0;
    scanAligned = ImageUtils.AlignSlices(scan);
    
    cellsRegions = Segment3D.FindCellsRegions(settings, scanAligned);
    Segment3D.ClassifyRegions(settings, cellsRegions);
    
    tic;
    nCells = 0;
    for region = cellsRegions.RegionDesc    
        if (region.Type == Segment3D.TRegionDesc.CELL)
            nCells = nCells + 1;
        end
    end
	models = [];
	distances = 0:settings.RayStep:settings.RayRadius;
	tesselationLevel = 1;
    k = 1;
    kCell = 1;
    for region = cellsRegions.RegionDesc    
        if (region.Type == Segment3D.TRegionDesc.CELL)
            fprintf('Cell %d of %d\n', kCell, nCells);
            ptCenter = region.Center;
            cellID = k;

            model = Segment3D.CreateTriangulatedSphere(tesselationLevel);
            MeshUtils.ProjectOnSphere(model, [0, 0, 0]', 1);
            MeshUtils.Translate(model, ptCenter);

            rayTraces = Segment3D.FindRaysValues(settings, model, scanAligned, distances);

            [distToNearest, nearestCellID, distPrior] = Segment3D.FindRaysNearestRegions(settings, model, cellID, cellsRegions, distances);
            Segment3D.EstimateCellBoundary(settings, model, distances, rayTraces, distPrior);
            
            models = [models, model];
            kCell = kCell + 1;
        end
        k = k + 1;
        if (k == 60)
            %break
        end
    end
    toc;
    
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
end

function values = TestFindRaysValues(settings, model, scanAligned, distances)
    values = nan(length(distances), length(model.lVertices));
    regressor = Regression.LinearStackRegressor(scanAligned, settings);

    % Pack points into an array for batch processing
    allPts = nan(3, length(distances), length(model.lVertices));
    k = 1;
    for ve = model.lVertices
        pts = bsxfun(@times, Collision.VectorUnit(ve.pt - model.ptCenter), distances );
        pts = bsxfun(@plus, pts, model.ptCenter);
        allPts(:, :, k) = pts;
        k = k + 1;
    end
    % Find all poins values
    values = reshape(regressor.Value(reshape(allPts, 3, [])), size(values));
    % Fill the vertices tags
    k = 1;
    for ve = model.lVertices    
        ve.tag = values(:, k);
        k = k + 1;
    end
end



function cellsCenters = TestFindCellsCenters(scan)
    cellsCenters = Segment3D.FindCellsCenters(scan);
    figure;
    plot3(cellsCenters(1,:), cellsCenters(2,:), -cellsCenters(3,:), '*');
end

function model = TestCreateTriangulatedSphere()
    model = Segment3D.CreateTriangulatedSphere();
	figure;
    opengl hardware;
    plot(model);
end

function collisions = TestFindRaysCollisions(model, scan, ptCenter)
    collisions = Segment3D.FindRaysCollisions(model, scan, ptCenter);
    figure(); hold on;
    for rayIntersection = collisions
        plot(rayIntersection.dist, rayIntersection.imgValAtPt);
    end
    
    figure(); hold on;
    for rayIntersection = collisions
        plot3(rayIntersection.ptIntersectRes(1,:), ...
              rayIntersection.ptIntersectRes(2,:), ...
              rayIntersection.ptIntersectRes(3,:), ...
              '.');
    end
end

function TestEstimateCellBoundary(model, collisions)
    Segment3D.EstimateCellBoundary(model, ptCenter, collisions);
    figure;
    opengl hardware;
    plot(model);
end