classdef TClassifyRegions < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        IN_CONVERGENCE = 2;
        OUT_REGIONS = 1;
    end
    
    properties (Access = public, Constant = true)
        RETINAL = 'RETINAL';
        CORTICAL = 'CORTICAL';
    end
    
    properties (Access = public)
        Settings;   
        ScanType; % Cortical or Retinal
    end
    
    properties (Access = protected)
        Regions;
    end
    
    methods (Access = public)        
        function this = TClassifyRegions(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this), ...
                           Core.TInputPoint('Convergence', 'Convergence Stack', this)];
            this.Outputs = [Core.TOutputPoint('Regions', 'Regions 3D', this)];
            this.ScanType = this.RETINAL;
        end
    
        function GetParameters(this, params)
            params.convergenceThreshold = this.Settings.ConvergenceThreshold;
            params.minCellVolume = this.Settings.CellMinPixVolumeFine;
        end
        
        function SetParameters(this, params)
            this.Settings.ConvergenceThreshold = params.convergenceThreshold;
            this.Settings.CellMinPixVolumeFine = params.minCellVolume;
        end
        
        function Run(this)
            Run@Core.TProcessor(this);                        
            convergence = this.Inputs(this.IN_CONVERGENCE).PullData();            
            regions = Segment3D.FindCellsRegions(this.Settings, convergence);
            this.Regions = regions;
            Segment3D.ClassifyRegions(this.Settings, regions, this.ScanType);
            this.Outputs(this.OUT_REGIONS).PushData(regions);
        end
        
        function BindJavaUI(this, ui)
            BindJavaUI@Core.TComponent(this, ui);
            if (~isempty(this.ExternalUI))
                set(this.ExternalUI, 'AutoClassifyCallback', @(h, e)(OnAutoClassify(this, h, e)));
                set(this.ExternalUI, 'GetRegionByRayCallback', @(h, e)(OnGetRegionByRay(this, h, e)));
                set(this.ExternalUI, 'MarkRegionCallback', @(h, e)(OnMarkRegion(this, h, e)));            
                set(this.ExternalUI, 'DeleteRegionCallback', @(h, e)(OnDeleteRegion(this, h, e)));            
                set(this.ExternalUI, 'CutRegionCallback', @(h, e)(OnCutRegion(this, h, e)));            
                set(this.ExternalUI, 'MergeRegionsCallback', @(h, e)(OnMergeRegions(this, h, e)));            
                set(this.ExternalUI, 'SetRegionsCallback', @(h, e)(OnSetRegions(this, h, e)));            
                this.PushRegionsDataToUI();
                this.ExternalUI.onNewSurfaces();
            end
        end
        
        function OnAutoClassify(this, sender, event)
            this.Pipeline.Run(this, true);
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnGetRegionByRay(this, sender, event)
            ptRay = event.data.ptRay;
            vRay = event.data.vRay;
            bSelectCells = event.data.selectCells;
            bSelectNoise = event.data.selectNoise;
            event.data.kSelected = this.GetSelectedRegionID(ptRay, vRay, bSelectCells, bSelectNoise)-1;
            event.onHandled(); % call java code back
        end
        
        function OnMarkRegion(this, sender, event)
            this.Pipeline.MarkChildrenInvalid(this);
            this.Outputs(this.OUT_REGIONS).PushData(this.Regions);
            this.Pipeline.CallComponentsStateChangeCallback();
            regionID = event.data.regionID + 1;
            newMark =  event.data.newMark;
            this.Regions.RegionDesc(regionID).Type = newMark;
            this.PushRegionsMarksToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnDeleteRegion(this, sender, event)
            this.Pipeline.MarkChildrenInvalid(this);
            this.Outputs(this.OUT_REGIONS).PushData(this.Regions);
            this.Pipeline.CallComponentsStateChangeCallback();
            regionID = event.data.regionID + 1;
            this.Regions.RemoveRegionDesc(regionID);
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnCutRegion(this, sender, event)
            this.Pipeline.MarkChildrenInvalid(this);
            this.Outputs(this.OUT_REGIONS).PushData(this.Regions);
            this.Pipeline.CallComponentsStateChangeCallback();
            regionID = event.data.regionID + 1;
            ptPlane = event.data.ptPlane;
            vnPlane = event.data.vnPlane;
            [oldRegionDesc, pixels] = this.Regions.RemoveRegionDesc(regionID);
            up = (vnPlane' * (pixels - repmat(ptPlane, 1, size(pixels, 2))) > 0);
            
            indexes = [up; ~up]';
            for index = indexes
                if (sum(index) > 0)                    
                    surface = Segment3D.CreateSurfaceMesh(this.Settings, this.Settings.MicronToPix(pixels(:, index)));
                    this.Regions.AddRegionDesc( ...
                        pixels(:, index), ...
                        mean(pixels(:, index), 2), ...
                        surface, ...
                        oldRegionDesc.Type);
                end
            end
           
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnMergeRegions(this, sender, event)
            this.Pipeline.MarkChildrenInvalid(this);
            this.Outputs(this.OUT_REGIONS).PushData(this.Regions);
            this.Pipeline.CallComponentsStateChangeCallback();
            regionIDs = event.data.regionIDs + 1;
            pixels = [];
            for k = 1:length(regionIDs)
                regionID = regionIDs(k);
                [oldRegionDesc, pix] = this.Regions.RemoveRegionDesc(regionID);
                pixels = [pixels, pix];
                regionIDs(regionIDs > regionID) = regionIDs(regionIDs > regionID) - 1;
            end
            
            surface = Segment3D.CreateSurfaceMesh(this.Settings, this.Settings.MicronToPix(pixels));
            this.Regions.AddRegionDesc( ...
            	pixels, ...
                mean(pixels, 2), ...
                surface, ...
                oldRegionDesc.Type);                        
            
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function OnSetRegions(this, sender, event)
            this.Pipeline.MarkChildrenInvalid(this);
            this.Outputs(this.OUT_REGIONS).PushData(this.Regions);
            this.Pipeline.CallComponentsStateChangeCallback();
            regionsType = event.data.regionsType(2:end);
            regionsMap = event.data.regionsMap;
            nRegions = length(regionsType);
            this.Regions.Clear();
            for k = 1:nRegions
                [k1, k2, k3] = ind2sub(size(regionsMap), find(regionsMap == k));
                if (~isempty(k1))
                    pixels = [k1, k2, k3]';
                    pixelsInMicrons = this.Settings.PixToMicron(pixels);
                    center = mean(pixelsInMicrons, 2);
                    surface = Segment3D.CreateSurfaceMesh(this.Settings, pixels);
                    this.Regions.AddRegionDesc( ...
                        pixelsInMicrons, ...
                        center, ...
                        surface, ...
                        regionsType(k));
                end
            end
    
            this.PushRegionsDataToUI();
            this.ExternalUI.onNewSurfaces();
            event.onHandled(); % call java code back
        end
        
        function res = GetSelectedRegionID(this, ptRay, vRay, bSelectCells, bSelectNoise)
            res = 0;
            distClosest = Inf;
            k = 1;
            if (~isempty(this.Regions))
                for region = this.Regions.RegionDesc
                    if (((region.Type == Segment3D.TRegionDesc.CELL) && bSelectCells) || ...
                        ((region.Type ~= Segment3D.TRegionDesc.CELL) && bSelectNoise))
                        [bHit, ptHit] = region.Surface.RayHit(ptRay, vRay);
                        if (bHit && (norm(ptHit-ptRay) < distClosest))
                            distClosest = norm(ptHit-ptRay);
                            res = k;
                        end
                    end
                    k = k + 1;
                end
            end
        end
        
        function PushRegionsDataToUI(this)
            this.ExternalUI.surfaces.clear();
            if (isempty(this.Regions))
                return;
            end
            
            fprintf('Getting stack data\n');
            stack = this.Inputs(this.IN_STACK).PullData();
            this.ExternalUI.stack = stack;
            stackSize = size(stack);
            clear stack;

            fprintf('Pushing stack data\n');
            overlay = zeros(stackSize);
            pixels = round(this.Settings.MicronToPix(this.Regions.Pixels));
            overlay(sub2ind(size(overlay), pixels(1, :), pixels(2, :), pixels(3, :))) = this.Regions.PixelID;
            this.ExternalUI.overlay = overlay;
            clear overlay;
            
            fprintf('Pushing surfaces\n');
            k = 1;
            for region = this.Regions.RegionDesc
                fprintf('Surface %d ', k);
                surface = de.unituebingen.cin.celllab.opengl.IndexMesh( ...
                    size(region.Surface.lVertices, 2), ...
                    size(region.Surface.lFacets, 2));
                
                surface.vertices = region.Surface.lVertices';
                surface.normals = region.Surface.lNormals';
                surface.facets = region.Surface.lFacets' - 1;                                
                surface.tag = region.Type;
                this.ExternalUI.surfaces.add(surface);                
                fprintf('done\n');
                k = k + 1;
            end            
        end
        
        function PushRegionsMarksToUI(this)
            k = 0;
            for region = this.Regions.RegionDesc
                surface = this.ExternalUI.surfaces.get(k);
                surface.tag = region.Type;
                k = k + 1;
            end
        end
    end
end