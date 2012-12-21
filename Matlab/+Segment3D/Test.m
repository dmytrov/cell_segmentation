function Test()
    sScanFileName = '../../Data/Q5 512.tif';
    scan = ImageUtils.LoadTIFF(sScanFileName);
    scan(:, 1:3, :) = 0;
    
    model = TestCreateTriangulatedSphere();
    cellsCenters = TestFindCellsCenters(scan);
    ptCenter = [445, 446, 8]';
    fCellRadius = 30;
    MeshUtils.ProjectOnSphere(model, [0, 0, 0]', fCellRadius);
    MeshUtils.Translate(model, ptCenter);
    TestFindRaysCollisions(model, scan, ptCenter);
end

function cellsCenters = TestFindCellsCenters(scan)
    cellsCenters = Segment3D.FindCellsCenters(scan);
    figure;
    plot3(cellsCenters(1,:), cellsCenters(2,:), -cellsCenters(3,:), '*');
end

function model = TestCreateTriangulatedSphere()
    model = Segment3D.CreateTriangulatedSphere();
	figure;
    opengl hardware;
    plot(model);
end

function collisions = TestFindRaysCollisions(model, scan, ptCenter)
    collisions = Segment3D.FindRaysCollisions(model, scan, ptCenter);
    figure(); hold on;
    for rayIntersection = collisions
        plot(rayIntersection.dist, rayIntersection.imgValAtPt);
    end
    
    figure(); hold on;
    for rayIntersection = collisions
        plot3(rayIntersection.ptIntersectRes(1,:), ...
              rayIntersection.ptIntersectRes(2,:), ...
              rayIntersection.ptIntersectRes(3,:), ...
              '.');
    end
end