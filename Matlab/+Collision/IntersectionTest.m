function IntersectionTest()
    ptVec = [0.1, 0, 0,]';
    vVec = [1, 1, 1]';
    ptGrid = [0, 0, 0]';
    radGrid = 10;
    stepGrid = 1;
    ptIntersectX = Collision.VectorGridIntersect(ptVec, vVec, ptGrid, radGrid, stepGrid)
    figure(1); 
    plot3(ptIntersectX(1,:), ptIntersectX(2,:), ptIntersectX(3,:), '.');
    grid on;
end