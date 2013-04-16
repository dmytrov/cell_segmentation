function res = ELExtractActivityTraces(scan, ROI)
    [sx, sy, sz] = size(scan);    
    nClusters = max(ROI(:));
    res = zeros(sz, nClusters);
    clusterSize = zeros(1, nClusters);
    for kx = 1:sx
        for ky = 1:sy
            cID = ROI(kx, ky);
            if (cID > 0)
                res(:, cID) = res(:, cID) + squeeze(scan(kx, ky, :));
                clusterSize(cID) = clusterSize(cID) + 1;
            end
        end
    end
    for cID = 1:clusterSize
        res(:, cID) = res(:, cID) ./ clusterSize(cID);
    end
end