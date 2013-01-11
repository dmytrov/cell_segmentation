function EstimateCellBoundary(settings, model, distances, values)
    sigma = settings.RayKernelVariance/settings.RayStep;
    x = -3*sigma:3*sigma;
    kern = normpdf(x, 0, sigma)';
    [~, raysGrad]= gradient(values);
    raysGradConv = conv2(raysGrad, kern, 'same');
    figure;
    plot(raysGradConv);
    
    k = 1;
    for ray = raysGradConv
        posteriorRay = ray .* settings.RadiusPrior.ValueAt(distances)';
        [peak, peakIndex] = min(posteriorRay);
        %[peaks, peakIndex] = findpeaks(-ray);
        if (numel(peakIndex) >= 1)
            dist = distances(peakIndex(1));
            vRay = model.lVertices(k).pt - model.ptCenter;
            vRay = dist * vRay/norm(vRay);
            model.lVertices(k).pt = model.ptCenter + vRay;        
        end
        k = k + 1;
    end
    
end