function res = ELLimitClustersRange3D(scan, clusterID, thresh)
    res = clusterID;
    [he, wi, de] = size(scan);
    nClusters = max(max(clusterID));
    maxMap = -Inf(nClusters+1, 1);
    for k1 = 1:he
        for k2 = 1:wi
            for k3 = 1:de
                maxMap(clusterID(k1, k2, k3)+1) = max(maxMap(clusterID(k1, k2, k3)+1), scan(k1, k2, k3));
            end
        end
    end
    
    for k1 = 1:he
        for k2 = 1:wi
            for k3 = 1:de
                if (scan(k1, k2, k3) < thresh * maxMap(clusterID(k1, k2, k3)+1))
                    res(k1, k2, k3) = 0;
                end
            end
        end
    end
end