function [regMap, n] = ELLocalMax(scan, squareSize)
    %regMap = scan;
    %squareSize = 3;
    regMap = zeros(size(scan));
    [sx, sy] = size(scan);
    n = 0;
    for k1 = 1:1:sx-squareSize+1
        for k2 = 1:1:sy-squareSize+1
            piece = scan(k1:round(k1+squareSize-1), k2:round(k2+squareSize-1));
            [maxXValues, maxXIndexes] = max(piece);
            [~, maxYIndex] = max(maxXValues);
            maxXIndex = maxXIndexes(maxYIndex);
            if (maxXIndex > 1) && (maxYIndex > 1) && (maxXIndex < squareSize) && (maxYIndex < squareSize)
                n = n+1;
                regMap(k1+maxXIndex-1, k2+maxYIndex-1) = n;
            end    
        end
    end
end