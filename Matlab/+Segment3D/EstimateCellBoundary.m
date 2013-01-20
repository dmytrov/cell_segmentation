function EstimateCellBoundary(settings, model, distances, values)
    sigma = settings.RayKernelVariance/settings.RayStep;
    x = -3*sigma:3*sigma;
    kern = normpdf(x, 0, sigma)';
    [~, raysGrad]= gradient(values);
    raysGradConv = conv2(raysGrad, kern, 'same');
    %figure;
    %plot(raysGradConv);
    
    s = Segment3D.TSettings();
    nIterations = 1;
    for i = 1:nIterations
        k = 1;
        nDist = 0;
        distSum = 0;
        for ray = raysGradConv
            % Shape with the prior, find the MAP value
            posteriorRay = ray .* s.RadiusPrior.ValueAt(distances)';
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
        model.ptCenter = MeshUtils.GetCenter(model);
    end
end