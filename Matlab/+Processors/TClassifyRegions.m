classdef TClassifyRegions < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_REGIONS = 1;
    end
    
    properties (Access = public)
        Settings;
    end
    
    methods (Access = public)        
        function this = TClassifyRegions(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('Regions', 'Regions 3D', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);                        
            stack = this.Inputs(this.IN_STACK).PullData();            
            regions = Segment3D.FindCellsRegions(this.Settings, stack);
            Segment3D.ClassifyRegions(this.Settings, regions);
            this.Outputs(this.OUT_REGIONS).PushData(regions);
        end
        
    end
end