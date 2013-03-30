classdef TAlignStack < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
        OUT_STACK = 1;
    end
    
    methods (Access = public)
        function this = TAlignStack(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [Core.TOutputPoint('Stack', 'Image Stack', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);            
            stack = this.Inputs(this.IN_STACK).PullData();
            stackAligned = ImageUtils.AlignSlices(stack);
            this.Outputs(this.OUT_STACK).PushData(stackAligned);
        end
        
    end
end