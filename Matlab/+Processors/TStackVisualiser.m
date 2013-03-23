classdef TStackVisualiser < Core.TProcessor
    properties (Constant = true)
        IN_STACK = 1;
    end
    
    properties (Access = public)
        Visualiser;        
    end
    
    methods (Access = public)
        function this = TStackVisualiser(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
            this.Outputs = [];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            
            this.Visualiser = UI.StackViewer(this.Inputs(this.IN_STACK).Other.Component.Data);
        end
    end    
end