function EstimateCellBoundary(settings, model, distances, rayTraces, distPrior)
    sigma = settings.RayKernelVariance/settings.RayStep;
    x = -3*sigma:3*sigma;
    kern = normpdf(x, 0, sigma)';
    [~, raysGrad]= gradient(rayTraces);
    raysGradConv = conv2(raysGrad, kern, 'same');
    %figure;
    %plot(raysGradConv);    
    
    distancesPosteriorFactor = 1; % iteratively updated radius prior
    nIterations = 3;
    for i = 1:nIterations
        radiusPrior = settings.RadiusPrior.ValueAt(distancesPosteriorFactor * distances)';
        nDist = 0;
        distSum = 0;
        %for ve = model.lVertices
        %    ve.tag.scanValues
        %end
            
        k = 1;
        for ray = raysGradConv
            % Shape with the priors, find the MAP value
            posteriorRay = ray .* radiusPrior .* model.lVertices(k).tag.distPrior;
            [peak, peakIndex] = min(posteriorRay);
            %[peaks, peakIndex] = findpeaks(-ray);
            if (numel(peakIndex) >= 1)
                dist = distances(peakIndex(1));
                vRay = Collision.VectorUnit(model.lVertices(k).pt - model.ptCenter);
                model.lVertices(k).pt = model.ptCenter + dist * vRay;        
                distSum = distSum + dist;
                nDist = nDist + 1;
            end
            k = k + 1;
        end
        % Add some EM flavour here. 
        % Factor 1.1 is used to avoid
        % concentrating on the inner boundary (close to nuclei)
        distancesPosteriorFactor = settings.RadiusPrior.mean / (1.1 * distSum / nDist);        
    end
end