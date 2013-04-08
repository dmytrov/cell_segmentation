classdef TMake2DROI < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_ROI = 1;
    end
    
    properties (Access = public)
    end
    
    methods (Access = public)
        function this = TMake2DROI(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('ROI', '2D ROI', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            stackMean = mean(stack, 3);
            ROI = Segment2DWS.ELCellSegmentation2D(stackMean);
            this.Outputs(this.OUT_ROI).PushData(ROI);
        end
        
    end
end