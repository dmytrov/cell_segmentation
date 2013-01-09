function EstimateCellBoundary(model, ptCenter, collisions)
    sigma = 6;
    x = -3*sigma:3*sigma;
    mu = 0;
    kern = normpdf(x, mu, sigma);
    figure; hold on;
    k = 1;
    for rayIntersection = collisions
        rayGrad = -gradient(rayIntersection.imgValAtPt);
        rayConv = conv(rayGrad, kern, 'same');
        plot(rayIntersection.dist, rayConv);
        [peaks, peakIndex] = findpeaks(rayConv);
        model.lVertices(k).pt = rayIntersection.ptIntersectRes(:, peakIndex(1));
        k = k + 1;
    end
    
    figure;
    plot(model);
end