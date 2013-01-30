% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function res = SumDecimate(scan, decX, decY, decZ)
    res = nan(ceil(size(scan) ./ [decX, decY, decZ]));
    scanExp = zeros(size(res) .* [decX, decY, decZ]);
    scanExp(1:size(scan, 1), 1:size(scan, 2), 1:size(scan, 3)) = scan;
    for k1 = 1:size(res, 1)
        for k2 = 1:size(res, 2)
            for k3 = 1:size(res, 3)
                chunk = scanExp((k1-1)*decX+1:k1*decX, ...
                                (k2-1)*decY+1:k2*decY, ...
                                (k3-1)*decZ+1:k3*decZ);
                res(k1, k2, k3) = sum(chunk(:));
            end
        end    
    end
    res = res / (decX * decY * decZ);
end