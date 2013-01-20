function Test()
    %  TODO: Use priors for:
    %   - cell radius
    %   - isosurface (same boundary values in neighboring rays)
    %   - prior for boundary intensity (say 20% of cell max or center)
    %   - surface curvature
    %   - optimization priority (lateral rays boundaries have higher
    %   evidence)
	settings = Segment3D.TSettings();
    sScanFileName = '../../Data/Q5 512.tif';
    scan = ImageUtils.LoadTIFF(sScanFileName);
    scan(:, 1:3, :) = 0;
    scanAligned = ImageUtils.AlignSlices(scan);
    clear viewer;
    viewer = UI.StackProfileViewer(scanAligned);
    
    model = Segment3D.CreateTriangulatedSphere();
    %cellsCenters = TestFindCellsCenters(scan);
    ptCenter = [398, 165, 18]';
    %pt = [321, 131, 16]';
    ptCenter = settings.PixToMicron(ptCenter);
    MeshUtils.ProjectOnSphere(model, [0, 0, 0]', 1);
    MeshUtils.Translate(model, ptCenter);
    distances = 0:settings.RayStep:settings.RayRadius;
    viewer.model = model;
    viewer.settings = settings;
    
    values = Segment3D.FindRaysValues(settings, model, scanAligned, distances);
    figure;
    plot(values);
    
    Segment3D.EstimateCellBoundary(settings, model, distances, values)
    
	figure; opengl hardware;
    plot(model);
    
%     %%
%     surf(squeeze(scan(300:end,300:end,7)))
%     %%
%     s = scan(:,:,7);
%     [sx, sy] = gradient(s);
%     sxy = abs(sx) + abs (sy);
%     %figure
%     imagesc(sxy)
%     %%
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