% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function IntersectionTest()
    close all;
    %VectorGridIntersectTest();
    VectorImageIntersect();
end

function VectorImageIntersect()
    img = ones(20, 20, 20);
    c = 5:15;
    img(c, c, c) = 2;
    c = 8:12;
    img(c, c, c) = 3;
    
    pt1 = [10, 10, 10]';
    pt2 = [10, 10, 20]';
    [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(pt1, pt2, img);
    figure;
    plot(imgValAtPt);
    pt2 = [10, 10, 0]';
    [ptIntersectRes, imgCoords, imgValAtPt] = Collision.VectorImageIntersect(pt1, pt2, img);
    figure;
    plot(imgValAtPt);
end

function VectorGridIntersectTest()
    ptVec = [0.1, 0, 0,]';
    vVec = [1, 1, 1]';
    ptGrid = [0, 0, 0]';
    radGrid = 10;
    stepGrid = 1;
    ptIntersectX = Collision.VectorGridIntersect(ptVec, vVec, ptGrid, radGrid, stepGrid)
    figure; 
    plot3(ptIntersectX(1,:), ptIntersectX(2,:), ptIntersectX(3,:), '.');
    grid on;
end