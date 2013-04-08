function res = ELExtractActivityTraces(scan, ROI)
    [sx, sy, sz] = size(scan);    
    nClusters = max(ROI(:));
    res = zeros(sz, nClusters);
    for kx = 1:sx
        for ky = 1:sy
            cID = ROI(kx, ky);
            if (cID > 0)
                res(:, cID) = res(:, cID) + squeeze(scan(kx, ky, :));
            end
        end
    end
end