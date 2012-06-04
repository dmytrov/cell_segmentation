function res = ELLimitClustersRange(scan, clusterID, thresh)
    res = clusterID;
    [he, wi] = size(scan);
    nClusters = max(max(clusterID));
    maxMap = -Inf(nClusters+1, 1);
    for k1 = 1:he
        for k2 = 1:wi
            maxMap(clusterID(k1,k2)+1) = max(maxMap(clusterID(k1,k2)+1), scan(k1,k2));
        end
    end
    
    for k1 = 1:he
        for k2 = 1:wi
            if (scan(k1,k2) < thresh*maxMap(clusterID(k1,k2)+1))
                res(k1,k2) = 0;
            end
        end
    end
end