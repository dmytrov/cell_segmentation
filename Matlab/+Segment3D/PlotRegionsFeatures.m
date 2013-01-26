% Max PCA vector vs Z-vector angle    
function PlotRegionsFeatures(settings, cellsRegions)
    feat1 = nan(length(cellsRegions.RegionDesc), 1);
    feat2 = nan(length(cellsRegions.RegionDesc), 1);
    k = 1;
    for region = cellsRegions.RegionDesc
        principalAxes = GetPrincipalAxes(region.Pixels);
        %feat1(k) = abs(principalAxes(:, 1)' * [0, 0, 1]');
        feat1(k) = abs(Collision.VectorUnit(principalAxes(:, 1))' * [0, 0, 1]');
        feat2(k) = min(size(region.Pixels, 2), 5000);
        k = k + 1;
    end
    
    figure(10);
    plot(feat1, feat2, 'x');
    %axis image;
        
%     clc
%     x = mvnrnd([1, 2], [2, 0; 0, 4].^2, 1000)';
%     
%     %x =  bsxfun(@times, rand(2, 100), [10, 1]');
%     x = bsxfun(@minus, x, mean(x, 2));
%     figure(10); hold on;
%     plot(x(1,:), x(2,:), 'x'); 
%     axis image;
%     
%     [s, v, d] = svd(x);
%     v(1:2,1:2)/sqrt(1000)
%     %
%     mCov = cov(x');
%     [v, d] = eig(mCov);
%     % d is variance, take sqrt to get the std
%     sqrt(d)
%     
%     %
%     plot(0, 0, 'or');
%     plot(d(1,:) * v(1,1), d(2,:) * v(2,2), 'or');
%     hold off;
end

function res = GetPrincipalAxes(x)
    % Returns pricipal axes (of std length) in descending order
    res = eye(3, 3);
    if (size(x, 2) > 1)
        x = bsxfun(@minus, x, mean(x, 2));
        [v, d] = eig(x*x'/(size(x,2)-1));
        d = diag(d);
        [d, indexes] = sort(d, 'descend');
        v = v(:, indexes);
        % d is variance, take sqrt to get the std
        res = v .* repmat(sqrt(d)', size(v, 1), 1);
    end
end

