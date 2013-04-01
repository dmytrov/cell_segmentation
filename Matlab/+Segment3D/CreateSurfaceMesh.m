function res = CreateSurfaceMesh(settings, pixels)
    minCoord = min(pixels, [], 2);
    maxCoord = max(pixels, [], 2);
    % Do not try to understand matlab indexing
    [x, y, z] = meshgrid(minCoord(2)-1:maxCoord(2)+1, ...
                         minCoord(1)-1:maxCoord(1)+1, ...
                         minCoord(3)-1:maxCoord(3)+1);
    val = zeros(size(x));
    for k = 1:size(pixels, 2)
        pt = pixels(:, k) - minCoord + 2; 
        val(pt(1), pt(2), pt(3)) = 1;
    end
    fv = isosurface(x, y, z, val, 0.5);
    fv.vertices =  fv.vertices(:, [2, 1, 3]);
    res = Segment3D.TIndexMesh();
    res.InitFromFacetVertex(fv);
    res.lVertices = settings.PixToMicron(res.lVertices);
    
%     figure; plot3(pixels(1,:), pixels(2,:), pixels(3,:), '.');
%     p = patch(fv);
%     set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
%     axis image;
%     camlight;
%     lighting gouraud;
end
