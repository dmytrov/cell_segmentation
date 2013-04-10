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
            set(this.ExternalUI, 'GetRegionByRayCallback', @(h, e)(OnGetRegionByRay(this, h, e)));
        end
        
        function OnAutoClassify(this, sender, event)
            this.Pipeline.Run(this);
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnGetRegionByRay(this, sender, event)
            ptRay = event.data.ptRay;
            vRay = event.data.vRay;
            event.data.kSelected = this.GetSelectedRegionID(ptRay, vRay)-1;
            %this.ExternalUI.onRegionSelected(this.GetSelectedRegionID(ptRay, vRay)-1);
            event.onHandled(); % call java code back
        end
        
        function res = GetSelectedRegionID(this, ptRay, vRay)
            res = 0;
            distClosest = Inf;
            k = 1;
            for region = this.Regions.RegionDesc
                [bHit, ptHit] = region.Surface.RayHit(ptRay, vRay);
                if (bHit && (norm(ptHit-ptRay) < distClosest))
                    distClosest = norm(ptHit-ptRay);
                    res = k;
                end
                k = k + 1;
            end
        end
        
        function PushRegionsDataToUI(this)
            this.ExternalUI.surfaces.clear();
            for region = this.Regions.RegionDesc
                surface = de.unituebingen.cin.celllab.opengl.IndexMesh( ...
                    size(region.Surface.lVertices, 2), ...
                    size(region.Surface.lFacets, 2));
                
                surface.vertices = region.Surface.lVertices';
                surface.normals = region.Surface.lNormals';
                surface.facets = region.Surface.lFacets' - 1;                                
                surface.tag = region.Type;
                this.ExternalUI.surfaces.add(surface);
            end
        end
    end
end