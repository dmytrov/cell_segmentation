% Not Bresenham, but still good enough
function RasterizeTriangle2D(buffer, pt1, pt2, pt3, marker)
    pts = round([pt1, pt2, pt3]);
    [~, ids] = sort(pts(2, :), 2, 'descend');
    ptTop = pts(:, ids(1));
    ptMid = pts(:, ids(2));
    ptBottom = pts(:, ids(3));   
    
    [bIntersect, ptCross] = Collision.LineLineIntersect2D(ptBottom, ptTop - ptBottom, ptMid, [1, 0]');
    if (bIntersect)
        if (ptCross(1) > ptMid(1))
            w = ptMid;
            ptMid = ptCross;
            ptCross = w;
        end
        RasterizeUpperTriangle(buffer, ptTop, ptMid, ptCross, marker);
        RasterizeLowerTriangle(buffer, ptBottom, ptMid, ptCross, marker);
    end    
end

function RasterizeUpperTriangle(buffer, ptTop, ptMid, ptCross, marker)    
    [sx, sy] = size(buffer.Data);
    ySteps = ptMid(2):ptTop(2);
    correction = 0;
    x1Steps = round(linspace(ptCross(1), ptTop(1), length(ySteps)+correction));
    x1Steps = x1Steps(1:end-correction);
    x2Steps = round(linspace(ptMid(1), ptTop(1), length(ySteps)+correction));
    x2Steps = x2Steps(1:end-correction);
    for k = 1:length(ySteps)
        if (InRange(ySteps(k), 1, sy))
            buffer.Data(max(1, x1Steps(k)):min(sx, x2Steps(k)), ySteps(k)) = marker;
        end
    end
end

function RasterizeLowerTriangle(buffer, ptBottom, ptMid, ptCross, marker)    
    [sx, sy] = size(buffer.Data);
    ySteps = ptBottom(2):ptMid(2);
    correction = 0;
    x1Steps = round(linspace(ptBottom(1), ptCross(1), length(ySteps)+correction));
    x1Steps = x1Steps(1+correction:end);
    x2Steps = round(linspace(ptBottom(1), ptMid(1), length(ySteps)+correction));
    x2Steps = x2Steps(1+correction:end);
	for k = 1:length(ySteps)
        if (InRange(ySteps(k), 1, sy))
            buffer.Data(max(1, x1Steps(k)):min(sx, x2Steps(k)), ySteps(k)) = marker;
        end
	end
end

function res = InRange(x, a, b)
    res = ((x>=a) && (x<=b));
end
    
function Test()
%%
    close all;
    buffer = ImageUtils.TImageStack(zeros(100, 100));

    ptCenter = [50, 50]';
    angles = [0:2*pi/11:2*pi];
    radius = 45;
    for k = 1:length(angles)-1
        pt1 = ptCenter + radius * [sin(angles(k)), cos(angles(k))]';
        pt2 = ptCenter + radius * [sin(angles(k+1)), cos(angles(k+1))]';
        RasterUtils.RasterizeTriangle2D(buffer, ptCenter, pt1, pt2, k);
    end
    viewer = UI.StackViewer(buffer.Data);
%%
end

