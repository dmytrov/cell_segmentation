% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [vAxes, scale] = GetPrincipalAxes(x)
    % Returns pricipal axes (of std length) in descending order
    [dim, nPoints] = size(x);
    vAxes = eye(dim, dim);
    scale = ones(1, dim);
    if (nPoints > 1)
        x = bsxfun(@minus, x, mean(x, 2));
        [v, d] = eig(x*x' / (nPoints-1));
        d = diag(d);
        [d, indexes] = sort(d, 'descend');
        vAxes = v(:, indexes);
        % d is variance, take sqrt to get the std scale
        scale = sqrt(d)';
    end
end