function ClassifyRegions(settings, cellsRegions)
    featZAxisAngle      = nan(length(cellsRegions.RegionDesc), 1);
    featVolume          = nan(length(cellsRegions.RegionDesc), 1);
    featBoundingVolume  = nan(length(cellsRegions.RegionDesc), 1);
    featElongation      = nan(length(cellsRegions.RegionDesc), 1);
    k = 1;
    for region = cellsRegions.RegionDesc
        [principalAxes, axesScale] = MathUtils.GetPrincipalAxes(region.Pixels);
        featZAxisAngle(k) = abs(principalAxes(:, 1)' * [0, 0, 1]');
        featVolume(k) = size(region.Pixels, 2);
        featBoundingVolume(k) = BoundingVolume(settings, region.Pixels, principalAxes);
        if (axesScale(3) > 1e-6) % check for zero
            featElongation(k) = axesScale(1) / axesScale(3);
        else
            featElongation(k) = axesScale(1) / axesScale(2);
        end
        k = k + 1;
    end
    
    % Rough estimation
    isCell = (featVolume > 200) & (featVolume < 4000) & (featZAxisAngle < 0.4);
    cellsPixels = nan(3, 0);
    k = 1;
    for region = cellsRegions.RegionDesc
        if (isCell(k))
            region.Type = Segment3D.TRegionDesc.CELL;
            cellsPixels = [cellsPixels, region.Pixels];
        else
            region.Type = Segment3D.TRegionDesc.NOISE;
        end
        k = k + 1;
    end
    
    % Find cells plane
    [planeAxes, axesScale] = MathUtils.GetPrincipalAxes(cellsPixels);
    vnPlane = planeAxes(:, 3);
    ptPlane = mean(cellsPixels, 2);
    
    % Re-run the classification with cells plane information
    cellsPixels = nan(3, 0);
    k = 1;
    for region = cellsRegions.RegionDesc
        isCell(k) = (featVolume(k) > 10) & ...
                    (featVolume(k) < 10000) & ...
                    (featZAxisAngle(k) < 0.9) & ...
                    (featVolume(k) / featBoundingVolume(k) > 0.001) & ...
                    (featElongation(k) < 5) & ...
                    (abs(Collision.PointPlaneDist(region.Center, ptPlane, vnPlane)) < 1.5 * settings.RadiusPrior.mean);
        if (isCell(k))
            region.Type = Segment3D.TRegionDesc.CELL;
            cellsPixels = [cellsPixels, region.Pixels];
        else
            region.Type = Segment3D.TRegionDesc.NOISE;
        end
        k = k + 1;
    end
    
    
    if (settings.IsDebug)
        figure; hold on;
        for region = cellsRegions.RegionDesc    
            if (region.Type == Segment3D.TRegionDesc.CELL)
                style = '.r';
            else
                style = '.g';
            end
            plot3(  region.Pixels(1, :), ...
                    region.Pixels(2, :), ...
                    region.Pixels(3, :), ...
                    style);
        end
        hold off;
    end
end

% Bounding volume w.r.t. principal axes
function res = BoundingVolume(settings, pixels, principalAxes)
    res = 1;
    for k = 1:3
        vAxis = principalAxes(:, k);
        projected = vAxis' * pixels;
        span = max(projected) - min(projected);
        res = res * (1 + span / (vAxis' * settings.Resolution));
    end
    res = abs(res);
end








