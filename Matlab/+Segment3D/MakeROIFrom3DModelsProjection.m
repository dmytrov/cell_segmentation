function res = MakeROIFrom3DModelsProjection(settings, models, scan3D, scanFunctional)
    [sx, sy, sz] = size(scan3D);
    buffer = ImageUtils.TImageStack(zeros(sx, sy));
    % Resize the models
    k = 1;
    for model = models
        for k2 = 1:model.nFacets
            e1 = model.lFacets(k2).lEdges(1);
            e2 = e1.eNext;
            e3 = e2.eNext;
            pt1 = settings.MicronToPix(e1.vertex.pt);
            pt1 = pt1(1:2);
            pt2 = settings.MicronToPix(e2.vertex.pt);
            pt2 = pt2(1:2);
            pt3 = settings.MicronToPix(e3.vertex.pt);
            pt3 = pt3(1:2);
            RasterUtils.RasterizeTriangle2D(buffer, pt1, pt2, pt3, k);
        end
        k = k + 1;
    end
    
    % Resize the buffer to functional stack size    
    [sx, sy, sz] = size(scanFunctional);
	res = imresize(buffer.Data, [sx, sy], 'nearest');
    
end




