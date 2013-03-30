classdef TEstimateModels < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        IN_REGIONS = 2;
        OUT_MODELS = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)        
        function this = TEstimateModels(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this), ...
                           Core.TInputPoint('Regions', 'Regions 3D', this)];
            this.Outputs = [Core.TOutputPoint('Models', 'WEMesh List', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);                        
            stack = this.Inputs(this.IN_STACK).PullData();            
            regions = this.Inputs(this.IN_REGIONS).PullData();
            nCells = 0;
            for region = regions.RegionDesc    
                if (region.Type == Segment3D.TRegionDesc.CELL)
                    nCells = nCells + 1;
                end
            end
            fprintf('Found %d cells in %d convergence regions.\n', nCells, length(regions.RegionDesc));
            distances = 0:this.Settings.RayStep:this.Settings.RayRadius;
            k = 1;
            kCell = 1;
            models = [];
            for region = regions.RegionDesc    
                if (region.Type == Segment3D.TRegionDesc.CELL)
                    fprintf('Estimatings cell %d of %d\n', kCell, nCells);
                    ptCenter = region.Center;
                    cellID = k;

                    model = Segment3D.CreateTriangulatedSphere(this.Settings.TesselationLevel);
                    MeshUtils.ProjectOnSphere(model, [0, 0, 0]', 1);
                    MeshUtils.Translate(model, ptCenter);

                    rayTraces = Segment3D.FindRaysValues(this.Settings, model, stack, distances);

                    Segment3D.FindRaysNearestRegions(this.Settings, model, cellID, regions, distances);
                    Segment3D.EstimateCellBoundary(this.Settings, model, distances, rayTraces);

                    models = [models, model];
                    kCell = kCell + 1;
                end
                k = k + 1;
            end
            this.Outputs(this.OUT_MODELS).PushData(models);
        end
        
    end
end