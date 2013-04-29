% History:
%   Dmytro Velychko - created. Euler AG, CIN, Tuebingen, 2012-2013
%   mailto:dmytro.velychko@student.uni-tuebingen.de

function [models, regions] = RecognizeCells(settings, scanAligned)
	models = [];
    fprintf('Calculating convergence... ');
    convergence = Segment3D.CalcConvergence(settings, scanAligned);
    fprintf('done.\n');
    fprintf('Extracting regions... ');
	regions = Segment3D.FindCellsRegions(settings, convergence);
    fprintf('done.\n');
    fprintf('Classifying regions... ');
	Segment3D.ClassifyRegions(settings, regions);
    fprintf('done.\n');
    
    nCells = 0;
    for region = regions.RegionDesc    
        if (region.Type == Segment3D.TRegionDesc.CELL)
            nCells = nCells + 1;
        end
    end
    fprintf('Found %d cells in %d convergence regions.\n', nCells, length(regions.RegionDesc));
	distances = 0:settings.RayStep:settings.RayRadius;
    k = 1;
    kCell = 1;
    for region = regions.RegionDesc    
        if (region.Type == Segment3D.TRegionDesc.CELL)
            fprintf('Estimatings cell %d of %d\n', kCell, nCells);
            ptCenter = region.Center;
            cellID = k;

            model = Segment3D.CreateTriangulatedSphere(settings.TesselationLevel);
            MeshUtils.ProjectOnSphere(model, [0, 0, 0]', 1);
            MeshUtils.Translate(model, ptCenter);

            rayTraces = Segment3D.FindRaysValues(settings, model, scanAligned, distances);

            Segment3D.FindRaysNearestRegions(settings, model, cellID, regions, distances);
            Segment3D.EstimateCellBoundary(settings, model, distances, rayTraces);
            
            models = [models, model];
            kCell = kCell + 1;
        end
        k = k + 1;
    end
end