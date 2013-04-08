% Modified watershed clustering
function clusterID = ELWatershed(scan, Neighbors, cellDiameterHint)
    [he, wi] = size(scan);
    clusterID = zeros(size(scan));
    
    clusterCenter(1).x = 0; 
    clusterCenter(1).y = 0;
    
    % Sorting of the image pixels and with pixel coordinates
    imgVect = reshape(scan', wi*he, 1);
    [~, sortOrder] = sort(imgVect, 'descend');
    order(wi*he).x = 0;
    order(wi*he).y = 0;
    for k1 = 1:length(sortOrder)
        order(k1).x = floor((sortOrder(k1)+wi-1)/wi);
        order(k1).y = mod(sortOrder(k1),wi) + 1;
    end

    % A bit modified "Watershed" clustering
    k1 = 1;
    nClusters = 0;
    while (k1 <= length(order))
        x = order(k1).x;
        y = order(k1).y;
        if (scan(x,y) > 0)
            CID = zeros(1,8); % cluster IDs of neighbors
            if (x>1)  CID(1) = clusterID(x-1, y); end
            if (x<he) CID(2) = clusterID(x+1, y); end
            if (y>1)  CID(3) = clusterID(x, y-1); end
            if (y<wi) CID(4) = clusterID(x, y+1); end
            if (Neighbors == 8)
                if ((x>1) && (y>1))   CID(5) = clusterID(x-1, y-1); end
                if ((x<he) && (y>1))  CID(6) = clusterID(x+1, y-1); end
                if ((x>1) && (y<wi))  CID(7) = clusterID(x-1, y+1); end
                if ((x<he) && (y<wi)) CID(8) = clusterID(x+1, y+1); end
            end    
            nCID = sum(CID>0);
            if (nCID == 0)
                % New cluster center suspect            
                % Search for the closest existing cluster center
                closest.dist = Inf;
                for k2=1:nClusters
                    distToCluster = ELPointPointDistSQR(x, y, clusterCenter(k2).x, clusterCenter(k2).y);
                    if (distToCluster < closest.dist)
                        closest.x = clusterCenter(k2).x;
                        closest.y = clusterCenter(k2).y;
                        closest.dist = distToCluster;
                    end
                end
                if (closest.dist <= (cellDiameterHint/2)^2) % < sqrt(8)
                    clusterID(x,y) = clusterID(closest.x, closest.y);
                else            
                    nClusters = nClusters + 1;
                    clusterID(x,y) = nClusters;
                    clusterCenter(nClusters).x = x;
                    clusterCenter(nClusters).y = y;
                end
            else
                CIDSorted = sort(CID, 'descend');
                bSameCID = sum((CIDSorted(1:nCID) - CIDSorted(1)) == 0) == nCID;
                if (bSameCID)
                    % Attach the point to the existing cluster            
                    clusterID(x,y) = CIDSorted(1);
                end
            end
        end
        k1 = k1 + 1;
    end
end

function dist = ELPointPointDist(x1, y1, x2, y2)
    dist = sqrt( ELPointPointDistSQR(x1, y1, x2, y2) );
end    

function dist = ELPointPointDistSQR(x1, y1, x2, y2)
    dist = (x1-x2)^2 + (y1-y2)^2;
end    
