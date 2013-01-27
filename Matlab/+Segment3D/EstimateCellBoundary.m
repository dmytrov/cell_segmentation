function EstimateCellBoundary(settings, model, distances, rayTraces, distPrior)
    sigma = settings.RayKernelVariance/settings.RayStep;
    x = -3*sigma:3*sigma;
    kern = normpdf(x, 0, sigma)';
    [~, raysGrad]= gradient(rayTraces);
    raysGradConv = conv2(raysGrad, kern, 'same');
    %figure;
    %plot(raysGradConv);
    
    radiusPrior = settings.RadiusPrior.ValueAt(distances)';
    
    %s = Segment3D.TSettings();
    nIterations = 10;
    for i = 1:nIterations
        k = 1;
        nDist = 0;
        distSum = 0;
        %for ve = model.lVertices
        %    ve.tag.scanValues
        %end
            
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
        % Add some EM flavour here. Factor 1.2 is used to avoid
        % concentrating on the inner boundary (close to nuclei)
        s.RadiusPrior.mean = 1.2 * distSum / nDist;
        %model.ptCenter = MeshUtils.GetCenter(model);
    end
end