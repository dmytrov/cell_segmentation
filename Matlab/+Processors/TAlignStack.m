classdef TAlignStack < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_STACK = 1;
    end
    
    properties (Access = public)
        Mode = 'CONTINUOUS';
        StartSlice = 2;
    end
    
    methods (Access = public)
        function this = TAlignStack(name, pipeline)
            this = this@Core.TProcessor(name, pipeline);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('Stack', 'Image Stack', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            stackAligned = stack;
            %stackAligned = ImageUtils.AlignSlices(stack, this.Mode, this.StartSlice, this.Pipeline.MessageLog);
            this.Outputs(this.OUT_STACK).PushData(stackAligned);
        end
        
    end
end