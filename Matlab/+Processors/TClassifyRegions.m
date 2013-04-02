classdef TClassifyRegions < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_REGIONS = 1;
    end
    
    properties (Access = public)
        Settings;        
    end
    
    properties (Access = protected)
        Regions;
    end
    
    methods (Access = public)        
        function this = TClassifyRegions(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('Regions', 'Regions 3D', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);                        
            stack = this.Inputs(this.IN_STACK).PullData();            
            regions = Segment3D.FindCellsRegions(this.Settings, stack);
            this.Regions = regions;
            Segment3D.ClassifyRegions(this.Settings, regions);
            this.Outputs(this.OUT_REGIONS).PushData(regions);
        end
        
        function BindJavaUI(this, ui)
            BindJavaUI@Core.TComponent(this, ui);
            set(this.ExternalUI, 'AutoClassifyCallback', @(h, e)(OnAutoClassify(this, h, e)));            
        end
        
        function OnAutoClassify(this, sender, event)
            this.Run();
            this.PushRegionsDataToUI();            
            event.onHandled(); % call java code back
            this.ExternalUI.onNewSurfaces();
        end
        
        function PushRegionsDataToUI(this)
            this.ExternalUI.surfaces.clear();
            k = 0;
            for region = this.Regions.RegionDesc
                surface = de.unituebingen.cin.celllab.opengl.IndexMesh();
                for k = 1:size(region.Surface.lVertices, 2)
                    surface.AddVertex(region.Surface.lVertices(1, k), ...
                                      region.Surface.lVertices(2, k), ...
                                      region.Surface.lVertices(3, k));
                end
                for k = 1:size(region.Surface.lFacets, 2)
                    surface.AddFacet(region.Surface.lFacets(1, k)-1, ...
                                     region.Surface.lFacets(2, k)-1, ...
                                     region.Surface.lFacets(3, k)-1);
                end
                this.ExternalUI.surfaces.add(surface);
                k = k + 1;
                if (k > 1)
                    return;
                end
            end
        end
    end
end