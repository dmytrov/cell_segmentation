function [vAxes, scale] = GetPrincipalAxes(x)
    % Returns pricipal axes (of std length) in descending order
    vAxes = eye(3, 3);
    scale = ones(1, 3);
    if (size(x, 2) > 1)
        x = bsxfun(@minus, x, mean(x, 2));
        [v, d] = eig(x*x'/(size(x,2)-1));
        d = diag(d);
        [d, indexes] = sort(d, 'descend');
        vAxes = v(:, indexes);
        % d is variance, take sqrt to get the std scale
        scale = sqrt(d)';
    end
end