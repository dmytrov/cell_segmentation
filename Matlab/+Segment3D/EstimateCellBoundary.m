% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function EstimateCellBoundary(settings, model, distances, rayTraces)
    sigma = settings.RayKernelVariance/settings.RayStep;
    x = -3*sigma:3*sigma;
    kern = normpdf(x, 0, sigma)';
    [~, raysGrad]= gradient(rayTraces);
    raysGradConv = conv2(raysGrad, kern, 'same');
    rayTracesCoordinates = nan([3, size(rayTraces)]); % 3 x nDistances x nVertices
	for k = 1:model.nVertices
        vRay = Collision.VectorUnit(model.lVertices(k).pt - model.ptCenter);        
        rayTracesCoordinates(:, :, k) = bsxfun(@plus, bsxfun(@times, distances, vRay), model.ptCenter);
    end
    model.tag.logLikelihood = 0;
    
    distancesPosteriorFactor = 1; % iteratively updated radius prior    
    for i = 1:settings.BoundaryEstimationIterations
        radiusPrior = settings.RadiusPrior.ValueAt(distancesPosteriorFactor * distances)';
        nDist = 0;
        distSum = 0;
            
        k = 1;
        for ray = raysGradConv
            % Shape with the priors, find the first peak ("MAP value")            
            posteriorRay = ray .* radiusPrior .* model.lVertices(k).tag.distPrior;
            if (i == settings.BoundaryEstimationIterations) % use curvature on the last iteration
                [ptPlane, vnPlane] = PlaneFromSurroundingVertices(model, model.lVertices(k));
                planeDistances = Collision.PointsPlaneDist(rayTracesCoordinates(:, :, k), ptPlane, vnPlane);
                curvaturePrior = settings.CurvaturePrior.ValueAt(planeDistances)';
                posteriorRay = posteriorRay .* curvaturePrior;                
            end
            [peak, peakIndex] = min(posteriorRay);
            if (numel(peakIndex) >= 1)
                dist = distances(peakIndex(1));
                if (dist > 0)
                    vRay = Collision.VectorUnit(model.lVertices(k).pt - model.ptCenter);
                    model.lVertices(k).pt = model.ptCenter + dist * vRay;        
                    distSum = distSum + dist;
                    nDist = nDist + 1;
                    if ((i == settings.BoundaryEstimationIterations) && (peak < 0))
                        model.tag.logLikelihood = model.tag.logLikelihood + log(-peak);
                    end
                end
            end
            k = k + 1;
        end
        
        % Add some EM flavour here. 
        % Factor 1.1 is used to avoid
        % concentrating on the inner boundary (close to nucleus)
        distancesPosteriorFactor = settings.RadiusPrior.mean / (1.1 * distSum / nDist);        
    end
end

function [pt, vn] = PlaneFromSurroundingVertices(model, ve)        
    nEdges = size(ve.lEdges, 2);
    lPts = nan(3, nEdges);
    distances = nan(1, nEdges);

    for k = 1:nEdges
        lPts(:, k) = ve.lEdges(k).eOpposite.vertex.pt;
        distances(k) = norm(lPts(:, k) - model.ptCenter);
    end
    
    % Remove one outlier ("median spike filtering")
    [~, maxIndex] = max(distances - mean(distances));
    lPts = [lPts(:, 1:maxIndex-1), lPts(:, maxIndex+1:end)];
    
    [vAxes, scale] = MathUtils.GetPrincipalAxes(lPts);
    pt = mean(lPts, 2);
    vn = vAxes(:, 3);    
    if (vn' * (ve.pt - model.ptCenter) < 0)
        vn = -vn;
    end
end

