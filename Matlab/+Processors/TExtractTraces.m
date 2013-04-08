classdef TExtractTraces < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        IN_ROI = 2;
        OUT_TRACES = 1;
    end
    
    properties (Access = public)
    end
    
    methods (Access = public)
        function this = TExtractTraces(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this), ...
                           Core.TInputPoint('ROI', '2D ROI', this)];
            this.Outputs = [Core.TOutputPoint('Traces', 'Activity traces', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            ROI = this.Inputs(this.IN_ROI).PullData();
            traces = Segment2DWS.ELExtractActivityTraces(stack, ROI);
            this.Outputs(this.OUT_TRACES).PushData(traces);
        end
        
    end
end