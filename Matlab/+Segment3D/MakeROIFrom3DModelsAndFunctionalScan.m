function res = MakeROIFrom3DModelsAndFunctionalScan(settings, models, scan3D, scanFunctional)
    % Resize the stacks
    meanFunctional = mean(scanFunctional, 3);
    meanFunctional = meanFunctional - mean(meanFunctional(:));
    [sx, sy] = size(meanFunctional);
    sz = size(scan3D, 3);
    resized3D = nan(sx, sy, sz);
    for k = 1:sz;
        slice = imresize(scan3D(:, :, k), size(meanFunctional), 'bicubic');
        slice = slice - mean(slice(:));
        resized3D(:, :, k) = slice;
    end
    
    % Calculate correlations
    correlations = nan(1, sz);
    for k = 1:sz;
        slice = resized3D(:,:,k);
        correlations(k) = meanFunctional(:)' * slice(:);
    end
    
    [~, kMax] = max(correlations);
    planeZ = settings.Resolution(3) * kMax;
    
    % Cut the models with planeZ
    res = zeros(sx, sy);
    ptPlane = [0, 0, planeZ]';
    vnPlane = [0, 0, 1]';
    k = 1;
    for model = models
        section = Collision.MeshPlaneIntersect(model, ptPlane, vnPlane);
        if (size(section, 3) > 0)
            section = section ./ repmat(settings.Resolution', [2, 1, size(section, 3)]);
            section(:, 3, :) = [];
            section = section ./ repmat([size(scan3D, 1)/sx, size(scan3D, 2)/sz], [2, 1, size(section, 3)]);
            sectionMin = floor(min(squeeze(cat(3, section(1, :, :), section(2, :, :))), [], 2));
            sectionMax = ceil(max(squeeze(cat(3, section(1, :, :), section(2, :, :))), [], 2));
            sectionMin = max([sectionMin, [1, 1]'], [], 2);
            sectionMax = max([sectionMax, [1, 1]'], [], 2);
            for k1 = sectionMin(1):sectionMax(1)
                for k2 = sectionMin(2):sectionMax(2)
                    if (PointInsideRegion2D([k1, k2]', section))
                        res(k1, k2) = k;
                    end
                end
            end
        end
        k = k + 1;
    end
    
end

function res = PointInsideRegion2D(pt, section)
    res = false;
    for k = 1:size(section, 3)
        pt1 = section(1, :, k);
        pt2 = section(2, :, k);
        if (Collision.RaySegmentIntersect2D(pt, [0, 1]', pt1, pt2))
            res = ~res;
        end
    end   
    
end







