classdef TStackVisualiser < Core.TProcessor
    properties (Access = public)
        Visualiser;        
    end
    
    methods (Access = public)
        function this = TStackVisualiser(name)
            this = this@Core.TProcessor(name);
            this.Inputs = [Core.TInputPoint('Stack', 'Image Stack', this)];
        end
    
        function Run(this)
            Run@Core.TProcessor(this);
            
            this.Visualiser = UI.StackViewer(this.Inputs(1).Other.Component.Data);
        end
    end    
end